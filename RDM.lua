local utilities = gFunc.LoadFile('utilities.lua')
local naSpell = gFunc.LoadFile('naSpell.lua')

local profile = {}
local melee = false

local sets = {
    Idle = {
        Head = 'Dls. Chapeau +1',
        Neck = 'Oneiros Torque',
        Ear1 = 'Loquac. Earring',
        Ear2 = 'Soil Earring',
        Body = 'Dalmatica',
        Hands = 'Dls. Gloves +1',
        Ring1 = 'Defending Ring',
        Ring2 = { Name = 'Dark Ring', Augment = { [1] = 'Magic dmg. taken -5%' } },
        Back = 'Umbra Cape',
        Waist = 'Oneiros Belt',
        Legs = 'Goliard Trews',
        Feet = 'Zenith Pumps +1',
    },
    Idle_Weapons = {
        Main = 'Elegy\'s Respite',
        Sub = 'Staff Strap',
    },
    Heal_Weapons = {
        Main = 'Tamaxchi',
        Sub = 'Genmei Shield',
    },
    DW_Weapons = {
        -- TODO
    },
    TPGain = {
        -- applied on top of idle set
        -- TODO
    },
    WS_Default = {
        -- TODO
    },
    Nuke = {
        -- Assume always magic bursting.
        Ammo = 'Rimestone',
        Head = 'Wlk. Chapeau +1',
        Neck = 'Lmg. Medallion +1',
        Ear1 = 'Novio Earring',
        Ear2 = 'Static Earring',
        Body = 'Morrigan\'s Robe',
        Hands = 'Zenith Mitts +1',
        Ring1 = 'Galdr Ring',
        Ring2 = 'Tamas Ring',
        Back = 'Hecate\'s Cape',
        Waist = 'Salire Belt',
        Legs = 'Dls. Tights +1',
        Feet = 'Uk\'uxkaj Boots',
    },
    DayWeatherNuke = {
        Waist = 'Hachirin-no-Obi',
    },
    Rest = {
        -- todo
        Main = 'Chatoyant Staff',
        Sub  = 'Staff Strap',
        Head = 'Goliard Chapeau',
        Body = 'Yigit Gomlek',
        -- Back = 'Blue Cape', -- augmented, hMP +2
        Waist = 'Qiqirn Sash',
        Legs = 'Yigit Seraweels',
        Feet = 'Goliard Clogs',
    },
    IntEnfeeble = {
        -- Head = 'Dls. Chapeau +1',
        Head = 'Blood Mask',
        Neck = 'Incanter\'s Torque',
        Ear1 = 'Enfeebling Earring',
        Ear2 = 'Spire Earring',
        Body = 'Wlk. Tabard +1',
        Hands = 'Avesta Bangles',
        Ring1 = 'Omega Ring',
        Ring2 = 'Tamas Ring',
        Back = 'Altruistic Cape',
        Waist = 'Duelist\'s Belt',
        Legs = 'Nashira Seraweels',
        Feet = 'Shadow Clogs',
    },
    MndEnfeeble = {
        -- Head = 'Dls. Chapeau +1',
        Head = 'Blood Mask',
        Neck = 'Incanter\'s Torque',
        Ear1 = 'Enfeebling Earring',
        Ear2 = 'Aqua Earring',
        Body = 'Wlk. Tabard +1',
        Hands = 'Avesta Bangles',
        Ring1 = 'Karka Ring',
        Ring2 = 'Tamas Ring',
        Back = 'Altruistic Cape',
        Waist = 'Duelist\'s Belt',
        Legs = 'Nashira Seraweels',
        Feet = 'Shadow Clogs',
    },
    Enhance = {
        Head = 'Zenith Crown +1',
        Neck = 'Incanter\'s Torque',
        Ear1 = 'Augment. Earring',
        Ear2 = 'Spire Earring',
        Body = 'Nashira Manteel',
        Hands = 'Dls. Gloves +1',
        Ring1 = 'Karka Ring',
        Ring2 = 'Tamas Ring',
        Back = 'Grapevine Cape',
        Waist = 'Pythia Sash +1',
        Legs = 'Wlk. Tights +1',
        Feet = 'Morrigan\'s Pgch.',
    },
    Stoneskin = {
        Neck = 'Stone Gorget',
    },
    Fast = {
        Legs = 'Blood Cuisses',
    },
    Weapons_Default = {
        -- TODO, melee weapons
    },
    Precast = {
        Head = 'Wlk. Chapeau +1',
        Ear1 = 'Loquac. Earring',
        Neck = 'Jeweled Collar',
        Body = 'Dls. Tabard +1',
        Hands = 'Dls. Gloves +1',
        Ring1 = { Name = 'Dark Ring', Augment = { [1] = '"Fast Cast"+1', [2] = '"Conserve MP"+3' } },
        Ring2 = 'Tamas Ring',
        Legs = 'Blood Cuisses',
        Back = 'Swith Cape +1',
        Feet = 'Rostrum Pumps',
    },
    PrecastHeal = {
        Back = 'Hierarch\'s Mantle',
        Feet = 'Zenith Pumps +1',
    },
    Heal = {
        Ammo = 'Hedgehog Bomb',
        Head = 'Maat\'s Cap',
        Neck = 'Fylgja Torque +1',
        Ear1 = 'Roundel Earring',
        Ear2 = 'Light Earring',
        Body = 'Blood Scale Mail',
        Hands = 'Augur\'s Gloves', -- BIS: Apogee Cuffs
        Ring1 = 'Karka Ring',
        Ring2 = 'Tamas Ring',
        Back = 'Dew Silk Cape +1',
        Waist = 'Pythia Sash +1',
        Legs = 'Wlk. Tights +1',
        Feet = 'Zenith Pumps +1',
    },
    Cursna = {
        Head = 'Wlk. Chapeau +1',
        Neck = 'Incanter\'s Torque',
        Ear1 = 'Loquac. Earring',
        Ear2 = 'Spire Earring',
        Body = 'Dls. Tabard +1',
        Hands = 'Dls. Gloves +1',
        Ring1 = { Name = 'Dark Ring', Augment = { [1] = '"Fast Cast"+1', [2] = '"Conserve MP"+3' } },
        Ring2 = 'Tamas Ring',
        Back = 'Swith Cape +1',
        Waist = 'Ninurta\'s Sash',
        Legs = 'Blood Cuisses',
        Feet = 'Rostrum Pumps',
    },
    ConserveMP = { -- plus a little haste and fast cast
        Ammo = 'Hedgehog Bomb',
        Head = 'Wlk. Chapeau +1',
        Neck = 'Incanter\'s Torque',
        Ear1 = 'Magnetic Earring',
        Ear2 = 'Adept\'s Earring',
        Body = 'Nashira Manteel',
        Hands = 'Cobra Gloves', -- conserve mp 5
        Ring1 = { Name = 'Dark Ring', Augment = { [1] = '"Fast Cast"+1', [2] = '"Conserve MP"+3' } },
        Ring2 = 'Tamas Ring',
        Back = 'Swith Cape +1', -- fast cast
        Waist = 'Pythia Sash +1',
        Legs = 'Cobra Trews', -- conserve mp 5
        Feet = 'Aife\'s Pumps',
    },
    PDT = {
        Ring1 = 'Defending Ring',
        Back = 'Umbra Cape',
    },
    MDT = {
        Ring1 = 'Defending Ring',
        Ring2 = { Name = 'Dark Ring', Augment = { [1] = 'Magic dmg. taken -5%' } },
    },
    BDT = {},
    Showoff = {},
}
profile.Sets = sets

