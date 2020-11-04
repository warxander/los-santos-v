local _players = { }

RegisterNetEvent('lsv:finishVehicleImport')
AddEventHandler('lsv:finishVehicleImport', function(vehicle)
	local player = source
	if not _players[player] or table.length(PlayerData.GetVehicles(player)) >= PlayerData.GetGaragesCapacity(player) then
		return
	end

	PlayerData.AddVehicle(player, vehicle)
	_players[player] = nil

	TriggerClientEvent('lsv:finishVehicleImport', player, true, '')
end)

RegisterNetEvent('lsv:purchaseVehicleImport')
AddEventHandler('lsv:purchaseVehicleImport', function(tierIndex, model)
	local player = source
	if MissionManager.IsPlayerOnMission(player) then
		return
	end

	local vehicleData = Settings.vehicleImport.tiers[tierIndex].models[model]
	if vehicleData.prestige and PlayerData.GetPrestige(player) < vehicleData.prestige then
		return
	end

	local price = Settings.vehicleImport.tiers[tierIndex].price

	if PlayerData.GetCash(player) >= price then
		PlayerData.UpdateCash(player, -price)

		local vehicle = { }

		vehicle.tierIndex = tierIndex
		vehicle.model = model
		vehicle.isBike = vehicleData.isBike
		vehicle.name =  vehicleData.name

		vehicle.isMaxedOut = Settings.vehicleImport.tiers[tierIndex].isMaxedOut
		vehicle.location = table.random(Settings.vehicleImport.locations)
		vehicle.plate = table.random(Settings.vehicleImport.plates)

		_players[player] = vehicle

		TriggerClientEvent('lsv:vehicleImportPurchased', player, vehicle)
	else
		TriggerClientEvent('lsv:vehicleImportPurchased', player, nil)
	end
end)

AddEventHandler('lsv:playerConnected', function(player)
	local vehiclesToRemove = { }

	table.iforeach(PlayerData.GetVehicles(player), function(vehicle, index)
		for model, cash in pairs(Settings.vehicleImport.removedVehicles) do
			if vehicle.model == model then
				table.insert(vehiclesToRemove, { index = index, cash = cash })
				break
			end
		end
	end)

	for i = #vehiclesToRemove, 1, -1 do
		local data = vehiclesToRemove[i]
		PlayerData.RemoveVehicle(player, data.index)
		PlayerData.UpdateCash(player, data.cash)
	end
end)

AddEventHandler('lsv:playerDropped', function(player)
	_players[player] = nil
end)
