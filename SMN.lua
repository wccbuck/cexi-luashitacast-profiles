utilities = gFunc.LoadFile('utilities.lua');
naSpell = gFunc.LoadFile('naSpell.lua');

local profile = {};

local pupinparty = false;
local bstinparty = false;

local sets = {
    Idle = {
        -- refresh, regen, mp and -dt otherwise
        -- TODO
        Head = 'Evk. Horn +1', -- refresh
        Neck = 'Incanter\'s Torque',
        Ear1 = 'Loquac. Earring',
        Ear2 = 'Antivenom Earring',
        Body = 'Yinyang Robe',
        Hands = 'Marduk\'s Dastanas',
        Ring1 = 'Evoker\'s Ring',
        Ring2 = 'Tamas Ring',
        Back = 'Summoner\'s Cape',
        Waist = 'Mujin Obi',
        Legs = 'Goliard Trews',
        Feet = 'Summoner\'s Pgch.', -- swap for evoker's +1
    },
    Weapons_Default = {
        Main = 'Chatoyant Staff',
        Sub = 'Norn\'s Grip',
        Ammo = 'Hedgehog Bomb', -- replace with soothing sachet, arfarvegr drop (pashhow DKP)
    },
    Pet_Idle = {
        -- similar to Idle, except add avatar perpetuation cost
        Head = 'Evk. Horn +1', -- refresh
        Neck = 'Incanter\'s Torque',
        Ear1 = 'Loquac. Earring',
        Ear2 = 'Antivenom Earring',
        Body = 'Yinyang Robe',
        Hands = 'Summoner\'s Brcr.',
        Ring1 = 'Evoker\'s Ring',
        Ring2 = 'Tamas Ring',
        Back = 'Summoner\'s Cape',
        Waist = 'Mujin Obi',
        Legs = 'Goliard Trews',
        Feet = 'Summoner\'s Pgch.', -- swap for evoker's +1
    },
    Pet_TPGain = {
        -- similar to Idle, except add pet buffs (acc+ etc)
        Head = 'Evk. Horn +1', -- refresh
        Neck = 'Incanter\'s Torque',
        Ear1 = 'Loquac. Earring',
        Ear2 = 'Antivenom Earring',
        Body = 'Yinyang Robe',
        Hands = 'Summoner\'s Brcr.',
        Ring1 = 'Evoker\'s Ring',
        Ring2 = 'Tamas Ring',
        Back = 'Summoner\'s Cape',
        Waist = 'Mujin Obi',
        Legs = 'Goliard Trews',
        Feet = 'Summoner\'s Pgch.', -- swap for evoker's +1
    },
    Affinity = {
        -- if party has puppetmaster in it, use this when pet is engaged or during physical BP
        -- NOTE: as of march 2025, this earring does not work
        Ear2 = 'Affinity Earring',
    },
    Fidelity = {
        -- if party has beastmaster in it, use this when pet is engaged or during physical BP
        -- NOTE: as of march 2025, this earring does not work
        Ear2 = 'Fidelity Earring',
    },
    AffinityFidelity = {
        -- if both, use both. Otherwise we only swap earring 2.
        Ear1 = 'Affinity Earring',
        Ear2 = 'Fidelity Earring',
    },
    Carb_Mitts = {
        Hands = 'Carbuncle Mitts',
    },
    TPGain = {},
    WS_Default = {},
    Rest = {
        Main = 'Chatoyant Staff',
        Sub = 'Staff Strap',
        Ammo = 'Mana Ampulla',
        Head = 'Evk. Horn +1', -- refresh
        Neck = 'Gnole Torque',
        Ear1 = 'Antivenom Earring',
        Ear2 = 'Darkness Earring',
        Body = 'Oracle\'s Robe',
        Hands = 'Oracle\'s Gloves',
        Ring1 = 'Star Ring',
        Ring2 = 'Star Ring',
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
        Waist = 'Hierarch Belt',
        Legs = 'Yigit Seraweels',
        Feet = 'Goliard Clogs',
    },
    Fast = {
        Feet = 'Herald\'s Gaiters',
    },
    Precast = {
        Head = 'Windfall Hat',
        Ear1 = 'Loquac. Earring',
        Ear2 = 'Antivenom Earring',
        Body = 'Marduk\'s Jubbah',
        Back = 'Veela Cape',
        Feet = 'Rostrum Pumps',
    },
    Precast_Summon = {
        Hands = 'Carbuncle\'s Cuffs',
    },
    Precast_Heal = {
        Feet = 'Zenith Pumps +1', -- cure spellcasting time 
    },
    BP_Delay = {
        -- blood pact delay but also blood boon+ (relic pants aug)
        Head = 'Summoner\'s Horn',
        Body = 'Yinyang Robe',
        Hands = 'Summoner\'s Brcr.',
        Legs = 'Summoner\'s Spats', -- upgrade this to get blood boon+8
        Feet = 'Summoner\'s Pgch.',
    },
    BP_Phys = {
        -- bp damage, physical pet bonuses, smn skill
        -- this set isn't great at the moment; relic+1 augments are on the agenda
        Head = 'Marduk\'s Tiara',
        Neck = 'Incanter\'s Torque',
        Body = 'Summoner\'s Dblt.', -- swap for +1 augmented (bp dmg +4)
        Hands = 'Summoner\'s Brcr.', -- swap for +1 augmented (bp dmg +3)
        Ring1 = 'Evoker\'s Ring',
        Ring2 = 'Tamas Ring',
        Back = 'Aife\'s Mantle', -- pet attack +10
        Waist = 'Mujin Obi',
        Legs = 'Evoker\'s Spats', -- pet acc +10
        Feet = 'Summoner\'s Pgch.', -- pet attack +7. swap for +1 augmented (pet DA/crit+3%)
    },
    BP_Mag = {
        -- bp damage, pet MAB+, smn skill
        -- TODO (for now just use summoning skill set)
        -- Main = 'Conjurer\'s Crook', -- pet MAB+15
    },
    Smn_Mag_Skill = {
        -- for bp ward, summon spirits, siphon
        Head = 'Marduk\'s Tiara',
        Neck = 'Incanter\'s Torque',
        Hands = 'Summoner\'s Brcr.',
        Ring1 = 'Evoker\'s Ring',
        Ring2 = 'Tamas Ring',
        Back = 'Summoner\'s Cape',
        Waist = 'Mujin Obi',
        Legs = 'Marduk\'s Shalwar',
        Feet = 'Nashira Crackows',
    },
    Heal = {
        -- cure potency, mind
        Head = 'Goliard Chapeau',
        Neck = 'Fylgja Torque +1',
        Ear1 = 'Light Earring',
        Ear2 = 'Aqua Earring',
        Body = 'Errant Hpl.',
        Hands = 'Yigit Gages',
        Ring1 = 'Karka Ring',
        Ring2 = 'Tamas Ring',
        Back = 'Dew Silk Cape +1',
        Waist = 'Salire Belt',
        Legs = 'Errant Slops',
        Feet = 'Zenith Pumps +1',
    },
    Heal_Weapons = {
        Main = 'Tamaxchi',
        Sub = 'Genbu\'s Shield',
    },
    Stoneskin = { -- if sub whm or rdm
        Neck = 'Stone Gorget',
        Back = 'Grapevine Cape',
    },
    Cursna = {
        -- fast cast, healing magic+
        Head = 'Windfall Hat', -- fast cast
        Neck = 'Incanter\'s Torque', -- healing magic
        Ear2 = 'Loquac. Earring', -- fast cast
        Body = 'Goliard Saio', -- haste
        Back = 'Veela Cape', -- fast cast
        Waist = 'Ninurta\'s Sash', -- haste
        Legs = 'Marduk\'s Shalwar', -- healing magic
        Feet = 'Rostrum Pumps',
    },
    Enhancing = {
        Back = 'Grapevine Cape',
    },
    Stoneskin = {
        Neck = 'Stone Gorget',
    },
    PDT = {
        Back = 'Shadow Mantle',
    },
    MDT = {},
    BDT = {},
    Pet_Def = {
        -- TODO: pet defense+, pet -dt
        -- head: smn horn +1, pet damage taken -4%
        -- hands: evoker's bracers +1, pet damage taken -5%
        -- waist: beastly girdle (yasuo drop), pet damage taken -5%, augments give acc+, regen
        Legs = 'Goliard Trews', -- pet def +10
        Feet = 'Koschei Crackows', -- avatar def +5
        -- Legs = 'Enticer\'s Pants' -- pet damage taken -2%
        -- (or, smn spats +1: pet magic damage taken -4%)
    },
};
profile.Sets = sets;

