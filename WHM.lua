utilities = gFunc.LoadFile('utilities.lua');
naSpell = gFunc.LoadFile('naSpell.lua');

local profile = {};

local sets = {
    Heal = {
        Ammo = 'Hedgehog Bomb',
        Head = 'Hlr. Cap +1', -- mnd +7
        Neck = 'Fylgja Torque +1', -- cure pot +3
        Ear1 = 'Light Earring', -- cure pot +2
        Ear2 = 'Roundel Earring', -- cure pot +5
        Body = 'Aristocrat\'s Coat', -- cure pot +12
        Hands = 'Hlr. Mitts +1', -- mnd +7, cure pot 3, conserve mp 5, healing mag skill 15
        Ring1 = 'Karka Ring', -- mnd +6
        Ring2 = 'Tamas Ring', -- mnd +5
        Back = 'Dew Silk Cape +1', -- cure pot +3, mnd +6
        Waist = 'Cleric\'s Belt', -- cure pot +5, mnd +6
        Legs = 'Clr. Pantaln. +1', -- cure pot +6, healing magic +15
        Feet = 'Zenith Pumps +1', -- cure pot +6
    },
    Cure_Weapons = {
        -- Main = 'Tamaxchi', -- I'm over the cure potency cap with this
        Main = 'Sindri', -- mnd +6, convert 1% of cure amt to MP
        Sub = 'Genbu\'s Shield', -- cure pot +5
    },
    Status_Weapons = {
        Main = 'Yagrush',
        Sub = 'Genbu\'s Shield',
    },
    DW_Weapons = {
        Main = 'Yagrush',
        Sub = 'Sindri',
    },
    Idle = {
        -- refresh, regen, -dt
        Head = 'Hlr. Cap +1',
        Neck = 'Fylgja Torque +1',
        Ear1 = 'Light Earring',
        Ear2 = 'Soil Earring',
        Body = 'Clr. Bliaut +1',
        -- Body = 'Marduk\'s Jubbah',
        Hands = 'Marduk\'s Dastanas',
        Ring1 = 'Defending Ring',
        Ring2 = 'Tamas Ring',
        Back = 'Umbra Cape',
        Waist = 'Cleric\'s Belt',
        Legs = 'Clr. Pantaln. +1',
        Feet = 'Zenith Pumps +1',
    },
    TPGain = {
        Ammo = 'Tiphia Sting',
        Head = 'Windfall Hat',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Brutal Earring',
        Ear2 = 'Hollow Earring',
        Body = 'Reverend Mail +1',
        Hands = 'Blessed Mitts',
        Ring1 = 'Rajas Ring',
        Ring2 = 'Mars\'s Ring',
        Back = 'Aife\'s Mantle',
        Waist = 'Ninurta\'s Sash',
        Legs = 'Blessed Trousers', -- augmented
        Feet = 'Blessed Pumps',
    },
    WS_Default = {
        -- realmrazer: mnd 85%
        Ammo = 'Tiphia Sting',
        Head = 'Hlr. Cap +1',
        -- Head = 'Maat\'s Cap',
        -- Neck = 'Fotia Gorget',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Brutal Earring',
        Ear2 = 'Emberpearl Earring',
        Body = 'Blessed Bliaut', -- mnd+5 (augment for dex+ and atk+)
        Body = 'Marduk\'s Jubbah',
        Hands = 'Hlr. Mitts +1', --mnd+7, str+7
        Ring1 = 'Rajas Ring',
        Ring2 = 'Aqua Ring', -- replace with Strigoi? or Karka?
        Back = 'Cuchulain\'s Mantle',
        Waist = 'Visionary Obi',
        Legs = 'Blessed Trousers',
        Feet = 'Goliard Clogs', -- dex+4 mnd+4. swap for marduk's (mnd+10)
    },
    WS_Mystic_Boon = {
        -- note that Mystic Boon has no SC properties and therefore doesn't get a bonus from Fotia
        -- str 95%, mnd 95%
        Neck = 'Chivalrous Chain', -- laran's pendant?
        Waist = 'Stormlord Shawl',
    },
    Haste = {
        Head = 'Windfall Hat',
        Ear2 = 'Loquac. Earring',
        Hands = 'Blessed Mitts',
        Body = 'Marduk\'s Jubbah',
        Back = 'Swith Cape +1',
        Waist = 'Ninurta\'s Sash',
        Legs = 'Blessed Trousers',
        Feet = 'Blessed Pumps',
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
        Body = 'Nashira Manteel',
        Hands = 'Hlr. Mitts +1',
        Ring1 = 'Dark Ring', -- fast cast
        Back = 'Swith Cape +1',
        Waist = 'Ninurta\'s Sash',
        Legs = 'Clr. Pantaln. +1',
        Feet = 'Blessed Pumps',
    },
    Precast = {
        Head = 'Windfall Hat',
        Ear2 = 'Loquac. Earring',
        Hands = 'Blessed Mitts', -- fast cast aug
        Ring1 = 'Dark Ring', -- fast cast
        Body = 'Marduk\'s Jubbah',
        Back = 'Swith Cape +1',
        Waist = 'Ninurta\'s Sash',
        Feet = 'Rostrum Pumps',
    },
    PrecastHeal = {
        Feet = 'Zenith Pumps +1', -- cure clogs?
    },
    Regen = {
        Head = 'Goliard Chapeau',
        Neck = 'Fylgja Torque +1',
        Ear2 = 'Loquac. Earring',
        Body = 'Clr. Bliaut +1',
        Hands = 'Blessed Mitts',
        Ring1 = 'Karka Ring',
        Ring2 = 'Tamas Ring',
        Back = 'Grapevine Cape',
        Waist = 'Cleric\'s Belt',
        Legs = 'Blessed Trousers',
        Feet = 'Clr. Duckbills +1',
    },
    Stoneskin = {
        Neck = 'Stone Gorget',
    },
    Divine = {
        Ammo = 'Mana Ampulla',
        Head = 'Marduk\'s Tiara',
        Neck = 'Jokushu Chain', -- 10 divine
        -- Ear1 = 'Knight\'s Earring',
        Ear2 = 'Aqua Earring',
        Body = 'Marduk\'s Jubbah',
        Hands = 'Blessed Mitts',
        Ring1 = 'Karka Ring',
        Ring2 = 'Tamas Ring',
        Back = 'Dew Silk Cape +1',
        Waist = 'Salire Belt',
        Legs = 'Healer\'s Pantaln.',
        Feet = 'Clr. Duckbills +1',
    },
    Divine_Weapons = {
        Main = 'Chatoyant Staff',
        Sub = 'Light Grip',
    },
    Rest = {
        Main = 'Chatoyant Staff',
        Sub = 'Staff Strap',
        Ammo = 'Mana Ampulla',
        Head = 'Hlr. Cap +1',
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
        Waist = 'Cleric\'s Belt',
        Legs = 'Yigit Seraweels',
        Feet = 'Goliard Clogs',
    },
    Barspell = {
        -- also general enhancing
        -- Head = 'Hlr. Cap +1',
        Head = 'Seer\'s Crown', -- augment: conserve MP +2
        Neck = 'Fylgja Torque +1',
        Ear1 = 'Brachyura Earring',
        Ear2 = 'Aqua Earring',
        Body = 'Blessed Bliaut',
        Hands = 'Blessed Mitts',
        Ring1 = 'Karka Ring',
        Ring2 = 'Tamas Ring',
        Back = 'Grapevine Cape',
        Waist = 'Cleric\'s Belt',
        Legs = 'Clr. Pantaln. +1',
        Feet = 'Clr. Duckbills +1',
    },
    Enfeeble = {
        Ammo = 'Mana Ampulla',
        Head = 'Hlr. Cap +1',
        Neck = 'Incanter\'s Torque',
        Ear2 = 'Aqua Earring',
        Body = 'Marduk\'s Jubbah',
        Hands = 'Cleric\'s Mitts',
        Ring1 = 'Karka Ring',
        Ring2 = 'Tamas Ring',
        Back = 'Dew Silk Cape +1',
        Waist = 'Cleric\'s Belt',
        Legs = 'Blessed Trousers',
        Feet = 'Clr. Duckbills +1',
    },
    Fast = {
        -- Body = 'Kupo Suit',
        -- Legs = 'displaced',
        Feet = 'Herald\'s Gaiters'
    },
    Weapons_Default = {
        Main = 'Yagrush',
        -- Main = 'Tamaxchi',
        Sub = 'Genbu\'s Shield',
        -- Sub = 'Sindri',
        Ammo = 'Hedgehog Bomb',
    },
    PDT = {
        -- TODO
        Body = 'Clr. Bliaut +1',
        -- Back = 'Umbra Cape',
        Back = 'Umbra Cape',
        Legs = 'Goliard Trews',
    },
    MDT = {
        -- TODO
        -- eventually Healer's Bliaut +1 (DT-5%)
    },
    BDT = {},
    Showoff = {},
};
profile.Sets = sets;

