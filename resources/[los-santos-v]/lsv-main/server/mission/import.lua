local _players = { }

RegisterNetEvent('lsv:vehicleImportFinished')
AddEventHandler('lsv:vehicleImportFinished', function(vehicle)
	local player = source
	if not _players[player] or table.length(PlayerData.GetVehicles(player)) >= PlayerData.GetGaragesCapacity(player) then
		return
	end

	PlayerData.AddVehicle(player, vehicle)
	_players[player] = nil

	TriggerClientEvent('lsv:vehicleImportFinished', player, true, '')
end)

RegisterNetEvent('lsv:purchaseVehicleImport')
AddEventHandler('lsv:purchaseVehicleImport', function(tierIndex, isBike)
	local player = source
	if MissionManager.IsPlayerOnMission(player) then
		return
	end

	local price = Settings.vehicleImport.tiers[tierIndex].price
	if PlayerData.GetCash(player) >= price then
		PlayerData.UpdateCash(player, -price)

		local vehicle = { }
		vehicle.tierIndex = tierIndex
		local vehicleData = nil

		local models = Settings.vehicleImport.tiers[tierIndex].models
		if isBike then
			models = table.filter(models, function(data)
				return data.isBike
			end)
		end

		vehicleData, vehicle.model = table.random(models)
		vehicle.name = vehicleData.name
		vehicle.location = table.random(Settings.vehicleImport.locations)
		vehicle.plate = table.random(Settings.vehicleImport.plates)

		_players[player] = vehicle

		TriggerClientEvent('lsv:vehicleImportPurchased', player, vehicle, isBike)
	else
		TriggerClientEvent('lsv:vehicleImportPurchased', player, nil)
	end
end)

AddSignalHandler('lsv:playerDropped', function(player)
	_players[player] = nil
end)
