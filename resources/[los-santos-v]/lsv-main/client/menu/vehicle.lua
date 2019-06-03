local transaction = RemoteTransaction.New()

local vehicleAccessItems = { 'No-one', 'Crew', 'Everyone' }
local vehicleAccessCurrentIndex = 1

local function updateDoorsLock()
	SetVehicleDoorsLockedForAllPlayers(Player.VehicleHandle, vehicleAccessCurrentIndex ~= 3)
	if vehicleAccessCurrentIndex == 2 then
		table.iforeach(Player.CrewMembers, function(member)
			SetVehicleDoorsLockedForPlayer(Player.VehicleHandle, GetPlayerFromServerId(member), false)
		end)
	end

	SetVehicleDoorsLockedForPlayer(Player.VehicleHandle, PlayerId(), false)
end

local function requestVehicle()
	local playerPosition = Player.Position()
	local success, position, heading = GetClosestVehicleNodeWithHeading(playerPosition.x, playerPosition.y, playerPosition.z)

	if not success or Player.DistanceTo(position) > Settings.personalVehicle.maxDistance then
		Gui.DisplayPersonalNotification('Failed to deliver Personal Vehicle to your location.')
		return
	end

	local model = Player.Vehicle.model
	Streaming.RequestModel(model)
	Player.VehicleHandle = CreateVehicle(GetHashKey(model), position.x, position.y, position.z, heading, true, false)
	SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(Player.VehicleHandle), true)
	SetVehicleColours(Player.VehicleHandle, Player.Vehicle.color.primary, Player.Vehicle.color.secondary)
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

	Streaming.RequestModel('a_f_y_business_04')
	local driver = CreatePedInsideVehicle(Player.VehicleHandle, 4, GetHashKey('a_f_y_business_04'), -1)
	SetBlockingOfNonTemporaryEvents(driver, true)
	SetPedFleeAttributes(driver, 0, 0)

	local _, taskSequence = OpenSequenceTask()
	TaskLeaveVehicle(0, Player.VehicleHandle, 256)
	TaskWanderStandard(0, 10.0, 10)
	CloseSequenceTask(taskSequence)
	TaskPerformSequence(driver, taskSequence)
	ClearSequenceTask(taskSequence)
end

local function getVehicleHealthPerCent()
	return math.floor(GetEntityHealth(Player.VehicleHandle) / GetEntityMaxHealth(Player.VehicleHandle) * 100)
end


