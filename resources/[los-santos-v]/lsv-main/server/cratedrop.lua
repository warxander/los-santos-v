local logger = Logger:CreateNamedLogger('CrateDrop')

local crateDropData = nil


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(Settings.crateDropSettings.timeout)

		if not crateDropData and Scoreboard.GetPlayersCount() > 1 then
			crateDropData = { }
			crateDropData.positionIndex = math.random(Utils.GetTableLength(Settings.crateDropSettings.positions))
			crateDropData.weaponIndex = math.random(Utils.GetTableLength(Settings.crateDropSettings.weapons))

			logger:Info('Spawn { '..tostring(crateDropData.positionIndex)..', '..tostring(crateDropData.weaponIndex)..' }')

			TriggerClientEvent('lsv:spawnCrate', -1, crateDropData.positionIndex, crateDropData.weaponIndex)
		end
	end
end)


RegisterServerEvent('lsv:cratePickedUp')
AddEventHandler('lsv:cratePickedUp', function()
	local player = source

	if not crateDropData then return end

	logger:Info('Picked up by player { '..player..' }')

	Db.UpdateMoney(player, Settings.crateDropSettings.money, function()
		crateDropData = nil
		TriggerClientEvent('lsv:removeCrate', -1, player, Settings.crateDropSettings.weaponClipCount, Settings.crateDropSettings.money)
	end)
end)


AddEventHandler('lsv:playerConnected', function(player)
	if not crateDropData then return end

	logger:Info('Spawn for player { '..player..' }')

	TriggerClientEvent('lsv:spawnCrate', player, crateDropData.positionIndex, crateDropData.weaponIndex)
end)


AddEventHandler('lsv:playerDropped', function(player)
	if Scoreboard.GetPlayersCount() ~= 0 then return end

	logger:Info('Remove ')

	crateDropData = nil
end)