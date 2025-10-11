utilities = gFunc.LoadFile('utilities.lua');
bluMag = gFunc.LoadFile('bluMag.lua');
isTargetTargetingMe = gFunc.LoadFile('isTargetTargetingMe');
isTargetTagged = gFunc.LoadFile('isTargetTagged');

local profile = {};

local learning = false;
local sird = false;
local cleave = false;

local sets = {
    Idle = {
        Ammo = 'Oneiros Pebble', -- +3 vit, +3 acc
        Ear1 = 'Genmei Earring',
        Ear2 = 'Soil Earring',
        Neck = 'Oneiros Torque',
        Body = 'Morrigan\'s Robe',
        Hands = 'Denali Wristbands',
        Ring1 = 'Sattva Ring',
        Ring2 = 'Titanium Band',
        Back = 'Shadow Mantle',
        Waist = 'Oneiros Belt',
        Legs = 'Magus Shalwar +1',
    },
    TPGain = {
        -- Head = 'Dampening Tam',
        Head = 'Mirage Keffiyeh +1',
        Neck = 'Fortitude Torque',
        -- Neck = 'Tiercel Necklace',
        Ear1 = 'Brutal Earring +1',
        Ear2 = 'Suppanomimi',
        Body = 'Samnuha Coat',
        -- Body = 'Blood Scale Mail',
        -- Body = 'Morrigan\'s Robe',
        -- Hands = 'Mrg. Bazubands +1',
        Hands = 'Swift Gages',
        -- Ring1 = 'Toreador\'s Ring',
        Ring1 = 'Mars\'s Ring',
        Ring2 = 'Rajas Ring',
        Back = 'Mirage Mantle', -- acc, store TP
        Waist = 'Ninurta\'s Sash',
        Legs = 'Acrobat\'s Breeches',
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
        Ring1 = 'Strigoi Ring',
    },
    WS_Default = {
        Ammo = 'Tiphia Sting',
        Head = 'Maat\'s Cap',
        Neck = 'Fotia Gorget',
        Ear1 = 'Brutal Earring +1',
        Ear2 = 'Emberpearl Earring',
        Body = 'Morrigan\'s Robe',
        Hands = 'Enkidu\'s Mittens',
        Ring1 = 'Strigoi Ring',
        Ring2 = 'Rajas Ring',
        Back = 'Cuchulain\'s Mantle',
        Waist = 'Potent Belt',
        Legs = 'Mirage Shalwar +1',
        Feet = 'Denali Gamashes', -- replace with Setanta's when you get it
    },
    WS_Requiescat = {
        -- 5 hits, MND 85%
        Hands = 'Mrg. Bazubands +1',
        Ring1 = 'Aqua Ring', -- swap with Tjukurrpa Annulet
        Back = 'Stormlord Shawl +1',
        Waist = 'Visionary Obi',
        Feet = 'Denali Gamashes',
    },
    WS_Expiacion = {
        -- 2 hits, STR 95%, INT 95%
        Waist = 'Warwolf Belt',
    },
    WS_SavageBlade = {
        -- 2 hits, STR 80%, MND 80%
        Hands = 'Mrg. Bazubands +1',
        Back = 'Stormlord Shawl +1',
        Waist = 'Visionary Obi',
        Feet = 'Denali Gamashes',
    },
    WS_High_Eva = {
        -- this overrides anything set in specific WS sets
        Hands = 'Enkidu\'s Mittens',
        -- Ring1 = 'Mars\'s Ring', -- strigoi might still be better in most cases
    },
    WS_Low_Eva = {
    },
    Learning = {
        Hands = 'Mag. Bazubands +1',
    },
    Precast = {
        Ear1 = 'Loquac. Earring',
        Head = 'Entrancing Ribbon',
        Body = 'Mirage Jubbah +1',
        Ring2 = 'Dark Ring', -- fast cast
        Back = 'Swith Cape +1',
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
        Body = 'Blood Scale Mail',
        Hands = 'Mrg. Bazubands +1',
        Ring1 = 'Tamas Ring',
        Ring2 = 'Karka Ring',
        Back = 'Dew Silk Cape +1',
        Waist = 'Salire Belt',
        Legs = 'Morrigan\'s Slops',
        Feet = 'Errant Pigaches',
    },
    Fast = {
        Legs = 'Blood Cuisses',
    },
    Rest = {
        Main = 'Chatoyant Staff',
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
    --     Ammo = 'Phtm. Tathlum',
    --     Head = 'Mirage Keffiyeh +1',
    --     Neck = 'Lieut. Gorget',
    --     Ear1 = 'Aqua Earring',
    --     Ear2 = 'Suppanomimi',
	-- 	Body = 'Magus Jubbah +1',
    --     Hands = 'Mag. Bazubands +1',
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
        Head = 'Optical Hat',
        Neck = 'Peacock Charm',
        Ear1 = 'Hollow Earring',
        Ear2 = 'Suppanomimi',
        Body = 'Homam Corazza',
        Hands = 'Mrg. Bazubands +1',
        Ring1 = 'Mars\'s Ring',
        Ring2 = 'Rajas Ring',
        Back = 'Mirage Mantle',
        Waist = 'Potent Belt',
        Legs = 'Prince\'s Slops', -- acc/att augments
        Feet = 'Homam Gambieras',
    },
    BluMagSkill = {
        -- blue mag skill and magic accuracy only
        -- used for enfeebs, buffs, and drains
        Head = 'Mirage Keffiyeh +1',
        Neck = 'Incanter\'s Torque',
        Ear1 = 'Aqua Earring',
        Body = 'Magus Jubbah +1',
        Hands = 'Nashira Gages',
        Ring1 = 'Antica Ring',
        Ring2 = 'Balrahn\'s Ring',
        Back = 'Mirage Mantle',
        Waist = 'Salire Belt',
        -- Legs = 'Mirage Shalwar +1',
        Legs = 'Homam Cosciales', -- blue magic skill, conserve MP, haste
        Feet = 'Blood Greaves',
    },
    Phys_Spell = {
        Ammo = 'Oneiros Pebble',
        -- Head = 'Dampening Tam',
        Head = 'Mirage Keffiyeh +1',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Pixie Earring',
        Ear2 = 'Suppanomimi',
        Body = 'Magus Jubbah +1',
        Hands = 'Mrg. Bazubands +1',
        Ring1 = 'Strigoi Ring',
        Ring2 = 'Rajas Ring',
        Back = 'Cuchulain\'s Mantle',
        Waist = 'Visionary Obi',
        Legs = 'Mirage Shalwar +1',
        Feet = 'Blood Greaves', -- or denali gamashes if you don't have acc+5 blu mag+5
    },
    Phys_Spell_High_Eva = {
        Neck = 'Peacock Charm',
        Ring1 = 'Mars\'s Ring',
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
        Body = 'Mirage Jubbah +1',
        Hands = 'Yigit Gages',
        Ring1 = 'Omega Ring',
        Ring2 = 'Light Ring',
        Back = 'Jester\'s Cape',
        Waist = 'Charmer\'s Sash',
        Legs = 'Errant Slops', -- nimue's tights, byakko 2.0
        Feet = 'Magus Charuqs +1',
    },
    Mag_Spell_Intelligence = {
        Ammo = 'Phtm. Tathlum',
        Head = 'Maat\'s Cap',
        Neck = 'Lmg. Medallion +1',
        Ear1 = 'Moldavite Earring',
        Ear2 = 'Novio Earring',
        Body = 'Morrigan\'s Robe',
        Hands = 'Yigit Gages',
        Ring1 = 'Tamas Ring',
        Ring2 = 'Galdr Ring',
        -- Back = 'Voluspa Mantle',
        Back = 'Mirage Mantle', -- blue magic skill and m.acc
        Waist = 'Charmer\'s Sash',
        Legs = 'Morrigan\'s Slops',
        -- Feet = 'Denali Gamashes',
        Feet = 'Magus Charuqs +1',
    },
    Mag_Spell_Mind = {
        Ammo = 'Hedgehog Bomb',
        Head = 'Maat\'s Cap',
        Neck = 'Gnole Torque',
        Ear1 = 'Moldavite Earring',
        Ear2 = 'Novio Earring',
        Body = 'Morrigan\'s Robe',
        Hands = 'Yigit Gages',
        Ring1 = 'Tamas Ring',
        Ring2 = 'Karka Ring',
        Back = 'Dew Silk Cape +1',
        Waist = 'Salire Belt',
        Legs = 'Morrigan\'s Slops',
        -- Feet = 'Denali Gamashes',
        -- Feet = 'Yigit Crackows',
        Feet = 'Magus Charuqs +1',
    },
    -- tempest, floe, and entomb sets are applied on top of Mag_Spell_Intelligence
    Searing_Tempest = {
        -- consider swapping some pieces for str+
    },
    Entomb_Floe = {
        -- prioritize blue magic skill and magic acc over MAB
        Head = 'Mirage Keffiyeh +1',
        Neck = 'Incanter\'s Torque',
        Ear1 = 'Aqua Earring',
        -- best earring combo: Cassandra/Helenus set. MAB+5 M.Acc+5
        -- or two HQ aqua earrings. $$$
        -- Body = 'Magus Jubbah +1',
        Hands = 'Nashira Gages',
        Ring1 = 'Tamas Ring',
        Ring2 = 'Galdr Ring',
        Back = 'Voluspa Mantle',
        Waist = 'Salire Belt',
        Legs = 'Morrigan\'s Slops',
        Feet = 'Magus Charuqs +1',
    },
    Cannonball = {
        -- def, vit, acc, str
        Ammo = 'Oneiros Pebble',
        Head = 'Maat\'s Cap',
        Neck = 'Fortitude Torque',
        Ear1 = 'Hollow Earring',
        Ear2 = 'Suppanomimi',
        Body = 'Enkidu\'s Harness',
        Hands = 'Mrg. Bazubands +1',
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
        Body = 'Blood Scale Mail',
        Ring2 = 'Corneus Ring',
        Legs = 'Blood Cuisses',
    },
    BlazingBound = {
        Ammo = 'Phtm. Tathlum',
        Head = 'Maat\'s Cap',
        Neck = 'Lmg. Medallion +1',
        Ear1 = 'Abyssal Earring',
        Ear2 = 'Aqua Earring', -- swap for INT+
        Body = 'Blood Scale Mail',
        Hands = 'Yigit Gages',
        Ring1 = 'Tamas Ring',
        Ring2 = 'Galdr Ring',
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
        Ear2 = 'Pigeon Earring +1',
        Body = 'Blood Scale Mail',
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
        -- sird, spell interruption rate down
        Head = 'Nashira Turban', -- 10%
        -- Neck = 'Willpower Torque', -- 5%
        -- Ear1 = 'Magnetic Earring', -- 8%
        Body = 'Magus Jubbah +1', -- blue magic skill +15
        Hands = 'Swift Gages', -- 10%
        -- Back = 'Solitaire Cape', -- 8%
        Waist = 'Ninurta\'s Sash', -- 6%, or druid's rope 10%
        Legs = 'Magus Shalwar +1', -- 12%
        -- Feet = 'Karasutengu', -- 15%
        Feet = 'Magus Charuqs +1', -- blue magic skill +5
    },
    PDT = {
        -- Ammo = 'Bibiki Seashell',
        -- Ammo = 'Oneiros Pebble',
        -- Ear1 = 'Colossus\'s Earring',
        -- Ear1 = 'Ethereal Earring',
        Neck = 'Oneiros Torque',
        Ear1 = 'Genmei Earring',
        Ear2 = 'Soil Earring',
        Body = 'Blood Scale Mail',
        -- Body = 'Morrigan\'s Robe',
        Hands = 'Denali Wristbands',
        Ring1 = 'Sattva Ring',
        Ring2 = 'Titanium Band',
        Back = 'Shadow Mantle',
        -- Back = 'Umbra Cape',
        Waist = 'Oneiros Belt',
        Legs = 'Blood Cuisses',
    },
    MDT = {
        Head = 'Dampening Tam',
        Ear1 = 'Merman\'s Earring',
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
        Body = 'Blood Scale Mail',
        Hands = 'Denali Wristbands',
        Ring2 = 'Titanium Band',
    },
    Showoff = {},
    Weapons_Default = {
        Main = 'Stormblade',
        Sub = 'Mimesis',
        Ammo = 'Oneiros Pebble',
    },
    Weapons_Learning = {
        Main = 'Kam\'lanaut\'s Sword',
        Sub = 'Save the Queen II',
    },
    Weapons_Mag = {
        Main = 'Chatoyant Staff',
        Sub = 'Vivid Strap',
    },
    Terras_Staff = {
        Main = 'Terra\'s Staff',
        Sub = 'Vivid Strap',
        Ammo = 'Bibiki Seashell',
    },
    Buff = {
        Back = 'Grapevine Cape',
        Legs = 'Homam Cosciales', -- enhancing duration
        Feet = 'Mirage Charuqs +1', -- https://discord.com/channels/696847769444548700/855508485122555914/1276165277578428538
    },
    Stoneskin = { -- if sub whm or rdm
        Neck = 'Stone Gorget',
        Back = 'Grapevine Cape',
    },
    Sleep = {
        Neck = 'Opo-opo Necklace',
    },
    TH = {
        Head = 'Wh. Rarab Cap +1',
    },
};
profile.Sets = sets;

