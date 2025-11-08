utilities = gFunc.LoadFile('utilities.lua');

local profile = {};

local sets = {
    Idle = {
        Head = 'Wzd. Petasos +1',
        Neck = 'Lmg. Medallion +1',
        Ear1 = 'Novio Earring',
        Ear2 = 'Soil Earring', -- -pdt
        Body = 'Src. Coat +1', -- refresh
        Hands = 'Wzd. Gloves +1',
        Ring1 = 'Galdr Ring',
        Ring2 = 'Tamas Ring',
        -- Back = 'Umbra Cape', -- -pdt
        Back = 'Shadow Mantle',
        Waist = 'Sorcerer\'s Belt',
        Legs = 'Goliard Trews', -- -dt
        Feet = 'Src. Sabots +1',
    },
    Weapons_Default = {
        Main = 'Kaladanda',
        Sub = 'Norn\'s Grip',
        Ammo = 'Rimestone'
    },
    TPGain = {}, -- TODO: scythe set
    WS_Default = {}, -- TODO
    Rest = {
        Main = 'Chatoyant Staff',
        Sub = 'Staff Strap',
        Ammo = 'Mana Ampulla',
        Head = 'Goliard Chapeau',
        Neck = 'Gnole Torque',
        Ear1 = 'Antivenom Earring',
        Ear2 = 'Darkness Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Oracle\'s Gloves',
        Ring1 = 'Star Ring',
        Ring2 = 'Star Ring',
        Back = 'Blue Cape', -- augmented, hMP +2
        Waist = 'Qiqirn Sash',
        Legs = 'Yigit Seraweels',
        Feet = 'Goliard Clogs',
    },
    Fast = {
        Feet = 'Herald\'s Gaiters',
    },
    Precast = {
        Head = 'Windfall Hat',
        Ear2 = 'Loquac. Earring',
        Body = 'Src. Coat +1', -- 4% fast cast
        Ring1 = 'Hibernal Ring', -- 2% fast cast
        Ring2 = 'Dark Ring', -- augmented, fast cast
        Back = 'Veela Cape',
        Feet = 'Rostrum Pumps',
    },
    Dalmatica = {
        Body = 'Dalmatica +1',
    },
    Nuke = {
        Head = 'Src. Petasos +1',
        Neck = 'Lmg. Medallion +1',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Src. Coat +1',
        -- Hands = 'Zenith Mitts +1',
        Hands = 'Wzd. Gloves +1', -- with the elemental magic damage bonus, this is BiS
        Ring1 = 'Galdr Ring',
        Ring2 = 'Tamas Ring',
        Back = 'Voluspa Mantle',
        Waist = 'Sorcerer\'s Belt',
        Legs = 'Shadow Trews',
        Feet = 'Src. Sabots +1',
    },
    Stoneskin = { -- if sub whm or rdm
        Neck = 'Stone Gorget',
        Back = 'Grapevine Cape',
    },
    Enfeeble = {
        Head = 'Src. Petasos +1',
        Neck = 'Incanter\'s Torque',
        Ear1 = 'Aqua Earring',
        Body = 'Wizard\'s Coat',
        Hands = 'Oracle\'s Gloves',
        Ring1 = 'Omega Ring',
        Ring2 = 'Tamas Ring',
        Back = 'Voluspa Mantle',
        Waist = 'Sorcerer\'s Belt',
        Legs = 'Errant Slops',
        Feet = 'Goliard Clogs',
    },
    Dark = {
        -- mostly dark magic skill+, also magic accuracy, int (for magic accuracy)
        Ammo = 'Rimestone',
        Head = 'Windfall Hat', -- just for recast. could swap for zenith crown with dark augment
        Neck = 'Incanter\'s Torque',
        Ear1 = 'Aqua Earring', -- swap with dark earring
        Ear2 = 'Abyssal Earring',
        Body = 'Nashira Manteel',
        Hands = 'Sorcerer\'s Gloves', -- upgrade, augment
        Ring1 = 'Galdr Ring',
        Ring2 = 'Tamas Ring',
        Back = 'Voluspa Mantle',
        Waist = 'Charmer\'s Sash',
        Legs = 'Wizard\'s Tonban', -- upgrade this
        Feet = 'Src. Sabots +1', -- swap with Igqira Huaraches (esp augmented)
    },
    PDT = { -- TODO
        Back = 'Shadow Mantle',
    },
    MDT = {},
    BDT = {},

};
profile.Sets = sets;

profile.Packer = {
};

profile.OnLoad = function()
    gSettings.AllowAddSet = true;
    utilities.Initialize();

    (function () AshitaCore:GetChatManager():QueueCommand(1, '/lockstyleset 14') end):once(3);
end

profile.OnUnload = function()
end

profile.HandleCommand = function(args)
    utilities.HandleCommands(args);
end

profile.HandleDefault = function()
    local player = gData.GetPlayer();

    if (player.Status == 'Engaged') then
        gFunc.EquipSet(sets.TPGain);
        -- if all three weapon slots are empty during combat,
        -- equip the default weapon set (useful against merrows)
        utilities.ResetDefaultWeapons(sets.Weapons_Default);
    elseif (player.Status == 'Resting') then
        gFunc.EquipSet(sets.Rest);
    elseif (player.IsMoving) then
		gFunc.EquipSet(sets.Fast);
    else
        gFunc.EquipSet(sets.Idle);
        gFunc.EquipSet(sets.Weapons_Default);
    end

    if (T{'PDT', 'MDT', 'BDT'}:contains(utilities.OverrideSet)) then
        -- damage-taken sets take precedence over everything
        gFunc.EquipSet(utilities.OverrideSet);
    end

    utilities.CheckDefaults();
end

profile.HandleAbility = function()
    utilities.CheckCancels();
end

profile.HandleItem = function()
end

local slowSpells = T{
    'Freeze',  'Freeze II', 'Tornado', 'Tornado II', 'Quake',      'Quake II',
    'Burst',   'Burst II',  'Flood',   'Flood II',   'Flare',      'Flare II',
    'Stone V', 'Water V',   'Aero V',  'Fire V',     'Blizzard V', 'Thunder V'
}

profile.HandlePrecast = function()
    gFunc.EquipSet(sets.Precast)
    local spell = gData.GetAction()
    -- the idea here is: The first big nuke you magic burst with, you want to know exactly how long it'll take to cast.
    -- subsequent spells you can use the Dalmatica's "occasionally quickens spellcasting" to maybe get more spells in the MB window.
    if (not slowSpells:contains(spell.Name)) then
        gFunc.EquipSet(sets.Dalmatica)
    end
    utilities.CheckCancels()
end

profile.HandleMidcast = function()
    local spell = gData.GetAction();
    if (spell.Name == 'Stoneskin' or spell.Name == 'Blink') then
        -- TODO make an enhancing magic + set
        gFunc.EquipSet(sets.Stoneskin);
    elseif (spell.Skill == 'Elemental Magic') then
        -- if you have uggalepih pendant you can add it here if MPP < 51,
        -- however my nuke set has enough MAB that int+ actually helps my
        -- damage more than 8 MAB would anyway
        gFunc.EquipSet(sets.Nuke);
    elseif (spell.Skill == 'Enfeebling Magic') then
        gFunc.EquipSet(sets.Enfeeble);
    elseif (spell.Skill == 'Dark Magic') then
        gFunc.EquipSet(sets.Dark);
    end
end

profile.HandlePreshot = function()
end

profile.HandleMidshot = function()
end

profile.HandleWeaponskill = function()
    gFunc.EquipSet(sets.WS_Default);
end

return profile;