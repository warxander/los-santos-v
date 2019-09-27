local transaction = RemoteTransaction.New()

local vehicleAccessItems = { 'No-one', 'Crew', 'Everyone' }
local vehicleAccessCurrentIndex = 1
local vehiclePosition = { }


local lastVehicle = nil


local function updateDoorsLock()
	SetVehicleDoorsLockedForAllPlayers(Player.VehicleHandle, vehicleAccessCurrentIndex ~= 3)
	if vehicleAccessCurrentIndex == 2 then
		table.iforeach(Player.CrewMembers, function(member)
			SetVehicleDoorsLockedForPlayer(Player.VehicleHandle, GetPlayerFromServerId(member), false)
		end)
	end

	SetVehicleDoorsLockedForPlayer(Player.VehicleHandle, PlayerId(), false)
end

local function tryFindVehicleLocation()
	local playerPosition = Player.Position()
	local success, position, heading = GetClosestVehicleNodeWithHeading(playerPosition.x, playerPosition.y, playerPosition.z)
	if not success or Player.DistanceTo(position) > Settings.personalVehicle.maxDistance then
		Gui.DisplayPersonalNotification('Unable to deliver Personal Vehicle to your location.')
		return false
	end

	vehiclePosition.position = position
	vehiclePosition.heading = heading

	return true
end

local function getVehiclePrice(vehicle)
	if vehicle.prestige and Player.Prestige < vehicle.prestige then return 'Prestige '..vehicle.prestige end
	if vehicle.rank and Player.Rank < vehicle.rank then return 'Rank '..vehicle.rank end
	return '$'..vehicle.cash
end


local function requestVehicle(model)
	Streaming.RequestModel(model)
	Player.VehicleHandle = CreateVehicle(GetHashKey(model), vehiclePosition.position.x, vehiclePosition.position.y, vehiclePosition.position.z, vehiclePosition.heading, true, false)
	updateDoorsLock()
	SetVehicleNumberPlateText(Player.VehicleHandle, GetPlayerName(PlayerId()))
	SetVehicleOnGroundProperly(Player.VehicleHandle)

	local vehicleBlip = AddBlipForEntity(Player.VehicleHandle)
	SetBlipSprite(vehicleBlip, Blip.PersonalVehicleCar())
	SetBlipHighDetail(vehicleBlip, true)
	SetBlipColour(vehicleBlip, Color.BlipBlue())
	Map.SetBlipText(vehicleBlip, 'Personal Vehicle')
	Map.SetBlipFlashes(vehicleBlip)

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)

			if not DoesEntityExist(Player.VehicleHandle) or not IsVehicleDriveable(Player.VehicleHandle) then
				Gui.DisplayPersonalNotification('Your Personal Vehicle has been destroyed.')
				RemoveBlip(vehicleBlip)
				Player.VehicleHandle = nil
				return
			else
				local isPlayerInVehicle = IsPedInVehicle(PlayerPedId(), Player.VehicleHandle)
				SetBlipAlpha(vehicleBlip, isPlayerInVehicle and 0 or 255)
			end
		end
	end)
end


AddEventHandler('lsv:init', function()
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)

			if IsControlJustReleased(0, 246) then Gui.OpenMenu('vehicle') end
		end
	end)

	local selectedVehicleCategory = nil

	local vehicles = { }
	table.foreach(Settings.personalVehicle.vehicles, function(categoryVehicles, vehicleCategory)
		vehicles[vehicleCategory] = { }
		table.foreach(categoryVehicles, function(vehicleData, id)
			vehicleData.id = id
			table.insert(vehicles[vehicleCategory], vehicleData)
		end)
		table.sort(vehicles[vehicleCategory], function(lhs, rhs)
			if lhs.rank ~= rhs.rank then return lhs.rank < rhs.rank end
			if lhs.cash ~= rhs.cash then return lhs.cash < rhs.cash end
			return lhs.name < rhs.name
		end)
	end)

	WarMenu.CreateMenu('vehicle', '')
	WarMenu.SetMenuMaxOptionCountOnScreen('vehicle', Settings.maxMenuOptionCount)
	WarMenu.SetSubTitle('vehicle', 'Personal Vehicle Menu')
	WarMenu.SetTitleColor('vehicle', 255, 255, 255)
	WarMenu.SetTitleBackgroundColor('vehicle', 255, 255, 255)
	WarMenu.SetTitleBackgroundSprite('vehicle', 'shopui_title_carmod', 'shopui_title_carmod')

	WarMenu.CreateSubMenu('vehicle_categories', 'vehicle', 'Select Vehicle Category')
	WarMenu.CreateSubMenu('vehicle_vehicles', 'vehicle_categories')
	WarMenu.SetMenuButtonPressedSound('vehicle_vehicles', 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET')

	while true do
		if WarMenu.IsMenuOpened('vehicle') then
			if Player.VehicleHandle then
				if WarMenu.Button('Explode') then
					WarMenu.CloseMenu()
					Player.ExplodePersonalVehicle()
				else
					if WarMenu.ComboBox('Vehicle Access', vehicleAccessItems, vehicleAccessCurrentIndex, vehicleAccessCurrentIndex, function(currentIndex)
						if currentIndex ~= vehicleAccessCurrentIndex then
							vehicleAccessCurrentIndex = currentIndex
							updateDoorsLock()
						end
					end) then
					else
						if WarMenu.Button('Customize') then Gui.DisplayPersonalNotification('Not available yet.') end
					end
				end
			else
				if WarMenu.MenuButton('Rent', 'vehicle_categories') then
				elseif lastVehicle and WarMenu.Button(lastVehicle.name, getVehiclePrice(lastVehicle)) then
					if tryFindVehicleLocation() then
						WarMenu.CloseMenu()
						TriggerServerEvent('lsv:rentVehicle', lastVehicle.id, lastVehicle.category)
						transaction:WaitForEnding()
					end
				end
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('vehicle_categories') then
			table.foreach(vehicles, function(_, vehicleCategory)
				if WarMenu.MenuButton(vehicleCategory, 'vehicle_vehicles') then
					WarMenu.SetSubTitle('vehicle_vehicles', vehicleCategory)
					selectedVehicleCategory = vehicleCategory
				end
			end)

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('vehicle_vehicles') then
			table.foreach(vehicles[selectedVehicleCategory], function(vehicle, _)
				if WarMenu.Button(vehicle.name, getVehiclePrice(vehicle)) then
					if vehicle.prestige and vehicle.prestige > Player.Prestige then
						Gui.DisplayPersonalNotification('Your Prestige is too low.')
					elseif vehicle.rank and vehicle.rank > Player.Rank then
						Gui.DisplayPersonalNotification('Your Rank is too low.')
					elseif tryFindVehicleLocation() then
						lastVehicle = vehicle
						lastVehicle.category = selectedVehicleCategory
						WarMenu.CloseMenu()
						TriggerServerEvent('lsv:rentVehicle', vehicle.id, selectedVehicleCategory)
						transaction:WaitForEnding()
					end
				end
			end)

			WarMenu.Display()
		end

		Citizen.Wait(0)
	end
end)


RegisterNetEvent('lsv:vehicleRented')
AddEventHandler('lsv:vehicleRented', function(model, name)
	if not model then
		Gui.DisplayPersonalNotification('You don\'t have enough cash.')
		transaction:Finish()
		return
	end

	requestVehicle(model)
	Gui.DisplayPersonalNotification('You have rented '..name..'.')
	transaction:Finish()
end)
