local utilities = gFunc.LoadFile('utilities.lua')
local naSpell = gFunc.LoadFile('naSpell.lua')
local equipBrachyura = gFunc.LoadFile('brachyura.lua')

local profile = {}

local sets = {
    Idle = {
        Head  = 'Cor. Tricorne +1', -- regen+2
        Neck  = 'Cloud Hairpin', -- MDT-4
        Ear1  = 'Soil Earring',
        Ear2  = 'Soil Earring',
        Body  = 'Blood Scale Mail',
        Hands = 'Denali Wristbands',
        Ring1 = 'Defending Ring',
        Ring2 = { Name = 'Dark Ring', Augment = { [1] = 'Magic dmg. taken -5%' } },
        Back  = 'Colossus\'s Mantle', -- umbral cape
        Waist = 'Oneiros Belt',
        Legs  = 'Blood Cuisses',
        Feet  = 'Comm. Bottes +1', -- swap for blood greaves
    },
    IdleRefresh = {
        Head = 'Wivre Hairpin', -- refresh
    },
    Weapons_Default = {
        Main  = 'Trailer\'s Kukri', -- turbulence
        Sub   = 'Archer\'s Shield',
        Range = 'Martial Gun',
        Ammo  = 'Corsair Bullet',
    },
    TPGainMelee = {
        -- TODO
    },
    TPGainRanged = {
        Head  = 'Cor. Tricorne +1', -- bersail cap / optical hat also ok
        Neck  = 'Crested Torque',
        Ear1  = 'Altdorf\'s Earring',
        Ear2  = 'Wilhelm\'s Earring',
        Body  = 'Corsair\'s Frac +1',
        Hands = 'Comm. Gants +1', -- blood fng. gauntlets are better, marksman 6 r.acc 5
        Ring1 = 'Merman\'s Ring', -- racc 10 mdt-4
        Ring2 = 'Merman\'s Ring',
        Back  = 'Jaeger Mantle',
        -- Back  = 'Libeccio Mantle', -- recycle is nice when using bismuth bullets
        Waist = 'Subtle Sash', -- or commodore belt
        Legs  = 'Dusk Trousers', -- replace with skadi's chausses augmented
        Feet  = 'Cor. Bottes +1', -- replace with blood greaves, store TP 6 agi5
    },
    TPGainRanged_Low_Eva = {
        Back  = 'Aife\'s Mantle', -- if r.acc capped. Tactical mantle also an option
    },
    TPGainRanged_High_Eva = {

    },
    Preshot = {
        Head  = 'Zha\'Go\'s Barbut',
        Neck  = 'Loxo Scarf',
        Hands = 'Comm. Gants +1',
        Feet  = 'Cor. Bottes +1',
    },
    WS_Default = {
        Head  = 'Maat\'s Cap',
        -- Neck  = 'Combatant\'s Torque',
        Neck  = 'Fotia Gorget',
        Ear1  = 'Altdorf\'s Earring',
        Ear2  = 'Wilhelm\'s Earring',
        Body  = 'Corsair\'s Frac +1',
        Hands = 'Comm. Gants +1',
        Ring1 = 'Moepapa Ring',
        Ring2 = 'Garrulous Ring',
        Back  = 'Fowler\'s Mantle +1',
        Waist = 'Subtle Sash',
        Legs  = 'Hailstone Hose',
        Feet  = 'Cor. Bottes +1', -- replace with blood greaves, store TP 6 agi5
    },
    Detonator = {
        -- mostly ws_default
        -- Hands: skadi's bazubands or blood fng. gauntlets with marksman6
        -- Legs: maybe acrobats breeches slightly better? about equal to hailstone
    },
    Last_Stand = {
        Neck  = 'Loxo Scarf',
        Ring2 = 'Blobnag Ring',
    },
    Leaden_Salute = {
        -- agi, macc, mab
        -- Head = 'Blood Mask', -- AGI+6, MAcc+6, MAB+5
        Ear1  = 'Novio Earring',
        Ear2  = 'Adept\'s Earring',
        Ring2 = 'Blobnag Ring',
        Back  = 'Tjukurrpa Mantle',
    },
    Requiescat = {
        -- TODO
    },
    PhantomRoll = {
        Head = 'Comm. Tricorne +1',
        Body = 'Comm. Frac +1',
        Ring1 = 'Luzaf\'s Ring',
        -- scnm legs
        Feet = 'Comm. Bottes +1',
    },
    RandomDeal = {
        Body = 'Comm. Frac +1',
    },
    QuickDraw = {
        Head  = 'Cor. Tricorne +1',
        Neck  = 'Arctier\'s Torque', -- navarch's choker better?
        Ear1  = 'Novio Earring',
        Ear2  = 'Adept\'s Earring',
        Body  = 'Comm. Frac +1',
        Hands = 'Comm. Gants +1',
        Ring1 = 'Balrahn\'s Ring',
        Ring2 = 'Blobnag Ring',
        Back  = 'Tjukurrpa Mantle',
        Waist = 'Salire Belt',
        Legs  = 'Hailstone Hose',
        Feet  = 'Cor. Bottes +1', -- best = blood greaves with MAB+5 random aug
    },
    MatchingDay = {
        Waist = 'Hachirin-no-Obi',
    },
    MatchingWeather = {
        Waist = 'Hachirin-no-Obi',
    },
    Precast = {
        -- Head = 'Entrancing Ribbon', -- FC 1
        Neck  = 'Jeweled Collar', -- FC 3
        Ear1  = 'Loquac. Earring', -- FC 2
        -- Body = 'Apex Togi', -- FC 5
        Ring1 = { Name = 'Dark Ring', Augment = { [1] = '"Fast Cast"+1', [2] = '"Conserve MP"+3' } },
        Ring2 = 'Tamas Ring',
        Legs  = 'Blood Cuisses', -- FC 4
    },
    Cure = {
        Head  = 'Blood Mask', -- MND+6, MP+22
        Neck  = 'Gnole Torque',
        Ear1  = 'Light Earring',
        Ear2  = 'Light Earring',
        Body  = 'Blood Scale Mail',
        Hands = 'Corsair\'s Gants +1', -- MND+5. silk cuffs +1 from ventures have cure potency+2 MND+3
        Ring1 = 'Tamas Ring',
        Ring2 = 'Karka Ring',
        --Ring2 = 'Star Ring', -- could swap for karka but this has MP+20
        Back  = 'Altruistic Cape', -- MP+25 healing mag+5
        Waist = 'Salire Belt', -- MND+5 MP+25
        Legs  = 'Prince\'s Slops', -- MND+3 MP+30
        Feet  = 'Praeda Sabatons', -- MND+6
    },
    Enhancing = {
        -- TODO
        Body  = 'Blood Scale Mail',
        Ring1 = 'Tamas Ring',
        Ring2 = 'Star Ring',
        Back = 'Grapevine Cape',
        Waist = 'Salire Belt', -- MND+5 MP+25
        Legs  = 'Prince\'s Slops', -- MND+3 MP+30
    },
    Stoneskin = {
        Neck = 'Stone Gorget',
    },
    Rest = {
        Head  = 'Mirror Tiara',
        Neck  = 'Gnole Torque',
        Ear1  = 'Darkness Earring',
        Ear2  = 'Darkness Earring',
        Ring1 = 'Star Ring',
        Ring2 = 'Star Ring',
    },
    Fast = {
        Feet = 'Skadi\'s Jambeaux',
    },
    PDT = {
        -- TODO
    },
    MDT = {
        -- TODO
    },
    BDT = {},
    Showoff = {},
    Brachyura = {
        Ear1 = 'Brachyura Earring',
    },
}
profile.Sets = sets