profile.Packer = {
};

local buff_BPs = T{
    'Shining Ruby','Glittering Ruby','Crimson Howl','Inferno Howl','Frost Armor','Crystal Blessing','Aerial Armor','Hastega II',
    'Fleet Wind','Hastega','Earthen Ward','Earthen Armor','Rolling Thunder','Lightning Armor','Soothing Current','Ecliptic Growl',
    'Heavenward Howl','Ecliptic Howl','Noctoshield','Dream Shroud','Altana\'s Favor','Reraise','Reraise II','Reraise III','Raise',
    'Raise II','Raise III','Wind\'s Blessing'
};

local mag_BPs = T{
    'Searing Light','Meteorite','Holy Mist','Inferno','Fire II','Fire IV','Meteor Strike','Conflag Strike','Diamond Dust',
    'Blizzard II','Blizzard IV','Heavenly Strike','Aerial Blast','Aero II','Aero IV','Wind Blade','Earthen Fury','Stone II',
    'Stone IV','Geocrush','Judgement Bolt','Thunder II','Thunder IV','Thunderstorm','Thunderspark','Tidal Wave','Water II',
    'Water IV','Grand Fall','Howling Moon','Lunar Bay','Ruinous Omen','Somnolence','Nether Blast','Night Terror','Level ? Holy'
};

