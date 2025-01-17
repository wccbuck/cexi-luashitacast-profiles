

utilities = gFunc.LoadFile('utilities.lua');
local isTargetTagged = gFunc.LoadFile('isTargetTagged');

local profile = {};

-- some equipment pieces I use in multiple places
local ohat = {
    Name = 'Optical Hat',
    Augment = { [1] = 'Haste+3', [2] = 'HP+15', [3] = 'AGI+3', [4] = 'DEX+3' }
};

local dragonHarness = {
    Name = 'Dragon Harness',
    Augment = { [1] = 'Sklchn.dmg.+2%', [2] = 'Attack+8', [3] = 'AGI+2', [4] = 'DEX+2' }
};

local hctMittens = {
    Name = 'Hct. Mittens +1',
    Augment = { [1] = 'Dagger skill +5', [2] = 'Crit. hit damage +2%' }
};

local acroBreeches = {
    Name = 'Acrobat\'s Breeches',
    Augment = { [1] = '"Dual Wield"+2', [2] = 'Attack+5', [3] = 'DEX+5' }
};

local sets = {
    TPGain = {
        Head = ohat,
        Neck = 'Tiercel Necklace',
        Ear1 = 'Brutal Earring',
        Ear2 = 'Suppanomimi',
        Body = 'Homam Corazza',
        Hands = 'Homam Manopolas',
        Ring1 = 'Toreador\'s Ring',
        Ring2 = 'Rajas Ring',
        Back = 'Aesir Mantle',
        Waist = 'Ninurta\'s Sash',
        Legs = acroBreeches,
        Feet = 'Homam Gambieras',
    },
    TPGain_Low_Eva = {
        Body = 'Rapparee Harness',
    },
    TPGain_High_Eva = {
        Neck = 'Chivalrous Chain',
        Back = 'Cuchulain\'s Mantle',
    },
    Idle = { -- gets applied on top of TPGain
    },
    WS_Default = {
        Head = ohat,
        Neck = 'Fotia Gorget',
        Ear1 = 'Aesir Ear Pendant',
        Ear2 = 'Bushinomimi',
        Body = dragonHarness,
        Hands = hctMittens,
        -- Ring1 = 'Garrulous Ring',
        Ring2 = 'Rajas Ring',
        Back = 'Cuchulain\'s Mantle',
        Waist = 'Warwolf Belt',
        Legs = acroBreeches,
        Feet = 'Adsilio Boots +1',
    },
    WS_Exent = {
        Head = ohat,
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
        Head = ohat,
        Neck = 'Fotia Gorget',
        Ear1 = 'Bushinomimi',
        Ear2 = 'Aesir Ear Pendant',
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
    TH = {
        Sub = 'Thief\'s Knife',
        Head = 'Wh. Rarab Cap +1',
        Hands = 'Assassin\'s Armlets',
    },
    TrickAttack = {
        -- +agi, +enmity
        -- Head = 'Dragon Cap' -- augment
        Ear1 = 'Wilhelm\'s Earring',
        Ear2 = 'Altdorf\'s Earring',
        Ring1 = 'Sattva Ring',
        Back = 'Assassin\'s Cape',
        Waist = 'Warwolf Belt',
    },
    Steal = {
        Head = 'Rogue\'s Bonnet',
        Hands = 'Rogue\'s Armlets',
        Legs = 'Rogue\'s Culottes',
        Feet = 'Rogue\'s Poulaines',
    },
    Hide = {
        Body = 'Rogue\'s Vest',
    },
    Fast = {
        Body = 'Kupo Suit',
        Legs = 'displaced',
        Feet = 'Rogue\'s Poulaines',
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
        Head = 'Dragon Cap',
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
        Back = 'Amemet Mantle',
        Legs = 'Dusk Trousers',
        Feet = 'Homam Gambieras',
    }
};
profile.Sets = sets;

profile.Packer = {
};

profile.OnLoad = function()
    gSettings.AllowAddSet = true;
    utilities.Initialize();

    (function () AshitaCore:GetChatManager():QueueCommand(1, '/lockstyleset 20') end):once(3);
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
        if (not isTargetTagged()) then
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

    if (T{'PDT', 'MDT', 'BDT'}:contains(utilities.OverrideSet)) then
        -- damage-taken sets take precedence over everything
        gFunc.EquipSet(utilities.OverrideSet);
    end

    utilities.CheckDefaults();
end

profile.HandleAbility = function()
    local ability = gData.GetAction();
    if (ability.Name == 'Flee') then
		gFunc.EquipSet(sets.Fast);
    elseif (ability.Name == 'Steal') then
		gFunc.EquipSet(sets.Steal);
    elseif (ability.Name == 'Hide') then
		gFunc.EquipSet(sets.Hide);
	end

    utilities.CheckCancels();
end

profile.HandleItem = function()
end

profile.HandlePrecast = function()
    utilities.CheckCancels();
end

profile.HandleMidcast = function()
end

profile.HandlePreshot = function()
end

profile.HandleMidshot = function()
    gFunc.EquipSet(sets.Ranged);
    if (not isTargetTagged()) then
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
    if (T{'Exenterator', 'Last Stand'}:contains(ws.Name)) then
        gFunc.EquipSet(sets.WS_Exent);
        -- TODO: make an actual last stand set (e.g. pahluwan hands)
    elseif (ws.Name == 'Mandalic Stab') then
        gFunc.EquipSet(sets.WS_Mandalic);
    elseif (ws.Name == 'Mercy Stroke') then
        gFunc.EquipSet(sets.WS_Mercy);
    end

    if (ta > 0) then
        gFunc.EquipSet(sets.TrickAttack);
    end
end

return profile;
