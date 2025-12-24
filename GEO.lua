utilities = gFunc.LoadFile('utilities.lua')
naSpell = gFunc.LoadFile('naSpell.lua')

local petdef = false

local profile = {}
local sets = {
    Idle = {
        Head = 'Geomancy Galero',
        Neck = 'Incanter\'s Torque',
        Ear1 = 'Loquac. Earring',
        Ear2 = 'Soil Earring',
        Body = 'Morrigan\'s Robe',
        Hands = 'Bagua Mitaines +1',
        Ring1 = 'Tamas Ring',
        Ring2 = 'Bagua Ring',
        Back = 'Shadow Mantle',
        Waist = 'Bagua Sash',
        Legs = 'Goliard Trews',
        Feet = 'Bagua Sandals +1',
    },
    Weapons_Default = {
        Main = 'Idris',
        Sub = 'Genbu\'s Shield',
        Range = 'Dunna',
    },
    Heal_Weapons = {
        Main = 'Tamaxchi',
        Sub = 'Genbu\'s Shield',
    },
    Geoskill = {
        Head = 'Geomancy Galero',
        Neck = 'Incanter\'s Torque',
        Ear1 = 'Loquac. Earring',
        Ear2 = 'Magnetic Earring',
        Body = 'Bagua Tunic +1',
        Hands = 'Geomancy Mitaines',
        Ring1 = 'Tamas Ring',
        Ring2 = 'Bagua Ring',
        Back = 'Shadow Mantle',
        Waist = 'Bagua Sash',
        Legs = 'Bagua Pants +1',
        Feet = 'Medium\'s Sabots',
    },
    LifeCycle = {
        Body = 'Geomancy Tunic',
    },
    Rest = {
        Main = 'Chatoyant Staff',
        Sub = 'Staff Strap',
        Head = 'Geomancy Galero',
        Neck = 'Gnole Torque',
        Ear1 = 'Darkness Earring',
        Ear2 = 'Magnetic Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Bagua Mitaines +1',
        Ring1 = 'Star Ring',
        Ring2 = 'Star Ring',
        Back = 'Blue Cape', -- augmented, hMP +2
        Waist = 'Hierarch Belt',
        Legs = 'Yigit Seraweels',
        Feet = 'Goliard Clogs',
    },
    Fast = {
        Feet = 'Herald\'s Gaiters'
    },
    Pet_Def = {
        -- todo: pet def, pet regen
        Hands = 'Geomancy Mitaines',
        Waist = 'Bagua Sash',
        Legs = 'Goliard Trews',
    },
    Precast = {
        Head = 'Windfall Hat',
        Ear1 = 'Loquac. Earring',
        Body = 'Dalmatica +1',
        Hands = 'Bagua Mitaines +1',
        Ring1 = 'Dark Ring',
        Ring2 = 'Hibernal Ring',
        Back = 'Swith Cape +1',
        Legs = 'Geomancy Pants',
        Feet = 'Rostrum Pumps',
    },
    PrecastHeal = {
        Feet = 'Zenith Pumps +1', -- cure clogs?
    },
    Nuke = {
        Head = 'Geomancy Galero',
        Neck = 'Lmg. Medallion +1',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Morrigan\'s Robe',
        Hands = 'Zenith Mitts +1',
        Ring1 = 'Tamas Ring',
        Ring2 = 'Galdr Ring',
        Back = 'Voluspa Mantle',
        Waist = 'Charmer\'s Sash',
        Legs = 'Shadow Trews',
        Feet = 'Bagua Sandals +1',
    },
    Heal = {
        Head = 'Maat\'s Cap',
        Neck = 'Fylgja Torque +1',
        Ear1 = 'Aqua Earring',
        Ear2 = 'Light Earring',
        Body = 'Bagua Tunic +1',
        Hands = 'Geomancy Mitaines',
        Ring1 = 'Tamas Ring',
        Ring2 = 'Karka Ring',
        Back = 'Dew Silk Cape +1',
        Waist = 'Bagua Sash',
        Legs = 'Bagua Pants +1',
        Feet = 'Zenith Pumps +1',
    },
    Haste = { -- and esuna, and cursna
        Head = 'Windfall Hat',
        Neck = 'Incanter\'s Torque',
        Ear1 = 'Loquac. Earring',
        Ear2 = 'Magnetic Earring',
        Body = 'Dalmatica +1',
        Hands = 'Bagua Mitaines +1',
        Ring1 = 'Dark Ring',
        Ring2 = 'Hibernal Ring',
        Back = 'Swith Cape +1',
        Waist = 'Ninurta\'s Sash',
        Legs = 'Geomancy Pants',
        Feet = 'Rostrum Pumps',
    },
    Enhancing = {
        Head = 'Maat\'s Cap',
        Neck = 'Incanter\'s Torque',
        Ear1 = 'Brachyura Earring',
        Ear2 = 'Aqua Earring',
        Body = 'Nashira Manteel',
        Hands = 'Geomancy Mitaines',
        Ring1 = 'Tamas Ring',
        Ring2 = 'Karka Ring',
        Back = 'Grapevine Cape',
        Waist = 'Bagua Sash',
        Legs = 'Bagua Pants +1',
        Feet = 'Bagua Sandals +1',
    },
    Stoneskin = {
        Neck = 'Stone Gorget',
    },
    Enfeebling = {}, -- TODO
    Dark = {
        Head = 'Bagua Galero',
        Neck = 'Incanter\'s Torque',
        Ear1 = 'Novio Earring',
        Ear2 = 'Abyssal Earring',
        Body = 'Geomancy Tunic',
        Hands = 'Zenith Mitts +1',
        Ring1 = 'Tamas Ring',
        Ring2 = 'Galdr Ring',
        Back = 'Voluspa Mantle',
        Waist = 'Charmer\'s Sash',
        Legs = 'Bagua Pants +1',
        Feet = 'Bagua Sandals +1',
    },
    TPGain = {
        -- normal stuff like haste, acc, store TP... but also pet regen. Probably will still have a luopan out while meleeing.
        Head = 'Windfall Hat',
        Neck = 'Prudence Torque',
        Ear1 = 'Brutal Earring +1',
        Ear2 = 'Hollow Earring',
        Body = 'Goliard Saio',
        Hands = 'Ornate Gloves',
        Ring1 = 'Rajas Ring',
        Ring2 = 'Bagua Ring',
        Back = 'Aife\'s Mantle',
        Waist = 'Bagua Sash',
        Legs = 'Enticer\'s Pants',
        Feet = 'Bagua Sandals +1', -- just for the luopan regen
    },
    WS_Default = {
         -- Exudiation is INT and MND
        Head = 'Maat\'s Cap',
        Neck = 'Fotia Gorget',
        Ear1 = 'Brutal Earring +1',
        Ear2 = 'Emberpearl Earring',
        Body = 'Morrigan\'s Robe',
        Hands = 'Yigit Gages',
        Ring1 = 'Rajas Ring',
        Ring2 = 'Tamas Ring',
        Back = 'Stormlord Shawl +1',
        Waist = 'Visionary Obi',
        Legs = 'Bagua Pants +1',
        Feet = 'Bagua Sandals +1',
    },
}
profile.Sets = sets