profile.Packer = {
}

profile.OnLoad = function()
    gSettings.AllowAddSet = true
    utilities.Initialize()

    ;(function () AshitaCore:GetChatManager():QueueCommand(1, '/lockstyleset 1') end):once(3)
    -- TODO: set these based on subjob
    -- AshitaCore:GetChatManager():QueueCommand(1, '/macro book 2')
    -- AshitaCore:GetChatManager():QueueCommand(1, '/macro set 1')
end

profile.OnUnload = function()
end

profile.HandleCommand = function(args)
    if args[1] == 'naspell' then
        naSpell.Cast()
    elseif args[1] == 'naspellprio' then
        -- comma-delimited list of player names
        naSpell.SetPlayerPriority(args)
    elseif args[1] == 'melee' then
        melee = not melee
        gFunc.Echo(255,  'Melee [' .. (melee and 'ON' or 'OFF') .. ']')
        gFunc.EquipSet(sets.Weapons_Default)
    end
    utilities.HandleCommands(args)
end

profile.HandleDefault = function()
    local player = gData.GetPlayer()

    if (player.Status == 'Engaged') then
        gFunc.EquipSet(sets.Idle)
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
        if not melee then
            gFunc.EquipSet(sets.Idle_Weapons)
        end
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
    if (spell.Name:match('^Cure')) or (spell.Name:match('^Cura')) then
        gFunc.EquipSet(sets.PrecastHeal)
    end
    utilities.CheckCancels()
end

profile.HandleMidcast = function()
    local spell = gData.GetAction()
    if (spell.Skill == 'Elemental Magic') then
        gFunc.EquipSet(sets.Nuke)
        local environment = gData.GetEnvironment()
        local dayElement = environment.DayElement
        local weatherElement = environment.WeatherElement
        if
            not T{"None", "Unknown"}:contains(weatherElement) and
            spell.Element == weatherElement
        then
            gFunc.EquipSet(sets.DayWeatherNuke)
        end

        if
            not T{"None", "Unknown"}:contains(dayElement) and
            spell.Element == dayElement
        then
            gFunc.EquipSet(sets.DayWeatherNuke)
        end
    elseif (spell.Skill == 'Healing Magic') then
        if (spell.Name == 'Cursna') then
            -- healing magic+, haste, fast cast
            gFunc.EquipSet(sets.Cursna)
        else
            gFunc.EquipSet(sets.Heal)
        end
    elseif (spell.Skill == 'Enfeebling Magic') then
        if
            T{'Paralyze', 'Paralyze II', 'Slow', 'Slow II', 
             'Frazzle', 'Distract', 'Flash', 'Silence'}:contains(spell.Name)
        then
            gFunc.EquipSet(sets.MndEnfeeble)
        else
            gFunc.EquipSet(sets.IntEnfeeble)
        end
    elseif (spell.Skill == 'Enhancing Magic') then
        gFunc.EquipSet(sets.Enhance)
        if (spell.Name == 'Stoneskin') then
            gFunc.EquipSet(sets.Stoneskin)
        end
        if T{'Haste', 'Refresh'}:contains(spell.Name) then
            gFunc.EquipSet(sets.ConserveMP)
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
