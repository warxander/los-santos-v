local _offices = {
	{ blip = nil, x = -1585.6872558594, y = -571.20220947266, z = 34.978904724121 },
	{ blip = nil, x = -1371.1125488281, y = -459.93716430664, z = 34.477592468262 },
	{ blip = nil, x = 38.66121673584, y = -694.73736572266, z = 31.706129074097 },
	{ blip = nil, x = -197.51435852051, y = -570.88153076172, z = 34.635047912598 },
}

local _cargo = nil

RegisterNetEvent('lsv:cargoCratePurchased')
AddEventHandler('lsv:cargoCratePurchased', function(cargo)
	if not cargo then
		Gui.DisplayPersonalNotification('You don\'t have enough cash.')
	else
		WarMenu.CloseMenu()
		MissionManager.StartMission('specialCargo', Settings.cargo.missionName)
		TriggerEvent('lsv:startSpecialCargo', cargo)
	end

	Prompt.Hide()
end)

RegisterNetEvent('lsv:specialCargoFinished')
AddEventHandler('lsv:specialCargoFinished', function(success, reason)
	MissionManager.FinishMission(success)

	World.EnableWanted(false)

	if DoesEntityExist(_cargo.vehicle) then
		SetEntityAsMissionEntity(_cargo.vehicle, true, true)
		DeleteVehicle(_cargo.vehicle)
	end

	RemoveBlip(_cargo.vehicleBlip)
	RemoveBlip(_cargo.warehouseBlip)

	_cargo = nil

	if not reason then
		reason = success and 'Special Cargo vehicle delivered' or ''
	end

	Gui.FinishMission(Settings.cargo.missionName, success, reason)
end)

AddEventHandler('lsv:startSpecialCargo', function(cargo)
	Streaming.RequestModelAsync(cargo.vehicle)
	local vehicleHash = GetHashKey(cargo.vehicle)

	_cargo = { }
	_cargo.vehicle = CreateVehicle(vehicleHash, cargo.location.x, cargo.location.y, cargo.location.z, cargo.location.heading, false, true)
	SetModelAsNoLongerNeeded(vehicleHash)

	local missionTimer = Timer.New()
	local isInVehicle = false
	local routeBlip = nil

	_cargo.vehicleBlip = AddBlipForEntity(_cargo.vehicle)
	SetBlipHighDetail(_cargo.vehicleBlip, true)
	SetBlipSprite(_cargo.vehicleBlip, Blip.CARGO)
	SetBlipColour(_cargo.vehicleBlip, Color.BLIP_GREEN)
	SetBlipRouteColour(_cargo.vehicleBlip, Color.BLIP_GREEN)
	SetBlipAlpha(_cargo.vehicleBlip, 0)
	Map.SetBlipFlashes(_cargo.vehicleBlip)

	_cargo.warehouseBlip = AddBlipForCoord(cargo.warehouse.x, cargo.warehouse.y, cargo.warehouse.z)
	SetBlipColour(_cargo.warehouseBlip, Color.BLIP_YELLOW)
	SetBlipRouteColour(_cargo.warehouseBlip, Color.BLIP_YELLOW)
	SetBlipHighDetail(_cargo.warehouseBlip, true)
	SetBlipAlpha(_cargo.warehouseBlip, 0)

	Gui.StartMission(Settings.cargo.missionName, 'Collect the '..cargo.goods)

	-- GUI
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)

			if not MissionManager.Mission then
				return
			end

			SetBlipAlpha(_cargo.vehicleBlip, isInVehicle and 0 or 255)
			SetBlipAlpha(_cargo.warehouseBlip, isInVehicle and 255 or 0)

			if Player.IsActive() then
				local objectiveText = 'Collect the ~g~'..cargo.goods..'~w~.'
				if isInVehicle then
					objectiveText = GetPlayerWantedLevel(PlayerId()) == 0 and 'Take the '..cargo.goods..' to the ~y~Warehouse~w~.' or 'Lose the cops.'
				end
				Gui.DisplayObjectiveText(objectiveText)

				Gui.DrawTimerBar('MISSION TIME', Settings.cargo.time - missionTimer:elapsed(), 1)
			end
		end
	end)

	World.EnableWanted(true)

	while true do
		Citizen.Wait(0)

		if not MissionManager.Mission then
			TriggerEvent('lsv:specialCargoFinished', false)
			return
		end

		if missionTimer:elapsed() < Settings.cargo.time then
			if not DoesEntityExist(_cargo.vehicle) or not IsVehicleDriveable(_cargo.vehicle, false) then
				TriggerEvent('lsv:specialCargoFinished', false, 'A Special Cargo vehicle has been destroyed.')
				return
			end

			isInVehicle = IsPedInVehicle(PlayerPedId(), _cargo.vehicle, false)

			if isInVehicle then
				if not NetworkGetEntityIsNetworked(_cargo.vehicle) then
					NetworkRegisterEntityAsNetworked(_cargo.vehicle)
					if cargo.wanted then
						World.SetWantedLevel(Settings.cargo.wantedLevel)
					end
					Gui.DisplayPersonalNotification('You have collected the Special Cargo vehicle.')
				end

				if routeBlip ~= _cargo.warehouseBlip then
					SetBlipRoute(_cargo.warehouseBlip, true)
					routeBlip = _cargo.warehouseBlip
				end

				if Player.DistanceTo(cargo.warehouse, true) < Settings.cargo.deliveryRadius then
					if GetPlayerWantedLevel(PlayerId()) ~= 0 then
						Gui.DisplayHelpText('You need to lose the cops first.')
					else
						TriggerServerEvent('lsv:specialCargoFinished')
						return
					end
				end
			elseif routeBlip ~= _cargo.vehicleBlip then
				SetBlipRoute(_cargo.vehicleBlip, true)
				routeBlip = _cargo.vehicleBlip
			end
		else
			TriggerEvent('lsv:specialCargoFinished', false, 'Time is over.')
			return
		end
	end
