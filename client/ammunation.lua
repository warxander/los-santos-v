Ammunations = {
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


local ammunationColor = Color.GetHudFromBlipColor(Color.Red)


AddEventHandler('lsv:firstSpawnPlayer', function()
	for _, ammunation in pairs(Ammunations) do
		ammunation.blip = Map.CreatePlaceBlip(Blip.AmmuNation(), ammunation.x, ammunation.y, ammunation.z)
	end
end)


Citizen.CreateThread(function()
	WarMenu.CreateMenu('ammunation', 'Ammu-Nation')
	WarMenu.SetSubTitle('ammunation', 'STARTING WEAPON')
	WarMenu.SetTitleBackgroundColor('ammunation', ammunationColor.r, ammunationColor.g, ammunationColor.b)
	WarMenu.SetMenuButtonPressedSound('ammunation', 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET')

	local currentMenuIndex = nil

	while true do
		if GetPlayerWantedLevel(PlayerId()) == 0 and Player.initialized then
			for index, ammunation in pairs(Ammunations) do
				DrawMarker(1, ammunation.x, ammunation.y, ammunation.z - 1, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, ammunationColor.r, ammunationColor.g, ammunationColor.b, 196, false, nil, nil, false)

				if Vdist(ammunation.x, ammunation.y, ammunation.z, table.unpack(GetEntityCoords(PlayerPedId(), true))) < 1.0 then
					if IsControlJustReleased(0, 38) then
						currentMenuIndex = index
						WarMenu.OpenMenu('ammunation')
					end

					if WarMenu.IsMenuOpened('ammunation') then
						for _, weapon in pairs(Weapon.GetWeapons()) do
							if not weapon.melee and not weapon.unique then
								local price = '$'..tostring(weapon.price)
								if weapon.id == Player.startingWeapon then price = 'Owned' end

								if WarMenu.Button(weapon.name, price) then
									if weapon.id == Player.startingWeapon then
										Gui.DisplayNotification('You have already selected this starting weapon.')
									elseif Player.IsEnoughMoney(weapon.price) then
										Player.startingWeapon = weapon.id
										Player.ChangeMoney(-weapon.price)
										TriggerServerEvent('lsv:updatePlayerStartingWeapon', weapon.id)
										Gui.DisplayNotification('You have changed your starting weapon to '..weapon.name..'.')
										WarMenu.CloseMenu()
									else
										Gui.DisplayNotification('You don\'t have enough money to purchase this starting weapon.')
									end
								end
							end
						end

						WarMenu.Display()
					else
						 --TODO Add sound notification
						Gui.DisplayHelpTextThisFrame('Press ~INPUT_PICKUP~ to browse weapons.')
					end
				elseif WarMenu.IsMenuOpened('ammunation') and index == currentMenuIndex then
					WarMenu.CloseMenu()
				end
			end
		end

		Citizen.Wait(0)
	end
end)