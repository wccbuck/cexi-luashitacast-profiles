utilities = gFunc.LoadFile('utilities.lua');
bluMag = gFunc.LoadFile('bluMag.lua');
isTargetTargetingMe = gFunc.LoadFile('isTargetTargetingMe');

local profile = {};

-- some equipment pieces I use in multiple places
local bloodMail = {
    Name = 'Blood Scale Mail',
    Augment = { [1] = 'STR+5', [2] = 'CHR+4', [3] = 'Haste+2' }
};

local bloodCuisses = {
    Name = 'Blood Cuisses',
    Augment = { [1] = 'VIT+6', [2] = '"Fast Cast"+4', [3] = 'Evasion+4' }
};

local ohat = {
    Name = 'Optical Hat',
    Augment = { [1] = 'Haste+3', [2] = 'HP+15', [3] = 'AGI+3', [4] = 'DEX+3' }
};

local acroBreeches = {
    Name = 'Acrobat\'s Breeches',
    Augment = { [1] = '"Dual Wield"+2', [2] = 'Attack+5', [3] = 'DEX+5' }
};

local princesSlops =  {
    Name = 'Prince\'s Slops',
    Augment = { 
        [1] = 'Pet: Rng. Acc.+6', 
        [2] = '"Mag.Def.Bns."+2', 
        [3] = 'Accuracy+3', 
        [4] = 'Pet: Accuracy+6', 
        [5] = 'Attack+3' 
    }
};

local magBaz = {
    Name = 'Mag. Bazubands +1',
    Augment = { [1] = 'Haste+3', [2] = '"Dbl.Atk."+3' }
};

local mrgBaz = {
    Name = 'Mrg. Bazubands +1',
    Augment = {
        [1] = 'VIT+6',
        [2] = 'STR+6',
        [3] = 'Accuracy+8',
        [4] = 'Attack+8',
        [5] = 'Haste+5'
    }
};

local learning = false;

