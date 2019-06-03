local logger = Logger:CreateNamedLogger('VehicleShop')


RegisterNetEvent('lsv:purchaseVehicle')
AddEventHandler('lsv:purchaseVehicle', function(model, vehicleCategory)
	local player = source

	if not Scoreboard.IsPlayerOnline(player) then return end

	local vehiclePrice = Settings.personalVehicle.vehicles[vehicleCategory][model].cash
	if Scoreboard.GetPlayerCash(player) >= vehiclePrice then
		local vehicle = {
			model = model,
			name = Settings.personalVehicle.vehicles[vehicleCategory][model].name,
			color = { primary = 0, secondary = 0 },
		}

		Db.SetValue(player, 'Vehicle', Db.ToString(json.encode(vehicle)), function()
			logger:Info('Purchase { '..player..', '..model..', '..vehiclePrice..' }')
			Db.UpdateCash(player, -vehiclePrice)
			TriggerClientEvent('lsv:vehiclePurchased', player, vehicle)
		end)
	else TriggerClientEvent('lsv:vehiclePurchased', player, nil) end
end)


RegisterNetEvent('lsv:sellVehicle')
AddEventHandler('lsv:sellVehicle', function(model)
	local player = source

	if not Scoreboard.IsPlayerOnline(player) then return end

	for _, vehicles in pairs(Settings.personalVehicle.vehicles) do
		for vehicleModel, vehicleData in pairs(vehicles) do
			if vehicleModel == model then
				local cash = math.floor(vehicleData.cash * Settings.personalVehicle.sellRate)
				Db.UpdateCash(player, cash)
				Db.SetValue(player, 'Vehicle', Db.ToString('NULL'), function()
					logger:Info('Sold { '..player..', '..model..', '..cash..' }')
					TriggerClientEvent('lsv:vehicleSold', player, vehicleData.name)
				end)
				return
			end
		end
	end
end)


RegisterNetEvent('lsv:repairVehicle')
AddEventHandler('lsv:repairVehicle', function(vehicleHealthToRepair)
	local player = source

	if not Scoreboard.IsPlayerOnline(player) then return end

	local vehicleRepairPrice = vehicleHealthToRepair * Settings.personalVehicle.repairCashPerCent
	if Scoreboard.GetPlayerCash(player) >= vehicleRepairPrice then
		Db.UpdateCash(player, -vehicleRepairPrice, function()
			logger:Info('Repair { '..player..', '..vehicleRepairPrice..' }')
			TriggerClientEvent('lsv:vehicleRepaired', player, true)
		end)
	else TriggerClientEvent('lsv:vehicleRepaired', player, nil) end
end)