-- This function allows you to cast the highest-priority status ailment recovery spell on a member of your party.

-- Place this file in the same directory as your WHM.lua etc.

local naSpell = T{};

-- priorityPlayers: a list of names of players who should be restored before others
local priorityPlayers = T{}; 

-- This is from HXUI's statushandler
local ptrPartyBuffs = ashita.memory.find('FFXiMain.dll', 0, 'B93C0000008D7004BF????????F3A5', 9, 0);
ptrPartyBuffs = ashita.memory.read_uint32(ptrPartyBuffs);

-- Call once at plugin load and keep reference to table
local function readPartyBuffsFromMemory()
    local ptrPartyBuffs = ashita.memory.read_uint32(AshitaCore:GetPointerManager():Get('party.statusicons'));
    local partyBuffTable = {};
    for memberIndex = 0,4 do
        local memberPtr = ptrPartyBuffs + (0x30 * memberIndex);
        local playerId = ashita.memory.read_uint32(memberPtr);
        if (playerId ~= 0) then
            local buffs = {};
            local empty = false;
            for buffIndex = 0,31 do
                if empty then
                    buffs[buffIndex + 1] = -1;
                else
                    local highBits = ashita.memory.read_uint8(memberPtr + 8 + (math.floor(buffIndex / 4)));
                    local fMod = math.fmod(buffIndex, 4) * 2;
                    highBits = bit.lshift(bit.band(bit.rshift(highBits, fMod), 0x03), 8);
                    local lowBits = ashita.memory.read_uint8(memberPtr + 16 + buffIndex);
                    local buff = highBits + lowBits;
                    if buff == 255 then
                        empty = true;
                        buffs[buffIndex + 1] = -1;
                    else
                        buffs[buffIndex + 1] = buff;
                    end
                end
            end
            partyBuffTable[playerId] = buffs;
        end
    end
    return partyBuffTable;
end
local partyBuffs = readPartyBuffsFromMemory();

--Call with incoming packet 0x076
local function readPartyBuffsFromPacket(e)
    local partyBuffTable = {};
    for i = 0,4 do
        local memberOffset = 0x04 + (0x30 * i) + 1;
        local memberId = struct.unpack('L', e.data, memberOffset);
        if memberId > 0 then
            local buffs = {};
            local empty = false;
            for j = 0,31 do
                if empty then
                    buffs[j + 1] = -1;
                else
                    --This is at offset 8 from member start.. memberoffset is using +1 for the lua struct.unpacks
                    local highBits = bit.lshift(ashita.bits.unpack_be(e.data_raw, memberOffset + 7, j * 2, 2), 8);
                    local lowBits = struct.unpack('B', e.data, memberOffset + 0x10 + j);
                    local buff = highBits + lowBits;
                    if (buff == 255) then
                        buffs[j + 1] = -1;
                        empty = true;
                    else
                        buffs[j + 1] = buff;
                    end
                end
            end
            partyBuffTable[memberId] = buffs;
        end
    end
    partyBuffs = partyBuffTable;
end

local function GetJobStr(jobIdx)
    if (jobIdx == nil or jobIdx == 0 or jobIdx == -1) then
        return '';
    end
    return AshitaCore:GetResourceManager():GetString("jobs.names_abbr", jobIdx);
end

local function isMage(job, subjob) 
    local mageJobs = T{'BLM', 'WHM', 'RDM', 'SMN', 'DRK', 'PLD', 'BLU', 'SCH', 'RUN', 'GEO'}
    local jobStr = GetJobStr(job);
    local sjStr = GetJobStr(subjob);
    return mageJobs:contains(jobStr) or mageJobs:contains(sjStr);
end

