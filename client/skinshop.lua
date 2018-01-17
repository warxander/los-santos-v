Skinshops = {
	{ blip = nil, ['x'] = 72.071105957031, ['y'] = -1399.3981933594, ['z'] = 29.376142501831 },
	{ blip = nil, ['x'] = 428.79281616211, ['y'] = -800.67486572266, ['z'] = 29.491132736206 },
	{ blip = nil, ['x'] = 121.04691314697, ['y'] = -225.82836914063, ['z'] = 54.55782699585 },
	{ blip = nil, ['x'] = -167.84260559082, ['y'] = -299.65042114258, ['z'] = 39.733276367188 },
	{ blip = nil, ['x'] = -704.68463134766, ['y'] = -151.84358215332, ['z'] = 37.415134429932 },
	{ blip = nil, ['x'] = -1447.6271972656, ['y'] = -242.27815246582, ['z'] = 49.820835113525 },
	{ blip = nil, ['x'] = -1187.9968261719, ['y'] = -768.77459716797, ['z'] = 17.32541847229 },
	{ blip = nil, ['x'] = -829.22619628906, ['y'] = -1073.8569335938, ['z'] = 11.328105926514 },
	{ blip = nil, ['x'] = -3175.4289550781, ['y'] = 1042.0402832031, ['z'] = 20.863210678101 },
	{ blip = nil, ['x'] = -1107.6646728516, ['y'] = 2708.447265625, ['z'] = 19.107870101929 },
	{ blip = nil, ['x'] = 617.60980224609, ['y'] = 2766.5490722656, ['z'] = 42.088138580322 },
	{ blip = nil, ['x'] = 1190.5170898438, ['y'] = 2712.6530761719, ['z'] = 38.222595214844 },
	{ blip = nil, ['x'] = 1695.5983886719, ['y'] = 4829.2368164063, ['z'] = 42.063117980957 },
	{ blip = nil, ['x'] = 11.053486824036, ['y'] = 6514.693359375, ['z'] = 31.877849578857 },
}


local skinshopColor = Color.GetHudFromBlipColor(Color.Green)


AddEventHandler('lsv:firstSpawnPlayer', function()
	for _, skinshop in pairs(Skinshops) do
		skinshop.blip = Map.CreatePlaceBlip(Blip.Clothes(), skinshop.x, skinshop.y, skinshop.z)
	end
end)


Citizen.CreateThread(function()
	WarMenu.CreateMenu('skinshop', 'Skin Shop')
	WarMenu.SetSubTitle('skinshop', 'SKINS')
	WarMenu.SetTitleBackgroundColor('skinshop', skinshopColor.r, skinshopColor.g, skinshopColor.b)
	WarMenu.SetMenuButtonPressedSound('skinshop', 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET')

	local currentMenuIndex = nil

	while true do
		if GetPlayerWantedLevel(PlayerId()) == 0 and Player.initialized then
			for index, skinshop in pairs(Skinshops) do
				DrawMarker(1, skinshop.x, skinshop.y, skinshop.z - 1, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, skinshopColor.r, skinshopColor.g, skinshopColor.b, 196, false, nil, nil, false)

				if Vdist(skinshop.x, skinshop.y, skinshop.z, table.unpack(GetEntityCoords(GetPlayerPed(-1), true))) < 1.0 then
					if IsControlJustReleased(0, 38) then
						currentMenuIndex = index
						WarMenu.OpenMenu('skinshop')
					end

					if WarMenu.IsMenuOpened('skinshop') then
						for _, skin in pairs(Skin.GetSkins()) do
							local owned = nil
							if skin == Player.skin then owned = 'Owned' end
							if WarMenu.Button(skin, owned) then
								if skin == Player.skin then
									Gui.DisplayNotification('You have already selected this skin.')
								else
									Skin.ChangePlayerSkin(skin)
									TriggerServerEvent('lsv:updatePlayerSkin', skin)
								end
							end
						end

						WarMenu.Display()
					else
						Gui.DisplayHelpTextThisFrame('Press ~INPUT_PICKUP~ to browse skins.')
					end
				elseif WarMenu.IsMenuOpened('skinshop') and index == currentMenuIndex then
					WarMenu.CloseMenu()
				end
			end
		end

		Citizen.Wait(0)
	end
end)