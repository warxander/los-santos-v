local _vehicleColors = {
	['Classic'] = {
		{ name = 'Black', id = 0 },
		{ name = 'Carbon Black', id = 147 },
		{ name = 'Graphite', id = 1 },
		{ name = 'Anhracite Black', id = 11 },
		{ name = 'Black Steel', id = 2 },
		{ name = 'Dark Steel', id = 3 },
		{ name = 'Silver', id = 4 },
		{ name = 'Bluish Silver', id = 5 },
		{ name = 'Rolled Steel', id = 6 },
		{ name = 'Shadow Silver', id = 7 },
		{ name = 'Stone Silver', id = 8 },
		{ name = 'Midnight Silver', id = 9 },
		{ name = 'Cast Iron Silver', id = 10 },
		{ name = 'Red', id = 27 },
		{ name = 'Torino Red', id = 28 },
		{ name = 'Formula Red', id = 29 },
		{ name = 'Lava Red', id = 150 },
		{ name = 'Blaze Red', id = 30 },
		{ name = 'Grace Red', id = 31 },
		{ name = 'Garnet Red', id = 32 },
		{ name = 'Sunset Red', id = 33 },
		{ name = 'Cabernet Red', id = 34 },
		{ name = 'Wine Red', id = 143 },
		{ name = 'Candy Red', id = 35 },
		{ name = 'Hot Pink', id = 135 },
		{ name = 'Pfsiter Pink', id = 137 },
		{ name = 'Salmon Pink', id = 136 },
		{ name = 'Sunrise Orange', id = 36 },
		{ name = 'Orange', id = 38 },
		{ name = 'Bright Orange', id = 138 },
		{ name = 'Gold', id = 99 },
		{ name = 'Bronze', id = 90 },
		{ name = 'Yellow', id = 88 },
		{ name = 'Race Yellow', id = 89 },
		{ name = 'Dew Yellow', id = 91 },
		{ name = 'Dark Green', id = 49 },
		{ name = 'Racing Green', id = 50 },
		{ name = 'Sea Green', id = 51 },
		{ name = 'Olive Green', id = 52 },
		{ name = 'Bright Green', id = 53 },
		{ name = 'Gasoline Green', id = 54 },
		{ name = 'Lime Green', id = 92 },
		{ name = 'Midnight Blue', id = 141 },
		{ name = 'Galaxy Blue', id = 61 },
		{ name = 'Dark Blue', id = 62 },
		{ name = 'Saxon Blue', id = 63 },
		{ name = 'Blue', id = 64 },
		{ name = 'Mariner Blue', id = 65 },
		{ name = 'Harbor Blue', id = 66 },
		{ name = 'Diamond Blue', id = 67 },
		{ name = 'Surf Blue', id = 68 },
		{ name = 'Nautical Blue', id = 69 },
		{ name = 'Racing Blue', id = 73 },
		{ name = 'Ultra Blue', id = 70 },
		{ name = 'Light Blue', id = 74 },
		{ name = 'Chocolate Brown', id = 96 },
		{ name = 'Bison Brown', id = 101 },
		{ name = 'Creeen Brown', id = 95 },
		{ name = 'Feltzer Brown', id = 94 },
		{ name = 'Maple Brown', id = 97 },
		{ name = 'Beechwood Brown', id = 103 },
		{ name = 'Sienna Brown', id = 104 },
		{ name = 'Saddle Brown', id = 98 },
		{ name = 'Moss Brown', id = 100 },
		{ name = 'Woodbeech Brown', id = 102 },
		{ name = 'Straw Brown', id = 99 },
		{ name = 'Sandy Brown', id = 105 },
		{ name = 'Bleached Brown', id = 106 },
		{ name = 'Schafter Purple', id = 71 },
		{ name = 'Spinnaker Purple', id = 72 },
		{ name = 'Midnight Purple', id = 142 },
		{ name = 'Bright Purple', id = 145 },
		{ name = 'Cream', id = 107 },
		{ name = 'Ice White', id = 111 },
		{ name = 'Frost White', id = 112 },
	},

	['Matte'] = {
		{ name = 'Black', id = 12 },
		{ name = 'Gray', id = 13 },
		{ name = 'Light Gray', id = 14 },
		{ name = 'Ice White', id = 131 },
		{ name = 'Blue', id = 83 },
		{ name = 'Dark Blue', id = 82 },
		{ name = 'Midnight Blue', id = 84 },
		{ name = 'Midnight Purple', id = 149 },
		{ name = 'Schafter Purple', id = 148 },
		{ name = 'Red', id = 39 },
		{ name = 'Dark Red', id = 40 },
		{ name = 'Orange', id = 41 },
		{ name = 'Yellow', id = 42 },
		{ name = 'Lime Green', id = 55 },
		{ name = 'Green', id = 128 },
		{ name = 'Forest Green', id = 151 },
		{ name = 'Foliage Green', id = 155 },
		{ name = 'Olive Darb', id = 152 },
		{ name = 'Dark Earth', id = 153 },
		{ name = 'Desert Tan', id = 154 },
	},

	['Metal'] = {
		{ name = 'Brushed Steel', id = 117 },
		{ name = 'Brushed Black Steel', id = 118 },
		{ name = 'Brushed Aluminum', id = 119 },
		{ name = 'Pure Gold', id = 158 },
		{ name = 'Brushed Gold', id = 159 },
	},
}

