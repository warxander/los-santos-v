local _vehicleAccessItems = { 'No-one', 'Crew', 'Everyone' }
local _vehicleAccessCurrentIndex = 1
local _vehiclePosition = { }

local _vehicleIndex = nil

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

local function requestVehicle(vehicleData)
	Player.DestroyPersonalVehicle()

	Player.VehicleHandle = Network.CreateVehicleAsync(GetHashKey(vehicleData.model), _vehiclePosition.position, _vehiclePosition.heading)
	if not Player.VehicleHandle then
		return --TODO:
	end

	local vehicle = NetToVeh(Player.VehicleHandle)

	Vehicle.ApplyMods(vehicle, vehicleData)
	updateVehicle(vehicle)
	SetVehicleNumberPlateText(vehicle, GetPlayerName(PlayerId()))
	SetVehicleMod(vehicle, 16, 1) -- Armor 40%
	SetVehicleTyresCanBurst(vehicle, false)
	SetVehicleOnGroundProperly(vehicle)

	local vehicleBlip = AddBlipForEntity(vehicle)
	SetBlipSprite(vehicleBlip, Blip.CAR)
	SetBlipHighDetail(vehicleBlip, true)
	Map.SetBlipText(vehicleBlip, 'Personal Vehicle')
	Map.SetBlipFlashes(vehicleBlip)

	Citizen.CreateThread(function()
		local vehicleHandle = Player.VehicleHandle
		local vehicleBlip = vehicleBlip

		while true do
			Citizen.Wait(250)

			local vehicle = NetToVeh(vehicleHandle)

			if not DoesEntityExist(vehicle) or not IsVehicleDriveable(vehicle) then
				if DoesBlipExist(vehicleBlip) then
					RemoveBlip(vehicleBlip)
				end

				Network.DeleteVehicle(vehicleHandle)

				if Player.VehicleHandle == vehicleHandle then
					Gui.DisplayPersonalNotification('Your Personal Vehicle has been destroyed.')
					Player.VehicleHandle = nil
				end

				return
			else
				local isPlayerInVehicle = IsPedInVehicle(PlayerPedId(), vehicle)
				SetBlipAlpha(vehicleBlip, isPlayerInVehicle and 0 or 255)
			end
		end
	end)
end

RegisterNetEvent('lsv:vehicleRented')
AddEventHandler('lsv:vehicleRented', function(vehicleIndex)
	if vehicleIndex then
		_vehicleIndex = vehicleIndex

		local vehicleData = Player.Vehicles[vehicleIndex]
		requestVehicle(vehicleData)
		Prompt.Hide()

		WarMenu.SetSubTitle('vehicle', Player.GetVehicleName(vehicleIndex))

		PlaySoundFrontend(-1, 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET')
		WarMenu.CloseMenu()
	else
		Gui.DisplayPersonalNotification('You don\'t have enough cash.')
	end
end)

RegisterNetEvent('lsv:rerollVehicleColors')
AddEventHandler('lsv:rerollVehicleColors', function(vehicleIndex)
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
	Gui.CreateMenu('vehicle', '')
	WarMenu.SetSubTitle('vehicle', 'Personal Vehicle Menu')
	WarMenu.SetTitleColor('vehicle', 255, 255, 255)
	WarMenu.SetTitleBackgroundColor('vehicle', 255, 255, 255)
	WarMenu.SetTitleBackgroundSprite('vehicle', 'shopui_title_carmod', 'shopui_title_carmod')

	WarMenu.CreateSubMenu('rerollColors_confirm', 'vehicle', '')
	WarMenu.SetMenuButtonPressedSound('rerollColors_confirm', 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET')

	local needToUpdateSlots = true
	local showVehicleList = false

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
				if WarMenu.Button('Deliver Another Vehicle') then
					showVehicleList = true
				else
					if WarMenu.ComboBox('Vehicle Access', _vehicleAccessItems, _vehicleAccessCurrentIndex, _vehicleAccessCurrentIndex, function(currentIndex)
						if currentIndex ~= _vehicleAccessCurrentIndex then
							_vehicleAccessCurrentIndex = currentIndex
							updateDoorsLock()
						end
					end) then
					elseif WarMenu.MenuButton('Reroll Vehicle Colors', 'rerollColors_confirm', getRerollColorsPrice()) then
						WarMenu.SetSubTitle('rerollColors_confirm', 'Reroll Vehicle Colors for '..getRerollColorsPrice()..'?')
					end
				end
			else
				table.iforeach(Player.Vehicles, function(vehicle, vehicleIndex)
					if WarMenu.Button(Player.GetVehicleName(vehicleIndex), '$'..Settings.personalVehicle.rentPrice) then
						_vehiclePosition = World.TryGetClosestVehicleNode(PlayerPedId(), Settings.personalVehicle.maxDistance)
						if _vehiclePosition then
							TriggerServerEvent('lsv:rentVehicle', vehicleIndex)
							Prompt.ShowAsync()
						else
							Gui.DisplayPersonalNotification('Unable to deliver Personal Vehicle to your location.')
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
