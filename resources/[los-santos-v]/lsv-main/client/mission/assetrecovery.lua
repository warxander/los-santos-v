local vehicle = nil
local vehicleBlip = nil
local dropOffBlip = nil
local dropOffLocationBlip = nil

local helpHandler = nil


AddEventHandler('lsv:startAssetRecovery', function()
	local variant = table.random(Settings.assetRecovery.variants)

	Streaming.RequestModel(variant.vehicle, true)
	local vehicleHash = GetHashKey(variant.vehicle)
	vehicle = CreateVehicle(vehicleHash, variant.vehicleLocation.x, variant.vehicleLocation.y, variant.vehicleLocation.z, variant.vehicleLocation.heading, false, true)
	SetVehicleModKit(vehicle, 0)
	SetVehicleMod(vehicle, 16, 4)
	SetModelAsNoLongerNeeded(vehicleHash)

	local eventStartTime = Timer.New()
	local isInVehicle = false
	local routeBlip = nil

	vehicleBlip = AddBlipForEntity(vehicle)
	SetBlipHighDetail(vehicleBlip, true)
	SetBlipSprite(vehicleBlip, Blip.PersonalVehicleCar())
	SetBlipColour(vehicleBlip, Color.BlipGreen())
	SetBlipRouteColour(vehicleBlip, Color.BlipGreen())
	SetBlipAlpha(vehicleBlip, 0)
	Map.SetBlipText(vehicleBlip, 'Vehicle')
	Map.SetBlipFlashes(vehicleBlip)

	dropOffBlip = AddBlipForCoord(variant.dropOffLocation.x, variant.dropOffLocation.y, variant.dropOffLocation.z)
	SetBlipColour(dropOffBlip, Color.BlipYellow())
	SetBlipRouteColour(dropOffBlip, Color.BlipYellow())
	SetBlipHighDetail(dropOffBlip, true)
	SetBlipAlpha(dropOffBlip, 0)

	dropOffLocationBlip = Map.CreateRadiusBlip(variant.dropOffLocation.x, variant.dropOffLocation.y, variant.dropOffLocation.z, Settings.assetRecovery.dropRadius, Color.BlipYellow())
	SetBlipAlpha(dropOffLocationBlip, 0)

	Gui.StartMission('Asset Recovery', 'Steal the vehicle and deliver it to the drop-off location.')

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)

			if not MissionManager.Mission then return end

			SetBlipAlpha(vehicleBlip, isInVehicle and 0 or 255)
			SetBlipAlpha(dropOffBlip, isInVehicle and 255 or 0)
			SetBlipAlpha(dropOffLocationBlip, isInVehicle and 128 or 0)

			if Player.IsActive() then
				Gui.DisplayObjectiveText(isInVehicle and 'Deliver the vehicle to the ~y~drop off~w~.' or 'Steal the ~g~vehicle~w~.')
				Gui.DrawTimerBar('MISSION TIME', Settings.assetRecovery.time - eventStartTime:Elapsed())
				if isInVehicle then
					local healthProgress = GetEntityHealth(vehicle) / GetEntityMaxHealth(vehicle)
					local color = Color.GetHudFromBlipColor(Color.BlipGreen())
					if healthProgress < 0.33 then color = Color.GetHudFromBlipColor(Color.BlipRed())
					elseif healthProgress < 0.66 then color = Color.GetHudFromBlipColor(Color.BlipYellow()) end
					Gui.DrawProgressBar('VEHICLE HEALTH', healthProgress, color, 2)
				end
			end
		end
	end)

	while true do
		Citizen.Wait(0)

		if not MissionManager.Mission then
			TriggerEvent('lsv:assetRecoveryFinished', false)
			return
		end

		if eventStartTime:Elapsed() < Settings.assetRecovery.time then
			if not DoesEntityExist(vehicle) or not IsVehicleDriveable(vehicle, false) then
				TriggerEvent('lsv:assetRecoveryFinished', false, 'A vehicle has been destroyed.')
				return
			end

			isInVehicle = IsPedInVehicle(PlayerPedId(), vehicle, false)

			if isInVehicle then
				if not NetworkGetEntityIsNetworked(vehicle) then
					NetworkRegisterEntityAsNetworked(vehicle)
					Gui.DisplayPersonalNotification('You have stolen a vehicle.')
					helpHandler = HelpQueue.PushFront('Minimize the vehicle damage to get extra reward.')
				end

				if routeBlip ~= dropOffBlip then
					SetBlipRoute(dropOffBlip, true)
					routeBlip = dropOffBlip
				end

				World.SetWantedLevel(3)

				if Player.DistanceTo(variant.dropOffLocation, true) < Settings.assetRecovery.dropRadius then
					TriggerServerEvent('lsv:assetRecoveryFinished', GetEntityHealth(vehicle) / GetEntityMaxHealth(vehicle))
					return
				end				
			elseif routeBlip ~= vehicleBlip then
				SetBlipRoute(vehicleBlip, true)
				routeBlip = vehicleBlip
			end
		else
			TriggerEvent('lsv:assetRecoveryFinished', false, 'Time is over.')
			return
		end
	end
end)


RegisterNetEvent('lsv:assetRecoveryFinished')
AddEventHandler('lsv:assetRecoveryFinished', function(success, reason)
	if helpHandler then helpHandler:Cancel() end

	MissionManager.FinishMission(success)

	World.SetWantedLevel(0)

	if not success and not IsPedInVehicle(PlayerPedId(), vehicle, false) then
		SetEntityAsMissionEntity(vehicle, true, true)
		DeleteVehicle(vehicle)
	end
	vehicle = nil

	RemoveBlip(vehicleBlip)
	vehicleBlip = nil

	RemoveBlip(dropOffBlip)
	dropOffBlip = nil

	RemoveBlip(dropOffLocationBlip)
	dropOffLocationBlip = nil

	Gui.FinishMission('Asset Recovery', success, reason)
end)