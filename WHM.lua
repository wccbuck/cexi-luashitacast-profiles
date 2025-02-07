utilities = gFunc.LoadFile('utilities.lua');
naSpell = gFunc.LoadFile('naSpell.lua');

local profile = {};

-- some equipment pieces I use in multiple places

local zenithPumps = {
    Name = 'Zenith Pumps +1',
    Augment = {
        [1] = 'Summoning magic skill +5',
        [2] = '"Cure" spellcasting time -6%',
        [3] = '"Cure" potency +4%'
    }
};

local genbuShield = {
    Name = 'Genbu\'s Shield',
    Augment = {
        [1] = 'HP+15',
        [2] = '"Cure" spellcasting time -4%',
        [3] = '"Cure" potency +5%' }
};

local healerCap = {
    Name = 'Hlr. Cap +1',
    Augment = { [1] = 'MP recovered while healing +3', [2] = '"Refresh"+1' }
};

local sets = {
    Heal = {
        Ammo = 'Hedgehog Bomb',
        Head = 'Goliard Chapeau',
        Neck = 'Fylgja Torque +1',
        Ear1 = 'Light Earring',
        Ear2 = 'Roundel Earring',
        Body = 'Aristocrat\'s Coat',
        Hands = 'Blessed Mitts',
        Ring1 = 'Aqua Ring',
        Ring2 = 'Tamas Ring',
        Back = 'Dew Silk Cape +1',
        Waist = 'Cleric\'s Belt',
        Legs = 'Blessed Trousers',
        Feet = zenithPumps,
    },
    Heal_Weapons = {
        Main = 'Tamaxchi',
        Sub = genbuShield,
    },
    Idle = {
        -- refresh, regen, -dt
        Head = healerCap,
        Neck = 'Fylgja Torque +1',
        Ear1 = 'Light Earring',
        Ear2 = 'Soil Earring',
        Body = 'Aristocrat\'s Coat',
        Hands = 'Blessed Mitts',
        Ring1 = 'Star Ring',
        Ring2 = 'Tamas Ring',
        Back = 'Dew Silk Cape +1', -- replace with hexerei or cheviot
        Waist = 'Cleric\'s Belt',
        Legs = 'Goliard Trews',
        Feet = zenithPumps,
    },
    TPGain = {
        Ammo = 'Tiphia Sting',
        Head = { Name = 'Optical Hat', Augment = { [1] = 'Haste+3', [2] = 'HP+15', [3] = 'AGI+3', [4] = 'DEX+3' } },
        Neck = 'Chivalrous Chain',
        Ear1 = 'Brutal Earring',
        Ear2 = 'Ethereal Earring',
        Body = 'Nashira Manteel',
        Hands = 'Blessed Mitts',
        Ring1 = 'Rajas Ring',
        Ring2 = 'Tamas Ring',
        Back = 'Aesir Mantle',
        Waist = 'Ninurta\'s Sash',
        Legs = { Name = 'Prince\'s Slops', Augment = { [1] = 'Pet: Rng. Acc.+6', [2] = '"Mag.Def.Bns."+2', [3] = 'Accuracy+3', [4] = 'Pet: Accuracy+6', [5] = 'Attack+3' } },
        Feet = 'Blessed Pumps',
    },
    WS_Default = {}, -- TODO
    Haste = {
        Head = 'Windfall Hat',
        Ear2 = 'Loquac. Earring',
        Hands = 'Blessed Mitts',
        -- Body = marduk's or dalmatica
        Back = 'Veela Cape',
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
        Neck = 'Colossus\'s Torque',
        Ear2 = 'Loquac. Earring',
        Body = 'Nashira Manteel',
        Hands = 'Healer\'s Mitts',
        Back = 'Veela Cape',
        Waist = 'Ninurta\'s Sash',
        Legs = 'Cleric\'s Pantaln.',
        Feet = 'Blessed Pumps',
    },
    Precast = {
        Head = 'Windfall Hat',
        Ear2 = 'Loquac. Earring',
        Hands = 'Blessed Mitts',
        -- Body = marduk's or dalmatica
        Back = 'Veela Cape',
        Waist = 'Ninurta\'s Sash',
        -- Feet = 'Rostrum Pumps',
    },
    PrecastHeal = {
        Feet = zenithPumps,
    },
    Regen = {
        Head = 'Goliard Chapeau',
        Neck = 'Fylgja Torque +1',
        Ear2 = 'Loquac. Earring',
        Body = 'Cleric\'s Bliaut',
        Hands = 'Blessed Mitts',
        Ring1 = 'Aqua Ring',
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
        Head = healerCap,
        Neck = 'Divine Torque',
        Ear2 = 'Aqua Earring',
        Body = 'Errant Hpl.',
        Hands = 'Blessed Mitts',
        Ring1 = 'Aqua Ring',
        Ring2 = 'Tamas Ring',
        Back = 'Dew Silk Cape +1',
        Waist = 'Cleric\'s Belt',
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
        Head = healerCap,
        Neck = 'Gnole Torque',
        Ear1 = 'Antivenom Earring',
        Ear2 = 'Darkness Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Oracle\'s Gloves',
        Ring1 = 'Star Ring',
        Ring2 = 'Tamas Ring',
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
        Head = healerCap,
        Neck = 'Fylgja Torque +1',
        Ear1 = 'Brachyura Earring',
        Ear2 = 'Aqua Earring',
        Body = 'Blessed Bliaut',
        Hands = 'Blessed Mitts',
        Ring1 = 'Aqua Ring',
        Ring2 = 'Tamas Ring',
        Back = 'Grapevine Cape',
        Waist = 'Cleric\'s Belt',
        Legs = 'Cleric\'s Pantaln.',
        Feet = 'Clr. Duckbills +1',
    },
    Enfeeble = {
        Ammo = 'Mana Ampulla',
        Head = healerCap,
        Neck = 'Gnole Torque',
        Ear2 = 'Aqua Earring',
        Body = 'Errant Hpl.',
        Hands = 'Cleric\'s Mitts',
        Ring1 = 'Aqua Ring',
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
        Main = 'Tamaxchi',
        Sub = genbuShield,
    },
    PDT = {
        -- TODO
        -- eventually Healer's Bliaut +1 (DT-5%)
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
            if (player.Status ~= 'Engaged') then
                gFunc.EquipSet(sets.Heal_Weapons);
            end
        end
    elseif (spell.Skill == 'Enfeebling Magic') then
        gFunc.EquipSet(sets.Enfeeble);
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
end

return profile;