profile.Packer = {
};

profile.OnLoad = function()
    gSettings.AllowAddSet = true;
    utilities.Initialize();
    (function ()
        if cleave then
            AshitaCore:GetChatManager():QueueCommand(1, '/lockstyleset 56');
        else
            AshitaCore:GetChatManager():QueueCommand(1, '/lockstyleset 16');
        end
        AshitaCore:GetChatManager():QueueCommand(1, '/macro book 4');
        -- gFunc.ForceEquipSet(sets.Weapons_Default);
    end):once(3);

end

profile.OnUnload = function()
end

profile.HandleCommand = function(args)
    if args[1] == 'learning' then
        learning = not learning;
        gFunc.Echo(255,  'Learning [' .. (learning and 'ON' or 'OFF') .. ']');
    elseif args[1] == 'sird' then
        sird = not sird;
        gFunc.Echo(255,  'Sp. Int. Rate Down [' .. (sird and 'ON' or 'OFF') .. ']');
    elseif args[1] == 'cleave' then
        cleave = not cleave;
        gFunc.Echo(255,  'Cleaving [' .. (cleave and 'ON' or 'OFF') .. ']');
        (function ()
            if cleave then
                AshitaCore:GetChatManager():QueueCommand(1, '/lockstyleset 56');
            else
                AshitaCore:GetChatManager():QueueCommand(1, '/lockstyleset 16');
            end
        end):once(1);
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
        if ((player.SubJob == "THF") and (not isTargetTagged())) then
            gFunc.EquipSet(sets.TH);
        end
    elseif (player.IsMoving) then
        gFunc.EquipSet(sets.Fast);
    elseif (player.Status == 'Resting') then
        gFunc.EquipSet(sets.Rest);
    else
        gFunc.EquipSet(sets.TPGain);
        gFunc.EquipSet(sets.Idle);
        if cleave then
            gFunc.EquipSet(sets.Terras_Staff);
        else
            gFunc.EquipSet(sets.Weapons_Default); -- TODO, solve this more elegantly
        end
        -- gFunc.EquipSet(sets.Weapons_Mag);
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

local function isTargetAMob()
    local targetManager = AshitaCore:GetMemoryManager():GetTarget();
    local isSubTargetActive = targetManager:GetIsSubTargetActive();
    local targetId = targetManager:GetServerId(isSubTargetActive == 1 and 1 or 0);
    return bit.band(targetId, 0xFF000000) ~= 0;
end

profile.HandleMidcast = function()
    local spell = gData.GetAction();
    if cleave then
        gFunc.EquipSet(sets.Weapons_Mag);
    end

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
        elseif (T{'Entomb', 'Spectral Floe'}:contains(spell.Name)) then
            gFunc.EquipSet(sets.Entomb_Floe);
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
    if sird then
        gFunc.EquipSet(sets.SpIntDown);
    end
    local player = gData.GetPlayer();
    if ((player.SubJob == "THF") and (not isTargetTagged()) and isTargetAMob()) then
        gFunc.EquipSet(sets.TH);
    end
    if (T{'PDT', 'MDT', 'BDT'}:contains(utilities.OverrideSet)) and gData.GetBuffCount('Aquaveil') == 0 then
        gFunc.EquipSet(sets.SpIntDown);
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
