utilities = gFunc.LoadFile('utilities.lua');
isTargetTagged = gFunc.LoadFile('isTargetTagged');

local profile = {};
local thtier = 8; -- the treasure hunter tier at which we should switch to TP gain set

-- some equipment pieces I use in multiple places
local ohat = {
    Name = 'Optical Hat',
    Augment = { [1] = 'Haste+3', [2] = 'HP+15', [3] = 'AGI+3', [4] = 'DEX+3' }
};

local dragonHarness = {
    Name = 'Dragon Harness',
    Augment = { [1] = 'Sklchn.dmg.+2%', [2] = 'Attack+8', [3] = 'AGI+2', [4] = 'DEX+2' }
};

local dragonCap = {
    Name = 'Dragon Cap +1',
    Augment = { [1] = 'Dagger skill +8', [2] = '"Treasure Hunter"+1', [3] = 'AGI+6', [4] = '"Subtle Blow"+6' }
};

local hctMittens = {
    Name = 'Hct. Mittens +1',
    Augment = { [1] = 'Dagger skill +5', [2] = 'Crit. hit damage +2%' }
};

local acroBreeches = {
    Name = 'Acrobat\'s Breeches',
    Augment = { [1] = '"Dual Wield"+2', [2] = 'Attack+5', [3] = 'DEX+5' }
};

local rogArmlets = {
    Name = 'Rog. Armlets +1', 
    Augment = { [1] = '"Treasure Hunter"+1', [2] = 'Haste+3' }
};

