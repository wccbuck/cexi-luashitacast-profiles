-- use this like: local isTargetTargetingMe = gFunc.LoadFile('isTargetTargetingMe'); if (not isTargetTargetingMe()) then ...
-- based on isTargetTagged by will.8627 on the Ashita discord
-- and also targetlines by Jyouya

local targetedMobs = T {};

local function isMob(id)
    return bit.band(id, 0xFF000000) ~= 0;
end

local function handleActionPacket(e)
    local playerEntity = GetPlayerEntity();
    local playerId;
    if (playerEntity) then
        playerId = playerEntity.ServerId;
    else
        return;
    end

    local actorId = ashita.bits.unpack_be(e.data_raw, 0, 40, 32);
    if (not isMob(actorId)) then
        return
    end

    local targetCount = ashita.bits.unpack_be(e.data_raw, 0, 72, 6);
    local targetId = ashita.bits.unpack_be(e.data_raw, 0, 150, 32);

    if (targetCount > 0 and targetId == playerId) then
        targetedMobs[actorId] = os.clock()
    end
end

local deathMes = T { 6, 20, 97, 113, 406, 605, 646 };
local function handleMessagePacket(e)
    local message = struct.unpack('i2', e.data, 0x18 + 1);

    if (deathMes:contains(message)) then
        local target = struct.unpack('i4', e.data, 0x08 + 1);
        targetedMobs[target] = nil;
    end
end

local function isTargetTargetingMe()
    local targetManager = AshitaCore:GetMemoryManager():GetTarget();
    local isSubTargetActive = targetManager:GetIsSubTargetActive();

    local targetId = targetManager:GetServerId(isSubTargetActive == 1 and 1 or 0);

    local targeted = targetedMobs[targetId];

    return targeted and os.clock() - targeted < 10;
end

ashita.events.register('packet_in', 'packet_in_targeting_me_cb', function(e)
    if (e.id == 0x28) then
        handleActionPacket(e);
    elseif (e.id == 0x0029) then
        handleMessagePacket(e);
    elseif (e.id == 0x0A or e.id == 0x0B) then
        -- zone
        targetedMobs = T {};
    end
end);

return isTargetTargetingMe;
