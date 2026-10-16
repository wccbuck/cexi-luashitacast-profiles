local utilities = gFunc.LoadFile('utilities.lua')
local naSpell = gFunc.LoadFile('naSpell.lua')

local profile = {}

local freenuke = true

local sets = {
    Heal = {
        Ammo = 'Enlightenment',
        Head = 'Cobra Cloche', -- conserve mp
        Neck = 'Fylgja Torque +1', -- cure pot +3
        Ear1 = 'Light Earring', -- cure pot +2
        Ear2 = 'Light Earring', -- cure pot +2
        Body = 'Marduk\'s Jubbah', -- MND 12
        Hands = 'Augur\'s Gloves', -- cure pot +3
        Ring1 = 'Karka Ring', -- mnd +6
        Ring2 = 'Tamas Ring', -- mnd +5, MP+30
        Back = 'Dew Silk Cape +1', -- cure pot +3, mnd +6
        Waist = 'Pythia Sash',
        Legs = 'Scholar\'s Pants +1', --6%
        Feet = 'Argute Loafers +1', --4%
    },
    Cure_Weapons = {
        Main = 'Tamaxchi',
        Sub = 'Genmei Shield', -- cure pot +8
    },
    Idle = {
        -- refresh, regen, -dt
        Ammo = 'Hedgehog Bomb',
        Head = 'Sch. M.board +1',
        Neck = 'Fylgja Torque +1', -- fomor necklace
        Ear1 = 'Soil Earring',
        Ear2 = 'Loquac. Earring',
        Body = 'Marduk\'s Jubbah',
        Hands = 'Sch. Bracers +1',
        Ring1 = 'Defending Ring',
        Ring2 = 'Tamas Ring',
        Back = 'Umbra Cape',
        Waist = 'Lieutenant\'s Sash',
        Legs = 'Goliard Trews',
        Feet = 'Herald\'s Gaiters',
    },
    TPGain = {
        Hands = 'Sage\'s Cuffs',
    },
    WS_Default = {
    },
    Haste = {
        -- fast cast and haste, also conserve mp
        Head = 'Windfall Hat',
        Ear1 = 'Magnetic Earring',
        Ear2 = 'Loquac. Earring',
        Body = 'Marduk\'s Jubbah',
        Hands = 'Argute Bracers +1', -- fast cast aug
        Ring1 = { Name = 'Dark Ring', Augment = { [1] = '"Fast Cast"+1', [2] = '"Conserve MP"+3' } },
        Ring2 = 'Tamas Ring',
        Back = 'Swith Cape +1',
        Waist = 'Ninurta\'s Sash',
        Legs = 'Scholar\'s Pants +1', -- conserve MP +5
        Feet = 'Argute Loafers +1',
    },
    Cursna = {
        -- the priority here is fast cast / haste,
        -- followed by healing magic.
        -- Each 30 points of healing magic+ increases the chance of
        -- removing Doom by only 1%, so it's generally more important
        -- to focus on reducing recast cooldown.
        -- At 0 skill: 10% of removing Doom
        -- At 300 skill: 20%
        -- At 330 skill: 21%
        Head = 'Windfall Hat',
        Neck = 'Incanter\'s Torque',
        Ear2 = 'Loquac. Earring',
        Body = 'Marduk\'s Jubbah',
        Hands = 'Argute Bracers +1', -- fast cast aug
        Ring1 = { Name = 'Dark Ring', Augment = { [1] = '"Fast Cast"+1', [2] = '"Conserve MP"+3' } },
        Ring2 = 'Tamas Ring',
        Back = 'Swith Cape +1',
        Waist = 'Ninurta\'s Sash',  -- eventually manaflow
        Legs = 'Marduk\'s Shalwar', -- set bonus
        Feet = 'Argute Loafers +1',
    },
    Precast = {
        Head = 'Windfall Hat',
        Ear2 = 'Loquac. Earring',
        Body = 'Marduk\'s Jubbah',
        Hands = 'Argute Bracers +1', -- fast cast aug
        Ring1 = { Name = 'Dark Ring', Augment = { [1] = '"Fast Cast"+1', [2] = '"Conserve MP"+3' } },
        Ring2 = 'Tamas Ring',
        Back = 'Swith Cape +1',
        -- Waist = 'Ninurta\'s Sash', -- eventually manaflow
        Legs = 'Marduk\'s Shalwar', -- set bonus
        Feet = 'Argute Loafers +1',
    },
    PrecastHeal = {
        Back = 'Hierarch\'s Mantle',
    },
    PrecastHeal_Campaign = {
        Waist = 'Capricornian Rope',
    },
    Regen = {
        Head = 'Cobra Cloche',
        Neck = 'Fylgja Torque +1',
        Ear1 = 'Magnetic Earring',
        Ear2 = 'Loquac. Earring',
        Body = 'Goliard Saio', -- conserve MP
        Hands = 'Argute Bracers +1',
        Ring1 = { Name = 'Dark Ring', Augment = { [1] = '"Fast Cast"+1', [2] = '"Conserve MP"+3' } },
        Ring2 = 'Tamas Ring',
        Back = 'Grapevine Cape',
        Waist = 'Argute Belt', -- enh. magic duration
        Legs = 'Scholar\'s Pants +1',
        Feet = 'Argute Loafers +1',
    },
    Coeus = {
        Main = 'Coeus', -- regen duration, conserve mp
        Sub = 'Staff Strap',
        -- Sub = 'Wizzan Grip', -- conserve MP
    },
    MatchingDay = {
        Waist = 'Hachirin-no-Obi',
    },
    MatchingWeather = {
        Waist = 'Hachirin-no-Obi',
    },
    Stoneskin = {
        Neck = 'Stone Gorget',
    },
    Divine = {
        Ammo = 'Mana Ampulla',
        Head = 'Marduk\'s Tiara', -- divine 7
        Neck = 'Jokushu Chain', -- divine 10
        Ear1 = 'Knight\'s Earring', -- divine 5
        Ear2 = 'Spire Earring', -- divine +3
        Body = 'Marduk\'s Jubbah', -- MND 12
        -- Hands = 'Blessed Mitts', -- MND 7
        Ring1 = 'Karka Ring', -- MND 6
        Ring2 = 'Hieratic Ring', -- MND 5, divine 7
        Back = 'Dew Silk Cape +1', -- MND 6
        Waist = 'Salire Belt', -- MND 5, m.acc 4, MAB 4
        Legs = 'Scholar\'s Pants +1',
        Feet = 'Aife\'s Pumps',
    },
    Divine_Weapons = {
        Main = 'Coeus',
        Sub = 'Light Grip',
    },
    DrainAspir = {
        Ammo = 'Rimestone',
        Head = 'Sch. M.board +1',
        Neck = 'Incanter\'s Torque',
        Ear1 = 'Abyssal Earring',
        Ear2 = 'Spire Earring',
        Body = 'Scholar\'s Gown +1',
        Hands = 'Yigit Gages',
        Ring1 = 'Galdr Ring',
        Ring2 = 'Tamas Ring',
        Legs = 'Argute Pants +1',
        Feet = 'Sch. Loafers +1', -- drain/aspir potency +5
    },
    Rest = {
        Main = 'Chatoyant Staff',
        Sub = 'Staff Strap',
        Ammo = 'Mana Ampulla',
        Head = 'Goliard Chapeau',
        Neck = 'Gnole Torque',
        Ear1 = 'Darkness Earring',
        Ear2 = 'Darkness Earring',
        Body = 'Scholar\'s Gown +1',
        Hands = 'Sch. Bracers +1',
        Ring1 = 'Star Ring',
        Ring2 = 'Star Ring',
        -- Back = 'Blue Cape', -- augmented, hMP +2
        Waist = 'Qiqirn Sash',
        Legs = 'Yigit Seraweels',
        Feet = 'Goliard Clogs',
    },
    Enhancing = {
        -- Head = 'Hlr. Cap +1',
        Head = 'Cobra Cloche',
        Neck = 'Fylgja Torque +1',
        Ear1 = 'Augment. Earring',
        Ear2 = 'Spire Earring',
        Body = 'Argute Gown +1',
        Hands = 'Sch. Bracers +1',
        -- Hands = 'Cobra Gloves', -- conserve mp?
        Ring1 = 'Karka Ring',
        Ring2 = 'Tamas Ring',
        Back = 'Grapevine Cape',
        Waist = 'Argute Belt',
        Legs = 'Scholar\'s Pants +1',
        Feet = 'Argute Loafers +1',
    },
    ProShell = {
        Ear1 = 'Brachyura Earring',
    },
    Enfeeble = {
        Ammo = 'Rimestone',
        Head = 'Argute M.board +1',
        Neck = 'Incanter\'s Torque',
        Ear1 = 'Enfeebling Earring',
        Ear2 = 'Spire Earring',
        Body = 'Scholar\'s Gown +1',
        Hands = 'Argute Bracers +1',
        Ring1 = 'Omega Ring',
        Ring2 = 'Tamas Ring',
        Back  = 'Hecate\'s Cape',
        Waist = 'Argute Belt',
        Legs  = 'Argute Pants +1',
        Feet = 'Sch. Loafers +1',
    },
    Sublimation = {
        Head = 'Sch. M.board +1',
        Body = 'Argute Gown +1',
    },
    FreeNuke = {
        Ammo = 'Rimestone',
        Head = 'Sch. M.board +1',
        Neck = 'Lmg. Medallion +1',
        Ear1 = 'Novio Earring',
        Ear2 = 'Adept\'s Earring',
        Body = 'Scholar\'s Gown +1',
        Hands = 'Yigit Gages',
        -- Ring1 = 'Hibernal Ring',
        Ring1 = 'Galdr Ring',
        Ring2 = 'Tamas Ring',
        Back  = 'Hecate\'s Cape',
        Waist = 'Argute Belt',
        Legs  = 'Argute Pants +1',
        Feet  = 'Uk\'uxkaj Boots',
    },
    MBNuke = {
        Ammo = 'Rimestone',
        Head = 'Sch. M.board +1',
        Neck = 'Lmg. Medallion +1',
        Ear1 = 'Novio Earring',
        Ear2 = 'Static Earring',
        Body = 'Scholar\'s Gown +1',
        Hands = 'Yigit Gages',
        -- Ring1 = 'Hibernal Ring',
        Ring1 = 'Galdr Ring',
        Ring2 = 'Tamas Ring',
        Back  = 'Hecate\'s Cape',
        Waist = 'Argute Belt',
        Legs  = 'Argute Pants +1',
        Feet  = 'Uk\'uxkaj Boots',
    },
    Fast = {
        Feet = 'Herald\'s Gaiters'
    },
    Weapons_Default = {
        -- Main = 'Coeus',
        Main = 'Elegy\'s Respite',
        -- Main = 'Tamaxchi',
        Sub = 'Staff Strap',
        -- Sub = 'Sindri',
    },
    PDT = {
        -- TODO
        Ear1 = 'Soil Earring',
        Ear2 = 'Soil Earring',
        Back = 'Umbra Cape',
        Legs = 'Goliard Trews',
    },
    MDT = {
        -- TODO
        Back = 'Colossus\'s Mantle',
        Waist = 'Argute Belt',
    },
    BDT = {},
    Showoff = {},
}
profile.Sets = sets