profile.Packer = {
}

profile.OnLoad = function()
    gSettings.AllowAddSet = true
    utilities.Initialize();
    (function ()
        -- TODO pick a lockstyleset
        AshitaCore:GetChatManager():QueueCommand(1, '/lockstyleset 5')
        gFunc.ForceEquipSet(sets.Weapons_Default)
    end):once(3)
end

profile.OnUnload = function()
end

profile.HandleCommand = function(args)
    if args[1] == 'naspell' then
        naSpell.Cast()
    elseif args[1] == 'naspellprio' then
        -- comma-delimited list of player names
        naSpell.SetPlayerPriority(args)
    end
    utilities.HandleCommands(args)
end

profile.HandleDefault = function()
    local player = gData.GetPlayer()

    gFunc.EquipSet(sets.Idle)
    if (player.Status == 'Engaged') then
        gFunc.EquipSet(sets.TPGainMelee)
        -- if all three weapon slots are empty during combat,
        -- equip the default weapon set (useful against merrows)
        utilities.ResetDefaultWeapons(sets.Weapons_Default)
    elseif (player.Status == 'Resting') then
        gFunc.EquipSet(sets.Rest)
    elseif (player.IsMoving) then
        gFunc.EquipSet(sets.Fast)
    else
        if
            T{'WHM', 'RDM', 'BLM', 'SCH', 'SMN', 'BLU', 'GEO'}:contains(player.SubJob) and
            player.MPP < 100
        then
            gFunc.EquipSet(sets.IdleRefresh)
        end
        gFunc.EquipSet(sets.Weapons_Default)
    end

    if (T{'PDT', 'MDT', 'BDT'}:contains(utilities.OverrideSet)) then
        -- damage-taken sets take precedence over everything
        gFunc.EquipSet(utilities.OverrideSet)
    end

    if equipBrachyura() then
        gFunc.EquipSet(sets.Brachyura)
    end

    utilities.CheckDefaults()