function naSpell.Cast()
    local party = AshitaCore:GetMemoryManager():GetParty();
    local player = AshitaCore:GetMemoryManager():GetPlayer();

    local highestPriority = 999;
    local afflictedPlayers = T{}; -- will pick one randomly from this list, unless priority has been given
    local numSleptPlayersWithin10 = 0;
    local spellName;

    for memberIdx = 0, 5 do
        local sameZone = party:GetMemberZone(memberIdx) == party:GetMemberZone(0);
        local job = party:GetMemberMainJob(memberIdx);
        local subjob = party:GetMemberSubJob(memberIdx);
        local serverId = party:GetMemberServerId(memberIdx);
        local buffIds = {}
        if (memberIdx == 0) then
            buffIds = player:GetBuffs();
        else
            buffIds = partyBuffs[serverId];
        end
        if (buffIds ~= nil) and sameZone then
            -- ailment priority:
            -- 0: Doom (Cursna) id 15
            -- 1: Sleep (Cure, or Curaga if 2+ slept party members are within 10 yalms) id 2 or 19
            -- 2: Petrify (Stona) id 7
            -- 3: Plague (Viruna) id 31
            -- 4: Silence on mage (Silena) id 6
            -- 5: Paralysis (Paralyna) id 4
            -- 6: Curse/Bane (Cursna) id 9, 20 and 30 
            -- 7: Blindness (Blindna) id 5
            -- 8: Disease (Viruna) id 8
            -- 9: Silence on non-mage (Silena) id 6

            -- Ignore poison (id 3 and 540)

            for i = 0, #buffIds do
                local buffId = buffIds[i];
                local priority = 999;
                if buffId == 15 then -- Doom
                    priority = 0
                    if highestPriority > priority then
                        highestPriority = priority;
                        afflictedPlayers = {};
                        numSleptPlayersWithin10 = 0;
                        spellName = "Cursna";
                    end
                    if highestPriority == priority then
                        table.insert(afflictedPlayers, party:GetMemberName(memberIdx))
                    end
                elseif (buffId == 2) or (buffId == 19) then -- Sleep
                    priority = 1
                    if highestPriority > priority then
                        highestPriority = priority;
                        afflictedPlayers = {};
                        numSleptPlayersWithin10 = 0;
                        spellName = "Cure";
                    end
                    if highestPriority == priority then
                        table.insert(afflictedPlayers, party:GetMemberName(memberIdx))
                        local targetIdx = party:GetMemberTargetIndex(memberIdx);
                        local distance = math.sqrt(AshitaCore:GetMemoryManager():GetEntity():GetDistance(targetIdx));
                        if distance <= 10 then
                            numSleptPlayersWithin10 = numSleptPlayersWithin10 + 1
                        end
                        -- if numSleptPlayersWithin10 > 1, then target becomes <me> and spellName becomes Curaga
                    end
                elseif buffId == 7 then -- Petrify
                    priority = 2
                    if highestPriority > priority then
                        highestPriority = priority;
                        afflictedPlayers = {};
                        numSleptPlayersWithin10 = 0;
                        spellName = "Stona";
                    end
                    if highestPriority == priority then
                        table.insert(afflictedPlayers, party:GetMemberName(memberIdx))
                    end
                elseif buffId == 31 then -- Plague
                    priority = 3
                    if highestPriority > priority then
                        highestPriority = priority;
                        afflictedPlayers = {};
                        numSleptPlayersWithin10 = 0;
                        spellName = "Viruna";
                    end
                    if highestPriority == priority then
                        table.insert(afflictedPlayers, party:GetMemberName(memberIdx))
                    end
                elseif buffId == 6 and isMage(job, subjob) then -- Silenced mage
                    priority = 4
                    if highestPriority > priority then
                        highestPriority = priority;
                        afflictedPlayers = {};
                        numSleptPlayersWithin10 = 0;
                        spellName = "Silena";
                    end
                    if highestPriority == priority then
                        table.insert(afflictedPlayers, party:GetMemberName(memberIdx))
                    end
                elseif buffId == 4 then -- Paralysis
                    priority = 5
                    if highestPriority > priority then
                        highestPriority = priority;
                        afflictedPlayers = {};
                        numSleptPlayersWithin10 = 0;
                        spellName = "Paralyna";
                    end
                    if highestPriority == priority then
                        table.insert(afflictedPlayers, party:GetMemberName(memberIdx))
                    end
                elseif (buffId == 9) or (buffId == 20) or (buffId == 30) then -- Curse/Bane
                    priority = 6
                    if highestPriority > priority then
                        highestPriority = priority;
                        afflictedPlayers = {};
                        numSleptPlayersWithin10 = 0;
                        spellName = "Cursna";
                    end
                    if highestPriority == priority then
                        table.insert(afflictedPlayers, party:GetMemberName(memberIdx))
                    end
                elseif buffId == 5 then -- Blind
                    priority = 7
                    if highestPriority > priority then
                        highestPriority = priority;
                        afflictedPlayers = {};
                        numSleptPlayersWithin10 = 0;
                        spellName = "Blindna";
                    end
                    if highestPriority == priority then
                        table.insert(afflictedPlayers, party:GetMemberName(memberIdx))
                    end
                elseif buffId == 8 then -- Disease
                    priority = 8
                    if highestPriority > priority then
                        highestPriority = priority;
                        afflictedPlayers = {};
                        numSleptPlayersWithin10 = 0;
                        spellName = "Viruna";
                    end
                    if highestPriority == priority then
                        table.insert(afflictedPlayers, party:GetMemberName(memberIdx))
                    end
                elseif buffId == 9 then -- Silenced non-mage
                    priority = 9
                    if highestPriority > priority then
                        highestPriority = priority;
                        afflictedPlayers = {};
                        numSleptPlayersWithin10 = 0;
                        spellName = "Silena";
                    end
                    if highestPriority == priority then
                        table.insert(afflictedPlayers, party:GetMemberName(memberIdx))
                    end
                end
            end
        end
        if numSleptPlayersWithin10 > 1 then
            AshitaCore:GetChatManager():QueueCommand(1, '/ma "Curaga" <me>');
        elseif highestPriority < 999 then
            local targets = {};
            for _, name in ipairs(priorityPlayers) do
                if afflictedPlayers:contains(name) then
                    table.insert(targets, name);
                end
            end
            if #targets < 1 then
                targets = afflictedPlayers;
            end
            local target = targets[math.random(#targets)]
            AshitaCore:GetChatManager():QueueCommand(1, '/ma "'..spellName..'" '..target);
        end
    end
end

function naSpell.SetPlayerPriority(priorityListArgs)
    local priorityListString = table.concat({unpack(priorityListArgs, 2)}, "");
    priorityPlayers = T{};
    local party = AshitaCore:GetMemoryManager():GetParty();
    local player = AshitaCore:GetMemoryManager():GetPlayer();

    for name in priorityListString:gmatch('[^,]+') do
        if (name ~= nil) then
            local charName = name.trim();
            if charName == "<me>" or charName == "<p0>" then
                priorityPlayers:insert(party:GetMemberName(0));
            elseif charName == "<t>" and gData.GetTarget() ~= nil then
                local targetEntity = gData.GetTarget();
                priorityPlayers:insert(targetEntity.Name);
            elseif charName == "<p1>" then
                priorityPlayers:insert(party:GetMemberName(1));
            elseif charName == "<p2>" then
                priorityPlayers:insert(party:GetMemberName(2));
            elseif charName == "<p3>" then
                priorityPlayers:insert(party:GetMemberName(3));
            elseif charName == "<p4>" then
                priorityPlayers:insert(party:GetMemberName(4));
            elseif charName == "<p5>" then
                priorityPlayers:insert(party:GetMemberName(5));
            else
                priorityPlayers:insert(charName);
            end
        end
    end
    gFunc.Echo(2, "High-priority -na spell targets: ["..table.concat(priorityPlayers, ", ").."]")
end

ashita.events.register('packet_in', 'packet_in_naspell_cb', function (e)
	if (e.id == 0x076) then
		readPartyBuffsFromPacket(e);
	end
end);

return naSpell;