VehicleShop = { }

local vehicleShops = {
	{
		blip = nil,
		buy = { ['x'] = -343.45639038086, ['y'] = -132.33348083496, ['z'] = 39.009662628174 },
		spawn = { ['x'] = -327.06130981445, ['y'] = -144.24142456055, ['z'] = 38.51216506958, ['heading'] = 69.032455444336 },
		settings = Settings.vehicleSettings.superCars
	},

	{
		blip = nil,
		buy = { ['x'] = 729.28601074219, ['y'] = -1066.1860351563, ['z'] = 22.168672561646 },
		spawn = { ['x'] = 735.82940673828, ['y'] = -1072.2227783203, ['z'] = 21.575220108032, ['heading'] = 180.48377990723 },
		settings = Settings.vehicleSettings.superCars
	},

	{
		blip = nil,
		buy = { ['x'] = -1149.4119873047, ['y'] = -2004.0108642578, ['z'] = 13.180257797241 },
		spawn = { ['x'] = -1167.2578125, ['y'] = -2013.4609375, ['z'] = 12.762152671814, ['heading'] = 314.74981689453 },
		settings = Settings.vehicleSettings.superCars
	},

	{
		blip = nil,
		buy = { ['x'] = 1173.8170166016, ['y'] = 2638.5112304688, ['z'] = 37.769218444824 },
		spawn = { ['x'] = -1167.2578125, ['y'] = -2013.4609375, ['z'] = 12.762152671814, ['heading'] = 314.74981689453 },
		settings = Settings.vehicleSettings.superCars
	},

	{
		blip = nil,
		buy = { ['x'] = 110.07620239258, ['y'] = 6628.943359375, ['z'] = 31.787239074707 },
		spawn = { ['x'] = 103.63438415527, ['y'] = 6622.7026367188, ['z'] = 31.228212356567, ['heading'] = 224.52452087402 },
		settings = Settings.vehicleSettings.superCars
	},

	{
		blip = nil,
		buy = { ['x'] = -990.20458984375, ['y'] = -2988.85546875, ['z'] = 13.945067405701 },
		spawn = { ['x'] = -978.53314208984, ['y'] = -2995.2180175781, ['z'] = 13.44655418396, ['heading'] = 62.393993377686 },
		settings = Settings.vehicleSettings.planes
	},

	{
		blip = nil,
		buy = { ['x'] = -1109.9969482422, ['y'] = -2892.8879394531, ['z'] = 13.945918083191 },
		spawn = { ['x'] = -1112.2124023438, ['y'] = -2883.5236816406, ['z'] = 13.449026107788, ['heading'] = 149.9224395752 },
		settings = Settings.vehicleSettings.helicopters
	},

	{
		blip = nil,
		buy = { ['x'] = 1736.4291992188, ['y'] = 3292.0109863281, ['z'] = 41.154109954834 },
		spawn = { ['x'] = 1733.1650390625, ['y'] = 3303.8383789063, ['z'] = 40.929485321045, ['heading'] = 193.91323852539 },
		settings = Settings.vehicleSettings.planes
	},

	{
		blip = nil,
		buy = { ['x'] = 1760.5240478516, ['y'] = 3245.6018066406, ['z'] = 41.792789459229 },
		spawn = { ['x'] = 1770.310546875, ['y'] = 3239.7893066406, ['z'] = 41.843734741211, ['heading'] = 104.2003326416 },
		settings = Settings.vehicleSettings.helicopters
	},

	{
		blip = nil,
		buy = { ['x'] = 2127.1784667969, ['y'] = 4799.1000976563, ['z'] = 41.162982940674 },
		spawn = { ['x'] = 2133.2607421875, ['y'] = 4784.4477539063, ['z'] = 40.678649902344, ['heading'] = 23.563682556152 },
		settings = Settings.vehicleSettings.planes
	},

	{
		blip = nil,
		buy = { ['x'] = 2093.9289550781, ['y'] = 4775.4047851563, ['z'] = 41.251644134521 },
		spawn = { ['x'] = 2102.5183105469, ['y'] = 4767.212890625, ['z'] = 40.909629821777, ['heading'] = 98.875396728516 },
		settings = Settings.vehicleSettings.helicopters
	},

	{
		blip = nil,
		buy = { ['x'] = -1867.6484375, ['y'] = -1203.7532958984, ['z'] = 13.017106056213 },
		spawn = { ['x'] = -1883.8277587891, ['y'] = -1196.5783691406, ['z'] = 2.0171060562134, ['heading'] = 325.5 },
		settings = Settings.vehicleSettings.boats
	},

	{
		blip = nil,
		buy = { ['x'] = -997.04089355469, ['y'] = -1360.03515625, ['z'] = 5.0001788139343 },
		spawn = { ['x'] = -984.25183105469, ['y'] = -1366.7669677734, ['z'] = 1.0001788139343, ['heading'] = 106.49999237061 },
		settings = Settings.vehicleSettings.boats
	},
	{
		blip = nil,
		buy = { ['x'] = -740.29418945313, ['y'] = -2814.4045410156, ['z'] = 13.940433502197 },
		spawn = { ['x'] = -713.63189697266, ['y'] = -2804.5100097656, ['z'] = 3.9404335021973, ['heading'] = 196.4998626709 },
		settings = Settings.vehicleSettings.boats
	},

	{
		blip = nil,
		buy = { ['x'] = -3426.345703125, ['y'] = 967.71655273438, ['z'] = 8.3466835021973 },
		spawn = { ['x'] = -3444.9780273438, ['y'] = 967.7353515625, ['z'] = 2.5722370147705, ['heading'] = 1.5010634660721 },
		settings = Settings.vehicleSettings.boats
	},

	{
		blip = nil,
		buy = { ['x'] = 3113.4921875, ['y'] = 2158.029296875, ['z'] = 32.463645935059 },
		spawn = { ['x'] = 3088.3295898438, ['y'] = 2139.9675292969, ['z'] = 2.2830677032471, ['heading'] = 344.99996948242 },
		settings = Settings.vehicleSettings.boats
	},

	{
		blip = nil,
		buy = { ['x'] = -278.99493408203, ['y'] = 6633.2573242188, ['z'] = 7.4705123901367 },
		spawn = { ['x'] = -291.84033203125, ['y'] = 6643.0385742188, ['z'] = 3.5301523208618, ['heading'] = 308.99987792969 },
		settings = Settings.vehicleSettings.boats
	},

	{
		blip = nil,
		buy = { ['x'] = -1584.6968994141, ['y'] = 2794.3615722656, ['z'] = 16.871047973633 },
		spawn = { ['x'] = -1586.4848632813, ['y'] = 2785.4055175781, ['z'] = 16.888982772827, ['heading'] = 224.1650390625 },
		settings = Settings.vehicleSettings.military
	},

	{
		blip = nil,
		buy = { ['x'] = 1710.2841796875, ['y'] = 3275.1635742188, ['z'] = 41.153400421143 },
		spawn = { ['x'] = 1699.6365966797, ['y'] = 3274.4113769531, ['z'] = 41.13489151001, ['heading'] = 203.24487304688 },
		settings = Settings.vehicleSettings.military
	},

	{
		blip = nil,
		buy = { ['x'] = 2764.908203125, ['y'] = 1391.9899902344, ['z'] = 24.525352478027 },
		spawn = { ['x'] = 2755.8842773438, ['y'] = 1364.3022460938, ['z'] = 24.524000167847, ['heading'] = 0.72891885042191 },
		settings = Settings.vehicleSettings.military
	},

	{
		blip = nil,
		buy = { ['x'] = 170.58361816406, ['y'] = -3077.41796875, ['z'] = 5.8442854881287 },
		spawn = { ['x'] = 163.84124755859, ['y'] = -3092.4069824219, ['z'] = 5.9256281852722, ['heading'] = 264.79064941406 },
		settings = Settings.vehicleSettings.military
	},
}

