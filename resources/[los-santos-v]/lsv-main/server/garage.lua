RegisterNetEvent('lsv:purchaseGarage')
AddEventHandler('lsv:purchaseGarage', function(garage)
	local player = source
	if not PlayerData.IsExists(player) or PlayerData.HasGarage(player, garage) then
		return
	end

	local price = Settings.garages[garage].price
	if PlayerData.GetCash(player) >= price then
		PlayerData.UpdateCash(player, -price)
		PlayerData.UpdateGarage(player, garage)
		TriggerClientEvent('lsv:garagePurchased', player, true)
	else
		TriggerClientEvent('lsv:garagePurchased', player, nil)
	end
end)

RegisterNetEvent('lsv:renameVehicle')
AddEventHandler('lsv:renameVehicle', function(vehicleIndex, vehicle)
	local player = source
	if not PlayerData.IsExists(player) or not PlayerData.HasVehicle(player, vehicleIndex) then
		return
	end

	PlayerData.ReplaceVehicle(player, vehicleIndex, vehicle)
	TriggerClientEvent('lsv:vehicleRenamed', player, vehicle.userName)
end)
