local _ownedGarage = { text = 'Owned Garage', blip = Blip.GARAGE_OWNED, color = Color.GREEN, blipColour = Color.BLIP_GREEN }
local _lockedGarage = { text = 'Garage For Sale', blip = Blip.GARAGE_LOCKED, color = Color.BLUE }

local _garageBlips = { }
local _garageId = nil

local _vehicleMods = {
	['11'] = {
		name = 'Engine',
		values = {
			[-1] = 'Stock (1 of 5)',
			[0] = 'Level 1 (2 of 5)',
			[1] = 'Level 2 (3 of 5)',
			[2] = 'Level 3 (4 of 5)',
			[3] = 'Level 4 (5 of 5)',
		},
	},

	['12'] = {
		name = 'Brakes',
		values = {
			[-1] = 'Stock (1 of 4)',
			[0] = 'Street (2 of 4)',
			[1] = 'Sports (3 of 4)',
			[2] = 'Race (4 of 4)',
		},
	},

	['13'] = {
		name = 'Transmission',
		values = {
			[-1] = 'Stock (1 of 4)',
			[0] = 'Street (2 of 4)',
			[1] = 'Sports (3 of 4)',
			[2] = 'Race (4 of 4)',
			[3] = 'Super',
		},
	},

	['15'] = {
		name = 'Suspension',
		values = {
			[-1] = 'Stock (1 of 5)',
			[0] = 'Lowered (2 of 5)',
			[1] = 'Street (3 of 5)',
			[2] = 'Sport (4 of 5)',
			[3] = 'Competition (5 of 5)',
		},
	},

	['18'] = {
		name = 'Turbo',
		values = {
			[-1] = 'None',
			[0] = 'None',
			[1] = 'On',
		},
	},
}

local function getGarageType(capacity)
	if capacity == 2 then
		return 'Low-End'
	elseif capacity == 6 then
		return 'Medium'
	end
end

RegisterNetEvent('lsv:garageUpdated')
AddEventHandler('lsv:garageUpdated', function(garage)
	local blip = _garageBlips[garage]
	SetBlipSprite(blip, _ownedGarage.blip)
	SetBlipColour(blip, _ownedGarage.blipColour)
	Map.SetBlipText(blip, _ownedGarage.text)
	Map.SetBlipFlashes(blip)
end)

RegisterNetEvent('lsv:garagePurchased')
AddEventHandler('lsv:garagePurchased', function(success)
	WarMenu.CloseMenu()
	Prompt.Hide()

	if success then
		PlaySoundFrontend(-1, 'PROPERTY_PURCHASE', 'HUD_AWARDS')

		local scaleform = Scaleform.NewAsync('MIDSIZED_MESSAGE')
		scaleform:call('SHOW_SHARD_MIDSIZED_MESSAGE', 'GARAGE PURCHASED', '')
		scaleform:renderFullscreenTimed(7000)
	else
		Gui.DisplayPersonalNotification('You don\'t have enough cash.')
	end
end)

RegisterNetEvent('lsv:vehicleRenamed')
AddEventHandler('lsv:vehicleRenamed', function(name)
	WarMenu.SetSubTitle('garage_vehicle', name)
	Prompt.Hide()
end)

AddEventHandler('lsv:init', function(playerData)
	table.foreach(Settings.garages, function(garage, id)
		local isOwnedGarage = Player.HasGarage(id)
		local blip = isOwnedGarage and _ownedGarage.blip or _lockedGarage.blip
		local blipText = isOwnedGarage and _ownedGarage.text or getGarageType(garage.capacity)..' '.._lockedGarage.text
		_garageBlips[id] = Map.CreatePlaceBlip(blip, garage.location.x, garage.location.y, garage.location.z, blipText)
		if isOwnedGarage then
			SetBlipColour(_garageBlips[id], _ownedGarage.blipColour)
		end
	end)
end)