profile.Packer = {}

profile.OnLoad = function()
    gSettings.AllowAddSet = true
    utilities.Initialize()

    ;(function ()
        AshitaCore:GetChatManager():QueueCommand(1, '/lockstyleset 4')
        -- gFunc.ForceEquipSet(sets.Weapons_Default)
    end):once(3)
end

profile.OnUnload = function()
end

profile.HandleCommand = function(args)
    if args[1] == 'naspell' then
        naSpell.Cast()
    elseif args[1] == 'naspellprio' then
        -- comma-delimited list of player names
        naSpell.SetPlayerPriority(args)
    elseif args[1] == 'freenuke' then
        freenuke = not freenuke
        gFunc.Echo(255,  'FreeNuke [' .. (freenuke and 'ON' or 'OFF') .. ']')
    end
    utilities.HandleCommands(args)
end

profile.HandleDefault = function()
    local player = gData.GetPlayer()

    if (player.Status == 'Engaged') then
        gFunc.EquipSet(sets.TPGain)
        -- if all three weapon slots are empty during combat,
        -- equip the default weapon set (useful against merrows)
        utilities.ResetDefaultWeapons(sets.Weapons_Default)
    elseif (player.Status == 'Resting') then
        gFunc.EquipSet(sets.Rest)
    elseif (player.IsMoving) then
		gFunc.EquipSet(sets.Fast)
    else
        gFunc.EquipSet(sets.Idle)
        if gData.GetBuffCount(187) > 0 then -- 'sublimation activated'
            gFunc.EquipSet(sets.Sublimation)
        end
        -- TODO make the next line configurable
        gFunc.EquipSet(sets.Weapons_Default)
    end

    if (T{'PDT', 'MDT', 'BDT'}:contains(utilities.OverrideSet)) then
        -- damage-taken sets take precedence over everything
        gFunc.EquipSet(utilities.OverrideSet)
    end

    utilities.CheckDefaults()
