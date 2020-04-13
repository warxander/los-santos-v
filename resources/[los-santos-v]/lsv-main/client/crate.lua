local _crateShops = {
	{ x = -537.87445068359, y = -853.72033691406, z = 29.280401229858, heading = 203.77967834473 },
	{ x = -95.230491638184, y = 6456.8037109375, z = 31.457984924316, heading = 212.22171020508 },
}

local _crateData = nil

RegisterNetEvent('lsv:specialCratePurchased')
AddEventHandler('lsv:specialCratePurchased', function(purchased)
	if purchased then
		WarMenu.CloseMenu()
	else
		Gui.DisplayPersonalNotification('You don\'t have enough cash.')
	end

	Prompt.Hide()
end)

RegisterNetEvent('lsv:spawnSpecialCrate')
AddEventHandler('lsv:spawnSpecialCrate', function(crate)
	if _crateData then
		return
	end

	PlaySoundFrontend(-1, 'CONFIRM_BEEP', 'HUD_MINI_GAME_SOUNDSET', true)
	Gui.DisplayPersonalNotification('We have been dropped a Special Crate for you.', 'CHAR_AMMUNATION', 'Ammu-Nation', '', 2)

	_crateData = { }
	_crateData.pickup = CreatePickupRotate(`PICKUP_PORTABLE_CRATE_UNFIXED`, crate.position.x, crate.position.y, crate.position.z, 0.0, 0.0, 0.0, 512)
	_crateData.position = crate.position
	_crateData.location = crate.location
	_crateData.areaBlip = Map.CreateRadiusBlip(crate.location.x, crate.location.y, crate.location.z, Settings.crate.radius, Color.BLIP_YELLOW)

	_crateData.blip = Map.CreatePlaceBlip(Blip.CRATE_DROP, crate.location.x, crate.location.y, crate.location.z, nil, Color.BLIP_YELLOW)
	SetBlipAsShortRange(_crateData.blip, false)
	SetBlipScale(_crateData.blip, 1.5)
	Map.SetBlipFlashes(_crateData.blip)

	FlashMinimapDisplay()

	while true do
		Citizen.Wait(0)

		if HasPickupBeenCollected(_crateData.pickup) then
			TriggerServerEvent('lsv:specialCratePickedUp')
			return
		end

		if Player.IsInFreeroam() then
			if Player.DistanceTo(_crateData.location) < Settings.crate.radius then
				Gui.DrawProgressBar('CRATE DISTANCE', 1.0 - Player.DistanceTo(_crateData.position) / Settings.crate.radius, 7, Color.YELLOW)
			end
		end
	end
end)

RegisterNetEvent('lsv:specialCratePickedUp')
AddEventHandler('lsv:specialCratePickedUp', function(crate)
	local playerPed = PlayerPedId()

	SetPedArmour(playerPed, GetPlayerMaxArmour(PlayerId()))
	GiveWeaponToPed(playerPed, GetHashKey(crate.weapon.id), crate.weapon.ammo, false, true)

	Gui.DisplayPersonalNotification('Crate Contents:~w~\n+ $'..Settings.crate.reward.cash..'\n+ '..crate.weapon.name..'\n+ Body Armor')
	Player.SaveWeapons()

	RemoveBlip(_crateData.areaBlip)
	RemoveBlip(_crateData.blip)

	_crateData = nil
end)

AddEventHandler('lsv:init', function()
	table.iforeach(_crateShops, function(crateShop)
		Map.CreatePlaceBlip(Blip.CRATE_SHOP, crateShop.x, crateShop.y, crateShop.z, 'Special Crate Delivery')
	end)

	WarMenu.CreateMenu('crate', '')
	WarMenu.SetSubTitle('crate', 'Special Crate Delivery')
	WarMenu.SetTitleBackgroundColor('crate', Color.WHITE.r, Color.WHITE.g, Color.WHITE.b, Color.WHITE.a)
	WarMenu.SetTitleBackgroundSprite('crate', 'shopui_title_gunclub', 'shopui_title_gunclub')
	WarMenu.SetMenuButtonPressedSound('crate', 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET')

	while true do
		Citizen.Wait(0)

		if WarMenu.IsMenuOpened('crate') then
			if WarMenu.Button('Drop Special Crate', '$'..Settings.crate.cash) then
				if _crateData then
					Gui.DisplayPersonalNotification('Your Special Crate was already delivered.')
				else
					TriggerServerEvent('lsv:purchaseSpecialCrate')
					Prompt.ShowAsync()
				end
			end

			WarMenu.Display()
		end
	end
end)

AddEventHandler('lsv:init', function()
	local specialCrateShopIndex = nil
	local crateShopColor = Color.YELLOW

	while true do
		Citizen.Wait(0)

		if Player.IsActive() then
			table.iforeach(_crateShops, function(crateShop, crateShopIndex)
				Gui.DrawPlaceMarker(crateShop, crateShopColor)

				if Player.DistanceTo(crateShop, true) < Settings.placeMarker.radius then
					if not WarMenu.IsAnyMenuOpened() then
						Gui.DisplayHelpText('Press ~INPUT_PICKUP~ to browse Special Crate Delivery.')

						if IsControlJustReleased(0, 38) then
							specialCrateShopIndex = crateShopIndex
							Gui.OpenMenu('crate')
						end
					end
				elseif WarMenu.IsMenuOpened('crate') and crateShopIndex == specialCrateShopIndex then
					WarMenu.CloseMenu()
					Prompt.Hide()
				end
			end)
		end
	end
end)
