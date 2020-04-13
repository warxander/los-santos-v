local _vehicle = nil
local _vehicleBlip = nil
local _dropOffBlip = nil
local _dropOffLocationBlip = nil

local _helpHandler = nil

RegisterNetEvent('lsv:assetRecoveryFinished')
AddEventHandler('lsv:assetRecoveryFinished', function(success, reason)
	if _helpHandler then
		_helpHandler:cancel()
	end

	MissionManager.FinishMission(success)

	World.EnableWanted(false)

	if not success and not IsPedInVehicle(PlayerPedId(), _vehicle, false) then
		SetEntityAsMissionEntity(_vehicle, true, true)
		DeleteVehicle(_vehicle)
	end
	_vehicle = nil

	RemoveBlip(_vehicleBlip)
	_vehicleBlip = nil

	RemoveBlip(_dropOffBlip)
	_dropOffBlip = nil

	RemoveBlip(_dropOffLocationBlip)
	_dropOffLocationBlip = nil

	Gui.FinishMission('Asset Recovery', success, reason)
end)

AddEventHandler('lsv:startAssetRecovery', function()
	local variant = table.random(Settings.assetRecovery.variants)

	Streaming.RequestModelAsync(variant.vehicle)
	local vehicleHash = GetHashKey(variant.vehicle)
	_vehicle = CreateVehicle(vehicleHash, variant.vehicleLocation.x, variant.vehicleLocation.y, variant.vehicleLocation.z, variant.vehicleLocation.heading, false, true)
	SetVehicleModKit(_vehicle, 0)
	SetVehicleMod(_vehicle, 16, 4)
	SetVehicleTyresCanBurst(_vehicle, false)
	SetModelAsNoLongerNeeded(vehicleHash)

	local missionTimer = Timer.New()
	local isInVehicle = false
	local routeBlip = nil

	_vehicleBlip = AddBlipForEntity(_vehicle)
	SetBlipHighDetail(_vehicleBlip, true)
	SetBlipSprite(_vehicleBlip, Blip.CAR)
	SetBlipColour(_vehicleBlip, Color.BLIP_GREEN)
	SetBlipRouteColour(_vehicleBlip, Color.BLIP_GREEN)
	SetBlipAlpha(_vehicleBlip, 0)
	Map.SetBlipText(_vehicleBlip, 'Vehicle')
	Map.SetBlipFlashes(_vehicleBlip)

	_dropOffBlip = AddBlipForCoord(variant.dropOffLocation.x, variant.dropOffLocation.y, variant.dropOffLocation.z)
	SetBlipColour(_dropOffBlip, Color.BLIP_YELLOW)
	SetBlipRouteColour(_dropOffBlip, Color.BLIP_YELLOW)
	SetBlipHighDetail(_dropOffBlip, true)
	SetBlipAlpha(_dropOffBlip, 0)

	_dropOffLocationBlip = Map.CreateRadiusBlip(variant.dropOffLocation.x, variant.dropOffLocation.y, variant.dropOffLocation.z, Settings.assetRecovery.dropRadius, Color.BLIP_YELLOW)
	SetBlipAlpha(_dropOffLocationBlip, 0)

	Gui.StartMission('Asset Recovery', 'Steal the vehicle and deliver it to the drop-off location.')

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)

			if not MissionManager.Mission then
				return
			end

			SetBlipAlpha(_vehicleBlip, isInVehicle and 0 or 255)
			SetBlipAlpha(_dropOffBlip, isInVehicle and 255 or 0)
			SetBlipAlpha(_dropOffLocationBlip, isInVehicle and 128 or 0)

			if Player.IsActive() then
				Gui.DisplayObjectiveText(isInVehicle and 'Deliver the vehicle to the ~y~drop off~w~.' or 'Steal the ~g~vehicle~w~.')
				Gui.DrawTimerBar('MISSION TIME', Settings.assetRecovery.time - missionTimer:elapsed(), 1)

				if isInVehicle then
					local healthProgress = GetEntityHealth(_vehicle) / GetEntityMaxHealth(_vehicle)
					local color = Color.GREEN
					if healthProgress < 0.33 then
						color = Color.RED
					elseif healthProgress < 0.66 then
						color = Color.YELLOW
					end
					Gui.DrawProgressBar('VEHICLE HEALTH', healthProgress, 2, color)
				end
			end
		end
	end)

	World.EnableWanted(true)

	while true do
		Citizen.Wait(0)

		if not MissionManager.Mission then
			TriggerEvent('lsv:assetRecoveryFinished', false)
			return
		end

		if missionTimer:elapsed() < Settings.assetRecovery.time then
			if not DoesEntityExist(_vehicle) or not IsVehicleDriveable(_vehicle, false) then
				TriggerEvent('lsv:assetRecoveryFinished', false, 'A vehicle has been destroyed.')
				return
			end

			isInVehicle = IsPedInVehicle(PlayerPedId(), _vehicle, false)

			if isInVehicle then
				if not NetworkGetEntityIsNetworked(_vehicle) then
					NetworkRegisterEntityAsNetworked(_vehicle)
					Gui.DisplayPersonalNotification('You have stolen a vehicle.')
					_helpHandler = HelpQueue.PushFront('Minimize the vehicle damage to get extra reward.')
				end

				if routeBlip ~= _dropOffBlip then
					SetBlipRoute(_dropOffBlip, true)
					routeBlip = _dropOffBlip
				end

				World.SetWantedLevel(3)

				if Player.DistanceTo(variant.dropOffLocation, true) < Settings.assetRecovery.dropRadius then
					TriggerServerEvent('lsv:assetRecoveryFinished', GetEntityHealth(_vehicle) / GetEntityMaxHealth(_vehicle))
					return
				end
			elseif routeBlip ~= _vehicleBlip then
				SetBlipRoute(_vehicleBlip, true)
				routeBlip = _vehicleBlip
			end
		else
			TriggerEvent('lsv:assetRecoveryFinished', false, 'Time is over.')
			return
		end
	end
end)
