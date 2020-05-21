local _vehicleAccessItems = { 'No-one', 'Crew', 'Everyone' }
local _vehicleAccessCurrentIndex = 1
local _vehiclePosition = { }

local _vehicleIndex = nil

local function updateDoorsLock()
	SetVehicleDoorsLockedForAllPlayers(Player.VehicleHandle, _vehicleAccessCurrentIndex ~= 3)
	if _vehicleAccessCurrentIndex == 2 then
		table.foreach(Player.CrewMembers, function(_, member)
			SetVehicleDoorsLockedForPlayer(Player.VehicleHandle, GetPlayerFromServerId(member), false)
		end)
	end

	SetVehicleDoorsLockedForPlayer(Player.VehicleHandle, PlayerId(), false)
end

local function updateVehicle()
	updateDoorsLock()
end

local function getRerollColorsPrice()
	local rerollColorsCount = Player.Vehicles[_vehicleIndex].rerollColorsCount or 0
	return '$'..Settings.personalVehicle.rerollColorsPrice.base + (rerollColorsCount * Settings.personalVehicle.rerollColorsPrice.perRoll)
end

local function requestVehicle(vehicleData)
	Player.DestroyPersonalVehicle()

	Streaming.RequestModelAsync(vehicleData.model)
	Player.VehicleHandle = CreateVehicle(GetHashKey(vehicleData.model), _vehiclePosition.position.x, _vehiclePosition.position.y, _vehiclePosition.position.z, _vehiclePosition.heading, true, true)

	Vehicle.ApplyMods(Player.VehicleHandle, vehicleData)
	updateVehicle()
	SetVehicleNumberPlateText(Player.VehicleHandle, GetPlayerName(PlayerId()))
	SetVehicleMod(Player.VehicleHandle, 16, 1) -- Armor 40%
	SetVehicleTyresCanBurst(Player.VehicleHandle, false)
	SetVehicleOnGroundProperly(Player.VehicleHandle)

	local vehicleBlip = AddBlipForEntity(Player.VehicleHandle)
	SetBlipSprite(vehicleBlip, Blip.CAR)
	SetBlipHighDetail(vehicleBlip, true)
	Map.SetBlipText(vehicleBlip, 'Personal Vehicle')
	Map.SetBlipFlashes(vehicleBlip)

	Citizen.CreateThread(function()
		local vehicleHandle = Player.VehicleHandle
		local vehicleBlip = vehicleBlip

		while true do
			Citizen.Wait(250)

			if not DoesEntityExist(vehicleHandle) or not IsVehicleDriveable(vehicleHandle) then
				if DoesBlipExist(vehicleBlip) then
					RemoveBlip(vehicleBlip)
				end

				if DoesEntityExist(vehicleHandle) then
					World.MarkVehicleToDelete(vehicleHandle)
				end

				if Player.VehicleHandle == vehicleHandle then
					Gui.DisplayPersonalNotification('Your Personal Vehicle has been destroyed.')
					Player.VehicleHandle = nil
				end

				return
			else
				local isPlayerInVehicle = IsPedInVehicle(PlayerPedId(), vehicleHandle)
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
			Vehicle.ApplyMods(Player.VehicleHandle, Player.Vehicles[vehicleIndex])
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
