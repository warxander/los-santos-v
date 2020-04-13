local _skinshops = {
	{ x = 72.071105957031, y = -1399.3981933594, z = 29.376142501831 },
	{ x = 428.79281616211, y = -800.67486572266, z = 29.491132736206 },
	{ x = 121.04691314697, y = -225.82836914063, z = 54.55782699585 },
	{ x = -167.84260559082, y = -299.65042114258, z = 39.733276367188 },
	{ x = -704.68463134766, y = -151.84358215332, z = 37.415134429932 },
	{ x = -1447.6271972656, y = -242.27815246582, z = 49.820835113525 },
	{ x = -1187.9968261719, y = -768.77459716797, z = 17.32541847229 },
	{ x = -829.22619628906, y = -1073.8569335938, z = 11.328105926514 },
	{ x = -3175.4289550781, y = 1042.0402832031, z = 20.863210678101 },
	{ x = -1107.6646728516, y = 2708.447265625, z = 19.107870101929 },
	{ x = 617.60980224609, y = 2766.5490722656, z = 42.088138580322 },
	{ x = 1190.5170898438, y = 2712.6530761719, z = 38.222595214844 },
	{ x = 1695.5983886719, y = 4829.2368164063, z = 42.063117980957 },
	{ x = 11.053486824036, y = 6514.693359375, z = 31.877849578857 },
}

local function getSkinRequirements(skin)
	if skin.id == Player.Skin then
		return 'Used'
	end

	if skin.rank and Player.Rank < skin.rank then
		return 'Rank '..skin.rank
	end

	if skin.prestige and Player.Prestige < skin.prestige then
		return 'Prestige '..skin.prestige
	end

	return ''
end

RegisterNetEvent('lsv:playerSkinUpdated')
AddEventHandler('lsv:playerSkinUpdated', function(id)
	if id then
		Player.SetModel(id)
	else
		Gui.DisplayPersonalNotification('You can\'t use this skin.')
	end

	Prompt.Hide()
end)

AddEventHandler('lsv:init', function()
	local selectedCategory = nil

	table.iforeach(_skinshops, function(skinshop)
		Map.CreatePlaceBlip(Blip.CLOTHING_STORE, skinshop.x, skinshop.y, skinshop.z)
	end)

	WarMenu.CreateMenu('skinshop', '')
	WarMenu.SetSubTitle('skinshop', 'Select Skin Category')
	WarMenu.SetTitleBackgroundColor('skinshop', Color.WHITE.r, Color.WHITE.g, Color.WHITE.b, Color.WHITE.a)
	WarMenu.SetTitleBackgroundSprite('skinshop', 'shopui_title_lowendfashion', 'shopui_title_lowendfashion')

	WarMenu.CreateSubMenu('skinshop_skins', 'skinshop')
	WarMenu.SetMenuButtonPressedSound('skinshop_skins', 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET')

	while true do
		Citizen.Wait(0)

		if WarMenu.IsMenuOpened('skinshop') then
			table.foreach(Settings.skins, function(_, category)
				if WarMenu.MenuButton(category, 'skinshop_skins') then
					selectedCategory = category
					WarMenu.SetSubTitle('skinshop_skins', selectedCategory)
				end
			end)

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('skinshop_skins') then
			table.iforeach(Settings.skins[selectedCategory], function(skin, skinIndex)
				if WarMenu.Button(skin.name, getSkinRequirements(skin)) then
					if skin.rank and skin.rank > Player.Rank then
						Gui.DisplayPersonalNotification('Your Rank is too low.')
					elseif skin.prestige and skin.prestige > Player.Prestige then
						Gui.DisplayPersonalNotification('Your Prestige is too low.')
					else
						TriggerServerEvent('lsv:updatePlayerSkin', skinIndex, selectedCategory)
						Prompt.ShowAsync()
					end
				end
			end)

			WarMenu.Display()
		end
	end
end)

AddEventHandler('lsv:init', function()
	local skinshopOpenedMenuIndex = nil
	local skinshopColor = Color.GREEN

	while true do
		Citizen.Wait(0)

		if Player.IsActive() then
			table.iforeach(_skinshops, function(skinshop, skinshopIndex)
				Gui.DrawPlaceMarker(skinshop, skinshopColor)

				if Player.DistanceTo(skinshop, true) < Settings.placeMarker.radius then
					if not WarMenu.IsAnyMenuOpened() then
						Gui.DisplayHelpText('Press ~INPUT_PICKUP~ to browse characters.')

						if IsControlJustReleased(0, 38) then
							skinshopOpenedMenuIndex = skinshopIndex
							Gui.OpenMenu('skinshop')
						end
					end
				elseif WarMenu.IsMenuOpened('skinshop') and skinshopIndex == skinshopOpenedMenuIndex then
					WarMenu.CloseMenu()
					Prompt.Hide()
				end
			end)
		end
	end
end)
