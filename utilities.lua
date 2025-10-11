local utilities = T{};

-- Many of these are adapted from GetAwayCoxn's 'gcinclude.lua' here:
-- https://github.com/GetAwayCoxn/Luashitacast-Profiles/blob/main/config/addons/luashitacast/common/gcinclude.lua


utilities.LockingRings = T{'Echad Ring','Warp Ring','Venture Ring','Ecphoria Ring','Empress Band','Dim. Ring (Dem)','Dim. Ring (Mea)','Dim. Ring (Holla)'};
utilities.Towns = T{'Tavnazian Safehold','Al Zahbi','Aht Urhgan Whitegate','Nashmau','Southern San d\'Oria [S]','Bastok Markets [S]','Windurst Waters [S]','San d\'Oria-Jeuno Airship','Bastok-Jeuno Airship','Windurst-Jeuno Airship','Kazham-Jeuno Airship','Southern San d\'Oria','Northern San d\'Oria','Port San d\'Oria','Chateau d\'Oraguille','Bastok Mines','Bastok Markets','Port Bastok','Metalworks','Windurst Waters','Windurst Walls','Port Windurst','Windurst Woods','Heavens Tower','Ru\'Lude Gardens','Upper Jeuno','Lower Jeuno','Port Jeuno','Rabao','Selbina','Mhaura','Kazham','Norg','Mog Garden','Celennia Memorial Library','Western Adoulin','Eastern Adoulin'};
utilities.OverrideSet = 'NONE';
utilities.OverrideSetOptions = {'NONE', 'PDT', 'MDT', 'BDT', 'IDLE', 'SHOWOFF'};
utilities.TargetEva = 'default'; -- 'default', 'high', or 'low'

utilities.AliasList = T{'warpring','sproutberet','echadring','empressband','reraise','pdt','mdt','bdt','idle','showoff','acc','randmount'};

-- Add all of the above aliases to the bottom of your catseyexi-client/Ashita/scripts/default.txt file like so:
--      /alias /warpring /lac fwd warpring
--      /alias /sproutberet /lac fwd sproutberet
-- etc.
-- If you'd rather not do that, or are for whatever reason unable to, uncomment the "SetAlias" function below
-- and the line where that function is called in utilities.Initialize().

-- function utilities.SetAlias()
-- 	for _, v in ipairs(utilities.AliasList) do
-- 		AshitaCore:GetChatManager():QueueCommand(-1, '/alias /' .. v .. ' /lac fwd ' .. v);
-- 	end
-- end

-- function utilities.ClearAlias()
-- 	for _, v in ipairs(utilities.AliasList) do
-- 		AshitaCore:GetChatManager():QueueCommand(-1, '/alias del /' .. v);
-- 	end
-- end

function utilities.Initialize()
	-- utilities.SetAlias:once(2);
	math.randomseed(os.time())
end

function unequipSlot(slot)
    AshitaCore:GetChatManager():QueueCommand(1, '/equip ' .. string.lower(slot));
end

function useEquippedItem(slot, itemName)
	AshitaCore:GetChatManager():QueueCommand(1, '/item "' .. itemName .. '" <me>');
	(function() unequipSlot(slot) end):once(8);
end

function equipAndUseItem(slot, itemName, delay)
	-- gFunc.Equip(slot, itemName); -- doesn't seem to work
	AshitaCore:GetChatManager():QueueCommand(1, '/equip ' .. string.lower(slot) .. ' "'.. itemName ..'"');
	(function() useEquippedItem(slot, itemName) end):once(delay);
end