end

profile.HandleAbility = function()
    local ability = gData.GetAction()

    if
        ability.Name:match(' Roll$') or
        ability.Name == 'Double Up'
    then
        gFunc.EquipSet(sets.PhantomRoll)
    elseif (ability.Name == 'Random Deal') then
        gFunc.EquipSet(sets.RandomDeal)
    elseif ability.Name:match(' Shot$') then
        gFunc.EquipSet(sets.QuickDraw)

        -- abilities have no Element field, so derive it from the name
        -- ("Fire Shot" -> "Fire", "Thunder Shot" -> "Thunder", ...)
        local element = ability.Name:match('^(%a+) Shot$')
        local environment = gData.GetEnvironment()
        local dayElement = environment.DayElement
        local weatherElement = environment.WeatherElement
        if
            not T{'None', 'Unknown'}:contains(weatherElement) and
            element == weatherElement
        then
            gFunc.EquipSet(sets.MatchingWeather)
        end

        if
            not T{'None', 'Unknown'}:contains(dayElement) and
            element == dayElement
        then
            gFunc.EquipSet(sets.MatchingDay)
        end
    end

    utilities.CheckCancels()
end

profile.HandleItem = function()
end

profile.HandlePrecast = function()
    gFunc.EquipSet(sets.Precast)
    utilities.CheckCancels()
end

profile.HandleMidcast = function()
    local spell = gData.GetAction()

    if (spell.Skill == 'Enhancing Magic') then
        gFunc.EquipSet(sets.Enhancing)
        if (spell.Name == 'Stoneskin') then
            gFunc.EquipSet(sets.Stoneskin)
        end
    elseif spell.Name:match('^Cure') then
        gFunc.EquipSet(sets.Cure)
    end
end

profile.HandlePreshot = function()
    gFunc.EquipSet(sets.Preshot)
end

profile.HandleMidshot = function()
    gFunc.EquipSet(sets.TPGainRanged)
    if utilities.TargetEva == 'low' then
        gFunc.EquipSet(sets.TPGainRanged_Low_Eva)
    elseif utilities.TargetEva == 'high' then
        gFunc.EquipSet(sets.TPGainRanged_High_Eva)
    end
end

profile.HandleWeaponskill = function()
    gFunc.EquipSet(sets.WS_Default)
    local ws = gData.GetAction()
    if (ws.Name == 'Detonator') then
        gFunc.EquipSet(sets.Detonator)
    elseif (ws.Name == 'Last Stand') then
        gFunc.EquipSet(sets.Last_Stand)
    elseif (ws.Name == 'Leaden Salute') then
        gFunc.EquipSet(sets.Leaden_Salute)
    end
end

return profile
