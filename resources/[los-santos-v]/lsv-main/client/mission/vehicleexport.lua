local _vehicleIndex = nil
local _vehicleNet = nil
local _vehicleName = nil
local _vehicleTier = nil
local _vehicleBlip = nil

local _buyerLocation = nil
local _buyerBlip = nil

RegisterNetEvent('lsv:finishVehicleExport')
AddEventHandler('lsv:finishVehicleExport', function(success, reason)
	MissionManager.FinishMission(success)

	World.EnableWanted(false)

	_vehicleIndex = nil

	if _vehicleNet then
		local vehicle = NetToVeh(_vehicleNet)
		Player.LeaveVehicle(vehicle)
		SetVehicleDoorsLockedForAllPlayers(vehicle, true)
		Network.DeleteVehicle(_vehicleNet, 5000)
	end
	_vehicleNet = nil

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

	local vehicleMods = Player.Vehicles[vehicleIndex]
	local position = Settings.garages[garageId].exportPos

	local modelHash = GetHashKey(vehicleMods.model)
	Streaming.RequestModelAsync(modelHash)

	_vehicleNet = Network.CreateVehicle(modelHash, position, position.heading)

	local vehicle = NetToVeh(_vehicleNet)

	Vehicle.ApplyMods(vehicle, vehicleMods)

	SetVehicleMod(vehicle, 16, 2)
	SetVehicleTyresCanBurst(vehicle, false)
	SetEntityLoadCollisionFlag(vehicle, true)

	_vehicleName = vehicleMods.name

	_vehicleBlip = Map.CreateEntityBlip(vehicle, Blip.IMPORT_CAR, 'Vehicle', Color.BLIP_BLUE)
	SetBlipAlpha(_vehicleBlip, 0)
	Map.SetBlipFlashes(_vehicleBlip)

	_buyerLocation = table.random(Settings.vehicleExport.locations)

	_buyerBlip = Map.CreatePlaceBlip(nil, _buyerLocation.x, _buyerLocation.y, _buyerLocation.z, 'Buyer', Color.BLIP_YELLOW)
	SetBlipAsShortRange(_buyerBlip, false)
	SetBlipAlpha(_buyerBlip, 0)

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

			vehicle = NetToVeh(_vehicleNet)

			SetBlipAlpha(_vehicleBlip, isInVehicle and 0 or 255)
			SetBlipAlpha(_buyerBlip, isInVehicle and 255 or 0)

			if Player.IsActive() then
				local objectiveText = ''
				if not isInVehicle then
					objectiveText = 'Enter the ~b~vehicle~w~.'
				elseif GetPlayerWantedLevel(PlayerId()) ~= 0 then
					objectiveText = 'Lose the cops.'
				else
					objectiveText = 'Deliver the '.._vehicleName..' to the ~y~Buyer~w~.'
				end
				Gui.DisplayObjectiveText(objectiveText)

				Gui.DrawBar('SELL PRICE', '$'..math.floor(Settings.vehicleExport.rewards[_vehicleTier].cash * GetEntityHealth(vehicle) / GetEntityMaxHealth(vehicle)), 2)
				Gui.DrawTimerBar('TIME TO DELIVER', Settings.vehicleExport.time - missionTimer:elapsed(), 1)
			end
		end
	end)

	World.EnableWanted(true)

	while true do
		Citizen.Wait(0)

		if not MissionManager.Mission then
			return
		end

		vehicle = NetToVeh(_vehicleNet)

		if missionTimer:elapsed() < Settings.vehicleExport.time then
			if not DoesEntityExist(vehicle) or not IsVehicleDriveable(vehicle, false) then
				TriggerServerEvent('lsv:finishVehicleExport', false, _vehicleIndex)
				return
			end

			isInVehicle = IsPedInVehicle(PlayerPedId(), vehicle, false)

			if isInVehicle then
				Gui.DrawPlaceMarker(_buyerLocation, Color.YELLOW)

				if routeBlip ~= _buyerBlip then
					SetBlipRoute(_buyerBlip, true)
					routeBlip = _buyerBlip
				end

				if Player.DistanceTo(_buyerLocation, true) < Settings.vehicleExport.dropRadius and GetPlayerWantedLevel(PlayerId()) == 0 then
					TriggerServerEvent('lsv:finishVehicleExport', true, _vehicleIndex, _vehicleTier, GetEntityHealth(vehicle) / GetEntityMaxHealth(vehicle))
					return
				end
			elseif routeBlip ~= _vehicleBlip then
				SetBlipRoute(_vehicleBlip, true)
				routeBlip = _vehicleBlip
			end
		else
			TriggerEvent('lsv:finishVehicleExport', false, 'Time is over.')
			return
		end
	end
end)