local sets = {
    TPGain = {
        Head = 'Dampening Tam',
        Neck = 'Love Torque',
        Ear1 = 'Brutal Earring',
        Ear2 = 'Suppanomimi',
        Body = 'Skadi\'s Cuirie',
        Hands = 'Swift Gages',
        Ring1 = 'Mars\'s Ring',
        Ring2 = 'Rajas Ring',
        -- Back = 'Aesir Mantle',
        Back = 'Aife\'s Mantle',
        Waist = 'Ninurta\'s Sash',
        Legs = acroBreeches,
        Feet = 'Homam Gambieras',
    },
    TPGain_Low_Eva = {
        Body = 'Rapparee Harness',
    },
    TPGain_High_Eva = {
        Back = 'Cuchulain\'s Mantle',
    },
    Idle = { -- gets applied on top of TPGain
        Head = dragonCap,
        Hands = rogArmlets,
    },
    WS_Default = {
        Head = 'Hecatomb Cap +1',
        Neck = 'Fotia Gorget',
        Ear1 = 'Brutal Earring',
        Ear2 = 'Bushinomimi',
        Body = dragonHarness,
        Hands = hctMittens,
        Ring1 = 'Zilant Ring',
        Ring2 = 'Rajas Ring',
        Back = 'Cuchulain\'s Mantle',
        Waist = 'Warwolf Belt',
        Legs = 'Hct. Subligar +1',
        Feet = 'Adsilio Boots +1',
    },
    WS_Exent = {
        Head = dragonCap,
        Neck = 'Fotia Gorget',
        Ear1 = 'Wilhelm\'s Earring',
        Ear2 = 'Altdorf\'s Earring',
        Body = dragonHarness,
        Hands = hctMittens,
        Ring1 = 'Garrulous Ring',
        Ring2 = 'Rajas Ring',
        Back = 'Cuchulain\'s Mantle',
        Waist = 'Warwolf Belt',
        Legs = acroBreeches,
        Feet = 'Adsilio Boots +1',
    },
    WS_Mandalic = {
        Head = 'Hecatomb Cap +1',
        Neck = 'Fotia Gorget',
        -- Ear1 = 'Aesir Ear Pendant',
        Ear1 = 'Brutal Earring',
        Ear2 = 'Pixie Earring',
        Body = dragonHarness,
        Hands = hctMittens,
        Ring1 = 'Zilant Ring',
        Ring2 = 'Rajas Ring',
        Back = 'Cuchulain\'s Mantle',
        Waist = 'Cuchulain\'s Belt',
        Legs = 'Hct. Subligar +1',
        Feet = 'Adsilio Boots +1',
    },
    WS_Mercy = {}, -- STR
    WS_LastStand = {
        Head = 'Maat\'s Cap',
        Neck = 'Fotia Gorget',
        Ear1 = 'Wilhelm\'s Earring',
        Ear2 = 'Altdorf\'s Earring',
        -- Body = 'Denali Jacket',
        Body = 'Skadi\'s Cuirie',
        Hands = 'Enkidu\'s Mittens',
        Ring1 = 'Garrulous Ring',
        Ring2 = 'Rajas Ring',
        Back = 'Amemet Mantle',
        Waist = 'Buccaneer\'s Belt',
        Legs = acroBreeches,
        Feet = 'Adsilio Boots +1',
    },
    TH = {
        Sub = 'Thief\'s Knife',
        -- Head = 'Wh. Rarab Cap +1',
        Head = dragonCap,
        -- Hands = 'Assassin\'s Armlets',
        Hands = rogArmlets,
    },
    TrickAttack = {
        -- +agi, +enmity
        Head = dragonCap,
        Ear1 = 'Wilhelm\'s Earring',
        Ear2 = 'Altdorf\'s Earring',
        Hands = rogArmlets,
        Ring1 = 'Sattva Ring',
        Back = 'Assassin\'s Cape',
        Waist = 'Warwolf Belt',
    },
    Provoke = {
        -- +enmity
        Head = dragonCap,
        Ear1 = 'Eris\' Earring',
        -- Neck = harmonia's?
        -- Body = 'Avalon Breastplate', -- Tiamat drop
        Hands = 'Homam Manopolas',
        Ring1 = 'Sattva Ring',
        Back = 'Assassin\'s Cape',
        Waist = 'Warwolf Belt',
        -- Legs = 'Dragon Subligar',
        -- Feet = 'Dragon Leggings',
    },
    Steal = {
        Head = 'Rogue\'s Bonnet',
        Hands = rogArmlets,
        Legs = 'Assassin\'s Culottes',
        Feet = 'Rogue\'s Poulaines',
    },
    Hide = {
        Body = 'Rogue\'s Vest',
    },
    Flee = {
        Feet = 'Rogue\'s Poulaines',
    },
    Fast = {
        -- Body = 'Kupo Suit',
        -- Legs = 'displaced',
        Feet = 'Skadi\'s Jambeaux',
    },
    Step = {
        Ear1 = 'Choreia Earring',
    },
    PDT = {
        -- TODO
        -- Body = 'Scorpion Harness +1' -- see grand trials. -3%
        Ear2 = 'Soil Earring',
        Hands = 'Denali Wristbands',
        Ring1 = 'Sattva Ring',
        Back = 'Shadow Mantle',
    },
    MDT = {
        -- TODO
        Head = 'Dampening Tam',
        Neck = 'Jeweled Collar',
        Ear1 = 'Colossus\'s Earring',
        -- Body = 'Avalon Breastplate', -- Tiamat drop
        Hands = 'Denali Wristbands',
        Ring1 = 'Merman\'s Ring',
        Ring2 = 'Merman\'s Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Lieutenant\'s Sash',
    },
    BDT = {
        Head = dragonCap,
        Body = dragonHarness,
        Hands = 'Denali Wristbands',
    },
    Showoff = {},
    Weapons_Default = {
        -- Main = 'X\'s Knife',
        Main = 'Sandung',
        Sub = 'Thief\'s Knife',
        Range = 'Staurobow',
        Ammo = 'Crossbow Bolt',
    },
    Weapons_DD = {
        Main = 'Sandung',
        Sub = 'X\'s Knife',
    },
    Ranged = {
        Head = ohat,
        Neck = 'Peacock Charm',
        Ear1 = 'Wilhelm\'s Earring',
        Ear2 = 'Altdorf\'s Earring',
        Body = 'Denali Jacket',
        Hands = 'Barb. Moufles',
        Ring1 = 'Merman\'s Ring',
        Ring2 = 'Merman\'s Ring',
        Back = 'Aife\'s Mantle', -- agi+ and storeTP+
        Waist = 'Buccaneer\'s Belt',
        Legs = 'Dusk Trousers',
        Feet = 'Homam Gambieras',
    },
    Sleep = {
        Neck = 'Opo-opo Necklace',
    },
};
profile.Sets = sets;

profile.Packer = {
};

profile.OnLoad = function()
    gSettings.AllowAddSet = true;
    utilities.Initialize();
    gFunc.Echo(2,  'TH Tier set to [' .. thtier .. ']');

    (function ()
        AshitaCore:GetChatManager():QueueCommand(1, '/lockstyleset 20');
        AshitaCore:GetChatManager():QueueCommand(1, '/macro book 1');
        gFunc.ForceEquipSet(sets.Weapons_Default);
    end):once(3);
    -- TODO: set these based on subjob
    -- AshitaCore:GetChatManager():QueueCommand(1, '/macro book 2');
    -- AshitaCore:GetChatManager():QueueCommand(1, '/macro set 1');
end

profile.OnUnload = function()
end

profile.HandleCommand = function(args)
    if args[1] == 'thtier' then
        if #args == 1 then
            thtier = 1
        else
            thtier = tonumber(args[2])
            thtier = thtier == nil and 1 or thtier
        end
        gFunc.Echo(2,  'TH Tier set to [' .. thtier .. ']');
    end
    utilities.HandleCommands(args);
