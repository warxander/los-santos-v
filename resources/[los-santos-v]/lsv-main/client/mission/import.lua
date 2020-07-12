local _missionPlaces = {
	{ x = -1141.8776855469, y = -1992.3674316406, z = 13.164126396179 },
	{ x = -355.33285522461, y = -127.68566131592, z = 39.430629730225 },
	{ x = 1188.1120605469, y = 2648.0578613281, z = 37.850742340088 },
	{ x = 120.55924224854, y = 6625.4282226562, z = 31.956226348877 },
	{ x = -1485.5867919922, y = -909.01232910156, z = 10.023587226868 },
	{ x = 998.70379638672, y = -1486.9389648438, z = 31.389440536499 },
	{ x = 1394.8724365234, y = 3625.0979003906, z = 35.011951446533 },
}

local _missionName = 'Vehicle Import'

local _placeIndex = nil

local _vehicle = nil
local _vehicleNet = nil
local _vehicleBlip = nil
local _vehicleData = nil

local _garageData = nil

local _helpHandler = nil

local function getModelRequirements(modelData)
	if modelData.prestige and Player.Prestige < modelData.prestige then
		return 'Prestige '..modelData.prestige
	end

	return nil
end

RegisterNetEvent('lsv:vehicleImportFinished')
AddEventHandler('lsv:vehicleImportFinished', function(success, reason)
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

	_vehicleData = nil

	RemoveBlip(_vehicleBlip)
	_vehicleBlip = nil

	RemoveBlip(_garageData.blip)
	_garageData = nil

	if success then
		reason = 'The vehicle was added to your Personal Vehicles collection.'
	end

	Gui.FinishMission(_missionName, success, reason)
end)

RegisterNetEvent('lsv:vehicleImportPurchased')
AddEventHandler('lsv:vehicleImportPurchased', function(vehicle)
	Prompt.Hide()

	if vehicle then
		WarMenu.CloseMenu()
		MissionManager.StartMission('vehicleImport', _missionName)
		TriggerEvent('lsv:startVehicleImport', vehicle)
	else
		Gui.DisplayPersonalNotification('You don\'t have enough cash.')
	end
end)

AddEventHandler('lsv:startVehicleImport', function(vehicle)
	local modelHash = GetHashKey(vehicle.model)
	Streaming.RequestModelAsync(modelHash)
	_vehicle = CreateVehicle(modelHash, vehicle.location.x, vehicle.location.y, vehicle.location.z, vehicle.location.heading, false, true)
	SetModelAsNoLongerNeeded(modelHash)

	_vehicleData = Vehicle.GenerateRandomMods(_vehicle, vehicle.model, vehicle.isBike, vehicle.isMaxedOut)
	_vehicleData.name = vehicle.name
	_vehicleData.plate = vehicle.plate
	Vehicle.ApplyMods(_vehicle, _vehicleData)

	SetVehicleMod(_vehicle, 16, 2)
	SetVehicleTyresCanBurst(_vehicle, false)

	_vehicleBlip = AddBlipForEntity(_vehicle)
	SetBlipHighDetail(_vehicleBlip, true)
	SetBlipSprite(_vehicleBlip, vehicle.isBike and Blip.IMPORT_BIKE or Blip.IMPORT_CAR)
	SetBlipColour(_vehicleBlip, Color.BLIP_BLUE)
	SetBlipRouteColour(_vehicleBlip, Color.BLIP_BLUE)
	SetBlipAlpha(_vehicleBlip, 0)
	Map.SetBlipText(_vehicleBlip, 'Vehicle')
	Map.SetBlipFlashes(_vehicleBlip)

	_garageData = { }
	local _, garage = table.random(Player.Garages)
	_garageData.location = Settings.garages[garage].location
	_garageData.blip = AddBlipForCoord(_garageData.location.x, _garageData.location.y, _garageData.location.z)
	SetBlipColour(_garageData.blip, Color.BLIP_YELLOW)
	SetBlipRouteColour(_garageData.blip, Color.BLIP_YELLOW)
	SetBlipHighDetail(_garageData.blip, true)
	SetBlipAlpha(_garageData.blip, 0)

	Gui.StartMission(_missionName, 'Collect the vehicle and deliver it to the Garage.')

	local missionTimer = Timer.New()
	local isInVehicle = false
	local routeBlip = nil

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
			SetBlipAlpha(_garageData.blip, isInVehicle and 255 or 0)

			if Player.IsActive() then
				Gui.DisplayObjectiveText(isInVehicle and 'Deliver the '..vehicle.name..' to the ~y~Garage~w~.' or 'Collect the ~b~'..vehicle.name..'~w~.')
				Gui.DrawTimerBar('MISSION TIME', Settings.vehicleImport.time - missionTimer:elapsed(), 1)

				if isInVehicle then
					local healthProgress = (GetEntityHealth(_vehicle) / GetEntityMaxHealth(_vehicle)) - Settings.vehicleImport.minVehicleHealthRatio
					Gui.DrawProgressBar('VEHICLE DAMAGE', 1.0 - (healthProgress / (1.0 - Settings.vehicleImport.minVehicleHealthRatio)), 2, Color.RED)
				end
			end
		end
	end)

	World.EnableWanted(true)

	while true do
		Citizen.Wait(0)

		if not MissionManager.Mission then
			TriggerEvent('lsv:vehicleImportFinished', false)
			return
		end

		if _vehicleNet then
			_vehicle = NetToVeh(_vehicleNet)
		end

		if missionTimer:elapsed() < Settings.vehicleImport.time then
			if not DoesEntityExist(_vehicle) or not IsVehicleDriveable(_vehicle, false) or (GetEntityHealth(_vehicle) / GetEntityMaxHealth(_vehicle)) < Settings.vehicleImport.minVehicleHealthRatio then
				TriggerEvent('lsv:vehicleImportFinished', false, 'A vehicle has been destroyed.')
				return
			end

			isInVehicle = IsPedInVehicle(PlayerPedId(), _vehicle, false)

			if isInVehicle then
				if not _vehicleNet then
					_vehicleNet = Network.RegisterVehicle(_vehicle)
					if _vehicleNet then
						_vehicle = NetToVeh(_vehicleNet)
						Gui.DisplayPersonalNotification('You have collected '..vehicle.name..'.')
						_helpHandler = HelpQueue.PushFront('Avoid vehicle damage to complete mission successfully.')
					end
				end

				if routeBlip ~= _garageData.blip then
					SetBlipRoute(_vehicleBlip, false)
					SetBlipRoute(_garageData.blip, true)
					routeBlip = _garageData.blip
				end

				Gui.DrawPlaceMarker(_garageData.location, Color.YELLOW)

				if Player.DistanceTo(_garageData.location, true) < Settings.vehicleImport.dropRadius then
					TriggerServerEvent('lsv:vehicleImportFinished', _vehicleData)
					return
				end
			elseif routeBlip ~= _vehicleBlip then
				SetBlipRoute(_garageData.blip, false)
				SetBlipRoute(_vehicleBlip, true)
				routeBlip = _vehicleBlip
			end
		else
			TriggerEvent('lsv:vehicleImportFinished', false, 'Time is over.')
			return
		end
	end
