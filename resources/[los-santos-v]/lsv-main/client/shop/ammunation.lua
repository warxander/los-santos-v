AmmuNation = { }


local ammunations = {
	{ blip = nil, ['x'] = 251.37934875488, ['y'] = -48.90043258667, ['z'] = 69.941062927246 },
	{ blip = nil, ['x'] = 843.44445800781, ['y'] = -1032.1590576172, ['z'] = 28.194854736328 },
	{ blip = nil, ['x'] = 810.82800292969, ['y'] = -2156.3671875, ['z'] = 29.619010925293 },
	{ blip = nil, ['x'] = 20.719049453735, ['y'] = -1108.0506591797, ['z'] = 29.797027587891 },
	{ blip = nil, ['x'] = -662.86431884766, ['y'] = -936.32116699219, ['z'] = 21.829231262207 },
	{ blip = nil, ['x'] = -1306.2987060547, ['y'] = -393.93954467773, ['z'] = 36.695774078369 },
	{ blip = nil, ['x'] = -3171.1555175781, ['y'] = 1086.576171875, ['z'] = 20.838750839233 },
	{ blip = nil, ['x'] = -1117.4243164063, ['y'] = 2697.328125, ['z'] = 18.554145812988 },
	{ blip = nil, ['x'] = -329.94900512695, ['y'] = 6082.3178710938, ['z'] = 31.454774856567 },
	{ blip = nil, ['x'] = 2568.3815917969, ['y'] = 295.02661132813, ['z'] = 108.73487854004 },
	{ blip = nil, ['x'] = 1693.8348388672, ['y'] = 3759.2829589844, ['z'] = 34.705318450928 },
}


local function specialWeaponAmmoPrice(weapon, ammo, maxAmmo)
	if ammo == maxAmmo then return 'Maxed' end
	return '$'..Settings.ammuNationSpecialAmmo[weapon].price
end


local transaction = RemoteTransaction.New()


function AmmuNation.GetPlaces()
	return ammunations
end


AddEventHandler('lsv:init', function()
	table.foreach(ammunations, function(ammunation)
		ammunation.blip = Map.CreatePlaceBlip(Blip.AmmuNation(), ammunation.x, ammunation.y, ammunation.z)
	end)

	WarMenu.CreateMenu('ammunation_specialammo', '')
	WarMenu.SetMenuWidth('ammunation_specialammo', 0.25)
	WarMenu.SetSubTitle('ammunation_specialammo', 'Ammunition')
	WarMenu.SetTitleBackgroundColor('ammunation_specialammo', Color.GetHudFromBlipColor(Color.BlipWhite()).r, Color.GetHudFromBlipColor(Color.BlipWhite()).g, Color.GetHudFromBlipColor(Color.BlipWhite()).b, Color.GetHudFromBlipColor(Color.BlipWhite()).a)
	WarMenu.SetTitleBackgroundSprite('ammunation_specialammo', 'shopui_title_gunclub', 'shopui_title_gunclub')
	WarMenu.SetMenuButtonPressedSound('ammunation_specialammo', 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET')

	while true do
		Citizen.Wait(0)

		if WarMenu.IsMenuOpened('ammunation_specialammo') then
			table.foreach(Settings.ammuNationSpecialAmmo, function(data, weapon)
				local weaponHash = GetHashKey(weapon)
				if HasPedGotWeapon(PlayerPedId(), weaponHash, false) then
					local weaponAmmoType = GetPedAmmoTypeFromWeapon(PlayerPedId(), weaponHash)
					local _, maxAmmo = GetMaxAmmo(PlayerPedId(), weaponHash)
					local playerAmmo = GetPedAmmoByType(PlayerPedId(), weaponAmmoType)

					if WarMenu.Button(Weapon.GetWeapon(weapon).name..' '..data.type..' '..playerAmmo..' | '..maxAmmo..' (+'..data.ammo..')', specialWeaponAmmoPrice(weapon, playerAmmo, maxAmmo)) then
						if playerAmmo == maxAmmo then
							Gui.DisplayPersonalNotification('You already have max ammo.')
						else
							TriggerServerEvent('lsv:refillSpecialAmmo', weapon)
							transaction:WaitForEnding()
						end
					end
				end
			end)

			WarMenu.Display()
		end
	end
end)


AddEventHandler('lsv:init', function()
	local ammunationOpenedMenuIndex = nil
	local ammunationColor = Color.GetHudFromBlipColor(Color.BlipRed())

	while true do
		Citizen.Wait(0)

		if not IsPlayerDead(PlayerId()) then
			table.foreach(ammunations, function(ammunation, ammunationIndex)
				Gui.DrawPlaceMarker(ammunation.x, ammunation.y, ammunation.z - 1, Settings.placeMarkerRadius, ammunationColor.r, ammunationColor.g, ammunationColor.b, Settings.placeMarkerOpacity)

				if Player.DistanceTo(ammunation, true) < Settings.placeMarkerRadius then
					if not WarMenu.IsAnyMenuOpened() then
						Gui.DisplayHelpText('Press ~INPUT_PICKUP~ to browse ammo.')

						if IsControlJustReleased(0, 38) then
							ammunationOpenedMenuIndex = ammunationIndex
							openedFromInteractionMenu = false
							Gui.OpenMenu('ammunation_specialammo')
						end
					end
				elseif WarMenu.IsMenuOpened('ammunation_specialammo') and ammunationIndex == ammunationOpenedMenuIndex then
					WarMenu.CloseMenu()
					Player.SaveWeapons()
					transaction:Finish()
				end
			end)
		end
	end
end)


RegisterNetEvent('lsv:specialAmmoRefilled')
AddEventHandler('lsv:specialAmmoRefilled', function(weapon, amount)
	if amount then AddAmmoToPed(PlayerPedId(), GetHashKey(weapon), amount)
	else Gui.DisplayPersonalNotification('You don\'t have enough cash.') end
	transaction:Finish()
end)