local _vehicleAccessItems = { 'No-one', 'Crew', 'Everyone' }
local _vehicleAccessCurrentIndex = 1
local _vehiclePosition = { }
local _vehicleColor = { primary = 0, secondary = 0 }

local _lastVehicle = nil

local function updateDoorsLock()
	SetVehicleDoorsLockedForAllPlayers(Player.VehicleHandle, _vehicleAccessCurrentIndex ~= 3)
	if _vehicleAccessCurrentIndex == 2 then
		table.iforeach(Player.CrewMembers, function(member)
			SetVehicleDoorsLockedForPlayer(Player.VehicleHandle, GetPlayerFromServerId(member), false)
		end)
	end

	SetVehicleDoorsLockedForPlayer(Player.VehicleHandle, PlayerId(), false)
end

local function updateColor()
	SetVehicleColours(Player.VehicleHandle, _vehicleColor.primary, _vehicleColor.secondary)
end

local function updateVehicle()
	updateDoorsLock()
	updateColor()
end

local function tryFindVehicleLocation()
	local playerPosition = Player.Position()
	local success, position, heading = GetClosestVehicleNodeWithHeading(playerPosition.x, playerPosition.y, playerPosition.z)
	if not success or Player.DistanceTo(position) > Settings.personalVehicle.maxDistance then
		Gui.DisplayPersonalNotification('Unable to deliver Personal Vehicle to your location.')
		return false
	end

	_vehiclePosition.position = position
	_vehiclePosition.heading = heading

	return true
end

local function getVehiclePrice(vehicle)
	if vehicle.prestige and Player.Prestige < vehicle.prestige then
		return 'Prestige '..vehicle.prestige
	end

	if vehicle.rank and Player.Rank < vehicle.rank then
		return 'Rank '..vehicle.rank
	end

	local price = vehicle.cash
	if Player.PatreonTier ~= 0 then
		price = math.floor(price * Settings.patreon.rent[Player.PatreonTier])
	end

	return '$'..price
end