local heal_BPs = T{'Healing Ruby','Healing Ruby II','Whispering Wind','Spring Water'};

local enfeeb_BPs = T{
    'Diamond Storm','Sleepga','Shock Squall','Slowga','Tidal Roar','Pavor Nocturnus','Ultimate Terror','Nightmare',
    'Mewing Lullaby','Eerie Eye'
};

local function HandlePetAction(petAction)
	if (buff_BPs:contains(petAction.Name) or heal_BPs:contains(petAction.Name) or enfeeb_BPs:contains(petAction.Name)) then
        gFunc.EquipSet(sets.Smn_Mag_Skill);
	elseif (mag_BPs:contains(petAction.Name)) then
        gFunc.EquipSet(sets.Smn_Mag_Skill);
        -- gFunc.EquipSet(sets.BP_Mag);
    else
        gFunc.EquipSet(sets.BP_Phys);
        if (pupinparty) and (bstinparty) then
            gFunc.EquipSet(sets.AffinityFidelity);
        elseif pupinparty then
            gFunc.EquipSet(sets.Affinity);
        elseif bstinparty then
            gFunc.EquipSet(sets.Fidelity);
        end
    end

    -- note: petAction.Type can either be "Blood Pact: Rage" or "Blood Pact: Ward". Could maybe do something with that
end

profile.OnLoad = function()
    gSettings.AllowAddSet = true;
    utilities.Initialize();

    (function () 
        AshitaCore:GetChatManager():QueueCommand(1, '/lockstyleset 37');
        AshitaCore:GetChatManager():QueueCommand(1, '/macro book 5');
        AshitaCore:GetChatManager():QueueCommand(1, '/macro set 1');
    end):once(3);
end

profile.OnUnload = function()
end

