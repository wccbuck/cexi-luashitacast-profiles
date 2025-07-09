utilities = gFunc.LoadFile('utilities.lua');

local profile = {};

local sets = {
    Idle = {
        Head = 'Wzd. Petasos +1',
        Neck = 'Lmg. Medallion +1',
        Ear1 = 'Novio Earring',
        Ear2 = 'Soil Earring', -- -pdt
        Body = 'Src. Coat +1', -- refresh
        Hands = 'Zenith Mitts +1',
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
        Ammo = 'Phtm. Tathlum'
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
        Back = {
            Name = 'Blue Cape',
            Augment = {
                [1] = 'Lightning resistance+5',
                [2] = 'Water resistance+5',
                [3] = 'Wind resistance+5',
                [4] = 'Fire resistance+5',
                [5] = 'Ice resistance+5',
                [6] = 'MP recovered while healing +2',
                [7] = 'Earth resistance+5',
                [8] = 'Dark resistance+5',
                [9] = 'Light resistance+5',
                [10] = 'HP recovered while healing +2',
                [11] = 'HP+30'
            }
        },
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
        Body = 'Src. Coat +1', -- fast cast
        Ring1 = 'Hibernal Ring', -- 2% fast cast
        -- Body = dalmatica
        Back = 'Veela Cape',
        Feet = 'Rostrum Pumps',
    },
    Nuke = {
        Head = 'Src. Petasos +1',
        Neck = 'Lmg. Medallion +1',
        Ear1 = 'Novio Earring',
        Ear2 = 'Moldavite Earring',
        Body = 'Src. Coat +1',
        Hands = 'Zenith Mitts +1',
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
        Ammo = 'Phtm. Tathlum',
        Head = 'Windfall Hat', -- just for recast. could swap for zenith crown with dark augment
        Neck = 'Incanter\'s Torque',
        Ear1 = 'Aqua Earring', -- swap with dark earring
        Ear2 = 'Abyssal Earring',
        Body = 'Nashira Manteel',
        Hands = 'Sorcerer\'s Gloves',
        Ring1 = 'Omega Ring',
        Ring2 = 'Tamas Ring',
        Back = 'Voluspa Mantle',
        Waist = 'Charmer\'s Sash',
        Legs = 'Wizard\'s Tonban',
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

profile.HandlePrecast = function()
    gFunc.EquipSet(sets.Precast);
    utilities.CheckCancels();
end

profile.HandleMidcast = function()
    local spell = gData.GetAction();
    if (spell.Name == 'Stoneskin' or spell.Name == 'Blink') then
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