AddEventHandler('lsv:init', function()
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)

			if IsControlJustReleased(0, 246) then Gui.OpenMenu('vehicle') end
		end
	end)

	local selectedVehicleCategory = nil

	WarMenu.CreateMenu('vehicle', '')
	WarMenu.SetMenuMaxOptionCountOnScreen('vehicle', Settings.maxMenuOptionCount)
	WarMenu.SetSubTitle('vehicle', 'Personal Vehicle Menu')
	WarMenu.SetTitleColor('vehicle', 255, 255, 255)
	WarMenu.SetTitleBackgroundColor('vehicle', 255, 255, 255)
	WarMenu.SetTitleBackgroundSprite('vehicle', 'shopui_title_carmod', 'shopui_title_carmod')

	WarMenu.CreateSubMenu('vehicle_categories', 'vehicle', 'Select Vehicle Category')
	WarMenu.CreateSubMenu('vehicle_vehicles', 'vehicle_categories')
	WarMenu.SetMenuButtonPressedSound('vehicle_vehicles', 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET')

	WarMenu.CreateSubMenu('vehicle_sell', 'vehicle', 'Are you sure?')

	while true do
		if WarMenu.IsMenuOpened('vehicle') then
			if Player.VehicleHandle then
				if WarMenu.Button('Explode') then
					WarMenu.CloseMenu()
					Player.ExplodePersonalVehicle()
				else
					local vehicleHealthToRepair = 100 - getVehicleHealthPerCent()
					if WarMenu.Button('Repair', '$'..tostring(vehicleHealthToRepair * Settings.personalVehicle.repairCashPerCent)) and vehicleHealthToRepair ~= 0 then
						WarMenu.CloseMenu()
						TriggerServerEvent('lsv:repairVehicle', vehicleHealthToRepair)
						transaction:WaitForEnding()
					end
				end
			elseif Player.Vehicle then
				if WarMenu.Button('Request') then
					WarMenu.CloseMenu()
					requestVehicle()
				end
			end

			if Player.Vehicle then
				if Player.VehicleHandle and WarMenu.ComboBox('Vehicle Access', vehicleAccessItems, vehicleAccessCurrentIndex, vehicleAccessCurrentIndex, function(currentIndex)
					if currentIndex ~= vehicleAccessCurrentIndex then
						vehicleAccessCurrentIndex = currentIndex
						updateDoorsLock()
					end
				end) then
				elseif WarMenu.Button('Customize') then
					if not Player.VehicleHandle then Gui.DisplayPersonalNotification('You should request it first.')
					else Gui.DisplayPersonalNotification('Not available yet.') end
				elseif WarMenu.MenuButton('~r~Sell', 'vehicle_sell') then
				end
			else
				if WarMenu.MenuButton('Purchase', 'vehicle_categories') then
				end
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('vehicle_categories') then
			table.foreach(Settings.personalVehicle.vehicles, function(_, vehicleCategory)
				if WarMenu.MenuButton(vehicleCategory, 'vehicle_vehicles') then
					WarMenu.SetSubTitle('vehicle_vehicles', vehicleCategory)
					selectedVehicleCategory = vehicleCategory
				end
			end)

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('vehicle_vehicles') then
			table.foreach(Settings.personalVehicle.vehicles[selectedVehicleCategory], function(vehicle, model)
				if WarMenu.Button(vehicle.name, '$'..vehicle.cash) then
					WarMenu.CloseMenu()
					TriggerServerEvent('lsv:purchaseVehicle', model, selectedVehicleCategory)
					transaction:WaitForEnding()
				end
			end)

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('vehicle_sell') then
			if WarMenu.MenuButton('No', 'vehicle') then
			elseif WarMenu.Button('Yes') then
				WarMenu.CloseMenu()
				TriggerServerEvent('lsv:sellVehicle', Player.Vehicle.model)
				transaction:WaitForEnding()
			end

			WarMenu.Display()
		end

		Citizen.Wait(0)
	end
end)


RegisterNetEvent('lsv:vehiclePurchased')
AddEventHandler('lsv:vehiclePurchased', function(vehicle)
	if not vehicle then
		Gui.DisplayPersonalNotification('You don\'t have enough cash.')
		transaction:Finish()
		return
	end

	Player.Vehicle = vehicle
	requestVehicle()

	Gui.DisplayPersonalNotification('You have purchased '..vehicle.name..'.')
	transaction:Finish()
end)


RegisterNetEvent('lsv:vehicleSold')
AddEventHandler('lsv:vehicleSold', function(name)
	Gui.DisplayPersonalNotification('You have sold '..name..'.')

	Player.Vehicle = nil

	if Player.VehicleHandle then
		SetEntityAsMissionEntity(Player.VehicleHandle, true, true)
		DeleteEntity(Player.VehicleHandle)
	end

	transaction:Finish()
end)


RegisterNetEvent('lsv:vehicleRepaired')
AddEventHandler('lsv:vehicleRepaired', function(success)
	if not Player.VehicleHandle then
		transaction:Finish()
		return
	end

	if not success then
		Gui.DisplayPersonalNotification('You don\'t have enough cash.')
		transaction:Finish()
		return
	end

	SetVehicleEngineHealth(Player.VehicleHandle, 1000.)
	SetVehicleFixed(Player.VehicleHandle)

	Gui.DisplayPersonalNotification('Your Personal Vehicle has been repaired.')
	transaction:Finish()
end)
