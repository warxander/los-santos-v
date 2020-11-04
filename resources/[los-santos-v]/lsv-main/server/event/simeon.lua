local logger = Logger.New('Simeon')

local _simeonData = nil

local function finishEvent()
	local winners = nil

	if #_simeonData.players ~= 0 then
		winners = { }

		table.iforeach(_simeonData.players, function(playerData, index)
			if index < 4 then
				logger:info('Winner { '..playerData.id..', '..index..' }')
				table.insert(winners, playerData.id)
				PlayerData.UpdateEventsWon(playerData.id)
			end

			PlayerData.UpdateCash(playerData.id, #playerData.vehicles * Settings.simeon.rewards.cash)
			PlayerData.UpdateExperience(playerData.id, #playerData.vehicles * Settings.simeon.rewards.exp)
			PlayerData.GiveDrugBusinessSupply(playerData.id)
		end)
	else
		logger:info('No winners')
	end

	_simeonData = nil
	TriggerClientEvent('lsv:finishSimeonExport', -1, winners)

	EventScheduler.StopEvent()
end

local function sortPlayersByVehiclesCount(l, r)
	if not l then return false end
	if not r then return true end

	return #l.vehicles > #r.vehicles
end

RegisterNetEvent('lsv:simeonVehicleDelivered')
AddEventHandler('lsv:simeonVehicleDelivered', function(vehicleHash)
	if not _simeonData or not vehicleHash then
		return
	end

	local player = table.ifind_if(_simeonData.players, function(player)
		return player.id == source
	end)

	if player and table.ifind(player.vehicles, vehicleHash) then
		return
	end

	if not player then
		player = { id = source, vehicles = { } }
		table.insert(_simeonData.players, player)
	end

	table.insert(player.vehicles, vehicleHash)

	if #player.vehicles == Settings.simeon.vehiclesCount then
		finishEvent()
	else
		logger:info('Delivered { '..source..', '..vehicleHash..' }')

		table.sort(_simeonData.players, sortPlayersByVehiclesCount)
		TriggerClientEvent('lsv:updateSimeonExportPlayers', -1, _simeonData.players, source)
	end
end)

AddEventHandler('lsv:startSimeonExport', function()
	_simeonData = { }

	_simeonData.players = { }
	_simeonData.vehicles = table.irandom_n(Settings.simeon.vehicles, Settings.simeon.vehiclesCount)
	_simeonData.eventStartTimer = Timer.New()

	logger:info('Start { }')

	TriggerClientEvent('lsv:startSimeonExport', -1, _simeonData)

	while true do
		Citizen.Wait(0)

		if not _simeonData then
			return
		end

		if _simeonData.eventStartTimer:elapsed() >= Settings.simeon.duration then
			finishEvent()
			return
		end
	end
end)

AddEventHandler('lsv:playerConnected', function(player)
	if not _simeonData then
		return
	end

	TriggerClientEvent('lsv:startSimeonExport', player, _simeonData, _simeonData.eventStartTimer:elapsed())
end)

AddEventHandler('lsv:playerDropped', function(player)
	if not _simeonData then
		return
	end

	if PlayerData.GetCount() == 0 then
		_simeonData = nil
		EventScheduler.StopEvent()
		return
	end

	local _, playerIndex = table.ifind_if(_simeonData.players, function(playerData)
		return playerData.id == player
	end)

	if not playerIndex then
		return
	end

	table.remove(_simeonData.players, playerIndex)
	table.sort(_simeonData.players, sortPlayersByVehiclesCount)
	TriggerClientEvent('lsv:updateSimeonExportPlayers', -1, _simeonData.players)
end)