function utilities.HandleCommands(args)
	if not utilities.AliasList:contains(args[1]) then return end

	local player = gData.GetPlayer();
    if args[1] == 'warpring' then
		equipAndUseItem('Ring2', 'Warp Ring', 11);
    elseif args[1] == 'sproutberet' then
		equipAndUseItem('Head', 'Sprout Beret', 8);
    elseif args[1] == 'echadring' then
		equipAndUseItem('Ring2', 'Echad Ring', 8);
    elseif args[1] == 'empressband' then
        equipAndUseItem('Ring2', 'Empress Band', 8);
	-- elseif args[1] == 'reraise' then
    --     equipAndUseItem('Head', 'Wh. Rarab Cap +1', 33); -- further testing required
    elseif T{'pdt', 'mdt', 'bdt', 'idle', 'showoff'}:contains(args[1]) then
		local set = string.upper(args[1]);
		local isOverride = utilities.OverrideSet == set;
        gFunc.Echo(255, set ..' [' .. (isOverride and 'OFF' or 'ON') .. ']');
        utilities.OverrideSet = (isOverride and 'NONE' or set);
	elseif args[1] == 'acc' then
		if #args == 1 then
			utilities.TargetEva = 'default'
			gFunc.Echo(255, 'Accuracy [DEFAULT]');
		elseif T{'down', 'low', 'd', 'l'}:contains(string.lower(args[2])) then
			utilities.TargetEva = 'low'
			gFunc.Echo(255, 'Accuracy [LOW]');
		elseif T{'high', 'up', 'h', 'u'}:contains(string.lower(args[2])) then
			utilities.TargetEva = 'high'
			gFunc.Echo(255, 'Accuracy [HIGH]');
		else
			utilities.TargetEva = 'default'
			gFunc.Echo(255, 'Accuracy [DEFAULT]');
		end
	elseif args[1] == 'randmount' then
		local mounted = gData.GetBuffCount('Mounted');
		if (mounted > 0) then
			AshitaCore:GetChatManager():QueueCommand(1, '/dismount');
		else
			local mounts = {
				'Crab', 'Fenrir', 'Magic Pot', 'Tulfaire', 'Hippogryph', 'Raaz', 'Xzomit', 'Bomb',
				'Adamantoise', 'Buffalo', 'Wivre', 'Warmachine', 'Goobbue', 'Crawler', 'Spheroid',
				'Tiger', 'Beetle', 'Coeurl', 'Dhalmel', 'Doll', 'Golden Bomb'
			};
			local mount = mounts[math.random(#mounts)]
			AshitaCore:GetChatManager():QueueCommand(1, '/mount "'..mount..'"');
		end
    end
end

function utilities.CancelShadows(spell)
    -- improved on GetAwayCoxn's "DoShadows" which was loosely based on
    -- zach2good's "cancel_shadows"
    -- https://github.com/zach2good/AshitaAddons/blob/main/autonin/autonin.lua#L168
    local buffIds = {66, 444, 445, 446};
    local delay = nil

    if spell.Name == 'Utsusemi: Ichi' then
        delay = 1.0
    elseif spell.Name == 'Utsusemi: Ni' then
        delay = 0.1
    end

	if delay ~= nil then
        for _, buffId in ipairs(buffIds) do
            if gData.GetBuffCount(buffId) == 1 then
                (function() AshitaCore:GetChatManager():QueueCommand(-1, '/cancel ' .. buffId) end):once(delay)
                break
            end
        end
	end
end

function utilities.CheckCancels()
    -- Requirement: 'debuff' addon. /addon load debuff
	local action = gData.GetAction();
	local sneak = gData.GetBuffCount('Sneak');
	local stoneskin = gData.GetBuffCount('Stoneskin');
	local aquaveil = gData.GetBuffCount('Aquaveil');
	local target = gData.GetActionTarget();
	local me = AshitaCore:GetMemoryManager():GetParty():GetMemberName(0);

	if (action.Name == 'Spectral Jig' and sneak > 0) then
		gFunc.CancelAction();
		AshitaCore:GetChatManager():QueueCommand(1, '/cancel Sneak');
		(function() AshitaCore:GetChatManager():QueueCommand(1, '/ja "Spectral Jig" <me>') end):once(2);
	elseif (action.Name == 'Sneak' and sneak > 0 and target.Name == me) then
		(function() AshitaCore:GetChatManager():QueueCommand(1, '/cancel Sneak') end):once(0.5);
	elseif ((action.Name == 'Stoneskin' or action.Name == 'Diamondhide') and stoneskin > 0) then
		(function() AshitaCore:GetChatManager():QueueCommand(1, '/cancel Stoneskin') end):once(0.5);
	elseif ((action.Name == 'Aquaveil' or action.Name == 'Carcharian Verve') and aquaveil > 0) then
		(function() AshitaCore:GetChatManager():QueueCommand(1, '/cancel Aquaveil') end):once(0.5);
    else
        utilities.CancelShadows(action);
	end
end

function utilities.CheckDefaults()
	local eqp = gData.GetEquipment();
	if (eqp.Ring1 ~= nil) and (utilities.LockingRings:contains(eqp.Ring1.Name)) then
		gFunc.Equip('Ring1', eqp.Ring1.Name);
	end
	if (eqp.Ring2 ~= nil) and (utilities.LockingRings:contains(eqp.Ring2.Name)) then
		gFunc.Equip('Ring2', eqp.Ring2.Name);
	end
    if (eqp.Head ~= nil) and (eqp.Head.Name == 'Sprout Beret') then
		gFunc.Equip('Head', eqp.Head.Name);
	end
end

function utilities.ResetDefaultWeapons(weaponset)
    -- This function is intended to re-equip your weapons.
    -- Useful after a merrow removes them with Torrent.
    if (weaponset == nil) then return end

    local eqp = gData.GetEquipment();

    local function allNil(obj, keys)
        for _, key in ipairs(keys) do
            if obj[key] ~= nil then
                return false
            end
        end
        return true
    end

    if allNil(eqp, {"Main", "Sub", "Range"}) then
        gFunc.EquipSet(weaponset);
    end

end

function utilities.DelayExec(commands)
	-- Thorny on the ashita discord helped me put this together.
	-- use this function like so:
	-- utilities.DelayExec:bind1({
	-- 	{ Command='/echo "Line 1"', Delay=0 },
	-- 	{ Command='/echo "Line 2"', Delay=2 },
	-- 	{ Command='/jump', Delay=2 },
	-- }):oncef(1);

    for _,entry in pairs(commands) do
        coroutine.sleep(entry.Delay);
        AshitaCore:GetChatManager():QueueCommand(1, entry.Command);
    end
end

local greenPhrases = {
	"Treasure Hunter effectiveness",
	"Something is interrupting ventures at",
	"Something really dangerous has appeared",
	"have caused a Rift to appear",
	"Champions of unity, assemble",
	"The Summit Smelter has landed in",
	"Enemy forces are headed towards",
	"Who will stand against this darkness",
};

local redPhrases = {
	"uses Invincible",
	"uses Perfect Dodge",
	"Gates of Hades",
	"casting Meteor"
};

ashita.events.register('text_in', 'text_in_highlight_cb', function (e)
    -- this text_in callback makes certain incoming messages much more noticeable.
	-- By the way, string.match does not use full regex, so we can't use `|` (or)
	-- to simplify this.
	if (not e.injected) then
		for _, phrase in ipairs(greenPhrases) do
			if e.message:match(phrase) then
				-- green text
				gFunc.Echo(2, e.message);
				break
			end
		end
		-- these don't seem to work with simplelog, find a way to sidestep
		-- or just capture simplelog's messages
		for _, phrase in ipairs(redPhrases) do
			if e.message:match(phrase) then
				-- red text
				gFunc.Echo(5, e.message);
				break
			end
		end
	end
end);

return utilities;
