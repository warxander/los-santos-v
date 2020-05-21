local _vehicleIndex = nil
local _vehicle = nil
local _vehicleName = nil
local _vehicleTier = nil
local _vehicleBlip = nil

local _buyerLocation = nil
local _buyerBlip = nil

RegisterNetEvent('lsv:vehicleExportFinished')
AddEventHandler('lsv:vehicleExportFinished', function(success, reason)
	MissionManager.FinishMission(success)

	World.EnableWanted(false)

	_vehicleIndex = nil

	Player.LeaveVehicle(_vehicle)
	SetVehicleDoorsLockedForAllPlayers(_vehicle, true)
	World.MarkVehicleToDelete(_vehicle, 5000)
	_vehicle = nil

	_vehicleTier = nil

	RemoveBlip(_vehicleBlip)
	_vehicleBlip = nil

	_buyerLocation = nil

	RemoveBlip(_buyerBlip)
	_buyerBlip = nil


	Player.DestroyPersonalVehicle()

	if success then
		reason = _vehicleName..' was delivered to the Buyer.'
	end

	_vehicleName = nil

	Gui.FinishMission(Settings.vehicleExport.missionName, success, reason)
end)

AddEventHandler('lsv:startVehicleExport', function(vehicleIndex, vehicleTier, garageId)
	_vehicleIndex = vehicleIndex
	_vehicleTier = vehicleTier

	local vehicle = Player.Vehicles[vehicleIndex]

	Streaming.RequestModelAsync(vehicle.model)
	local modelHash = GetHashKey(vehicle.model)

	local position = Settings.garages[garageId].exportPos
	_vehicle = CreateVehicle(modelHash, position.x, position.y, position.z, position.heading, true, true)
	SetModelAsNoLongerNeeded(modelHash)

	Vehicle.ApplyMods(_vehicle, vehicle)

	SetVehicleMod(_vehicle, 16, 2)
	SetVehicleTyresCanBurst(_vehicle, false)

	_vehicleName = vehicle.name

	_vehicleBlip = AddBlipForEntity(_vehicle)
	SetBlipHighDetail(_vehicleBlip, true)
	SetBlipSprite(_vehicleBlip, Blip.IMPORT_CAR)
	SetBlipColour(_vehicleBlip, Color.BLIP_BLUE)
	SetBlipRouteColour(_vehicleBlip, Color.BLIP_BLUE)
	SetBlipAlpha(_vehicleBlip, 0)
	Map.SetBlipText(_vehicleBlip, 'Vehicle')
	Map.SetBlipFlashes(_vehicleBlip)

	_buyerLocation = table.random(Settings.vehicleExport.locations)
	_buyerBlip = AddBlipForCoord(_buyerLocation.x, _buyerLocation.y, _buyerLocation.z)
	SetBlipColour(_buyerBlip, Color.BLIP_YELLOW)
	SetBlipRouteColour(_buyerBlip, Color.BLIP_YELLOW)
	SetBlipHighDetail(_buyerBlip, true)
	SetBlipAlpha(_buyerBlip, 0)
	Map.SetBlipText(_buyerBlip, 'Buyer')

	Gui.StartMission(Settings.vehicleExport.missionName, 'Deliver the vehicle to the Buyer.')

	local missionTimer = Timer.New()
	local isInVehicle = false
	local routeBlip = nil

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)

			if not MissionManager.Mission then
				return
			end

			SetBlipAlpha(_vehicleBlip, isInVehicle and 0 or 255)
			SetBlipAlpha(_buyerBlip, isInVehicle and 255 or 0)

			if Player.IsActive() then
				local objectiveText = ''
				if not isInVehicle then
					objectiveText = 'Enter the ~b~vehicle~w~.'
				elseif GetPlayerWantedLevel(PlayerId()) ~= 0 then
					objectiveText = 'Lose the cops.'
				else
					objectiveText = 'Deliver the '..vehicle.name..' to the ~y~Buyer~w~.'
				end
				Gui.DisplayObjectiveText(objectiveText)

				Gui.DrawBar('SELL PRICE', '$'..math.floor(Settings.vehicleExport.rewards[_vehicleTier].cash * GetEntityHealth(_vehicle) / GetEntityMaxHealth(_vehicle)), 2)
				Gui.DrawTimerBar('TIME TO DELIVER', Settings.vehicleExport.time - missionTimer:elapsed(), 1)
			end
		end
	end)

	World.EnableWanted(true)

	while true do
		Citizen.Wait(0)

		if not MissionManager.Mission then
			TriggerEvent('lsv:vehicleExportFinished', false)
			return
		end

		if missionTimer:elapsed() < Settings.vehicleExport.time then
			if not DoesEntityExist(_vehicle) or not IsVehicleDriveable(_vehicle, false) then
				TriggerServerEvent('lsv:vehicleExportFinished', false, _vehicleIndex)
				return
			end

			isInVehicle = IsPedInVehicle(PlayerPedId(), _vehicle, false)

			if isInVehicle then
				Gui.DrawPlaceMarker(_buyerLocation, Color.YELLOW)

				if routeBlip ~= _buyerBlip then
					SetBlipRoute(_buyerBlip, true)
					routeBlip = _buyerBlip
				end

				if Player.DistanceTo(_buyerLocation, true) < Settings.vehicleExport.dropRadius and GetPlayerWantedLevel(PlayerId()) == 0 then
					TriggerServerEvent('lsv:vehicleExportFinished', true, _vehicleIndex, _vehicleTier, GetEntityHealth(_vehicle) / GetEntityMaxHealth(_vehicle))
					return
				end
			elseif routeBlip ~= _vehicleBlip then
				SetBlipRoute(_vehicleBlip, true)
				routeBlip = _vehicleBlip
			end
		else
			TriggerEvent('lsv:vehicleExportFinished', false, 'Time is over.')
			return
		end
	end
end)
