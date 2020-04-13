local _currentTravelIndex = nil

RegisterNetEvent('lsv:useFastTravel')
AddEventHandler('lsv:useFastTravel', function(travelIndex)
	if travelIndex then
		if WarMenu.IsMenuOpened('fastTravel') then
			WarMenu.CloseMenu()
		end

		Player.SetPassiveMode(true)

		DoScreenFadeOut(1000)
		Citizen.Wait(1500)

		Player.Teleport(Settings.travel.places[travelIndex].outPosition)

		Citizen.Wait(1000)
		DoScreenFadeIn(1000)

		Player.SetPassiveMode(true, true)
		Citizen.Wait(Settings.spawnProtectionTime)
		Player.SetPassiveMode(false)
	else
		Gui.DisplayPersonalNotification('You don\'t have enough cash.')
	end

	Prompt.Hide()
end)

AddEventHandler('lsv:init', function()
	table.iforeach(Settings.travel.places, function(place)
		local blip = Map.CreatePlaceBlip(Blip.FAST_TRAVEL, place.inPosition.x, place.inPosition.y, place.inPosition.z, place.name)
		SetBlipScale(blip, 1.2)
		SetBlipCategory(blip, 1)
	end)

	WarMenu.CreateMenu('fastTravel', 'Fast Travel')
	WarMenu.SetTitleColor('fastTravel', Color.WHITE.r, Color.WHITE.g, Color.WHITE.b)
	WarMenu.SetTitleBackgroundColor('fastTravel', Color.DARK_BLUE.r, Color.DARK_BLUE.g, Color.DARK_BLUE.b)
	WarMenu.SetSubTitle('fastTravel', 'Select Your Destination')
	WarMenu.SetMenuButtonPressedSound('fastTravel', 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET')

	while true do
		Citizen.Wait(0)

		if WarMenu.IsMenuOpened('fastTravel') then
			table.iforeach(Settings.travel.places, function(place, travelIndex)
				local isHere = _currentTravelIndex == travelIndex
				if WarMenu.Button(place.name, isHere and 'Here' or '$'..Settings.travel.cash) then
					if isHere then
						Gui.DisplayPersonalNotification('You are already here.')
					else
						TriggerServerEvent('lsv:useFastTravel', travelIndex)
						Prompt.ShowAsync()
					end
				end
			end)

			WarMenu.Display()
		end
	end
end)

AddEventHandler('lsv:init', function()
	local fastTravelColor = Color.DARK_BLUE

	while true do
		Citizen.Wait(0)

		if not IsPlayerDead(PlayerId()) then
			local isFastTravelAvailable = Player.IsInFreeroam()

			table.iforeach(Settings.travel.places, function(place, travelIndex)
				Gui.DrawPlaceMarker(place.inPosition, fastTravelColor)

				if Player.DistanceTo(place.inPosition, true) < Settings.placeMarker.radius then
					if not WarMenu.IsAnyMenuOpened() then
						if not isFastTravelAvailable then
							Gui.DisplayHelpText('Fast Travel is not available right now.')
						else
							Gui.DisplayHelpText('Press ~INPUT_PICKUP~ to open Fast Travel menu.')

							if IsControlJustReleased(0, 38) then
								_currentTravelIndex = travelIndex
								Gui.OpenMenu('fastTravel')
							end
						end
					end
				elseif WarMenu.IsMenuOpened('fastTravel') and travelIndex == _currentTravelIndex then
					WarMenu.CloseMenu()
					Prompt.Hide()
				end
			end)
		end
	end
end)