local sets = {
    Idle = {
        Body = 'Mirage Jubbah',
        -- Legs = 'Magus Shalwar +1' -- uncomment this when you get + augment this (refresh + regen)
        Back = 'Umbra Cape',
    },
    TPGain = {
        Head = 'Dampening Tam',
        Neck = 'Fortitude Torque',
        -- Neck = 'Tiercel Necklace',
        Ear1 = 'Brutal Earring',
        Ear2 = 'Suppanomimi',
        Body = bloodMail,
        Hands = mrgBaz,
        Ring1 = 'Toreador\'s Ring',
        Ring2 = 'Rajas Ring',
        Back = 'Mirage Mantle', -- acc, store TP
        Waist = 'Ninurta\'s Sash',
        Legs = acroBreeches,
        Feet = 'Homam Gambieras',
    },
    TPGain_Ammo = {
        -- Ammo = 'White Tathlum',
        -- Ammo = 'Tiphia Sting',
        Ammo = 'Oneiros Pebble', -- +3 vit, +3 acc
    },
    TPGain_High_Eva = {
        Body = 'Homam Corazza',
        Neck = 'Chivalrous Chain',
    },
    TPGain_Low_Eva = {
        Ring1 = 'Flame Ring',
    },
    WS_Default = {
        Ammo = 'Tiphia Sting',
        Head = 'Maat\'s Cap',
        Neck = 'Fotia Gorget',
        Ear1 = 'Brutal Earring',
        Ear2 = 'Suppanomimi',
        Body = bloodMail,
        Hands = 'Enkidu\'s Mittens',
        Ring1 = 'Flame Ring', -- replace with Strigoi when you get it
        Ring2 = 'Rajas Ring',
        Back = 'Cuchulain\'s Mantle',
        Waist = 'Potent Belt',
        Legs = 'Mirage Shalwar +1',
        Feet = 'Denali Gamashes', -- replace with Setanta's when you get it and add denali to req + savage blade
    },
    WS_Requiescat = {
        -- 5 hits, MND 73%
        Hands = mrgBaz,
        Ring1 = 'Aqua Ring', -- swap with Tjukurrpa Annulet
        Waist = 'Visionary Obi',
    },
    WS_Expiacion = {
        -- 2 hits, STR 30%, DEX 20%, INT 30%
        Waist = 'Warwolf Belt',
    },
    WS_SavageBlade = {
        -- 2 hits, STR 50%, MND 50%
        Hands = mrgBaz,
        Waist = 'Visionary Obi',
    },
    WS_High_Eva = {
        -- this overrides anything set in specific WS sets
        Head = ohat, -- remove this line when you get Maat's cap
        Hands = 'Enkidu\'s Mittens',
        Ring1 = 'Toreador\'s Ring', -- remove this line when you get strigoi's
    },
    WS_Low_Eva = {
    },
    Learning = {
        Hands = magBaz,
    },
    Precast = {
        Ear1 = 'Loquac. Earring',
        Legs = 'Homam Cosciales', -- better than blood cuisses +1
    },
    Ethereal = {
        Ear1 = 'Ethereal Earring',
    },
    Cure = { -- 1 pt MND = 3 pts VIT = 5 pts healing magic skill. Also cure potency+
        Ammo = 'Bibiki Seashell',
        Head = 'Yigit Turban',
        Neck = 'Gnole Torque',
        Ear1 = 'Light Earring',
        Ear2 = 'Aqua Earring',
        Body = bloodMail,
        Hands = mrgBaz,
        Ring1 = 'Tamas Ring',
        Ring2 = 'Aqua Ring',
        Back = 'Dew Silk Cape +1',
        Waist = 'Salire Belt',
        Legs = 'Errant Slops',
        Feet = 'Errant Pigaches',
    },
    Fast = {
        Legs = bloodCuisses,
    },
    Rest = {
        Head = 'Yigit Turban',
        Neck = 'Gnole Torque',
        Ear1 = 'Antivenom Earring',
        Ear2 = 'Darkness Earring',
        Body = 'Errant Hpl.',
        Ring1 = 'Star Ring',
        Ring2 = 'Star Ring',
        Back = 'Invigorating Cape',
        Waist = 'Hierarch Belt',
        Legs = 'Yigit Seraweels',
    },
    -- Headbutt = {
    --     -- blue mag skill, acc, magic acc, int, str
    --     -- Str affects damage the most, but if I'm using head butt,
    --     -- I don't really care about the damage; I want the stun to stick
    --     Ammo = 'Phantom Tathlum',
    --     Head = 'Mirage Keffiyeh',
    --     Neck = 'Lieut. Gorget',
    --     Ear1 = 'Aqua Earring',
    --     Ear2 = 'Suppanomimi',
	-- 	Body = 'Magus Jubbah',
    --     Hands = magBaz,
    --     Ring1 = 'Antica Ring',
    --     Ring2 = 'Balrahn\'s Ring',
    --     Back = 'Mirage Mantle',
    --     Waist = 'Potent Belt',
    --     Legs = 'Mirage Shalwar +1',
    --     Feet = 'Blood Greaves',
    -- },
    Headbutt = {
        -- all accuracy.
        Ammo = 'Oneiros Pebble',
        Head = ohat,
        Neck = 'Peacock Charm',
        Ear1 = 'Hollow Earring',
        Ear2 = 'Suppanomimi',
        Body = 'Homam Corazza',
        Hands = mrgBaz,
        Ring1 = 'Toreador\'s Ring',
        Ring2 = 'Rajas Ring',
        Back = 'Mirage Mantle',
        Waist = 'Potent Belt',
        Legs = princesSlops,
        Feet = 'Homam Gambieras',
    },
    BluMagSkill = {
        -- blue mag skill and magic accuracy only
        -- used for enfeebs, buffs, and drains
        Head = 'Mirage Keffiyeh',
        Neck = 'Incanter\'s Torque',
        Ear1 = 'Aqua Earring',
        Body = 'Magus Jubbah',
        Ring1 = 'Antica Ring',
        Ring2 = 'Balrahn\'s Ring',
        Back = 'Mirage Mantle',
        Waist = 'Salire Belt',
        Legs = 'Mirage Shalwar +1',
        Feet = 'Blood Greaves',
    },
    Phys_Spell = {
        Ammo = 'Oneiros Pebble',
        Head = 'Dampening Tam',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Pixie Earring',
        Ear2 = 'Suppanomimi',
        Body = 'Magus Jubbah',
        Hands = mrgBaz,
        Ring1 = 'Flame Ring',
        Ring2 = 'Rajas Ring',
        Back = 'Cuchulain\'s Mantle',
        Waist = 'Visionary Obi',
        Legs = 'Mirage Shalwar +1',
        Feet = 'Blood Greaves', -- or denali gamashes if you don't have acc+5 blu mag+5
    },
    Phys_Spell_High_Eva = {
        Neck = 'Peacock Charm',
        Ring1 = 'Toreador\'s Ring',
    },
    Phys_Spell_Low_Eva = {
        Ear1 = 'Bushinomimi',
        Waist = 'Warwolf Belt',
    },
    Phys_Spell_Dex = { -- e.g. disseverment, frenetic rip, hysteric barrage
        Feet = 'Blood Greaves',
    },
    Phys_Spell_Agi = { -- e.g. jet stream
        Head = 'Maat\'s Cap',
        Feet = 'Blood Greaves',
    },
    Phys_Spell_Vit = { -- e.g. quad continuum
        Head = 'Maat\'s Cap',
        -- Neck = 'Fortitude Torque',
    },
    Mag_Spell_Charisma = { -- eyes on me
        Ammo = 'Hedgehog Bomb',
        Head = 'Maat\'s Cap',
        Neck = 'Bird Whistle',
        Ear1 = 'Moldavite Earring',
        Ear2 = 'Novio Earring',
        Body = 'Errant Hpl.',
        Hands = 'Yigit Gages',
        Ring1 = 'Omega Ring',
        Ring2 = 'Angel\'s Ring',
        Back = 'Jester\'s Cape',
        Waist = 'Salire Belt',
        Legs = 'Errant Slops', -- nimue's tights, byakko 2.0
        Feet = 'Denali Gamashes',
    },
    Mag_Spell_Intelligence = {
        Ammo = 'Phantom Tathlum',
        Head = 'Maat\'s Cap',
        Neck = 'Lmg. Medallion +1',
        Ear1 = 'Moldavite Earring',
        Ear2 = 'Novio Earring',
        Body = bloodMail,
        Hands = 'Yigit Gages',
        Ring1 = 'Tamas Ring',
        Ring2 = 'Galdr Ring',
        Back = 'Voluspa Mantle',
        Waist = 'Salire Belt',
        Legs = 'Errant Slops',
        -- Feet = 'Denali Gamashes',
        Feet = 'Yigit Crackows',
    },
    Mag_Spell_Mind = {
        Ammo = 'Hedgehog Bomb',
        Head = 'Maat\'s Cap',
        Neck = 'Gnole Torque',
        Ear1 = 'Moldavite Earring',
        Ear2 = 'Novio Earring',
        Body = bloodMail,
        Hands = 'Yigit Gages',
        Ring1 = 'Tamas Ring',
        Ring2 = 'Aqua Ring',
        Back = 'Dew Silk Cape +1',
        Waist = 'Salire Belt',
        Legs = 'Errant Slops',
        -- Feet = 'Denali Gamashes',
        Feet = 'Yigit Crackows',
    },
    Searing_Tempest = {
        -- applied on top of Mag_Spell_Intelligence
    },
    Cannonball = {
        -- def, vit, acc, str
        Ammo = 'Oneiros Pebble',
        Head = 'Maat\'s Cap',
        Neck = 'Fortitude Torque',
        Ear1 = 'Hollow Earring',
        Ear2 = 'Suppanomimi',
        Body = 'Enkidu\'s Harness',
        Hands = mrgBaz,
        Ring1 = 'Unyielding Ring',
        Ring2 = 'Rajas Ring',
        Back = 'Cuchulain\'s Mantle',
        Waist = 'Warwolf Belt',
        Legs = 'Mirage Shalwar +1',
        Feet = 'Blood Greaves',
    },
    Cannonball_SA = {
        -- sneak attack, no need for acc. This gets placed on top of Cannonball set
        Ear1 = 'Soil Earring',
        Ear2 = 'Bushinomimi',
        Body = bloodMail,
        Ring2 = 'Corneus Ring',
        Legs = bloodCuisses,
    },
    BlazingBound = {
        Ammo = 'Phantom Tathlum',
        Head = 'Magus Keffiyeh',
        Neck = 'Lmg. Medallion +1',
        Ear1 = 'Abyssal Earring',
        Ear2 = 'Aqua Earring', -- swap for INT+
        Body = bloodMail,
        Hands = 'Yigit Gages',
        Ring1 = 'Tamas Ring',
        Ring2 = 'Snow Ring',
        Back = 'Lamia Mantle',
        Waist = 'Salire Belt', -- swap for int+ like penitent belt
        Legs = 'Errant Slops',
        Feet = 'Denali Gamashes',
    },
    HP = {
        -- use this set and heal to full (Magic Fruit) before using a breath spell
        Head = 'Saurian Helm',
        -- Neck = 'Tempered Chain',
        Ear1 = 'Ethereal Earring',
        Ear2 = 'Colossus\'s Earring',
        Body = bloodMail,
        Hands = 'Homam Manopolas',
        Ring1 = 'Bomb Queen Ring',
        Ring2 = 'Bloodbead Ring',
        Back = 'Gigant Mantle',
        Waist = 'Marid Belt',
        Legs = 'Dusk Trousers',
        Feet = 'Homam Gambieras',
    },
    Breath = {
        Head = 'Saurian Helm', -- or Mirage Keffiyeh but that has less HP+
    },
    SpIntDown = {
        -- Head = 'Nashira Turban', -- 10%
        -- Neck = 'Willpower Torque', -- 5%
        -- Ear1 = 'Magnetic Earring', -- 8%
        -- Hands = 'Swift Gages', -- 10%
        -- Back = 'Solitaire Cape', -- 8%
        Waist = 'Ninurta\'s Sash', -- 6%, or druid's rope 10%
        Legs = 'Magus Shalwar', -- 10%, 12% if +1
        -- Feet = 'Karasutengu', -- 15%
    },
    PDT = {
        -- TODO
        -- Ammo = 'Bibiki Seashell',
        Ammo = 'Oneiros Pebble',
        -- Ear1 = 'Colossus\'s Earring',
        Ear1 = 'Ethereal Earring',
        Ear2 = 'Soil Earring',
        Body = bloodMail,
        -- Body = 'Scorpion Harness +1' -- see grand trials. -3%
        Hands = 'Denali Wristbands',
        Ring1 = 'Sattva Ring',
        Back = 'Umbra Cape',
        Waist = 'Marid Belt',
        Legs = bloodCuisses,
    },
    MDT = {
        -- TODO
        Head = 'Dampening Tam',
        Ear1 = 'Colossus\'s Earring',
        Ear2 = 'Merman\'s Earring',
        Neck = 'Jeweled Collar',
        Hands = 'Denali Wristbands',
        Ring1 = 'Merman\'s Ring',
        Ring2 = 'Merman\'s Ring',
        Back = 'Colossus\'s Mantle',
        Waist = 'Lieutenant\'s Sash',
        Legs = 'Coral Cuisses',
    },
    BDT = {
        -- TODO
        Body = bloodMail,
        Hands = 'Denali Wristbands',
    },
    Showoff = {},
    Weapons_Default = {
        Main = 'Mimesis',
        Sub = 'Xiutleato',
        -- Range = 'Rising Sun',
        Ammo = 'Oneiros Pebble',
    },
    Buff = {
        Back = 'Grapevine Cape',
    },
    Stoneskin = { -- if sub whm or rdm
        Neck = 'Stone Gorget',
        Back = 'Grapevine Cape',
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
    (function () AshitaCore:GetChatManager():QueueCommand(1, '/lockstyleset 16') end):once(3);

end

profile.OnUnload = function()
end

profile.HandleCommand = function(args)
    if args[1] == 'learning' then
        learning = not learning;
        gFunc.Echo(255,  'Learning [' .. (learning and 'ON' or 'OFF') .. ']');
    end
    utilities.HandleCommands(args);
end

profile.HandleDefault = function()
    local player = gData.GetPlayer();
    if (player.Status == 'Engaged') then
        gFunc.EquipSet(sets.TPGain);
        gFunc.EquipSet(sets.TPGain_Ammo);
        if utilities.TargetEva == 'low' then
            gFunc.EquipSet(sets.TPGain_Low_Eva);
        elseif utilities.TargetEva == 'high' then
            gFunc.EquipSet(sets.TPGain_High_Eva);
        end

        if (utilities.OverrideSet == 'IDLE') then
            -- use this when unable to attack, e.g. a dragon is up in the air
            gFunc.EquipSet(sets.Idle);
        end
        utilities.ResetDefaultWeapons(sets.Weapons_Default);
        -- if (isTargetTargetingMe() and player.MPP < 90) then
        --     gFunc.EquipSet(sets.Ethereal);
        -- end
    elseif (player.IsMoving) then
        gFunc.EquipSet(sets.Fast);
    elseif (player.Status == 'Resting') then
        gFunc.EquipSet(sets.Rest);
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
        -- damage-taken sets take precedence over (almost) everything
        gFunc.EquipSet(utilities.OverrideSet);
        if player.MPP < 90 then
            -- might as well get some MP back
            gFunc.EquipSet(sets.Ethereal);
        end
    end

    if learning then
        gFunc.EquipSet(sets.Learning);
    end

    utilities.CheckDefaults();
end

profile.HandleAbility = function()
    utilities.CheckCancels();
end

profile.HandleItem = function()
end

profile.HandlePrecast = function()
    gFunc.EquipSet(sets.Precast);
    utilities.CheckCancels();
end

profile.HandleMidcast = function()
    local spell = gData.GetAction();

    if (bluMag.Stun:contains(spell.Name)) then
        gFunc.EquipSet(sets.Headbutt);
    elseif (spell.Name == 'Cannonball') then
        gFunc.EquipSet(sets.Cannonball);
        local sa = gData.GetBuffCount('Sneak Attack');
        if (sa > 0 or utilities.TargetEva == 'low') then
            gFunc.EquipSet(sets.Cannonball_SA);
        end
    elseif (spell.Name == 'Blazing Bound') then
        gFunc.EquipSet(sets.BlazingBound);
    elseif (spell.Name == 'Stoneskin') then
        gFunc.EquipSet(sets.Stoneskin);
    elseif bluMag.Phys:contains(spell.Name) then
        gFunc.EquipSet(sets.Phys_Spell);
        if utilities.TargetEva == 'low' then
            -- could check sneak attack here too but many phys spells are multi-hit
            -- so SA wouldn't help as much
            gFunc.EquipSet(sets.Phys_Spell_Low_Eva);
        elseif utilities.TargetEva == 'high' then
            gFunc.EquipSet(sets.Phys_Spell_High_Eva);
        end
        if bluMag.PhysAgi:contains(spell.Name) then
            gFunc.EquipSet(sets.Phys_Spell_Agi);
        elseif bluMag.PhysDex:contains(spell.Name) then
            gFunc.EquipSet(sets.Phys_Spell_Dex);
        elseif bluMag.PhysVit:contains(spell.Name) then
            gFunc.EquipSet(sets.Phys_Spell_Vit);
        end
    elseif bluMag.IntNuke:contains(spell.Name) then
        gFunc.EquipSet(sets.Mag_Spell_Intelligence);
        if (spell.Name == 'Searing Tempest') then
            gFunc.EquipSet(sets.Searing_Tempest);
        end
    elseif bluMag.MndNuke:contains(spell.Name) then
        gFunc.EquipSet(sets.Mag_Spell_Mind);
    elseif bluMag.ChrNuke:contains(spell.Name) then
        gFunc.EquipSet(sets.Mag_Spell_Charisma);
    elseif (spell.Skill == 'Healing Magic') or (bluMag.Cure:contains(spell.Name)) then
        gFunc.EquipSet(sets.Cure);
    elseif bluMag.Breath:contains(spell.Name) then
        gFunc.EquipSet(sets.Breath);
    else
        gFunc.EquipSet(sets.BluMagSkill);
        if (spell.Skill == 'Enhancing Magic') or (bluMag.Buff:contains(spell.Name)) then
            -- https://www.bg-wiki.com/ffxi/CatsEyeXI_Systems/Jobs#Blue_Mage
            -- "Blue Magic affected by Diffusion gets the bonus from gear that
            -- increases Enhancing Magic Duration after the 8-22-2024 update."
            gFunc.EquipSet(sets.Buff);
        end
    end
end

profile.HandlePreshot = function()
end

profile.HandleMidshot = function()
end

profile.HandleWeaponskill = function()
    -- local target = gData.GetActionTarget();
    -- if (tonumber(target.Distance) > 5) then
    --     gFunc.Echo(255, "Get closer!");
	-- 	gFunc.CancelAction();
    --     return;
    -- end

    local ws = gData.GetAction();
    gFunc.EquipSet(sets.WS_Default);

    if ws.Name == 'Requiescat' then
        gFunc.EquipSet(sets.WS_Requiescat);
    elseif ws.Name == 'Expiacion' then
        gFunc.EquipSet(sets.WS_Expiacion);
    elseif ws.Name == 'Savage Blade' then
        gFunc.EquipSet(sets.WS_SavageBlade);
    end

    if utilities.TargetEva == 'low' then
        gFunc.EquipSet(sets.WS_Low_Eva);
    elseif utilities.TargetEva == 'high' then
        gFunc.EquipSet(sets.WS_High_Eva);
    end
end

return profile;
