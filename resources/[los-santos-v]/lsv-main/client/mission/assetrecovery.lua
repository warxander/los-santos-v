local _vehicle = nil
local _vehicleNet = nil
local _vehicleBlip = nil
local _dropOffBlip = nil

local _helpHandler = nil

RegisterNetEvent('lsv:assetRecoveryFinished')
AddEventHandler('lsv:assetRecoveryFinished', function(success, reason)
	if _helpHandler then
		_helpHandler:cancel()
	end

	MissionManager.FinishMission(success)

	World.EnableWanted(false)

	if _vehicleNet then
		_vehicle = NetToVeh(_vehicleNet)
		Player.LeaveVehicle(_vehicle)
		SetVehicleDoorsLockedForAllPlayers(_vehicle, true)
		Network.DeleteVehicle(_vehicleNet, 5000)
	else
		World.DeleteEntity(_vehicle)
	end
	_vehicleNet = nil
	_vehicle = nil

	RemoveBlip(_vehicleBlip)
	_vehicleBlip = nil

	RemoveBlip(_dropOffBlip)
	_dropOffBlip = nil

	Gui.FinishMission('Asset Recovery', success, reason)
end)

AddEventHandler('lsv:startAssetRecovery', function()
	local variant = table.random(Settings.assetRecovery.variants)
	local vehicleHash = table.random(Settings.assetRecovery.vehicles)

	Streaming.RequestModelAsync(vehicleHash)
	_vehicle = CreateVehicle(vehicleHash, variant.vehicleLocation.x, variant.vehicleLocation.y, variant.vehicleLocation.z, variant.vehicleLocation.heading, false, true)
	SetVehicleModKit(_vehicle, 0)
	SetVehicleMod(_vehicle, 16, 4)
	SetVehicleTyresCanBurst(_vehicle, false)
	SetModelAsNoLongerNeeded(vehicleHash)

	local missionTimer = Timer.New()
	local isInVehicle = false
	local loseTheCops = false
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

	Gui.StartMission('Asset Recovery', 'Steal the vehicle and deliver it to the drop-off location.')

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)

			if not MissionManager.Mission then
				return
			end

			if _vehicleNet then
				_vehicle = NetToVeh(_vehicleNet)
			end

			SetBlipAlpha(_vehicleBlip, isInVehicle and 0 or 255)
			SetBlipAlpha(_dropOffBlip, isInVehicle and 255 or 0)

			if Player.IsActive() then
				local objectiveText = ''
				if not isInVehicle then
					objectiveText = 'Steal the ~g~vehicle~w~.'
				elseif not loseTheCops or GetPlayerWantedLevel(PlayerId()) == 0 then
					objectiveText = 'Deliver the vehicle to the ~y~drop off~w~.'
				else
					objectiveText = 'Lose the cops.'
				end

				Gui.DisplayObjectiveText(objectiveText)
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

		if _vehicleNet then
			_vehicle = NetToVeh(_vehicleNet)
		end

		if missionTimer:elapsed() < Settings.assetRecovery.time then
			if not DoesEntityExist(_vehicle) or not IsVehicleDriveable(_vehicle, false) then
				TriggerEvent('lsv:assetRecoveryFinished', false, 'A vehicle has been destroyed.')
				return
			end

			isInVehicle = IsPedInVehicle(PlayerPedId(), _vehicle, false)

			if isInVehicle then
				Gui.DrawPlaceMarker(variant.dropOffLocation, Color.YELLOW)

				if not _vehicleNet then
					_vehicleNet = Network.RegisterVehicle(_vehicle)
					if _vehicleNet then
						_vehicle = NetToVeh(_vehicleNet)
						World.SetWantedLevel(4, 5, true)
						Gui.DisplayPersonalNotification('You have stolen a vehicle.')
						_helpHandler = HelpQueue.PushFront('Minimize the vehicle damage to get extra reward.')
					end
				end

				if routeBlip ~= _dropOffBlip then
					SetBlipRoute(_dropOffBlip, true)
					routeBlip = _dropOffBlip
				end

				if Player.DistanceTo(variant.dropOffLocation, true) < Settings.assetRecovery.dropRadius and GetPlayerWantedLevel(PlayerId()) == 0 then
					TriggerServerEvent('lsv:assetRecoveryFinished', GetEntityHealth(_vehicle) / GetEntityMaxHealth(_vehicle))
					return
				elseif not loseTheCops and Player.DistanceTo(variant.dropOffLocation, true) < Settings.assetRecovery.nearDistance then
					_helpHandler = HelpQueue.PushFront('You are nearing the drop-off location. Lose your Wanted Level before delivering the vehicle.')
					World.SetWantedLevel(2, 2)
					loseTheCops = true
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