end

profile.HandleDefault = function()
    local player = gData.GetPlayer();
    if (player.Status == 'Engaged') then
        gFunc.EquipSet(sets.TPGain);
        if utilities.TargetEva == 'low' then
            gFunc.EquipSet(sets.TPGain_Low_Eva);
        elseif utilities.TargetEva == 'high' then
            gFunc.EquipSet(sets.TPGain_High_Eva);
        end

        if (utilities.OverrideSet == 'IDLE') then
            gFunc.EquipSet(sets.Idle);
        end
        utilities.ResetDefaultWeapons(sets.Weapons_Default);

        local ta = gData.GetBuffCount('Trick Attack');
        if (ta > 0) then
            gFunc.EquipSet(sets.TrickAttack);
        end
        if (not isTargetTagged(thtier)) then
            -- 'isTargetTagged' is a function which determines whether you have added yourself
            -- to the target's enmity list, based on that target's server id. It does *not*
            -- check whether you have applied your highest TH level to the mob, only that you
            -- have performed a direct hostile action against it. If you weren't wearing TH
            -- gear when you tagged the mob, you will need to reapply TH manually, perhaps with
            -- a macro. For example: `/lac set TH 6.0` will set your TH gear for 6 seconds.
            gFunc.EquipSet(sets.TH);
        end
    elseif (player.IsMoving == true) then
        gFunc.EquipSet(sets.Fast);
    else
        gFunc.EquipSet(sets.TPGain);
        gFunc.EquipSet(sets.Idle);
        if (utilities.OverrideSet == 'SHOWOFF') then
            gFunc.EquipSet(sets.Showoff);
        end
    end

    if (gData.GetBuffCount('Sleep') > 0) then
        gFunc.EquipSet(sets.Sleep);
    end

    if (T{'PDT', 'MDT', 'BDT'}:contains(utilities.OverrideSet)) then
        -- damage-taken sets take precedence over everything
        gFunc.EquipSet(utilities.OverrideSet);
    end

    utilities.CheckDefaults();
end

profile.HandleAbility = function()
    local ability = gData.GetAction();
    if (T{'Flee', 'Steal', 'Hide', 'Provoke'}:contains(ability.Name)) then
        gFunc.EquipSet(sets[ability.Name]);
    elseif (ability.Name == 'Trick Attack') then
        -- this is handled in HandleDefault as well, but sometimes the autoattack can happen
        -- before gData.GetBuffCount('Trick Attack') updates
        gFunc.EquipSet(sets.TrickAttack);
    elseif (string.lower(ability.Name):match('step')) then
        gFunc.EquipSet(sets.Step);
    end

    utilities.CheckCancels();
end

profile.HandleItem = function()
end

profile.HandlePrecast = function()
    -- TODO: fast cast
    utilities.CheckCancels();
end

profile.HandleMidcast = function()
    -- TODO: fast cast, haste
    -- I don't think you can proc TH on spells, so I'm not passing in thtier.
    if (not isTargetTagged()) then
        gFunc.EquipSet(sets.TH);
    end
end

profile.HandlePreshot = function()
end

profile.HandleMidshot = function()
    gFunc.EquipSet(sets.Ranged);
    if (not isTargetTagged(thTier)) then
        gFunc.EquipSet(sets.TH);
    end
end

profile.HandleWeaponskill = function()
    -- local target = gData.GetActionTarget();
    -- if (tonumber(target.Distance) > 5) then
    --     gFunc.Echo(255, "Get closer!");
	-- 	gFunc.CancelAction();
    --     return;
    -- end

    gFunc.EquipSet(sets.WS_Default);

    local ws = gData.GetAction();

    -- local sa = gData.GetBuffCount('Sneak Attack');
    local ta = gData.GetBuffCount('Trick Attack');

    -- all dagger WS sets assume you have either SA or TA up and therefore
    -- don't prioritize acc+ gear (especially Mandalic and Mercy which are 1-hit).
    if (ws.Name == 'Exenterator') then
        gFunc.EquipSet(sets.WS_Exent);
    elseif (ws.Name == 'Mandalic Stab') then
        gFunc.EquipSet(sets.WS_Mandalic);
    elseif (ws.Name == 'Mercy Stroke') then
        gFunc.EquipSet(sets.WS_Mercy);
    elseif (ws.Name == 'Last Stand') then
        gFunc.EquipSet(sets.WS_LastStand);
    end

    if (ta > 0) then
        gFunc.EquipSet(sets.TrickAttack);
    end
end

return profile;
