utilities = gFunc.LoadFile('utilities.lua');
naSpell = gFunc.LoadFile('naSpell.lua');

local profile = {};

-- this instruments table is only used if you don't have gjallarhorn.
local instruments = {
    Minuet = 'Cornette +1',
    Mambo = 'Hellish Bugle',
    Ballad = 'Terpander',
    Lullaby = 'Terpander',
    Madrigal = 'Traversiere +1',
    Mazurka = 'Harlequin\'s Horn',
    March = 'Faerie Piccolo',
    Requiem = 'Requiem Flute',
    Elegy = 'Horn +1',
    Threnody = 'Piccolo +1',
    Carol = 'Crumhorn',
};

local sets = {
    Idle = {
        Head = 'Chl. Roundlet +1',
        Neck = 'Oneiros Torque',
        Ear1 = 'Musical Earring',
        Ear2 = 'Soil Earring',
        Body = 'Marduk\'s Jubbah',
        Hands = 'Brd. Cuffs +1',
        Ring1 = 'Defending Ring',
        Ring2 = 'Tamas Ring',
        Back = 'Umbra Cape',
        Waist = 'Oneiros Belt',
        Legs = 'Brd. Cannions +1',
        Feet = 'Suzaku\'s Sune-Ate',
    },
    Idle_Weapons = {
        Main = 'Terra\'s Staff',
        Sub = 'Staff Strap',
    },
    Sing_Weapons = {
        Main = 'Chanter\'s Staff',
        -- Sub = 'Staff Strap',
        Sub = 'Reflexive Grip',
    },
    -- if you don't have chanter's staff:
    -- Sing_Weapons = {
    --     Main = 'Silktone',
    --     Sub = 'Genbu\'s Shield',
    -- },

    TPGain = {
        -- TODO
        -- Range = 'Hellish Bugle',
        -- Hands = 'Swift Gages',
    },
    WS_Default = {
        -- TODO
        -- hecatomb
    },
    Heal = {
        Head = 'Goliard Chapeau', -- swap for adept trials sheikh turban
        Neck = 'Fylgja Torque +1',
        Ear1 = 'Light Earring',
        Ear2 = 'Light Earring',
        Body = 'Errant Hpl.',
        Hands = 'Yigit Gages',
        Ring1 = 'Karka Ring',
        Ring2 = 'Tamas Ring',
        Back = 'Dew Silk Cape +1',
        Waist = 'Pythia Sash +1',
        Legs = 'Brd. Cannions +1',
        Feet = 'Zenith Pumps +1',
    },
    Heal_Weapons = {
        Main = 'Tamaxchi',
        Sub = 'Genbu\'s Shield',
    },
    Precast = {
        Head = 'Windfall Hat',
        Ear2 = 'Loquac. Earring',
        Body = 'Dalmatica',
        Hands = 'Brd. Cuffs +1',
        Ring1 = { Name = 'Dark Ring', Augment = { [1] = '"Fast Cast"+1', [2] = '"Conserve MP"+3' } },
        Ring2 = 'Hibernal Ring',
        Back = 'Swith Cape +1',
        Feet = 'Rostrum Pumps',
    },
    PrecastHeal = {
        Feet = 'Zenith Pumps +1',
    },
    PrecastSong = {
        -- Body = 'Sha\'ir Manteel',
        Legs = 'Zenith Slacks',
    },
    Cursna = {
        -- Ranged = 'Angel Lyre',
        Head = 'Windfall Hat', -- fast cast
        Neck = 'Incanter\'s Torque', -- healing magic
        Ear2 = 'Loquac. Earring', -- fast cast
        Body = 'Goliard Saio', -- haste
        Hands = 'Dusk Gloves', -- haste
        Ring1 = { Name = 'Dark Ring', Augment = { [1] = '"Fast Cast"+1', [2] = '"Conserve MP"+3' } },
        Ring2 = 'Hibernal Ring', -- 2% fast cast
        Back = 'Swith Cape +1', -- fast cast
        Waist = 'Ninurta\'s Sash', -- haste
        Legs = 'Byakko\'s Haidate', -- haste
        Feet = 'Rostrum Pumps', -- fast cast
    },
    Wind = {
        Head = 'Brd. Roundlet +1', -- wind +7
        Neck = 'Incanter\'s Torque',
        Ear1 = 'Musical Earring', -- wind, string +5
        Ear2 = 'Singing Earring', -- spire earring
        Body = 'Chl. Jstcorps +1', -- wind +6, sing +5
        Hands = 'Chl. Cuffs +1', -- sing +10
        Ring1 = 'Nereid Ring', -- wind+3
        Ring2 = 'Trumpet Ring', -- wind+2... get another Nereid
        -- Back = 'Echo Cape', -- wind+3
        Back = 'Astute Cape', -- sing+5
        Waist = 'Marching Belt', -- wind+3
        Legs = 'Chl. Cannions +1', -- wind+8
        Feet = 'Oracle\'s Pigaches', -- wind+5
    },
    String = {
        Head = 'Marduk\'s Tiara', -- sing+7
        Neck = 'Incanter\'s Torque',
        Ear1 = 'Musical Earring', -- wind, string +5
        Ear2 = 'Singing Earring', -- spire earring
        Body = 'Chl. Jstcorps +1',  -- string +6, sing +5
        Hands = 'Chl. Cuffs +1', -- sing+10
        Back = 'Astute Cape', -- sing +5
        Waist = 'Ninurta\'s Sash', -- haste
        Feet = 'Bard\'s Slippers', -- string+3
    },
    Lullaby = {
        Head = 'Brd. Roundlet +1',
        Neck = 'Incanter\'s Torque',
        Ear1 = 'Musical Earring',
        Ear2 = 'Beastly Earring',
        Body = 'Chl. Jstcorps +1',
        Hands = 'Chl. Cuffs +1',
        Ring1 = 'Omega Ring',
        Ring2 = 'Veela Ring',
        Back = 'Bard\'s Cape',
        Waist = 'Gleeman\'s Belt',
        Legs = 'Marduk\'s Shalwar',
        Feet = 'Goliard Clogs',
    },
    Elegy = {
        -- Note: Marduk's Shalwar augmented seems better overall than AF+1 pants.
        -- CHR, and song duration, but slightly lower m.acc and wind skill.
        -- Legs = 'Chl. Cannions +1', -- wind+8, earth m.acc +5
    },
    Duration = {
        -- for songs where sing skill doesn't really matter: ballad, dirge, mazurka
        Body = 'Brd. Jstcorps +1',
        Legs = 'Marduk\'s Shalwar',
    },
    Lullaby_Weapons = {
        Main = 'Chatoyant Staff',
        Sub = 'Omni Grip', -- or light grip
    },
    Enhancing = {
        -- todo: MND, enhancing magic +
        -- spire earring
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
        Ear1 = 'Magnetic Earring',
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
        Body = 'Kupo Suit',
        Legs = 'displaced',
    },
    Weapons_Default = {
        Main = 'Chanter\'s Staff',
        Sub = 'Staff Strap',
        Range = 'Gjallarhorn',
    },
    PDT = {
        -- TODO
        Head = 'Genbu\'s Kabuto',
        Hands = 'Melaco Mittens',
        Neck = 'Oneiros Torque',
        Ring1 = 'Defending Ring',
        Back = 'Umbra Cape',
        Waist = 'Oneiros Belt',
        Legs = 'Brd. Cannions +1',
    },
    MDT = {
        -- TODO
        Hands = 'Brd. Cuffs +1',
    },
    BDT = {},
    Showoff = {},
    Brachyura = {
        Ear1 = 'Brachyura Earring',
    },
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
    elseif (args[1] == 'quicksing') and #args > 1 then
        -- pianissimo trick: cast pianissimo and cancel it before the song ends
        -- for an extra -50% cast time
        local pianissimo = gData.GetBuffCount('Pianissimo');
        local night = gData.GetBuffCount('Nightingale');
        if (pianissimo + night == 0) then
            utilities.DelayExec:bind1({
                { Command='/ja "Pianissimo" <me>', Delay=0 },
                { Command='/up "'..args[2]..'" <me>', Delay=1 },
                { Command='/cancel Pianissimo', Delay=1 },
            }):oncef(1);
        else
            AshitaCore:GetChatManager():QueueCommand(1, '/up "'..args[2]..'" <me>');
        end
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

    if equipBrachyura() then
        gFunc.EquipSet(sets.Brachyura)
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
    local night = gData.GetBuffCount('Nightingale');
    if (night == 0) or (spell.Skill ~= 'Singing') then
        gFunc.EquipSet(sets.Precast);
        if (spell.Skill == 'Healing Magic') then
            gFunc.EquipSet(sets.PrecastHeal);
        elseif (spell.Skill == 'Singing') then
            gFunc.EquipSet(sets.PrecastSong);
            -- local player = gData.GetPlayer();
            -- if (player.HPP < 75 and player.TP < 1000) then
            --     gFunc.EquipSet(sets.MinstrelRing);
            -- end
        end
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
        gFunc.EquipSet(sets.Wind)
        if spell.Name:match('Lullaby') or spell.Name:match('Threnody') then
            -- CHR+, m.acc
            gFunc.EquipSet(sets.Lullaby)
            if (player.Status ~= 'Engaged') then
                -- dont want to lose TP while fighting
                if spell.Name:match('Lullaby') then
                    gFunc.EquipSet(sets.Lullaby_Weapons);
                else
                    gFunc.EquipSet(sets.Weapons_Default);
                end
            end
        elseif spell.Name:match('Elegy') then
            gFunc.EquipSet(sets.Lullaby)
            gFunc.EquipSet(sets.Elegy) -- earth m.acc
        elseif spell.Name:match('Ballad') or spell.Name:match('Dirge') or spell.Name:match('Mazurka') then
            gFunc.EquipSet(sets.Duration)
        end
        -- Uncomment this if you don't have gjallarhorn.
        --[[
        for song, inst in pairs(instruments) do
            if spell.Name:match(song) then
                gFunc.Equip('range', inst);
            end
        end
        ]]--
    end
end

profile.HandlePreshot = function()
end

profile.HandleMidshot = function()
end

profile.HandleWeaponskill = function()
    -- TODO
    --
    gFunc.EquipSet(sets.WS_Default);
end

return profile;
