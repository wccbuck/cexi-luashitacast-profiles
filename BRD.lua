-- Work in progress

utilities = gFunc.LoadFile('utilities.lua');

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
    Augment = { [1] = 'Singing skill +4', [2] = 'Wind instrument skill +5' } 
};


local instruments = {
    Minuet = 'Cornette +1',
    Mambo = 'Hellish Bugle',
    Ballad = 'Terpander',
    Lullaby = 'Terpander',
    Madrigal = 'Traversiere', -- get +1
    Mazurka = 'Harlequin\'s Horn',
    March = 'Ryl.Spr. Horn', -- replace with faerie piccolo (quest)
    Requiem = 'Requiem Flute',
    -- get Horn+1 for elegy, piccolo for threnody
};

local sets = {
    Idle = {
        Head = 'Bard\'s Roundlet',
        Neck = 'Fylgja Torque +1',
        Ear1 = 'Musical Earring',
        Ear2 = 'Soil Earring',
        Body = chlJust,
        Hands = 'Melaco Mittens',
        Ring1 = 'Trumpet Ring',
        Ring2 = 'Tamas Ring',
        Back = 'Dew Silk Cape +1', -- replace with hexerei
        Waist = 'Marid Belt',
        Legs = 'Goliard Trews',
        Feet = 'Suzaku\'s Sune-Ate',
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
        Neck = 'Colossus\'s Torque', -- healing magic
        Ear2 = 'Loquac. Earring', -- fast cast
        Body = 'Goliard Saio', -- haste
        -- Hands = 'Patrician\'s Cuffs', -- if we need to get to a multiple of 30 for healing magic
        Hands = 'Dusk Gloves', -- haste
        Back = 'Veela Cape', -- fast cast
        Waist = 'Ninurta\'s Sash', -- haste
        Legs = 'Byakko\'s Haidate', -- haste
        -- Feet = 'Rostrum Pumps', -- fast cast
    },
    Wind = {
        Head = 'Bard\'s Roundlet', -- sing+5
        Ear1 = 'Musical Earring', -- wind, string +5
        Body = chlJust, 
        Hands = 'Choral Cuffs', -- sing+5
        Ring1 = 'Trumpet Ring', -- wind+2
        Legs = zenithSlacks, -- wind+4
        Feet = 'Oracle\'s Pigaches', -- wind+5
    },
    String = {
        Head = 'Bard\'s Roundlet', -- sing+5
        Ear1 = 'Musical Earring', -- wind, string +5
        Body = chlJust, -- string +6
        Hands = 'Choral Cuffs', -- sing+5
        Feet = 'Bard\'s Slippers', -- string+3
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
    Enfeeble = {
        -- TODO: CHR+
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
        Body = 'Narasimha\'s Vest', -- replace with augmented scorp harness
        Hands = 'Melaco Mittens',
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
        -- gFunc.EquipSet(sets.Weapons_Default);
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

    if (spell.Skill == 'Enhancing Magic') then
        gFunc.EquipSet(sets.Enhancing)
        if (spell.Name == 'Stoneskin') then
            gFunc.EquipSet(sets.Stoneskin);
        end
    elseif (spell.Skill == 'Healing Magic') then
        if spell.Name == 'Cursna' then
            gFunc.EquipSet(sets.Cursna);
        else
            gFunc.EquipSet(sets.Heal);
            if (player.Status ~= 'Engaged') then
                gFunc.EquipSet(sets.Heal_Weapons);
            end
        end
    elseif (spell.Skill == 'Singing') then
        gFunc.EquipSet(sets.Wind);
        for song, inst in pairs(instruments) do
            if spell.Name:match(song) then
                if T{'Ballad', 'Lullaby'}:contains(song) then
                    -- terpander
                    gFunc.EquipSet(sets.String);
                end
                if (player.Status ~= 'Engaged') then
                    -- dont want to lose TP while fighting
                    gFunc.Equip('main', 'Silktone');
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
