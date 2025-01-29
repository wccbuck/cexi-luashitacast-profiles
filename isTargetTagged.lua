-- This is an altered version of the "isTargetTagged" function written by will.8627 on the Ashita discord.
-- I (wccbuck / ziphion) added the stuff dealing with treasure hunter tier, with some help from 
-- Thorny (https://github.com/ThornyFFXI).

-- This isTargetTagged function not only lets you know whether a given target has been "tagged" by you 
-- (e.g. any hostile action which would trigger the first stage of TH), but it also keeps track of the 
-- highest tier of TH applied on the target, and lets you know once that value has exceeded a value you 
-- specify.

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
    local actionPacket = ParseActionPacket(e);
    -- First check to see if this action proc'd TH on a mob we have already tagged
    -- We actually don't want to restrict this to actions only done by ourselves,
    -- in case another THF in the party proc'd a higher TH level
    for _, target in ipairs(actionPacket.Targets) do
        if taggedMobs[target.Id] ~= nil then
            for _,action in ipairs(target.Actions) do
                local addEffect = action.AdditionalEffect;
                if (addEffect) then
                    if (addEffect.Message == 603) then
                        taggedMobs[target.Id] = {
                            Tier = addEffect.Param,
                            Time = os.clock()
                        };
                    end
                end
            end
        end
    end
    -- If no procs in this action, we check to see if this is a hostile action performed 
    -- by ourselves on a mob, at which point we save its ID
    if (actionPacket.UserId ~= playerId) then
        return;
    end

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

return isTargetTagged;