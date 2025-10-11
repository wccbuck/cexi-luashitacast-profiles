utilities = gFunc.LoadFile('utilities.lua');

local profile = {};

local sets = {
    TPGain = {
        Head = 'Sao. Kabuto +1',
        Neck = 'Rikugame Nodowa',
        Ear1 = 'Brutal Earring +1',
        Ear2 = 'Bushinomimi',
        -- Body = { Name = 'Shura Togi +1', Augment = { [1] = 'Crit.hit rate+3', [2] = 'Haste+3' } }, -- this puts me over the haste cap
        Body = 'Usukane Haramaki',
        Hands = 'Swift Gages',
        Ring1 = 'Mars\'s Ring',
        Ring2 = 'Rajas Ring',
        -- Back = 'Aife\'s Mantle',
        Back = 'Cuchulain\'s Mantle',
        Waist = 'Ninurta\'s Sash',
        Legs = 'Myn. Haidate +1',
        Feet = 'Ruthless Greaves',
    },
    TPGain_Polearm = {
        Feet = 'Hmn. Sune-Ate +1',
    },
    TPGain_Low_Eva = {
    },
    TPGain_High_Eva = {
        -- Back = 'Cuchulain\'s Mantle',
    },
    Idle = { -- gets applied on top of TPGain
        Body = 'Myn. Domaru +1',
    },
    Meditate = {
        Head = 'Myn. Kabuto +1',
        Body = 'Myn. Domaru +1',
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
        Head = 'Shr.Znr.Kabuto +1', -- str, ws dmg
        Neck = 'Fotia Gorget',
        Ear1 = 'Brutal Earring +1',
        Ear2 = 'Bushinomimi',
        Body = 'Hmn. Domaru +1',
        -- Hands = 'Myn. Kote +1',
        Hands = 'Hachiman Kote +1',
        Ring1 = 'Strigoi Ring',
        Ring2 = 'Rajas Ring',
        Back = 'Cuchulain\'s Mantle',
        Waist = 'Warwolf Belt', -- replace with +1
        Legs = 'Hachiryu Haidate',
        Feet = 'Ruthless Greaves',
    },
    WS_Low_Eva = {
        -- Waist = 'Warwolf Belt',
    },
    WS_Rana = {
        Neck = 'Justice Torque',
    },
    WS_High_Eva = {
        Waist = 'Potent Belt',
        Legs = 'Shura Haidate +1', -- +2 strength aug after *hundreds* of dryadic tatters... +5 would obv be better
    },
    GKT_Skill = {
        Head = 'Sao. Kabuto +1',
        Neck = 'Justice Torque',
        Ear2 = 'Bushinomimi',
        -- moepapa annulet
    },
    Ranged = {
        Head = 'Optical Hat',
        Neck = 'Peacock Charm', -- swap to Hope Torque when you get it
        Ear1 = 'Altdorf\'s Earring',
        Ear2 = 'Wilhelm\'s Earring',
        Body = 'Kyudogi',
        Hands = 'Seiryu\'s Kote',
        Ring1 = 'Merman\'s Ring',
        Ring2 = 'Blobnag Ring',
        Back = 'Aife\'s Mantle',
        Waist = 'Buccaneer\'s Belt',
        Legs = 'Myn. Haidate +1',
        Feet = 'Hmn. Sune-Ate +1',
    },
    ApexArrow = {
        -- this gets applied on top of WS_Default
        Ear1 = 'Altdorf\'s Earring',
        Ear2 = 'Wilhelm\'s Earring',
        Hands = 'Seiryu\'s Kote',
        Ring1 = 'Garrulous Ring',
        Ring2 = 'Blobnag Ring',
        Back = 'Fowler\'s Mantle',
        Waist = 'Buccaneer\'s Belt',
        Feet = 'Hmn. Sune-Ate +1',
    },
    PDT = {
        Head = 'Ace\'s Helm',
        Neck = 'Rikugame Nodowa',
        Ear1 = 'Genmei Earring',
        Ear2 = 'Soil Earring',
        Body = 'Arhat\'s Gi +1',
        Hands = 'Melaco Mittens',
        Ring1 = 'Sattva Ring',
        Ring2 = 'Titanium Band',
        Back = 'Shadow Mantle',
        Waist = 'Oneiros Belt',
        Legs = 'Hydra Cuisses +1',
        Feet = 'Askar Gambieras',
    },
    MDT = {
        Neck = 'Jeweled Collar',
        Ear1 = 'Merman\'s Earring',
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
    BDT = {
        -- todo
        Ring2 = 'Titanium Band',
    },
    Showoff = {
    },
    Weapons_Default = {
        -- Main = 'Amanomurakumo',
        Main = 'Kogarasumaru',
        Sub = 'Pole Grip',
        Range = 'Ifrit\'s Bow',
        Ammo = 'Demon Arrow',
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
        
        -- consider re-enabling this if seigan is active
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
    elseif (ws.Name == 'Tachi: Rana') then
        gFunc.EquipSet(sets.WS_Rana);
    end
end

return profile;
