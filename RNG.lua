utilities = gFunc.LoadFile('utilities.lua');
local profile = {};
local sets = {

    Idle = {
        Head = 'Genbu\'s Kabuto',
        Neck = 'Hope Torque',
        Ear1 = 'Brutal Earring +1',
        Ear2 = 'Auster\'s Earring',
        Body = 'Kirin\'s Osode',
        Hands = 'Seiryu\'s Kote',
        Ring1 = 'Titanium Band',
        Ring2 = 'Sattva Ring',
        Back = 'Shadow Mantle',
        Waist = 'Scout\'s Belt',
        Legs = 'Blood Cuisses',
        Feet = 'Hachiryu Sune-Ate',
    },
    Weapons_Default = {
        -- Main = 'Thunder Staff',
        -- Sub = 'Claymore Grip',
        Main = 'Kriegsbeil',
        Sub = 'Archer\'s Shield',
        -- Range = 'Ajjub Bow',
        Range = 'Kennan\'s Longbow',
    },
    Ammo_Default = {
        Ammo = 'Demon Arrow', 
    },
    TPGain = {
        Head = 'Htr. Beret +1',
        Neck = 'Hope Torque',
        Ear1 = 'Brutal Earring +1',
        Ear2 = 'Auster\'s Earring',
        Body = 'Htr. Jerkin +1',
        Hands = 'Seiryu\'s Kote',
        Ring1 = 'Ydalir Ring',
        Ring2 = 'Ydalir Ring',
        Back = 'Aife\'s Mantle', -- agi+ and storeTP+
        Waist = 'Scout\'s Belt',
        Legs = 'Skadi\'s Chausses',
        Feet = 'Hachiryu Sune-Ate',
    },
    WS_Default = {
        Head = 'Maat\'s Cap',
        Neck = 'Fotia Gorget',
        Ear1 = 'Altdorf\'s Earring',
        Ear2 = 'Wilhelm\'s Earring',
        Body = 'Kirin\'s Osode',
        Hands = 'Seiryu\'s Kote',
        Ring1 = 'Blobnag Ring',
        Ring2 = 'Breeze Ring',
        Back = 'Fowler\'s Mantle +1',
        Waist = 'Scout\'s Belt',
        Legs = 'Htr. Braccae +1',
        Feet = 'Hachiryu Sune-Ate',
    },
    WS_StrAgi = {
        Ring2 = 'Garrulous Ring',
    },
    Preshot = {
        Head = 'Htr. Beret +1',
        Body = 'Scout\'s Jerkin',
    },
    Fast = {
        Feet = 'Skadi\'s Jambeaux',
    },
    Camouflage = {
        Body = 'Htr. Jerkin +1',
    },
    Scavenge = {
        Feet = 'Hunter\'s Socks',
    },
    Sharpshot = {
        Legs = 'Htr. Braccae +1',
    },
    Unlimited = {
        -- switch to this ammo when using WS when unlimited shot is active
        Ammo = 'Cmb.Cst. Arrow',
    },
    PDT = {},
    BDT = {},
    MDT = {
        Ring1 = 'Merman\'s Ring',
        Ring2 = 'Merman\'s Ring',
    },
};
profile.Sets = sets;

profile.Packer = {
};

profile.OnLoad = function()
    gSettings.AllowAddSet = true;
    utilities.Initialize();

    (function ()
        AshitaCore:GetChatManager():QueueCommand(1, '/lockstyleset 12');
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
    local player = gData.GetPlayer()
    gFunc.EquipSet(sets.Idle)
    if (player.IsMoving == true) then
       gFunc.EquipSet(sets.Fast)
    end
    if (T{'PDT', 'MDT', 'BDT'}:contains(utilities.OverrideSet)) then
        -- damage-taken sets take precedence over everything
        gFunc.EquipSet(utilities.OverrideSet)
    end
    if (gData.GetBuffCount('Unlimited Shot') > 0) then
        gFunc.EquipSet(sets.Unlimited)
    else
        gFunc.EquipSet(sets.Ammo_Default)
    end
    utilities.CheckDefaults()
end

profile.HandleAbility = function()
    local ability = gData.GetAction();
    if (T{'Scavenge', 'Camouflage', 'Sharpshot'}:contains(ability.Name)) then
        gFunc.EquipSet(sets[ability.Name]);
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
    gFunc.EquipSet(sets.Preshot);
end

profile.HandleMidshot = function()
    gFunc.EquipSet(sets.TPGain);
    if (utilities.OverrideSet == 'MDT') then
        gFunc.EquipSet(sets.MDT); -- mermans
    end
    if (gData.GetBuffCount('Unlimited Shot') > 0) then
        gFunc.EquipSet(sets.Unlimited)
    else
        gFunc.EquipSet(sets.Ammo_Default)
    end
end

profile.HandleWeaponskill = function()
    gFunc.EquipSet(sets.WS_Default);
    local ws = gData.GetAction();
    if (ws.Name == 'Empyreal Arrow') then
        gFunc.EquipSet(sets.WS_StrAgi);
    end
    -- TODO: Namas arrow set when I get Yoichi
    if (gData.GetBuffCount('Unlimited Shot') > 0) then
        gFunc.EquipSet(sets.Unlimited)
    else
        gFunc.EquipSet(sets.Ammo_Default)
    end
end

return profile;