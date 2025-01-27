-- This is an altered version of the "isTargetTagged" function written by will.8627 on the Ashita discord.
-- Most of this code is his, as are many of the helpful comments.

-- This isTargetTagged function not only lets you know whether a given target has been "tagged" by you 
-- (e.g. any hostile action which would trigger the first stage of TH), but it also keeps track of the 
-- highest tier of TH applied on the target, and lets you know once that value has exceeded a value you 
-- specify.

-- If you use a language other than English in your client, edit the text_in listener callback function at 
-- the end of this file with a portion of your Treasure Hunter proc message so that it can capture it.

-- Place this file in the same directory as your THF.lua.

local taggedMobs = T {};
local setThTier = 1;

local function ParseActionPacket(e)
    local bitData;
    local bitOffset;
    local maxLength = e.size * 8;
    local function UnpackBits(length)
        if ((bitOffset + length) >= maxLength) then
            maxLength = 0;
            return 0;
        end
        local value = ashita.bits.unpack_be(bitData, 0, bitOffset, length);
        bitOffset = bitOffset + length;
        return value;
    end

    local actionPacket = T {};
    bitData = e.data_raw;
    bitOffset = 40;
    actionPacket.UserId = UnpackBits(32);

    local targetCount = UnpackBits(6);
    --Unknown 4 bits
    bitOffset = bitOffset + 4;
    actionPacket.Type = UnpackBits(4);
    actionPacket.Id = UnpackBits(32);

    actionPacket.Recast = UnpackBits(32);

    actionPacket.Targets = T {};
    if (targetCount > 0) then
        for i = 1, targetCount do
            local target = T {};
            target.Id = UnpackBits(32);
            local actionCount = UnpackBits(4);
            target.Actions = T {};
            if (actionCount > 0) then
                for j = 1, actionCount do
                    local action = {};
                    action.Reaction = UnpackBits(5);
                    action.Animation = UnpackBits(12);
                    action.SpecialEffect = UnpackBits(7);
                    action.Knockback = UnpackBits(3);
                    action.Param = UnpackBits(17);
                    action.Message = UnpackBits(10);
                    action.Flags = UnpackBits(31);

                    local hasAdditionalEffect = (UnpackBits(1) == 1);
                    if hasAdditionalEffect then
                        local additionalEffect = {};
                        additionalEffect.Damage = UnpackBits(10);
                        additionalEffect.Param = UnpackBits(17);
                        additionalEffect.Message = UnpackBits(10);
                        action.AdditionalEffect = additionalEffect;
                    end

                    local hasSpikesEffect = (UnpackBits(1) == 1);
                    if hasSpikesEffect then
                        local spikesEffect = {};
                        spikesEffect.Damage = UnpackBits(10);
                        spikesEffect.Param = UnpackBits(14);
                        spikesEffect.Message = UnpackBits(10);
                        action.SpikesEffect = spikesEffect;
                    end

                    target.Actions:append(action);
                end
            end
            actionPacket.Targets:append(target);
        end
    end

    return actionPacket;
end

-- This includes npcs, but it's fine.
local function isMob(id)
    return bit.band(id, 0xFF000000) ~= 0;
end

local function onAction(e)
    local playerEntity = GetPlayerEntity();
    local playerId;
    if (playerEntity) then
        playerId = playerEntity.ServerId;
    else
        return;
    end
    local actorId = ashita.bits.unpack_be(e.data_raw, 0, 40, 32);

    -- We only care about actions done by the player
    if (actorId ~= playerId) then
        return;
    end

    local actionPacket = ParseActionPacket(e);

    for _, target in ipairs(actionPacket.Targets) do
        if (isMob(target.Id)) then
            if taggedMobs[target.Id] == nil then
                taggedMobs[target.Id] = {
                    Tier = 1,
                    Time = os.clock()
                };
            else
                taggedMobs[target.Id].Time = os.clock();
            end
        end
    end
end

local deathMes = T { 6, 20, 97, 113, 406, 605, 646 };
local function onMessage(e)
    local message = struct.unpack('i2', e.data, 0x18 + 1);
    if (deathMes:contains(message)) then
        local target = struct.unpack('i4', e.data, 0x08 + 1);
        taggedMobs[target] = nil;
    end
end

-- Clear tagged mob table on zone
local function onZone(e)
    taggedMobs = T {};
end

-- Call this function to determine if the current target/subtarget has been tagged by you
local function isTargetTagged(thTier)
    setThTier = thTier == nil and 1 or thTier;
    local targetManager = AshitaCore:GetMemoryManager():GetTarget();
    local isSubTargetActive = targetManager:GetIsSubTargetActive();

    local targetId = targetManager:GetServerId(isSubTargetActive == 1 and 1 or 0);

    local tagged = taggedMobs[targetId];

    if tagged == nil then return false end;

    return tagged.Tier >= setThTier and os.clock() - tagged.Time < 550;
end

ashita.events.register('packet_in', 'packet_in_th_cb', function(e)
    if (e.id == 0x28) then
        onAction(e);
    elseif (e.id == 0x29) then
        onMessage(e);
    elseif (e.id == 0x0A or e.id == 0x0B) then
        onZone(e);
    end
end);

ashita.events.register('text_in', 'text_in_th_cb', function (e)
    -- there is probably a more elegant way to do this by capturing the relevant part of the enspell portion
    -- of the action packet. You might also think that you might catch the TH proc in a message packet (0x29)
    -- and handle it in onMessage(). I wasn't able to get either of these approaches to work. Instead, this 
    -- listener just checks every incoming string of text for the TH proc message.
    if (not e.injected) and (e.message:match("Treasure Hunter effectiveness")) then
        gFunc.Echo(2, e.message);
        local thTierAsString = string.match(e.message, "%d+");
        if thTierAsString ~= nil then
            local targetManager = AshitaCore:GetMemoryManager():GetTarget();
            local isSubTargetActive = targetManager:GetIsSubTargetActive();

            local targetId = targetManager:GetServerId(isSubTargetActive == 1 and 1 or 0);
            taggedMobs[targetId] = {
                Tier = tonumber(thTierAsString),
                Time = os.clock()
            };
        end
    end
end);

return isTargetTagged;
