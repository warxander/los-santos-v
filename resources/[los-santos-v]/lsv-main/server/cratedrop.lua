local logger = Logger:CreateNamedLogger('CrateDrop')

local crateDropData = nil
local eventFinishedTime = nil


Citizen.CreateThread(function()
	eventFinishedTime = GetGameTimer()

	while true do
		Citizen.Wait(Settings.crateDropSettings.timeout - Settings.crateDropSettings.notifyBeforeTimeout)

		if Scoreboard.GetPlayersCount() > 1 and not crateDropData then TriggerClientEvent('lsv:notifyAboutCrate', -1) end

		Citizen.Wait(Settings.crateDropSettings.notifyBeforeTimeout)

		local timePassedSinceLastEvent = GetGameTimer() - eventFinishedTime
		if timePassedSinceLastEvent < Settings.crateDropSettings.timeout then Citizen.Wait(Settings.crateDropSettings.timeout - timePassedSinceLastEvent) end

		if not crateDropData and Scoreboard.GetPlayersCount() > 1 then
			crateDropData = { }
			crateDropData.positionIndex = math.random(Utils.GetTableLength(Settings.crateDropSettings.positions))
			crateDropData.weaponIndex = math.random(Utils.GetTableLength(Settings.crateDropSettings.weapons))

			logger:Info('Spawn { '..crateDropData.positionIndex..', '..crateDropData.weaponIndex..' }')

			TriggerClientEvent('lsv:spawnCrate', -1, crateDropData.positionIndex, crateDropData.weaponIndex)
		end
	end
end)


RegisterServerEvent('lsv:cratePickedUp')
AddEventHandler('lsv:cratePickedUp', function()
	local player = source

	if not crateDropData then return end

	logger:Info('Picked up by player { '..player..' }')

	Db.UpdateCash(player, Settings.crateDropSettings.cash, function()
		crateDropData = nil
		eventFinishedTime = GetGameTimer()
		TriggerClientEvent('lsv:removeCrate', -1, player, Settings.crateDropSettings.weaponClipCount, Settings.crateDropSettings.cash)
	end)
end)


AddEventHandler('lsv:playerConnected', function(player)
	if not crateDropData then return end

	logger:Info('Spawn for player { '..player..' }')

	TriggerClientEvent('lsv:spawnCrate', player, crateDropData.positionIndex, crateDropData.weaponIndex)
end)


AddEventHandler('lsv:playerDropped', function(player)
	if Scoreboard.GetPlayersCount() ~= 0 then return end

	logger:Info('Remove')

	crateDropData = nil
end)