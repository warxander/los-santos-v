RegisterNetEvent('lsv:rerollVehicleColors')
AddEventHandler('lsv:rerollVehicleColors', function(vehicleIndex)
	local player = source
	if not PlayerData.IsExists(player) or vehicleIndex > table.length(PlayerData.GetVehicles(player)) then
		return
	end

	local vehicle = PlayerData.GetVehicle(player, vehicleIndex)
	local rerollColorsCount = vehicle.rerollColorsCount or 0
	local rerollPrice = Settings.personalVehicle.rerollColorsPrice.base + (rerollColorsCount * Settings.personalVehicle.rerollColorsPrice.perRoll)

	if PlayerData.GetCash(player) >= rerollPrice then
		PlayerData.UpdateCash(player, -rerollPrice)

		vehicle.colors.primary = Color.GetRandomRgb()
		vehicle.colors.secondary = Color.GetRandomRgb()
		vehicle.colors.tyreSmoke = Color.GetRandomRgb()

		rerollColorsCount = rerollColorsCount + 1
		vehicle.rerollColorsCount = rerollColorsCount

		PlayerData.ReplaceVehicle(player, vehicleIndex, vehicle)
		TriggerClientEvent('lsv:vehicleCustomized', player, vehicleIndex)
	else
		TriggerClientEvent('lsv:vehicleCustomized', player, nil)
	end
end)

RegisterNetEvent('lsv:customizeVehicle')
AddEventHandler('lsv:customizeVehicle', function(vehicleIndex, vehicleMods)
	local player = source
	if not PlayerData.IsExists(player) or vehicleIndex > table.length(PlayerData.GetVehicles(player)) then
		return
	end

	local price = table.length(vehicleMods) * Settings.personalVehicle.customizePricePerMod
	if PlayerData.GetCash(player) >= price then
		PlayerData.UpdateCash(player, -price)

		local vehicle = PlayerData.GetVehicle(player, vehicleIndex)

		table.foreach(vehicleMods, function(modIndex, modType)
			vehicle.mods[modType] = modIndex ~= -1 and modIndex or nil
		end)

		PlayerData.ReplaceVehicle(player, vehicleIndex, vehicle)
		TriggerClientEvent('lsv:vehicleCustomized', player, vehicleIndex)
	else
		TriggerClientEvent('lsv:vehicleCustomized', player, nil)
	end
end)

RegisterNetEvent('lsv:rentVehicle')
AddEventHandler('lsv:rentVehicle', function(vehicleIndex, vehicleTier)
	local player = source
	if not PlayerData.IsExists(player) or vehicleIndex > table.length(PlayerData.GetVehicles(player)) then
		return
	end

	local rentPrice = Settings.personalVehicle.rentPrice[vehicleTier]

	local patreonTier = PlayerData.GetPatreonTier(player)
	if patreonTier ~= 0 then
		rentPrice = math.floor(rentPrice * Settings.patreon.rent[patreonTier])
	end

	if PlayerData.GetCash(player) >= rentPrice then
		PlayerData.UpdateCash(player, -rentPrice)
		TriggerClientEvent('lsv:vehicleRented', player, vehicleIndex)
	else
		TriggerClientEvent('lsv:vehicleRented', player, nil)
	end
end)