end

profile.HandleAbility = function()
    utilities.CheckCancels()
end

profile.HandleItem = function()
end

profile.HandlePrecast = function()
    local spell = gData.GetAction()
    gFunc.EquipSet(sets.Precast)
    if (spell.Skill == 'Healing Magic') then
        gFunc.EquipSet(sets.PrecastHeal)
        if gData.GetBuffCount('Allied Tags') > 0 then
            gFunc.EquipSet(sets.PrecastHeal_Campaign)
        end
    end
    utilities.CheckCancels()
end

profile.HandleMidcast = function()
    local spell = gData.GetAction()
    local player = gData.GetPlayer()

    -- local target = gData.GetActionTarget()
    -- local me = AshitaCore:GetMemoryManager():GetParty():GetMemberName(0)
    if (T{'Haste', 'Erase', 'Esuna'}:contains(spell.Name)) then
        -- lower recast
        gFunc.EquipSet(sets.Haste)
        if (player.Status ~= 'Engaged') then
            gFunc.EquipSet(sets.Coeus)
        end
    elseif (spell.Skill == 'Enhancing Magic') then
        if (string.contains(spell.Name, 'Regen')) then
            gFunc.EquipSet(sets.Regen)
        else
            gFunc.EquipSet(sets.Enhancing)
        end
        if (spell.Name == 'Stoneskin') then
            gFunc.EquipSet(sets.Stoneskin)
        end
        if 
            (player.Status ~= 'Engaged') and
            not string.contains(spell.Name, 'Teleport')
        then
            gFunc.EquipSet(sets.Coeus)
        end
    elseif (spell.Skill == 'Healing Magic') then
        if (spell.Name == 'Cursna') then
            -- healing magic+, haste, fast cast
            gFunc.EquipSet(sets.Cursna)
        else
            gFunc.EquipSet(sets.Heal)
        end
        if (player.Status ~= 'Engaged') then
            if (spell.Name:match('^Cure')) or (spell.Name:match('^Cura')) then
                gFunc.EquipSet(sets.Cure_Weapons)
            else
                gFunc.EquipSet(sets.Coeus)
            end
        end
    elseif (spell.Skill == 'Enfeebling Magic') then
        gFunc.EquipSet(sets.Enfeeble)
        if (player.Status ~= 'Engaged') then
            gFunc.EquipSet(sets.Coeus)
        end
    elseif (spell.Skill == 'Divine Magic') then
        gFunc.EquipSet(sets.Divine)
        if (player.Status ~= 'Engaged') then
            gFunc.EquipSet(sets.Divine_Weapons)
        end
    elseif (spell.Skill == 'Elemental Magic') then
        if freenuke then
            gFunc.EquipSet(sets.FreeNuke)
        else
            gFunc.EquipSet(sets.MBNuke)
        end

        if (player.Status ~= 'Engaged') then
            gFunc.EquipSet(sets.Coeus)
        end

        local environment = gData.GetEnvironment()
        local dayElement = environment.DayElement
        local weatherElement = environment.WeatherElement
        if
            not T{'None', 'Unknown'}:contains(weatherElement) and
            spell.Element == weatherElement
        then
            gFunc.EquipSet(sets.MatchingWeather)
        end

        if
            not T{'None', 'Unknown'}:contains(dayElement) and
            spell.Element == dayElement
        then
            gFunc.EquipSet(sets.MatchingDay)
        end
    end

end

profile.HandlePreshot = function()
end

profile.HandleMidshot = function()
end

profile.HandleWeaponskill = function()
    -- TODO
    -- local target = gData.GetActionTarget()
    -- if (tonumber(target.Distance) > 4.7) then
    --     gFunc.Echo(255, "Get closer!")
    --     gFunc.CancelAction()
    --     return
    -- end
    --
    gFunc.EquipSet(sets.WS_Default)
end

return profile
