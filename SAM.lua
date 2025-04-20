utilities = gFunc.LoadFile('utilities.lua');

local profile = {};

-- some equipment pieces I use in multiple places

local acesHelm = {
    Name = 'Ace\'s Helm',
    Augment = { [1] = 'Phys. dmg. taken -2%', [2] = 'HP+15', [3] = 'MP+15', [4] = 'DEX+4' }
};

local mynDomaru = {
    Name = 'Myn. Domaru +1',
    Augment = { [1] = 'Meditate eff. dur. +1', [2] = '"Regen"+3' }
};

local mynKote = {
    Name = 'Myn. Kote +1',
    Augment = { [1] = 'Haste+3', [2] = '"Zanshin"+3' }
};

-- local byakkoHaidate = {
--     Name = 'Byakko\'s Haidate',
--     Augment = { [1] = 'VIT+3', [2] = '"Store TP"+5', [3] = 'Crit. hit damage +1%' }
-- };

local mynHaidate = {
    Name = 'Myn. Haidate +1', Augment = { [1] = '"Store TP"+5', [2] = 'Haste+5' }
};

local hmnSuneate = {
    Name = 'Hmn. Sune-Ate +1', Augment = { [1] = 'STR+4', [2] = 'Polearm skill +10', [3] = 'AGI+8', [4] = 'Archery skill +6' }
};

local sets = {
    TPGain = {
        Head = 'Sao. Kabuto +1',
        Neck = 'Rikugame Nodowa',
        Ear1 = 'Brutal Earring',
        Ear2 = 'Bushinomimi',
        Body = { Name = 'Shura Togi +1', Augment = { [1] = 'Crit.hit rate+3', [2] = 'Haste+3' } },
        Hands = mynKote, -- swap for swift gages
        -- Ring1 = 'Toreador\'s Ring',
        Ring1 = 'Mars\'s Ring',
        Ring2 = 'Rajas Ring',
        Back = 'Aife\'s Mantle',
        Waist = 'Ninurta\'s Sash',
        Legs = mynHaidate,
        Feet = hmnSuneate,
    },
    TPGain_Low_Eva = {
    },
    TPGain_High_Eva = {
        -- Back = 'Cuchulain\'s Mantle',
    },
    Idle = { -- gets applied on top of TPGain
        Body = mynDomaru,
    },
    Meditate = {
        Head = { Name = 'Myn. Kabuto +1', Augment = { [1] = 'Crit.hit rate+1', [2] = 'Haste+3' } },
        Body = mynDomaru,
        Hands = 'Saotome Kote',
    },
    ThirdEye = {
        Legs = 'Saotome Haidate',
    },
    Fast = {
        Body = 'Kupo Suit',
        Legs = 'displaced',
    },
    WS_Default = {
        Head = { Name = 'Shr.Znr.Kabuto +1', Augment = { [1] = 'Weapon skill damage +4%', [2] = '"Conserve TP"+5', [3] = 'Sklchn.dmg.+4%' } },
        Neck = 'Fotia Gorget',
        Ear1 = 'Brutal Earring',
        Ear2 = 'Bushinomimi',
        Body = { Name = 'Hmn. Domaru +1', Augment = { [1] = 'STR+6', [2] = 'Sklchn.dmg.+3%', [3] = '"Conserve TP"+6', [4] = 'Attack+12' } },
        Hands = mynKote,
        Ring1 = 'Flame Ring',
        Ring2 = 'Rajas Ring',
        Back = 'Cuchulain\'s Mantle',
        Waist = 'Potent Belt',
        Legs = { Name = 'Shura Haidate +1', Augment = { [1] = 'Rng.Acc.+3', [2] = 'Accuracy+3', [3] = '"Dual Wield"+4' } },
        Feet = hmnSuneate,
    },
    WS_Low_Eva = {
        -- hachiryu haidate
        Waist = 'Warwolf Belt',
    },
    WS_High_Eva = {

    },
    GKT_Skill = {
        Head = 'Sao. Kabuto +1',
        Ear2 = 'Bushinomimi',
        -- justice torque, moepapa annulet
    },
    Ranged = {
        Head = { Name = 'Optical Hat', Augment = { [1] = 'Haste+3', [2] = 'HP+15', [3] = 'AGI+3', [4] = 'DEX+3' } },
        Neck = 'Peacock Charm', -- swap to Hope Torque when you get it
        Ear1 = 'Altdorf\'s Earring',
        Ear2 = 'Wilhelm\'s Earring',
        Body = 'Kyudogi',
        Hands = 'Seiryu\'s Kote',
        Ring1 = 'Merman\'s Ring',
        Ring2 = 'Merman\'s Ring',
        Back = 'Aife\'s Mantle',
        Waist = 'Buccaneer\'s Belt',
        Legs = mynHaidate,
        Feet = hmnSuneate,
    },
    ApexArrow = {
        -- this gets applied on top of WS_Default
        Ear1 = 'Altdorf\'s Earring',
        Ear2 = 'Wilhelm\'s Earring',
        Hands = 'Seiryu\'s Kote',
        Ring1 = 'Garrulous Ring',
        Ring2 = 'Merman\'s Ring',
        Back = 'Fowler\'s Mantle',
        Waist = 'Buccaneer\'s Belt',
        Feet = hmnSuneate,
    },
    PDT = {
        Head = acesHelm,
        Neck = 'Rikugame Nodowa',
        Ear1 = 'Colossus\'s Earring',
        Ear2 = 'Soil Earring',
        Body = 'Arhat\'s Gi +1',
        Hands = 'Melaco Mittens',
        Ring1 = 'Sattva Ring',
        Ring2 = 'Rajas Ring', -- swap for succor ring or defending ring
        Back = 'Cuchulain\'s Mantle', -- swap for boxer's mantle, then shadow mantle
        Waist = 'Marid Belt',
        Legs = 'Hydra Cuisses +1',
        Feet = 'Askar Gambieras',
    },
    MDT = {
        Head = acesHelm,
        Neck = 'Jeweled Collar',
        Ear1 = 'Colossus\'s Earring',
        Ear2 = 'Merman\'s Earring',
        Body = 'Gavial Mail', -- eventually Nocturnus
        Hands = 'Gavial Fng. Gnt.',
        Ring1 = 'Merman\'s Ring',
        Ring2 = 'Merman\'s Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Lieutenant\'s Sash',
        Legs = 'Coral Cuisses',
        Feet = 'Askar Gambieras',
    },
    BDT = {},
    Showoff = {
    },
    Weapons_Default = {
        Main = { Name = 'Amanomurakumo', Augment = 'DMG:+6' },
        Sub = 'Pole Grip',
        Range = 'Ifrit\'s Bow',
        Ammo = 'Iron Arrow',
    },
    Weapons_Archery = {
        Main = 'Thunder Staff',
        Sub = 'Axe Grip',
        Range = 'Ajjub Bow',
        Ammo = 'Demon Arrow',
    },
    Sleep = {
        Neck = 'Opo-opo Necklace',
    },
    Berserker = {
        Neck = 'Berserker\'s Torque',
    },
};
profile.Sets = sets;