profile.Packer = {
};

profile.OnLoad = function()
    gSettings.AllowAddSet = true;
    utilities.Initialize();

    (function () AshitaCore:GetChatManager():QueueCommand(1, '/lockstyleset 17') end):once(3);
    -- TODO: set these based on subjob
    -- AshitaCore:GetChatManager():QueueCommand(1, '/macro book 2');
    -- AshitaCore:GetChatManager():QueueCommand(1, '/macro set 1');
end

profile.OnUnload = function()
end

profile.HandleCommand = function(args)
    if args[1] == 'naspell' then
        naSpell.Cast();
    elseif args[1] == 'naspellprio' then
        -- comma-delimited list of player names
        naSpell.SetPlayerPriority(args);
    end
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
        -- TODO make the next line configurable
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
    local spell = gData.GetAction();
    gFunc.EquipSet(sets.Precast);
    if (spell.Skill == 'Healing Magic') then
        gFunc.EquipSet(sets.PrecastHeal);
    end
    utilities.CheckCancels();
end

profile.HandleMidcast = function()
    local spell = gData.GetAction();
    local player = gData.GetPlayer();

    -- local target = gData.GetActionTarget();
    -- local me = AshitaCore:GetMemoryManager():GetParty():GetMemberName(0);
    if (T{'Haste', 'Erase', 'Esuna'}:contains(spell.Name)) then
        -- lower recast
        gFunc.EquipSet(sets.Haste);
        if (spell.Name == 'Erase') and (player.Status ~= 'Engaged') then
            gFunc.EquipSet(sets.Status_Weapons);
        end
    elseif (spell.Skill == 'Enhancing Magic') then
        if (string.contains(spell.Name, 'Regen')) then
            gFunc.EquipSet(sets.Regen);
        elseif (string.match(spell.Name, '^Bar')) then
            gFunc.EquipSet(sets.Barspell);
        else
            --gFunc.EquipSet(sets.Enhancing); --TODO
            gFunc.EquipSet(sets.Barspell)
        end
        if (spell.Name == 'Stoneskin') then
            gFunc.EquipSet(sets.Stoneskin);
        end
    elseif (spell.Skill == 'Healing Magic') then
        if (spell.Name == 'Cursna') then
            -- healing magic+, haste, fast cast
            gFunc.EquipSet(sets.Cursna);
        else
            gFunc.EquipSet(sets.Heal);
        end
        if (player.Status ~= 'Engaged') then
            if (spell.Name:match('^Cure')) or (spell.Name:match('^Cura')) then
                gFunc.EquipSet(sets.Cure_Weapons);
            else
                gFunc.EquipSet(sets.Status_Weapons);
            end
        end
    elseif (spell.Skill == 'Enfeebling Magic') then
        gFunc.EquipSet(sets.Enfeeble);
        if (player.Status ~= 'Engaged') then
            gFunc.EquipSet(sets.Status_Weapons); -- yagrush has m.acc+
        end
    elseif (spell.Skill == 'Divine Magic') then
        gFunc.EquipSet(sets.Divine);
        if (player.Status ~= 'Engaged' and spell.Name ~= 'Enlight') then
            gFunc.EquipSet(sets.Divine_Weapons);
        end
    end

end

profile.HandlePreshot = function()
end

profile.HandleMidshot = function()
end

profile.HandleWeaponskill = function()
    -- TODO
    -- local target = gData.GetActionTarget();
    -- if (tonumber(target.Distance) > 4.7) then
    --     gFunc.Echo(255, "Get closer!");
    --     gFunc.CancelAction();
    --     return;
    -- end
    --
    gFunc.EquipSet(sets.WS_Default);
    local ws = gData.GetAction();
    if (ws.Name == 'Mystic Boon') then
        gFunc.EquipSet(sets.WS_Mystic_Boon);
    end
end

return profile;
