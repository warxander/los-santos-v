local vehicle = nil
local vehicleBlip = nil
local dropOffBlip = nil
local dropOffLocationBlip = nil

AddEventHandler('lsv:startAssetRecovery', function()
	local variant = Utils.GetRandom(Settings.assetRecovery.variants)

	Streaming.RequestModel(variant.vehicle)

	local vehicleHash = GetHashKey(variant.vehicle)

	vehicle = CreateVehicle(vehicleHash, variant.vehicleLocation.x, variant.vehicleLocation.y, variant.vehicleLocation.z, variant.vehicleLocation.heading, false, true)
	SetVehicleModKit(vehicle, 0)
	SetVehicleMod(vehicle, 16, 4)

	SetModelAsNoLongerNeeded(vehicleHash)

	vehicleBlip = AddBlipForEntity(vehicle)
	SetBlipHighDetail(vehicleBlip, true)
	SetBlipSprite(vehicleBlip, Blip.PersonalVehicleCar())
	SetBlipColour(vehicleBlip, Color.BlipGreen())
	SetBlipRouteColour(vehicleBlip, Color.BlipGreen())
	SetBlipAlpha(vehicleBlip, 0)
	Map.SetBlipText(vehicleBlip, 'Vehicle')

	dropOffBlip = AddBlipForCoord(variant.dropOffLocation.x, variant.dropOffLocation.y, variant.dropOffLocation.z)
	SetBlipColour(dropOffBlip, Color.BlipYellow())
	SetBlipHighDetail(dropOffBlip, true)
	SetBlipRouteColour(dropOffBlip, Color.BlipYellow())
	SetBlipAlpha(dropOffBlip, 0)

	dropOffLocationBlip = Map.CreateRadiusBlip(variant.dropOffLocation.x, variant.dropOffLocation.y, variant.dropOffLocation.z, Settings.assetRecovery.dropRadius, Color.BlipYellow())
	SetBlipAlpha(dropOffLocationBlip, 0)

	JobWatcher.StartJob('Asset Recovery')

	local eventStartTime = GetGameTimer()
	local isInVehicle = false
	local jobId = JobWatcher.GetJobId()

	Gui.StartJob(jobId, 'Steal the vehicle and deliver it to the drop-off location.', 'Minimize the vehicle damage to get extra cash.')

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)

			if JobWatcher.IsJobInProgress(jobId) then
				Gui.DrawTimerBar(0.13, 'JOB TIME', math.floor((Settings.assetRecovery.time - GetGameTimer() + eventStartTime) / 1000))
				if isInVehicle then Gui.DrawBar(0.13, 'VEHICLE HEALTH', math.floor(GetEntityHealth(vehicle) / GetEntityMaxHealth(vehicle) * 100)..'%', nil, 2) end
			else return end
		end
	end)

	local routeBlip = nil

	while true do
		Citizen.Wait(0)

		if GetTimeDifference(GetGameTimer(), eventStartTime) < Settings.assetRecovery.time then
			if not DoesEntityExist(vehicle) or not IsVehicleDriveable(vehicle, false) then
				TriggerEvent('lsv:assetRecoveryFinished', false, 'A vehicle has been destroyed.')
				return
			end

			isInVehicle = IsPedInVehicle(PlayerPedId(), vehicle, false)

			Gui.DisplayObjectiveText(isInVehicle and 'Deliver the vehicle to the ~y~drop off~w~.' or 'Steal the ~g~vehicle~w~.')

			SetBlipAlpha(vehicleBlip, isInVehicle and 0 or 255)
			SetBlipAlpha(dropOffBlip, isInVehicle and 255 or 0)
			SetBlipAlpha(dropOffLocationBlip, isInVehicle and 128 or 0)

			if isInVehicle then
				if not NetworkGetEntityIsNetworked(vehicle) then NetworkRegisterEntityAsNetworked(vehicle) end

				if routeBlip ~= dropOffBlip then
					SetBlipRoute(dropOffBlip, true)
					routeBlip = dropOffBlip
				end
			elseif routeBlip ~= vehicleBlip then
				SetBlipRoute(vehicleBlip, true)
				routeBlip = vehicleBlip
			end

			if isInVehicle then
				World.SetWantedLevel(3)

				local playerX, playerY, playerZ = table.unpack(GetEntityCoords(PlayerPedId(), true))

				if GetDistanceBetweenCoords(playerX, playerY, playerZ, variant.dropOffLocation.x, variant.dropOffLocation.y, variant.dropOffLocation.z, false) < Settings.assetRecovery.dropRadius then
					TriggerServerEvent('lsv:assetRecoveryFinished', GetEntityHealth(vehicle) / GetEntityMaxHealth(vehicle))
					return
				end
			end
		else
			TriggerEvent('lsv:assetRecoveryFinished', false, 'Time is over.')
			return
		end
	end
end)


RegisterNetEvent('lsv:assetRecoveryFinished')
AddEventHandler('lsv:assetRecoveryFinished', function(success, reason)
	JobWatcher.FinishJob('Asset Recovery')

	vehicle = nil

	RemoveBlip(vehicleBlip)
	vehicleBlip = nil

	RemoveBlip(dropOffBlip)
	dropOffBlip = nil

	RemoveBlip(dropOffLocationBlip)
	dropOffLocationBlip = nil

	World.SetWantedLevel(0)

	Gui.FinishJob('Asset Recovery', success, reason)
end)