profile.Packer = {
};

profile.OnLoad = function()
    gSettings.AllowAddSet = true;
    utilities.Initialize();

    (function ()
        AshitaCore:GetChatManager():QueueCommand(1, '/lockstyleset 19');
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
        -- if all three weapon slots are empty during combat,
        -- equip the default weapon set (useful against merrows)
        utilities.ResetDefaultWeapons(sets.Weapons_Default);
        
        -- saotome haidate dont appear to work correctly
        -- if (gData.GetBuffCount('Third Eye') > 0) then
        --     gFunc.EquipSet(sets.ThirdEye);
        -- end

        if (gData.GetBuffCount('Sleep') > 0) then
            if (player.HP > 200) then
                gFunc.EquipSet(sets.Berserker);
            else
                gFunc.EquipSet(sets.Sleep);
            end
        end

    else
        if (player.IsMoving == true) then
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
    end

    if (T{'PDT', 'MDT', 'BDT'}:contains(utilities.OverrideSet)) then
        -- damage-taken sets take precedence over everything
        gFunc.EquipSet(utilities.OverrideSet);
    end

    utilities.CheckDefaults()
end

profile.HandleAbility = function()
    local ability = gData.GetAction();
    if (ability.Name == 'Meditate') then
		gFunc.EquipSet(sets.Meditate);
    -- saotome haidate dont appear to work correctly
    -- elseif (ability.Name == 'Third Eye') then
	-- 	gFunc.EquipSet(sets.ThirdEye);
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
end

profile.HandleWeaponskill = function()
    -- local target = gData.GetActionTarget();
    -- if (tonumber(target.Distance) > 5) then
    --     gFunc.Echo(255, "Get closer!");
	-- 	gFunc.CancelAction();
    --     return;
    -- end

    gFunc.EquipSet(sets.WS_Default);

    if utilities.TargetEva == 'low' then
        gFunc.EquipSet(sets.WS_Low_Eva);
    elseif utilities.TargetEva == 'high' then
        gFunc.EquipSet(sets.WS_High_Eva);
    end

    local ws = gData.GetAction();
    if (ws.Name == 'Apex Arrow') then
        gFunc.EquipSet(sets.ApexArrow);
    elseif (ws.Name == 'Tachi: Ageha') then
        -- need to keep GKT skill high enough
        gFunc.EquipSet(sets.GKT_Skill);
    end
    -- could put other WS sets here but they pretty much all are optimized around
    -- the pieces in WS_Default
    -- for example, if you don't have fotia:

    -- if (ws.Name == 'Tachi: Kaiten') then
    --     gFunc.EquipSet(sets.WS_ThunGorget);
    -- elseif (ws.Name == 'Tachi: Shoha') then
    --     gFunc.EquipSet(sets.WS_ShadGorget);
    -- elseif (ws.Name == 'Tachi: Rana') then
    --     gFunc.EquipSet(sets.WS_ShadGorget);
    -- elseif (ws.Name == 'Tachi: Gekko') then
    --     gFunc.EquipSet(sets.WS_SnowGorget);
    -- end
end

return profile;