end)

AddEventHandler('lsv:init', function()
	Gui.CreateMenu('vehicle_import', 'Vehicle Import')
	WarMenu.SetSubTitle('vehicle_import', 'Select Vehicle Tier')
	WarMenu.SetTitleBackgroundColor('vehicle_import', Color.LIME.r, Color.LIME.g, Color.LIME.b, Color.LIME.a)

	WarMenu.CreateSubMenu('vehicle_import_list', 'vehicle_import')
	WarMenu.SetMenuButtonPressedSound('vehicle_import_list', 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET')

	local _tierIndex = nil

	while true do
		Citizen.Wait(0)

		if WarMenu.IsMenuOpened('vehicle_import') then
			table.iforeach(Settings.vehicleImport.tiers, function(tier, tierIndex)
				if WarMenu.MenuButton(tier.name, 'vehicle_import_list', '$'..tier.price) then
					_tierIndex = tierIndex
					WarMenu.SetSubTitle('vehicle_import_list', tier.name..' Vehicles')
				end
			end)

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('vehicle_import_list') then
			table.foreach(Settings.vehicleImport.tiers[_tierIndex].models, function(data, model)
				if WarMenu.Button(data.name, getModelRequirements(data)) then
					if data.prestige and Player.Prestige < data.prestige then
						Gui.DisplayPersonalNotification('Your Prestige is too low.')
					else
						TriggerServerEvent('lsv:purchaseVehicleImport', _tierIndex, model)
						Prompt.ShowAsync()
					end
				end
			end)

			WarMenu.Display()
		end
	end
end)

AddEventHandler('lsv:init', function()
	table.iforeach(_missionPlaces, function(place)
		place.blip = Map.CreatePlaceBlip(Blip.VEHICLE_IMPORT, place.x, place.y, place.z, _missionName, Color.BLIP_LIME)
	end)

	while true do
		Citizen.Wait(0)

		local isPlayerInFreeroam = Player.IsInFreeroam()
		local playerPosition = Player.Position()

		table.iforeach(_missionPlaces, function(place, placeIndex)
			SetBlipAlpha(place.blip, isPlayerInFreeroam and 255 or 0)

			if isPlayerInFreeroam then
				Gui.DrawPlaceMarker(place, Color.LIME)

				if World.GetDistance(playerPosition, place, true) < Settings.placeMarker.radius then
					if not WarMenu.IsAnyMenuOpened() then
						Gui.DisplayHelpText('Press ~INPUT_TALK~ to start '.._missionName..'.')

						if IsControlJustReleased(0, 46) then
							if table.length(Player.Garages) == 0 then
								Gui.DisplayPersonalNotification('You need to purchase Garage first.')
							elseif table.length(Player.Vehicles) == Player.GetGaragesCapacity() then
								Gui.DisplayPersonalNotification('You don\'t have free slots in Garages.')
							else
								_placeIndex = placeIndex
								Gui.OpenMenu('vehicle_import')
							end
						end
					end
				elseif (WarMenu.IsMenuOpened('vehicle_import') or WarMenu.IsMenuOpened('vehicle_import_list')) and _placeIndex == placeIndex then
					WarMenu.CloseMenu()
					Prompt.Hide()
				end
			end
		end)
	end
end)