end)

AddEventHandler('lsv:init', function()
	WarMenu.CreateMenu('office', 'Office')
	WarMenu.SetSubTitle('office', 'Buy Crates to Start')
	WarMenu.SetTitleBackgroundColor('office', Color.PURPLE.r, Color.PURPLE.g, Color.PURPLE.b, Color.PURPLE.a)
	WarMenu.SetMenuButtonPressedSound('office', 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET')

	table.iforeach(_offices, function(office)
		office.blip = Map.CreatePlaceBlip(Blip.OFFICE, office.x, office.y, office.z, nil, Color.BLIP_PURPLE)
	end)

	local officeOpenedMenuIndex = nil
	local closestOfficeBlip = nil
	local officeColor = Color.PURPLE

	while true do
		Citizen.Wait(0)

		local isPlayerInFreeroam = Player.IsInFreeroam()
		local playerPosition = GetEntityCoords(PlayerPedId())
		local closestBlip = nil
		local closestBlipDistance = nil

		table.iforeach(_offices, function(office, officeIndex)
			if isPlayerInFreeroam then
				local officeDistance = GetDistanceBetweenCoords(office.x, office.y, office.z, playerPosition.x, playerPosition.y, playerPosition.z, true)

				if not closestBlipDistance or officeDistance < closestBlipDistance then
					closestBlipDistance = officeDistance
					closestBlip = office.blip
				end

				Gui.DrawPlaceMarker(office, officeColor)

				if officeDistance < Settings.placeMarker.radius then
					if not WarMenu.IsAnyMenuOpened() then
						Gui.DisplayHelpText('Press ~INPUT_PICKUP~ to start '..Settings.cargo.missionName..'.')

						if IsControlJustReleased(0, 38) then
							officeOpenedMenuIndex = officeIndex
							Gui.OpenMenu('office')
						end
					end
				elseif WarMenu.IsMenuOpened('office') and officeIndex == officeOpenedMenuIndex then
					WarMenu.CloseMenu()
				end
			end
		end)

		if closestBlip then
			if closestOfficeBlip ~= closestBlip then
				if closestOfficeBlip then
					SetBlipAsShortRange(closestOfficeBlip, true)
				end

				SetBlipAsShortRange(closestBlip, false)
				closestOfficeBlip = closestBlip
			end
		end

		if WarMenu.IsMenuOpened('office') then
			table.iforeach(Settings.cargo.crates, function(crate, crateIndex)
				if WarMenu.Button(crate.name, '$'..crate.price) then
					TriggerServerEvent('lsv:purchaseCargoCrate', crateIndex)
					Prompt.ShowAsync()
				end
			end)

			WarMenu.Display()
		end
	end
end)
