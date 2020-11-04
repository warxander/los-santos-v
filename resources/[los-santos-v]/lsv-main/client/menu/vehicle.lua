local _vehicleAccessItems = { 'No-one', 'Crew', 'Everyone' }
local _vehicleAccessCurrentIndex = 1
local _vehiclePosition = { }

local _vehicleIndex = nil
local _vehicleData = nil

local _rentTimer = nil

local _vehicleCustomizableMods = {
	['0'] = 'Spoilers',
	['1'] = 'Front Bumpers',
	['2'] = 'Rear Bumpers',
	['3'] = 'Skirts',
	['4'] = 'Exhausts',
	['5'] = 'Roll Cage',
	['6'] = 'Grille',
	['7'] = 'Hood',
	['8'] = 'Fenders',
	['23'] = 'Wheels',
	['24'] = 'Back Wheels',
	['25'] = 'Plate Holders',
	['26'] = 'Vanity Plates',
	['27'] = 'Trim Design',
	['28'] = 'Ornaments',
	['29'] = 'Dashboard',
	['30'] = 'Dials',
	['31'] = 'Door Speakers',
	['32'] = 'Seats',
	['33'] = 'Steering Wheels',
	['34'] = 'Shifter Leavers',
	['35'] = 'Plaques',
	['36'] = 'Speakers',
	['42'] = 'Arch Cover',
	['43'] = 'Aerials',
	['44'] = 'Roof Scoops',
	['46'] = 'Doors',
	['48'] = 'Liveries',
}

local function updateDoorsLock(vehicle)
	SetVehicleDoorsLockedForAllPlayers(vehicle, _vehicleAccessCurrentIndex ~= 3)
	if _vehicleAccessCurrentIndex == 2 then
		table.foreach(Player.CrewMembers, function(_, member)
			SetVehicleDoorsLockedForPlayer(vehicle, GetPlayerFromServerId(member), false)
		end)
	end

	SetVehicleDoorsLockedForPlayer(vehicle, PlayerId(), false)
end

local function updateVehicle(vehicle)
	updateDoorsLock(vehicle)
end

local function getRerollColorsPrice()
	local rerollColorsCount = Player.Vehicles[_vehicleIndex].rerollColorsCount or 0
	return '$'..Settings.personalVehicle.rerollColorsPrice.base + (rerollColorsCount * Settings.personalVehicle.rerollColorsPrice.perRoll)
end

local function getRentTimer()
	if _rentTimer then
		local rentElapsed = Settings.personalVehicle.rentTimeout - _rentTimer:elapsed()
		if rentElapsed >= 0 then
			return string.from_ms(rentElapsed)
		end
	end

	return nil
end

local function requestVehicleAsync(vehicleData)
	Player.DestroyPersonalVehicle()

	local modelHash = GetHashKey(vehicleData.model)
	Streaming.RequestModelAsync(modelHash)

	Player.VehicleHandle = Network.CreateVehicle(modelHash, _vehiclePosition.position, _vehiclePosition.heading, { personal = true })

	local vehicle = NetToVeh(Player.VehicleHandle)

	Vehicle.ApplyMods(vehicle, vehicleData)
	updateVehicle(vehicle)
	SetVehicleNumberPlateText(vehicle, GetPlayerName(PlayerId()))
	SetVehicleTyresCanBurst(vehicle, false)
	SetEntityLoadCollisionFlag(vehicle, true)
	SetVehicleOnGroundProperly(vehicle)

	local vehicleBlip = AddBlipForEntity(vehicle)
	SetBlipSprite(vehicleBlip, Blip.CAR)
	SetBlipHighDetail(vehicleBlip, true)
	Map.SetBlipText(vehicleBlip, 'Personal Vehicle')
	Map.SetBlipFlashes(vehicleBlip)
end

