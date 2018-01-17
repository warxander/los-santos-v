local positions = {
	{ ['x'] = 699.15850830078, ['y'] = -1594.9453125, ['z'] = 9.6801643371582 },
	{ ['x'] = 1436.9431152344, ['y'] = -2148.8503417969, ['z'] = 60.606800079346 },
	{ ['x'] = 977.98474121094, ['y'] = -3007.1948242188, ['z'] = 5.9007620811462 },
	{ ['x'] = 519.29821777344, ['y'] = -2980.8610839844, ['z'] = 6.0444560050964 },
	{ ['x'] = -1594.0063476563, ['y'] = -1025.740234375, ['z'] = 13.018488883972 },
	{ ['x'] = -3205.9792480469, ['y'] = 824.37823486328, ['z'] = 3.6351618766785 },
	{ ['x'] = -987.26776123047, ['y'] = 925.21795654297, ['z'] = 188.12802124023 },
	{ ['x'] = -323.3994140625, ['y'] = 1372.9141845703, ['z'] = 347.55932617188 },
	{ ['x'] = 738.34020996094, ['y'] = 1289.2221679688, ['z'] = 360.29647827148 },
	{ ['x'] = 1136.3858642578, ['y'] = 57.870365142822, ['z'] = 80.756072998047 },
	{ ['x'] = 1376.275390625, ['y'] = -740.32513427734, ['z'] = 67.232810974121 },
	{ ['x'] = 1975.4736328125, ['y'] = 501.99038696289, ['z'] = 161.87936401367 },
	{ ['x'] = 1461.1328125, ['y'] = 1111.3707275391, ['z'] = 114.33401489258 },
	{ ['x'] = 2282.044921875, ['y'] = 1530.5583496094, ['z'] = 65.374633789063 },
	{ ['x'] = 972.55712890625, ['y'] = 2366.0798339844, ['z'] = 52.216976165771 },
	{ ['x'] = 1456.7526855469, ['y'] = 2916.7160644531, ['z'] = 46.06986618042 },
	{ ['x'] = 1313.4600830078, ['y'] = 4332.83984375, ['z'] = 38.35871887207 },
	{ ['x'] = -1719.1187744141, ['y'] = 5044.27734375, ['z'] = 28.715219497681 },
	{ ['x'] = -2458.7272949219, ['y'] = 4203.5561523438, ['z'] = 3.6592676639557 },
	{ ['x'] = -2095.2294921875, ['y'] = 2519.5354003906, ['z'] = 0.95100903511047 },
}

local position = nil
local players = { }


RegisterServerEvent('lsv:cratePickedUp')
AddEventHandler('lsv:cratePickedUp', function()
	Citizen.Trace('>>> cratePickedUp: { '..tostring(source)..' }\n')

	position = nil
	TriggerClientEvent('lsv:removeCrate', -1, source)
	TriggerEvent('lsv:createCrateDrop')
end)


AddEventHandler('lsv:createCrateDrop', function()
	SetTimeout(Settings.crateDropEventTimeout, function()
		if Utils.GetTableLength(players) > 1 and not position then
			Citizen.Trace('>>> createCrateDrop\n')
			position = positions[math.random(Utils.GetTableLength(positions))]
			TriggerClientEvent('lsv:spawnCrate', -1, position)
		end
	end)
end)


AddEventHandler('lsv:crateDropOnPlayerConnected', function(player)
	table.insert(players, player)

	if position then
		Citizen.Trace('>>> spawnCrateDrop: { '..tostring(player)..' }\n')
		TriggerClientEvent('lsv:spawnCrate', player, position)
	elseif Utils.GetTableLength(players) > 1 then
		TriggerEvent('lsv:createCrateDrop')
	end
end)


AddEventHandler('lsv:crateDropOnPlayerDropped', function(player)
	table.remove(players, Utils.Index(players, player))

	if Utils.GetTableLength(players) == 0 then
		Citizen.Trace('>>> removeCrateDrop\n')
		position = nil
	end
end)