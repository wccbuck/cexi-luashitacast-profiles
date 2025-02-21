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

local zenithSlacks = { 
    Name = 'Zenith Slacks', 
    Augment = { [1] = 'Song spellcasting time -3%', [2] = 'Wind instrument skill +4' } 
};

local genbuShield = {
    Name = 'Genbu\'s Shield',
    Augment = {
        [1] = 'HP+15',
        [2] = '"Cure" spellcasting time -4%',
        [3] = '"Cure" potency +5%' }
};

local chlJust = { 
    Name = 'Chl. Jstcorps +1', 
    Augment = { [1] = 'Singing skill +5', [2] = 'Wind instrument skill +6' } 
};


local instruments = {
    Minuet = 'Cornette +1',
    Mambo = 'Hellish Bugle',
    Ballad = 'Terpander',
    Lullaby = 'Terpander',
    Madrigal = 'Traversiere +1',
    Mazurka = 'Harlequin\'s Horn',
    March = 'Ryl.Spr. Horn', -- replace with faerie piccolo (quest)
    Requiem = 'Requiem Flute',
    Elegy = 'Horn +1',
    -- get piccolo for threnody
};

local sets = {
    Idle = {
        Head = 'Genbu\'s Kabuto', -- -pdt
        Neck = 'Incanter\'s Torque',
        Ear1 = 'Musical Earring',
        Ear2 = 'Soil Earring',
        Body = chlJust,
        Hands = 'Melaco Mittens',
        Ring1 = 'Mercenary\'s Ring',
        Ring2 = 'Tamas Ring',
        Back = 'Umbra Cape',
        Waist = 'Marid Belt',
        Legs = 'Goliard Trews',
        Feet = 'Suzaku\'s Sune-Ate',
    },
    Sing_Weapons = {
        Main = 'Silktone',
        Sub = genbuShield,
    },
    TPGain = {
        -- TODO
        Range = 'Hellish Bugle',
    },
    WS_Default = {
        -- TODO
    },
    Heal = {
        Head = 'Goliard Chapeau',
        Neck = 'Fylgja Torque +1',
        Ear1 = 'Light Earring',
        Ear2 = 'Aqua Earring',
        Body = 'Errant Hpl.',
        Hands = 'Yigit Gages',
        Ring1 = 'Aqua Ring',
        Ring2 = 'Tamas Ring',
        Back = 'Dew Silk Cape +1',
        Waist = 'Salire Belt',
        Legs = 'Bard\'s Cannions',
        Feet = zenithPumps,
    },
    Heal_Weapons = {
        Main = 'Tamaxchi',
        Sub = genbuShield,
    },
    Precast = {
        Head = 'Windfall Hat',
        Ear2 = 'Loquac. Earring',
        -- Body = marduk's or dalmatica
        Back = 'Veela Cape',
        Feet = 'Suzaku\'s Sune-Ate', -- fast cast
        -- Feet = 'Rostrum Pumps',
    },
    PrecastHeal = {
        Feet = zenithPumps,
    },
    PrecastSong = {
        Body = 'Sha\'ir Manteel',
        Legs = zenithSlacks,
    },
    Cursna = {
        -- Ranged = 'Angel Lyre',
        Head = 'Windfall Hat', -- fast cast
        Neck = 'Incanter\'s Torque', -- healing magic
        Ear2 = 'Loquac. Earring', -- fast cast
        Body = 'Goliard Saio', -- haste
        -- Hands = 'Patrician\'s Cuffs', -- if we need to get to a multiple of 30 for healing magic
        Hands = 'Dusk Gloves', -- haste
        Back = 'Veela Cape', -- fast cast
        Waist = 'Ninurta\'s Sash', -- haste
        Legs = 'Byakko\'s Haidate', -- haste
        Feet = 'Suzaku\'s Sune-Ate', -- haste, fast cast
        -- Feet = 'Rostrum Pumps', -- fast cast
    },
    Wind = {
        Head = 'Bard\'s Roundlet', -- sing+5
        Neck = 'Incanter\'s Torque',
        Ear1 = 'Musical Earring', -- wind, string +5
        Body = chlJust, 
        Hands = 'Choral Cuffs', -- sing+5
        Ring1 = 'Trumpet Ring', -- wind+2
        Ring2 = 'Trumpet Ring', -- wind+2
        Waist = 'Ninurta\'s Sash', -- haste
        Legs = zenithSlacks, -- wind+4
        Feet = 'Oracle\'s Pigaches', -- wind+5
    },
    String = {
        Head = 'Bard\'s Roundlet', -- sing+5
        Neck = 'Incanter\'s Torque',
        Ear1 = 'Musical Earring', -- wind, string +5
        Body = chlJust, -- string +6
        Hands = 'Choral Cuffs', -- sing+5
        Waist = 'Ninurta\'s Sash', -- haste
        Feet = 'Bard\'s Slippers', -- string+3
    },
    Lullaby = {
        Head = 'Bard\'s Roundlet',
        Neck = 'Incanter\'s Torque',
        Ear1 = 'Musical Earring',
        Body = chlJust,
        Hands = 'Choral Cuffs',
        Ring1 = 'Omega Ring',
        Ring2 = 'Angel\'s Ring',
        Back = 'Jester\'s Cape',
        Waist = 'Corsette +1',
        Legs = 'Errant Slops',
        Feet = 'Goliard Clogs',
    },
    Lullaby_Weapons = {
        Main = 'Chatoyant Staff',
        Sub = 'Light Grip',
    },
    Enhancing = {
        Back = 'Grapevine Cape',
    },
    Stoneskin = {
        Neck = 'Stone Gorget',
    },
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
        -- Waist = 'Qiqirn Sash',
        Legs = 'Yigit Seraweels',
        Feet = 'Goliard Clogs',
    },
    Fast = {
        Body = 'Kupo Suit',
        Legs = 'displaced',
    },
    Weapons_Default = {
        Main = 'Silktone',
        Sub = genbuShield,
        Range = 'Ryl.Spr. Horn',
    },
    PDT = {
        -- TODO
        Head = 'Genbu\'s Kabuto',
        Hands = 'Melaco Mittens',
        Back = 'Umbra Cape',
        Legs = 'Goliard Trews',
    },
    MDT = {
        -- TODO
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

    (function () AshitaCore:GetChatManager():QueueCommand(1, '/lockstyleset 15') end):once(3);
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
        -- gFunc.EquipSet(sets.TPGain);
        -- remove next line when TPGain set is done
        gFunc.EquipSet(sets.Idle);
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
        gFunc.EquipSet(sets.Sing_Weapons);
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
    elseif (spell.Skill == 'Singing') then
        gFunc.EquipSet(sets.PrecastSong);
    end
    utilities.CheckCancels();
end

profile.HandleMidcast = function()
    local spell = gData.GetAction();
    local player = gData.GetPlayer();

    -- local target = gData.GetActionTarget();
    -- local me = AshitaCore:GetMemoryManager():GetParty():GetMemberName(0);
    if (T{'Cursna', 'Erase'}:contains(spell.Name)) then
        -- lower recast
        gFunc.EquipSet(sets.Cursna);
    elseif (spell.Skill == 'Enhancing Magic') then
        gFunc.EquipSet(sets.Enhancing)
        if (spell.Name == 'Stoneskin') then
            gFunc.EquipSet(sets.Stoneskin);
        end
    elseif (spell.Skill == 'Healing Magic') then
        gFunc.EquipSet(sets.Heal);
        if (player.Status ~= 'Engaged') then
            gFunc.EquipSet(sets.Heal_Weapons);
        end
    elseif (spell.Skill == 'Singing') then
        gFunc.EquipSet(sets.Wind);
        if spell.Name:match('Ballad') then
            gFunc.EquipSet(sets.String);
        elseif spell.Name:match('Lullaby') or spell.Name:match('Elegy') or spell.Name:match('Threnody') then
            -- CHR+
            gFunc.EquipSet(sets.Lullaby);
        end
        if (player.Status ~= 'Engaged') then
            -- dont want to lose TP while fighting
            if spell.Name:match('Lullaby') then
                gFunc.EquipSet(sets.Lullaby_Weapons);
            else
                gFunc.EquipSet(sets.Weapons_Default);
            end
            for song, inst in pairs(instruments) do
                if spell.Name:match(song) then
                    gFunc.Equip('range', inst);
                end
            end
        end
    end

end

profile.HandlePreshot = function()
end

profile.HandleMidshot = function()
end

profile.HandleWeaponskill = function()
    -- TODO
    --
    -- gFunc.EquipSet(sets.WS_Default);
end

return profile;