RegisterNetEvent('lsv:vehicleRented')
AddEventHandler('lsv:vehicleRented', function(vehicleIndex)
	if vehicleIndex then
		_vehicleIndex = vehicleIndex
		_vehicleData = Player.Vehicles[_vehicleIndex]

		requestVehicleAsync(_vehicleData)
		Prompt.Hide()

		WarMenu.SetSubTitle('vehicle', Player.GetVehicleName(vehicleIndex))

		PlaySoundFrontend(-1, 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET')
		WarMenu.CloseMenu()

		if not _rentTimer then
			_rentTimer = Timer.New()
		else
			_rentTimer:restart()
		end
	else
		Gui.DisplayPersonalNotification('You don\'t have enough cash.')
	end
end)

RegisterNetEvent('lsv:vehicleCustomized')
AddEventHandler('lsv:vehicleCustomized', function(vehicleIndex)
	WarMenu.CloseMenu()
	Prompt.Hide()

	if vehicleIndex then
		if Player.VehicleHandle and _vehicleIndex == vehicleIndex then
			Vehicle.ApplyMods(NetToVeh(Player.VehicleHandle), Player.Vehicles[vehicleIndex])
		end
	else
		Gui.DisplayPersonalNotification('You don\'t have enough cash.')
	end
end)

AddEventHandler('lsv:init', function()
	while true do
		Citizen.Wait(0)

		if IsControlJustReleased(0, 246) then
			if table.length(Player.Garages) == 0 then
				Gui.DisplayPersonalNotification('You need to purchase Garage first.')
			else
				Gui.OpenMenu('vehicle')
			end
		end
	end
end)

AddEventHandler('lsv:init', function()
	World.AddVehicleHandler(function(vehicle)
		if not NetworkGetEntityIsNetworked(vehicle) then
			return
		end

		local netId = VehToNet(vehicle)
		if not Network.DoesEntityExistWithNetworkId(netId) or not Network.GetData(netId, 'personal') or Network.GetCreator(netId) ~= Player.ServerId() then
			return
		end

		local blip = GetBlipFromEntity(vehicle)

		if not IsVehicleDriveable(vehicle) then
			if DoesBlipExist(blip) then
				RemoveBlip(blip)
			end

			Network.DeleteVehicle(netId, 5000)

			Gui.DisplayPersonalNotification('Your Personal Vehicle has been destroyed.')

			if Player.VehicleHandle == netId then
				Player.VehicleHandle = nil
			end
		else
			SetBlipAlpha(blip, IsPedInVehicle(PlayerPedId(), vehicle) and 0 or 255)
		end
	end)
end)

AddEventHandler('lsv:init', function()
	Gui.CreateMenu('vehicle', '')
	WarMenu.SetSubTitle('vehicle', 'Personal Vehicle Menu')
	WarMenu.SetTitleColor('vehicle', 255, 255, 255)
	WarMenu.SetTitleBackgroundColor('vehicle', 255, 255, 255)
	WarMenu.SetTitleBackgroundSprite('vehicle', 'shopui_title_carmod', 'shopui_title_carmod')

	WarMenu.CreateSubMenu('vehicle_customize', 'vehicle', 'Customize')
	WarMenu.SetMenuButtonPressedSound('vehicle_customize', 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET')

	WarMenu.CreateSubMenu('rerollColors_confirm', 'vehicle', '')
	WarMenu.SetMenuButtonPressedSound('rerollColors_confirm', 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET')

	local needToUpdateSlots = true
	local showVehicleList = false

	local vehicleMods = nil

	while true do
		Citizen.Wait(0)

		if WarMenu.IsMenuOpened('vehicle') then
			if needToUpdateSlots then
				if not Player.VehicleHandle then
					WarMenu.SetSubTitle('vehicle', table.length(Player.Vehicles)..' of '..Player.GetGaragesCapacity()..' garage slots used')
				end
				needToUpdateSlots = false
			end

			if Player.VehicleHandle and not showVehicleList then
				if WarMenu.Button('Request Personal Vehicle', getRentTimer()) then
					if not _rentTimer or _rentTimer:elapsed() >= Settings.personalVehicle.rentTimeout then
						showVehicleList = true
					end
				else
					if WarMenu.ComboBox('Vehicle Access', _vehicleAccessItems, _vehicleAccessCurrentIndex, _vehicleAccessCurrentIndex, function(currentIndex)
						if currentIndex ~= _vehicleAccessCurrentIndex then
							_vehicleAccessCurrentIndex = currentIndex
							updateDoorsLock(NetToVeh(Player.VehicleHandle))
						end
					end) then
					elseif WarMenu.MenuButton('Customize', 'vehicle_customize') then
						vehicleMods = { }
					elseif WarMenu.MenuButton('Reroll Vehicle Colors', 'rerollColors_confirm', getRerollColorsPrice()) then
						WarMenu.SetSubTitle('rerollColors_confirm', 'Reroll Vehicle Colors for '..getRerollColorsPrice()..'?')
					end
				end
			else
				local rentElapsed = getRentTimer()

				for vehicleIndex, vehicle in ipairs(Player.Vehicles) do
					local vehicleTier = Vehicle.GetTier(vehicle.model)

					if WarMenu.Button(Player.GetVehicleName(vehicleIndex), rentElapsed or '$'..Settings.personalVehicle.rentPrice[vehicleTier]) then
						if not _rentTimer or _rentTimer:elapsed() >= Settings.personalVehicle.rentTimeout then
							if not IsPedOnFoot(PlayerPedId()) then
								Gui.DisplayPersonalNotification('You need to be on foot.')
							else
								_vehiclePosition = World.TryGetClosestVehicleNode(PlayerPedId(), Settings.personalVehicle.maxDistance)
								if _vehiclePosition then
									TriggerServerEvent('lsv:rentVehicle', vehicleIndex, vehicleTier)
									Prompt.ShowAsync()
								else
									Gui.DisplayPersonalNotification('Unable to deliver Personal Vehicle to your location.')
								end
							end
						end
					end
				end
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('vehicle_customize') then
			local vehicle = NetToVeh(Player.VehicleHandle)
			local price = table.length(vehicleMods) * Settings.personalVehicle.customizePricePerMod

			if WarMenu.Button('~r~Confirm', '$'..price) then
				if price == 0 then
					Gui.DisplayPersonalNotification('Nothing to change.')
				else
					TriggerServerEvent('lsv:customizeVehicle', _vehicleIndex, vehicleMods)
					Prompt.ShowAsync()
				end
			else
				table.foreach(_vehicleCustomizableMods, function(name, modTypeStr)
					local modType = tonumber(modTypeStr)
					local modNum = GetNumVehicleMods(vehicle, modType)
					if modNum ~= 0 then
						local modIndex = GetVehicleMod(vehicle, modType)
						if WarMenu.Button(name, modIndex) then
							modIndex = modIndex + 1
							SetVehicleMod(vehicle, modType, modIndex)

							modIndex = GetVehicleMod(vehicle, modType)
							if modIndex == -1 then
								vehicleMods[modTypeStr] = _vehicleData.mods[modTypeStr] and modIndex or nil
							else
								vehicleMods[modTypeStr] = _vehicleData.mods[modTypeStr] ~= modIndex and modIndex or nil
							end
						end
					end
				end)
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('rerollColors_confirm') then
			if WarMenu.MenuButton('No', 'vehicle') then
			elseif WarMenu.Button('~r~Yes') then
				TriggerServerEvent('lsv:rerollVehicleColors', _vehicleIndex)
				Prompt.ShowAsync()
			end

			WarMenu.Display()
		else
			needToUpdateSlots = true
			showVehicleList = false
		end
	end
end)
