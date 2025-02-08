utilities = gFunc.LoadFile('utilities.lua');
local isTargetTagged = gFunc.LoadFile('isTargetTagged');

local profile = {};
local thtier = 6; -- the treasure hunter tier at which we should switch to TP gain set

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
    Augment = { [1] = 'Dagger skill +6', [2] = 'AGI+4', [3] = '"Subtle Blow"+4' }
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
        Body = 'Homam Corazza',
        Hands = 'Homam Manopolas',
        Ring1 = 'Toreador\'s Ring',
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
    },
    WS_Default = {
        Head = 'Gnadbhod\'s Helm', -- eventually hct
        Neck = 'Fotia Gorget',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Bushinomimi',
        Body = dragonHarness,
        Hands = hctMittens,
        Ring1 = 'Thunder Ring',
        Ring2 = 'Rajas Ring',
        Back = 'Cuchulain\'s Mantle',
        Waist = 'Warwolf Belt',
        Legs = acroBreeches, -- eventually hct
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
        Head = 'Gnadbhod\'s Helm', -- eventually hct
        Neck = 'Fotia Gorget',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Pixie Earring',
        Body = dragonHarness,
        Hands = hctMittens,
        Ring1 = 'Thunder Ring',
        Ring2 = 'Rajas Ring',
        Back = 'Cuchulain\'s Mantle',
        Waist = 'Cuchulain\'s Belt',
        Legs = acroBreeches,
        Feet = 'Adsilio Boots +1',
    },
    WS_Mercy = {}, -- STR
    WS_LastStand = {
        Head = dragonCap,
        Neck = 'Fotia Gorget',
        Ear1 = 'Wilhelm\'s Earring',
        Ear2 = 'Altdorf\'s Earring',
        Body = 'Denali Jacket',
        Hands = 'Enkidu\'s Mittens', -- get pahluwan?
        Ring1 = 'Garrulous Ring',
        Ring2 = 'Rajas Ring',
        Back = 'Amemet Mantle',
        Waist = 'Buccaneer\'s Belt',
        Legs = acroBreeches,
        Feet = 'Adsilio Boots +1',
    },
    TH = {
        Sub = 'Thief\'s Knife',
        Head = 'Wh. Rarab Cap +1',
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
        Legs = 'Rogue\'s Culottes', -- swap with assassin's
        Feet = 'Rogue\'s Poulaines',
    },
    Hide = {
        Body = 'Rogue\'s Vest',
    },
    Flee = {
        Feet = 'Rogue\'s Poulaines',
    },
    Fast = {
        Body = 'Kupo Suit',
        Legs = 'displaced',
    },
    PDT = {
        -- TODO
        -- Body = 'Scorpion Harness +1' -- see grand trials. -3%
        Ear2 = 'Soil Earring',
        Hands = 'Denali Wristbands',
        Ring1 = 'Sattva Ring',
    },
    MDT = {
        -- TODO
        Head = 'Dampening Tam',
        Neck = 'Jeweled Collar',
        Ear1 = 'Colossus\'s Earring',
        -- Body = 'Avalon Breastplate', -- Tiamat drop
        -- Body = 'Blue Cotehardie' -- see grand trials. -3%
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
        Main = 'X\'s Knife',
        Sub = 'Atoyac',
        Range = 'Staurobow',
        Ammo = 'Crossbow Bolt',
    },
    -- Weapons_TH = {
    --     Main = 'X\'s Knife',
    --     Sub = 'Thief\'s Knife',
    --     Range = 'Staurobow',
    --     Ammo = 'Crossbow Bolt',
    -- },
    Ranged = {
        Head = ohat,
        Neck = 'Peacock Charm',
        Ear1 = 'Wilhelm\'s Earring',
        Ear2 = 'Altdorf\'s Earring',
        Body = 'Denali Jacket',
        Hands = 'Enkidu\'s Mittens', -- get pahluwan
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

    (function () AshitaCore:GetChatManager():QueueCommand(1, '/lockstyleset 20') end):once(3);
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