profile.HandleCommand = function(args)
    if args[1] == 'spirit' then
        local environment = gData.GetEnvironment();
        local weatherElement = environment.WeatherElement;
        -- Add whichever spirits you don't have yet to the {"None", "Unknown"} table.
        -- e.g. {"None", "Unknown", "Thunder"}. If it's lightning day, you'll summon dark spirit instead.
        local spiritElement = "Dark";
        if (T{"None", "Unknown"}:contains(weatherElement)) then
            local dayElement = environment.DayElement;
            if (not T{"None", "Unknown"}:contains(dayElement)) then
                spiritElement = dayElement;
            end
        else
            spiritElement = weatherElement;
        end

        if spiritElement == "Wind" then spiritElement = "Air" end;

        AshitaCore:GetChatManager():QueueCommand(1, '/ma "' .. spiritElement .. ' Spirit" <me>');
    elseif args[1] == 'naspell' then
        naSpell.Cast();
    elseif args[1] == 'naspellprio' then
        -- comma-delimited list of player names
        naSpell.SetPlayerPriority(args);
    elseif args[1] == 'pupinparty' then
        pupinparty = not pupinparty;
        gFunc.Echo(255,  'Affinity Earring [' .. (pupinparty and 'ON' or 'OFF') .. ']');
    elseif args[1] == 'bstinparty' then
        bstinparty = not bstinparty;
        gFunc.Echo(255,  'Fidelity Earring [' .. (bstinparty and 'ON' or 'OFF') .. ']');
    end
    utilities.HandleCommands(args);
end

-- "hadPet" keeps track of whether you had a pet in the last handledefault pass.
-- When it flips from true to false, reset the macro sheet to the "hub" set.
local hadPet = false;

profile.HandleDefault = function()
    local petAction = gData.GetPetAction();
    if (petAction ~= nil) then
        -- pause other gear swaps while the pet is doing something
        HandlePetAction(petAction);
        return;
    end

    local player = gData.GetPlayer();
    local pet = gData.GetPet();

    if (pet ~= nil) then
        hadPet = true;
    elseif (hadPet) then
        AshitaCore:GetChatManager():QueueCommand(1, '/macro set 1');
        hadPet = false;
    end

    if (player.Status == 'Engaged') then
        gFunc.EquipSet(sets.TPGain);
        -- if all three weapon slots are empty during combat,
        -- equip the default weapon set (useful against merrows)
        utilities.ResetDefaultWeapons(sets.Weapons_Default);
    elseif (player.Status == 'Resting') then
        gFunc.EquipSet(sets.Rest);
    elseif (player.IsMoving) then
		gFunc.EquipSet(sets.Fast);        
    elseif (pet ~= nil) then
        gFunc.EquipSet(sets.Pet_Idle);
        if (pet.Status == 'Engaged') then
            gFunc.EquipSet(sets.Pet_TPGain);
            if (pupinparty) and (bstinparty) then
                gFunc.EquipSet(sets.AffinityFidelity);
            elseif pupinparty then
                gFunc.EquipSet(sets.Affinity);
            elseif bstinparty then
                gFunc.EquipSet(sets.Fidelity);
            end
        end
        if (pet.Name == 'Carbuncle') then
            gFunc.EquipSet(sets.Carb_Mitts);
        end
    else
        gFunc.EquipSet(sets.Idle);
        gFunc.EquipSet(sets.Weapons_Default);
    end

    if (T{'PDT', 'MDT', 'BDT'}:contains(utilities.OverrideSet)) then
        -- damage-taken sets take precedence over everything (except pet actions)
        gFunc.EquipSet(utilities.OverrideSet);
        if (pet ~= nil) then
            -- TODO: equip pet -dt set here as well
        end
    end

    utilities.CheckDefaults();
end

profile.HandleAbility = function()
    local ability = gData.GetAction();
    if (ability.Name == 'Elemental Siphon') then
        gFunc.EquipSet(sets.Smn_Mag_Skill);
    else
        gFunc.EquipSet(sets.BP_Delay);
    end
    utilities.CheckCancels();
end

profile.HandleItem = function()
end

profile.HandlePrecast = function()
    local spell = gData.GetAction();
    gFunc.EquipSet(sets.Precast);
    if (spell.Skill == 'Healing Magic') then
        gFunc.EquipSet(sets.Precast_Heal);
    elseif (spell.Skill == 'Summoning Magic') then
        gFunc.EquipSet(sets.Precast_Summon);
    end
    utilities.CheckCancels();
end

profile.HandleMidcast = function()
    local spell = gData.GetAction();
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
    end
end

profile.HandlePreshot = function()
end

profile.HandleMidshot = function()
end

profile.HandleWeaponskill = function()
    gFunc.EquipSet(sets.WS_Default);
end

return profile;