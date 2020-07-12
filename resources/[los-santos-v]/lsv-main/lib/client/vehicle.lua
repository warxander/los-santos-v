Vehicle = { }
Vehicle.__index = Vehicle

local function tryApplyToggableMod(vehicle, vehicleMods, modType)
	if vehicleMods.mods[tostring(modType)] == 1 then
		ToggleVehicleMod(vehicle, modType, true)
		return true
	end

	return false
end

local function getRandomToggableMod(vehicleMods, modType)
	if GetRandomIntInRange(0, 2) ~= 0 then
		vehicleMods.mods[tostring(modType)] = 1
		return true
	end

	return false
end

function Vehicle.GenerateRandomMods(vehicle, model, isBike, isMaxedOut)
	SetVehicleModKit(vehicle, 0)

	local vehicleMods = { }
	vehicleMods.model = model

	vehicleMods.mods = { }
	for modType = 0, 49 do
		if modType ~= 16 then
			local modNum = GetNumVehicleMods(vehicle, modType)
			if modNum ~= 0 then
				local modIndex = GetRandomIntInRange(0, modNum)
				vehicleMods.mods[tostring(modType)] = modIndex
			end
		end
	end

	vehicleMods.mods['10'] = nil -- Weapons?

	if isBike then
		local wheelType = vehicleMods.mods['23'] or vehicleMods.mods['24'] -- Front or Back Wheels
		if wheelType then
			vehicleMods.mods['23'] = wheelType
			vehicleMods.mods['24'] = wheelType
		end
	end

	vehicleMods.colors = { }
	vehicleMods.colors.primary = Color.GetRandomRgb()
	vehicleMods.colors.secondary = Color.GetRandomRgb()

	if GetRandomIntInRange(0, 2) ~= 0 then
		vehicleMods.neons = true
		vehicleMods.colors.neon = Color.GetRandomRgb()
	end

	if getRandomToggableMod(vehicleMods, 20) then -- Tyre Smoke
		vehicleMods.colors.tyreSmoke = Color.GetRandomRgb()
	end

	getRandomToggableMod(vehicleMods, 18) -- Turbo
	getRandomToggableMod(vehicleMods, 22) -- Xenon Headlights

	if isMaxedOut then
		table.iforeach({ 11, 12, 13 }, function(modType)
			local modNum = GetNumVehicleMods(vehicle, modType)
			if modNum ~= 0 then
				vehicleMods.mods[tostring(modType)] = modNum - 1
			end
		end)

		vehicleMods.mods['18'] = 1
	end

	return vehicleMods
end

function Vehicle.ApplyMods(vehicle, vehicleMods)
	SetVehicleModKit(vehicle, 0)

	table.foreach(vehicleMods.mods, function(modIndex, modType)
		SetVehicleMod(vehicle, tonumber(modType), modIndex)
	end)

	SetVehicleCustomPrimaryColour(vehicle, Color.UnpackRgb(vehicleMods.colors.primary))
	SetVehicleCustomSecondaryColour(vehicle, Color.UnpackRgb(vehicleMods.colors.secondary))

	if vehicleMods.plate then
		SetVehicleNumberPlateText(vehicle, vehicleMods.plate)
	end

	if vehicleMods.neons then
		for neonIndex = 0, 3 do
			SetVehicleNeonLightEnabled(vehicle, neonIndex, true)
		end
		SetVehicleNeonLightsColour(vehicle, Color.UnpackRgb(vehicleMods.colors.neon))
	end

	if tryApplyToggableMod(vehicle, vehicleMods, 20) then -- Tyre Smoke
		SetVehicleTyreSmokeColor(vehicle, Color.UnpackRgb(vehicleMods.colors.tyreSmoke))
	end

	tryApplyToggableMod(vehicle, vehicleMods, 18) -- Turbo
	tryApplyToggableMod(vehicle, vehicleMods, 22) -- Xenon Headlights
end

function Vehicle.GetTier(vehicleModel)
	for _, tierData in ipairs(Settings.vehicleImport.tiers) do
		for model, modelData in pairs(tierData.models) do
			if model == vehicleModel then
				return tierData.name
			end
		end
	end

	return nil
end