AddEventHandler('lsv:init', function()
	Gui.CreateMenu('garage')
	WarMenu.SetTitleBackgroundColor('garage', Color.WHITE.r, Color.WHITE.g, Color.WHITE.b, Color.WHITE.a)
	WarMenu.SetTitleBackgroundSprite('garage', 'shopui_title_carmod2', 'shopui_title_carmod2')

	WarMenu.CreateSubMenu('garage_vehicle', 'garage')

	WarMenu.CreateSubMenu('garage_vehicle_inspect', 'garage_vehicle')

	local selectedVehicleIndex = nil

	while true do
		Citizen.Wait(0)

		if WarMenu.IsMenuOpened('garage') then
			table.iforeach(Player.Vehicles, function(vehicle, vehicleIndex)
				local name = Player.GetVehicleName(vehicleIndex)
				if WarMenu.MenuButton(name, 'garage_vehicle') then
					selectedVehicleIndex = vehicleIndex
					WarMenu.SetSubTitle('garage_vehicle', name)
				end
			end)

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('garage_vehicle') then
			local vehicle = Player.Vehicles[selectedVehicleIndex]
			local vehicleTier = Vehicle.GetTier(vehicle.model)

			if WarMenu.Button('Export', '$'..Settings.vehicleExport.rewards[vehicleTier].cash) then
				WarMenu.CloseMenu()
				MissionManager.StartMission('VehicleExport', Settings.vehicleExport.missionName)
				TriggerEvent('lsv:startVehicleExport', selectedVehicleIndex, vehicleTier, _garageId)
			elseif WarMenu.Button('Rename') then
				local name = Gui.GetTextInputResultAsync(16, vehicle.userName)
				if name then
					vehicle.userName = name
					TriggerServerEvent('lsv:renameVehicle', selectedVehicleIndex, vehicle)
					Prompt.ShowAsync()
				end
			elseif WarMenu.MenuButton('Inspect', 'garage_vehicle_inspect') then
				WarMenu.SetSubTitle('garage_vehicle_inspect', Player.GetVehicleName(selectedVehicleIndex))
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('garage_vehicle_inspect') then
			local vehicleMods = Player.Vehicles[selectedVehicleIndex].mods

			table.foreach(_vehicleMods, function(data, modId)
				if WarMenu.Button(data.name, data.values[vehicleMods[modId] or -1]) then
				end
			end)

			WarMenu.Display()
		end
	end
end)

AddEventHandler('lsv:init', function()
	Gui.CreateMenu('garage_purchase')
	WarMenu.SetTitleBackgroundColor('garage_purchase', Color.WHITE.r, Color.WHITE.g, Color.WHITE.b, Color.WHITE.a)
	WarMenu.SetTitleBackgroundSprite('garage_purchase', 'shopui_title_carmod2', 'shopui_title_carmod2')

	while true do
		Citizen.Wait(0)

		if WarMenu.IsMenuOpened('garage_purchase') then
			if WarMenu.Button('Purchase', '$'..Settings.garages[_garageId].price) then
				TriggerServerEvent('lsv:purchaseGarage', _garageId)
				Prompt.ShowAsync()
			end

			WarMenu.Display()
		end
	end
end)

AddEventHandler('lsv:init', function()
	local closestGarageBlip = nil

	while true do
		Citizen.Wait(0)

		local closestBlip = nil
		local closestBlipDistance = nil
		local isPlayerInFreeroam = Player.IsInFreeroam()

		table.foreach(Settings.garages, function(garage, id)
			SetBlipAlpha(_garageBlips[id], isPlayerInFreeroam and 255 or 0)

			local isOwnedGarage =  Player.HasGarage(id)

			local garageDistance = Player.DistanceTo(garage.location, true)

			if isOwnedGarage and (not closestBlipDistance or garageDistance < closestBlipDistance) then
				closestBlipDistance = garageDistance
				closestBlip = _garageBlips[id]
			end

			if isPlayerInFreeroam then
				Gui.DrawPlaceMarker(garage.location, isOwnedGarage and _ownedGarage.color or _lockedGarage.color)

				if garageDistance < Settings.placeMarker.radius then
					if not WarMenu.IsAnyMenuOpened() then
						Gui.DisplayHelpText('Press ~INPUT_TALK~ to open Garage menu.')

						if IsControlJustReleased(0, 46) then
							_garageId = id

							if isOwnedGarage then
								WarMenu.SetSubTitle('garage', table.length(Player.Vehicles)..' of '..Player.GetGaragesCapacity()..' garage slots used')
								Gui.OpenMenu('garage')
							else
								WarMenu.SetSubTitle('garage_purchase', '('..garage.capacity..'-Car) '..garage.name)
								Gui.OpenMenu('garage_purchase')
							end
						end
					end
				elseif (WarMenu.IsMenuOpened('garage_purchase') or WarMenu.IsMenuOpened('garage') or WarMenu.IsMenuOpened('garage_vehicle') or WarMenu.IsMenuOpened('garage_vehicle_inspect')) and _garageId == id then
					ForceCloseTextInputBox()
					WarMenu.CloseMenu()
					Prompt.Hide()
				end
			end
		end)

		if closestBlip then
			if closestGarageBlip ~= closestBlip then
				if closestGarageBlip then
					SetBlipAsShortRange(closestGarageBlip, true)
				end

				SetBlipAsShortRange(closestBlip, false)
				closestGarageBlip = closestBlip
			end
		end
	end
end)
