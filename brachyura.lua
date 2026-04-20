-- This brachyuraActive helper function lets your luashitacast know that a party member
-- is casting protectra/shellra, or is casting protect/shell on you. That way you can
-- equip a Brachyura earring or Sheltered ring to get the bonus DEF/MDT.

-- Place this file in the same directory as your other luas.

local ST_WAIT_TIME = 5.0 -- single target
local RA_WAIT_TIME = 8.0 -- AoE

local ST_SPELLS =
T{
    43, -- PROTECT
    44, -- PROTECT_II
    45, -- PROTECT_III
    46, -- PROTECT_IV
    47, -- PROTECT_V
    48, -- SHELL
    49, -- SHELL_II
    50, -- SHELL_III
    51, -- SHELL_IV
    52, -- SHELL_V
}

local RA_SPELLS =
T{
    125, -- PROTECTRA
    126, -- PROTECTRA_II
    127, -- PROTECTRA_III
    128, -- PROTECTRA_IV
    129, -- PROTECTRA_V
    130, -- SHELLRA
    131, -- SHELLRA_II
    132, -- SHELLRA_III
    133, -- SHELLRA_IV
    134, -- SHELLRA_V
}

local brachyuraUntil = 0

local function ParseActionPacket(e)
    local bitData
    local bitOffset
    local maxLength = e.size * 8
    local function UnpackBits(length)
        if ((bitOffset + length) >= maxLength) then
            maxLength = 0
            return 0
        end
        local value = ashita.bits.unpack_be(bitData, 0, bitOffset, length)
        bitOffset = bitOffset + length
        return value
    end

    local actionPacket = T {}
    bitData = e.data_raw
    bitOffset = 40
    actionPacket.UserId = UnpackBits(32)

    local targetCount = UnpackBits(6)
    --Unknown 4 bits
    bitOffset = bitOffset + 4
    actionPacket.Type = UnpackBits(4)
    actionPacket.Id = UnpackBits(32)

    actionPacket.Recast = UnpackBits(32)

    actionPacket.Targets = T {}
    if (targetCount > 0) then
        for i = 1, targetCount do
            local target = T {}
            target.Id = UnpackBits(32)
            local actionCount = UnpackBits(4)
            target.Actions = T {}
            if (actionCount > 0) then
                for j = 1, actionCount do
                    local action = {}
                    action.Reaction = UnpackBits(5)
                    action.Animation = UnpackBits(12)
                    action.SpecialEffect = UnpackBits(7)
                    action.Knockback = UnpackBits(3)
                    action.Param = UnpackBits(17)
                    action.Message = UnpackBits(10)
                    action.Flags = UnpackBits(31)

                    local hasAdditionalEffect = (UnpackBits(1) == 1)
                    if hasAdditionalEffect then
                        local additionalEffect = {}
                        additionalEffect.Damage = UnpackBits(10)
                        additionalEffect.Param = UnpackBits(17)
                        additionalEffect.Message = UnpackBits(10)
                        action.AdditionalEffect = additionalEffect
                    end

                    local hasSpikesEffect = (UnpackBits(1) == 1)
                    if hasSpikesEffect then
                        local spikesEffect = {}
                        spikesEffect.Damage = UnpackBits(10)
                        spikesEffect.Param = UnpackBits(14)
                        spikesEffect.Message = UnpackBits(10)
                        action.SpikesEffect = spikesEffect
                    end

                    target.Actions:append(action)
                end
            end
            actionPacket.Targets:append(target)
        end
    end

    return actionPacket
end

local function isPartyMember(serverId)
    if (serverId == nil or serverId == 0) then
        return false
    end

    local party = AshitaCore:GetMemoryManager():GetParty()
    if (party == nil) then
        return false
    end

    for i = 0, 5 do
        if (party:GetMemberServerId(i) == serverId) then
            return true
        end
    end

    return false
end

local function onAction(e)
    local playerEntity = GetPlayerEntity()
    local playerId
    if (playerEntity) then
        playerId = playerEntity.ServerId
    else
        return
    end
    local actionPacket = ParseActionPacket(e)

    if (actionPacket == nil) then
        return
    end

    for _, target in ipairs(actionPacket.Targets or {}) do
        for _, action in ipairs(target.Actions or {}) do
            local messageId = action.Message
            local spellId = action.Param

            if (messageId == 3 or messageId == 327) then
                if (ST_SPELLS:contains(spellId) and target.Id == playerId) then
                    brachyuraUntil = os.clock() + ST_WAIT_TIME
                    return
                end

                if (RA_SPELLS:contains(spellId) and isPartyMember(actionPacket.UserId)) then
                    brachyuraUntil = os.clock() + RA_WAIT_TIME
                    return
                end
            end
        end
    end
end

local function equipBrachyura()
    return os.clock() < brachyuraUntil
end

ashita.events.register('packet_in', 'packet_in_brach_cb', function(e)
    if (e.id == 0x28) then
        onAction(e)
    end
end)

return equipBrachyura