local vehicleShopColor = Color.GetHudFromBlipColor(Color.Purple)
local currentVehicleShopIndex = nil


function VehicleShop.GetPlaces()
	return vehicleShops
end


AddEventHandler('lsv:init', function()
	for _, vehicleShop in pairs(vehicleShops) do
		vehicleShop.blip = Map.CreatePlaceBlip(vehicleShop.settings.blipSprite, vehicleShop.buy.x, vehicleShop.buy.y, vehicleShop.buy.z, vehicleShop.settings.blipName)
	end


	for _, settings in pairs(Settings.vehicleSettings) do
		WarMenu.CreateMenu(settings.menuName, 'Vehicle Shop')
		WarMenu.SetTitleBackgroundColor(settings.menuName, vehicleShopColor.r, vehicleShopColor.g, vehicleShopColor.b)
		WarMenu.SetSubTitle(settings.menuName, settings.blipName)
		WarMenu.SetMenuButtonPressedSound(settings.menuName, 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET')
	end

	while true do
		Citizen.Wait(0)

		for settingsIndex, settings in pairs(Settings.vehicleSettings) do
			if WarMenu.IsMenuOpened(settings.menuName) then
				for vehicleIndex, vehicle in pairs(settings.vehicles) do
					if WarMenu.Button(vehicle.name, '$'..vehicle.price) then
						TriggerServerEvent('lsv:purchaseVehicle', settingsIndex, vehicleIndex) --TODO Prevent purchasing few vehicles
					end
				end

				WarMenu.Display()
			end
		end
	end
end)


AddEventHandler('lsv:init', function()
	while true do
		Citizen.Wait(0)

		for vehicleShopIndex, vehicleShop in pairs(vehicleShops) do
			Gui.DrawPlaceMarker(vehicleShop.buy.x, vehicleShop.buy.y, vehicleShop.buy.z - 1, Settings.placeMarkerRadius, vehicleShopColor.r, vehicleShopColor.g, vehicleShopColor.b, Settings.placeMarkerOpacity)

			if Vdist(vehicleShop.buy.x, vehicleShop.buy.y, vehicleShop.buy.z, table.unpack(GetEntityCoords(PlayerPedId(), true))) < Settings.placeMarkerRadius then
				if not WarMenu.IsAnyMenuOpened() then
					if Player.vehicle then
						Gui.DisplayHelpTextThisFrame('You already have a vehicle.')
					else
						Gui.DisplayHelpTextThisFrame('Press ~INPUT_PICKUP~ to browse '..vehicleShop.settings.blipName..'.')

						if IsControlJustReleased(0, 38) then
							currentVehicleShopIndex = vehicleShopIndex
							WarMenu.OpenMenu(vehicleShop.settings.menuName)
						end
					end
				end
			elseif WarMenu.IsMenuOpened(vehicleShop.settings.menuName) and vehicleShopIndex == currentVehicleShopIndex then
				WarMenu.CloseMenu()
			end
		end
	end
end)


AddEventHandler('lsv:init', function()
	while true do
		Citizen.Wait(0)

		if Player.vehicle then
			if IsEntityDead(Player.vehicle) then
				Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(Player.vehicle)) --SetEntityAsNoLongerNeeded
				Citizen.InvokeNative(0x86A652570E5F25DD, Citizen.PointerValueIntInitialized(Player.vehicleBlip)) --RemoveBlip

				Gui.DisplayNotification('~r~Your vehicle has been destroyed.')

				Player.vehicle = nil
				Player.vehicleBlip = nil
			elseif Player.vehicleBlip then
				if IsPedInVehicle(PlayerPedId(), Player.vehicle) then
					SetBlipAlpha(Player.vehicleBlip, 0)
				else
					SetBlipAlpha(Player.vehicleBlip, 255)
				end
			end
		end
	end
end)


RegisterNetEvent('lsv:vehiclePurchasingApproved')
AddEventHandler('lsv:vehiclePurchasingApproved', function(settingsIndex, vehicleIndex)
	if WarMenu.IsMenuOpened(Settings.vehicleSettings[settingsIndex].menuName) then WarMenu.CloseMenu() end

	local vehicle = Settings.vehicleSettings[settingsIndex].vehicles[vehicleIndex]

	Player.SpawnVehicle(vehicle.hash, vehicleShops[currentVehicleShopIndex].spawn, vehicle.name)
end)


RegisterNetEvent('lsv:vehiclePurchasingDeclined')
AddEventHandler('lsv:vehiclePurchasingDeclined', function()
	Gui.DisplayNotification('~r~You don\'t have enough money.')
end)


RegisterNetEvent('lsv:repairPersonalVehicleSuccess')
AddEventHandler('lsv:repairPersonalVehicleSuccess', function()
	StartScreenEffect("SuccessFranklin", 0, false)
	SetVehicleFixed(Player.vehicle)
end)


RegisterNetEvent('lsv:repairPersonalVehicleError')
AddEventHandler('lsv:repairPersonalVehicleError', function()
	Gui.DisplayNotification('~r~You don\'t have enough money.')
end)