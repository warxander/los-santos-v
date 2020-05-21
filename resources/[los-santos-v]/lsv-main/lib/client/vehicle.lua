Vehicle = { }
Vehicle.__index = Vehicle

function Vehicle.ApplyMods(vehicle, vehicleMods)
	SetVehicleModKit(vehicle, 0)

	table.foreach(vehicleMods.mods, function(modIndex, modType)
		SetVehicleMod(vehicle, tonumber(modType), modIndex)
	end)

	SetVehicleCustomPrimaryColour(vehicle, Color.UnpackRgb(vehicleMods.colors.primary))
	SetVehicleCustomSecondaryColour(vehicle, Color.UnpackRgb(vehicleMods.colors.secondary))

	SetVehicleTyreSmokeColor(vehicle, Color.UnpackRgb(vehicleMods.colors.tyreSmoke))

	if vehicleMods.plate then
		SetVehicleNumberPlateText(vehicle, vehicleMods.plate)
	end

	if vehicleMods.neons then
		for neonIndex = 0, 3 do
			SetVehicleNeonLightEnabled(vehicle, neonIndex, true)
		end
		SetVehicleNeonLightsColour(vehicle, Color.UnpackRgb(vehicleMods.colors.neon))
	end
end