local function requestVehicle(model)
	Streaming.RequestModelAsync(model)
	Player.VehicleHandle = CreateVehicle(GetHashKey(model), _vehiclePosition.position.x, _vehiclePosition.position.y, _vehiclePosition.position.z, _vehiclePosition.heading, true, false)
	updateVehicle()
	SetVehicleNumberPlateText(Player.VehicleHandle, GetPlayerName(PlayerId()))
	SetVehicleModKit(Player.VehicleHandle, 0) -- Make SetVehicleMod actually works
	SetVehicleMod(Player.VehicleHandle, 16, 1) -- Armor 40%
	SetVehicleTyresCanBurst(Player.VehicleHandle, false)
	SetVehicleOnGroundProperly(Player.VehicleHandle)

	local vehicleBlip = AddBlipForEntity(Player.VehicleHandle)
	SetBlipSprite(vehicleBlip, Blip.CAR)
	SetBlipHighDetail(vehicleBlip, true)
	SetBlipColour(vehicleBlip, Color.BLIP_BLUE)
	Map.SetBlipText(vehicleBlip, 'Personal Vehicle')
	Map.SetBlipFlashes(vehicleBlip)

	Citizen.CreateThread(function()
		local vehicleHandle = Player.VehicleHandle
		local vehicleBlip = vehicleBlip

		while true do
			Citizen.Wait(250)

			if not DoesEntityExist(vehicleHandle) or not IsVehicleDriveable(vehicleHandle) then
				Gui.DisplayPersonalNotification('Your Personal Vehicle has been destroyed.')
				RemoveBlip(vehicleBlip)
				if Player.VehicleHandle == vehicleHandle then
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
AddEventHandler('lsv:vehicleRented', function(model, name)
	if not model then
		Gui.DisplayPersonalNotification('You can\'t rent this vehicle.')
		Prompt.Hide()
		return
	end

	requestVehicle(model)
	Gui.DisplayPersonalNotification('You have rented '..name..'.')
	Prompt.Hide()
end)

AddEventHandler('lsv:init', function()
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)

			if IsControlJustReleased(0, 246) then
				Gui.OpenMenu('vehicle')
			end
		end
	end)

	local selectedVehicleCategory = nil
	local selectedVehicleColor = nil
	local selectedVehicleColorCategory = nil

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

	WarMenu.CreateSubMenu('vehicle_colorCategory', 'vehicle', 'Vehicle Colors')
	WarMenu.CreateSubMenu('vehicle_color', 'vehicle_colorCategory', '')
	WarMenu.CreateSubMenu('vehicle_colorType', 'vehicle_color', '')

	while true do
		if WarMenu.IsMenuOpened('vehicle') then
			if Player.VehicleHandle then
				if WarMenu.Button('Re-rent') then
					if Player.ExplodePersonalVehicle() then
						if tryFindVehicleLocation() then
							WarMenu.CloseMenu()
							TriggerServerEvent('lsv:rentVehicle', _lastVehicle.id, _lastVehicle.category)
							Prompt.ShowAsync()
						end
					end
				elseif WarMenu.Button('Explode') then
					WarMenu.CloseMenu()
					Player.ExplodePersonalVehicle()
				else
					if WarMenu.ComboBox('Vehicle Access', _vehicleAccessItems, _vehicleAccessCurrentIndex, _vehicleAccessCurrentIndex, function(currentIndex)
						if currentIndex ~= _vehicleAccessCurrentIndex then
							_vehicleAccessCurrentIndex = currentIndex
							updateDoorsLock()
						end
					end) then
					elseif WarMenu.MenuButton('Color', 'vehicle_colorCategory') then
					end
				end
			else
				if WarMenu.MenuButton('Rent', 'vehicle_categories') then
				elseif _lastVehicle and WarMenu.Button(_lastVehicle.name, getVehiclePrice(_lastVehicle)) then
					if tryFindVehicleLocation() then
						WarMenu.CloseMenu()
						TriggerServerEvent('lsv:rentVehicle', _lastVehicle.id, _lastVehicle.category)
						Prompt.ShowAsync()
					end
				end
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('vehicle_colorCategory') then
			table.foreach(_vehicleColors, function(_, colorCategory)
				if WarMenu.MenuButton(colorCategory, 'vehicle_color') then
					selectedVehicleColorCategory = colorCategory
					WarMenu.SetSubTitle('vehicle_color', colorCategory..' Colors')
				end
			end)

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('vehicle_color') then
			table.iforeach(_vehicleColors[selectedVehicleColorCategory], function(colorData)
				if WarMenu.MenuButton(colorData.name, 'vehicle_colorType') then
					selectedVehicleColor = colorData.id
					WarMenu.SetSubTitle('vehicle_colorType', colorData.name..' '..selectedVehicleColorCategory..' Color')
				end
			end)

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('vehicle_colorType') then
			if WarMenu.Button('Primary') then
				_vehicleColor.primary = selectedVehicleColor
				updateColor()
				WarMenu.OpenMenu('vehicle_color')
			elseif WarMenu.Button('Secondary') then
				_vehicleColor.secondary = selectedVehicleColor
				updateColor()
				WarMenu.OpenMenu('vehicle_color')
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('vehicle_categories') then
			table.foreach(vehicles, function(_, vehicleCategory)
				if Player.Rank >= Settings.personalVehicle.freeMaxRank and vehicleCategory == 'Free' then
					return
				end

				if Player.Faction ~= Settings.faction.Enforcer and vehicleCategory == 'Enforcer' then
					return
				end

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
						_lastVehicle = vehicle
						_lastVehicle.category = selectedVehicleCategory
						WarMenu.CloseMenu()
						TriggerServerEvent('lsv:rentVehicle', vehicle.id, selectedVehicleCategory)
						Prompt.ShowAsync()
					end
				end
			end)

			WarMenu.Display()
		end

		Citizen.Wait(0)
	end
end)
