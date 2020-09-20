local _vehicleNet = nil
local _vehicleBlip = nil
local _buyerBlip = nil

local _productName = nil

RegisterNetEvent('lsv:finishDrugExport')
AddEventHandler('lsv:finishDrugExport', function(success, reason)
	MissionManager.FinishMission(success)

	World.EnableWanted(false)

	if _vehicleNet then
		local vehicle = NetToVeh(_vehicleNet)
		Player.LeaveVehicle(vehicle)
		SetVehicleDoorsLockedForAllPlayers(vehicle, true)
		Network.DeleteVehicle(_vehicleNet, 5000)
	end
	_vehicleNet = nil

	RemoveBlip(_vehicleBlip)
	_vehicleBlip = nil

	RemoveBlip(_buyerBlip)
	_buyerBlip = nil

	if success then
		reason = _productName..' was delivered to the Buyer.'
	end

	_productName = nil

	Gui.FinishMission(Settings.drugBusiness.export.missionName, success, reason)
end)

AddEventHandler('lsv:startDrugExport', function(data)
	local vehicleModel = table.random(Settings.drugBusiness.export.vehicles[data.type])
	local vehiclePosition = Settings.drugBusiness.businesses[Player.DrugBusiness[data.type].id].vehicleLocation

	Streaming.RequestModelAsync(vehicleModel)
	_vehicleNet = Network.CreateVehicle(vehicleModel, vehiclePosition, vehiclePosition.heading)

	local vehicle = NetToVeh(_vehicleNet)
	SetVehicleModKit(vehicle, 0)
	SetVehicleMod(vehicle, 16, 4)
	SetVehicleTyresCanBurst(vehicle, false)

	_productName = Settings.drugBusiness.types[data.type].productName

	_vehicleBlip = Map.CreateEntityBlip(vehicle, Blip.CARGO, _productName, Color.BLIP_BLUE)
	SetBlipAlpha(_vehicleBlip, 0)
	Map.SetBlipFlashes(_vehicleBlip)

	_buyerBlip = Map.CreatePlaceBlip(nil, data.location.x, data.location.y, data.location.z, 'Buyer', Color.BLIP_YELLOW)
	SetBlipAsShortRange(_buyerBlip, false)
	SetBlipAlpha(_buyerBlip, 0)

	Gui.StartMission(Settings.drugBusiness.export.missionName, 'Deliver '.._productName..' to the Buyer.')

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
					objectiveText = 'Collect the ~b~'.._productName..'~w~.'
				elseif GetPlayerWantedLevel(PlayerId()) ~= 0 then
					objectiveText = 'Lose the cops.'
				else
					objectiveText = 'Deliver the ~b~'.._productName..'~w~ to the ~y~Buyer~w~.'
				end
				Gui.DisplayObjectiveText(objectiveText)

				Gui.DrawBar('TOTAL PROFIT', '$'..data.totalProfit, 2)
				Gui.DrawTimerBar('MISSION TIME', Settings.drugBusiness.export.time - missionTimer:elapsed(), 1)
			end
		end
	end)

	if not Player.DrugBusiness[data.type].upgrades.security then
		World.EnableWanted(true)
	end

	while true do
		Citizen.Wait(0)

		if not MissionManager.Mission then
			return
		end

		vehicle = NetToVeh(_vehicleNet)

		if missionTimer:elapsed() < Settings.drugBusiness.export.time then
			if not DoesEntityExist(vehicle) or not IsVehicleDriveable(vehicle, false) then
				TriggerEvent('lsv:finishDrugExport', false, _productName..' has been destroyed.')
				return
			end

			isInVehicle = IsPedInVehicle(PlayerPedId(), vehicle, false)

			if isInVehicle then
				Gui.DrawPlaceMarker(data.location, Color.YELLOW)

				if routeBlip ~= _buyerBlip then
					SetBlipRoute(_buyerBlip, true)
					routeBlip = _buyerBlip
				end

				if Player.DistanceTo(data.location, true) < Settings.drugBusiness.export.dropRadius and GetPlayerWantedLevel(PlayerId()) == 0 then
					TriggerServerEvent('lsv:finishDrugExport')
					return
				end
			elseif routeBlip ~= _vehicleBlip then
				SetBlipRoute(_vehicleBlip, true)
				routeBlip = _vehicleBlip
			end
		else
			TriggerEvent('lsv:finishDrugExport', false, 'Time is over.')
			return
		end
	end
end)