profile.Packer = {
}

profile.OnLoad = function()
    gSettings.AllowAddSet = true
    utilities.Initialize();

    (function ()
        AshitaCore:GetChatManager():QueueCommand(1, '/lockstyleset 13')
        AshitaCore:GetChatManager():QueueCommand(1, '/macro book 1')
        gFunc.ForceEquipSet(sets.Weapons_Default)
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
    elseif args[1] == 'petdef' then
        petdef = not petdef
        gFunc.Echo(255,  'Pet PDT [' .. (petdef and 'ON' or 'OFF') .. ']')
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
        -- TODO make the next line configurable
        gFunc.EquipSet(sets.Weapons_Default)
    end

    if (T{'PDT', 'MDT', 'BDT'}:contains(utilities.OverrideSet)) then
        -- damage-taken sets take precedence over everything
        gFunc.EquipSet(utilities.OverrideSet)
    end

    if petdef then
        gFunc.EquipSet(sets.Pet_Def)
    end

    utilities.CheckDefaults()
end

profile.HandleAbility = function()
    local ability = gData.GetAction();
    if (ability.Name == 'Life Cycle') then
		gFunc.EquipSet(sets.LifeCycle);
	end

    utilities.CheckCancels()
end

profile.HandleItem = function()
end

profile.HandlePrecast = function()
    local spell = gData.GetAction()
    gFunc.EquipSet(sets.Precast)
    if (spell.Skill == 'Healing Magic') then
        gFunc.EquipSet(sets.PrecastHeal)
    end
    utilities.CheckCancels()
end

profile.HandleMidcast = function()
    local spell = gData.GetAction()
    local player = gData.GetPlayer()

    if (T{'Haste', 'Erase', 'Esuna'}:contains(spell.Name)) then
        -- lower recast
        gFunc.EquipSet(sets.Haste);
    elseif (spell.Skill == 'Enhancing Magic') then
        gFunc.EquipSet(sets.Enhancing)
        if (spell.Name == 'Stoneskin') then
            gFunc.EquipSet(sets.Stoneskin);
        end
    elseif (spell.Skill == 'Healing Magic') then
        if (spell.Name == 'Cursna') then
            -- healing magic+, haste, fast cast
            gFunc.EquipSet(sets.Haste);
        else
            gFunc.EquipSet(sets.Heal);
        end
        if (player.Status ~= 'Engaged') then
            gFunc.EquipSet(sets.Heal_Weapons);
        end
    elseif (spell.Skill == 'Geomancy') then
        gFunc.EquipSet(sets.Geoskill)
    elseif (spell.Skill == 'Elemental Magic') then
        gFunc.EquipSet(sets.Nuke)
    elseif (spell.Skill == 'Enfeebling Magic') then
        gFunc.EquipSet(sets.Enfeebling)
    elseif (spell.Skill == 'Dark Magic') then
        gFunc.EquipSet(sets.Dark)
    end
end

profile.HandlePreshot = function()
end

profile.HandleMidshot = function()
end

profile.HandleWeaponskill = function()
    gFunc.EquipSet(sets.WS_Default)
end

return profile