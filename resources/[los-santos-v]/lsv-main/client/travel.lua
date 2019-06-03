local function getTravelPrice()
	return '$'..tostring(Player.Rank * Settings.travel.cashPerRank)
end

local transaction = RemoteTransaction.New()


AddEventHandler('lsv:init', function()
	table.iforeach(Settings.travel.places, function(place)
		Map.CreatePlaceBlip(Blip.FastTravel(), place.inPosition.x, place.inPosition.y, place.inPosition.z, 'Fast Travel', Color.BlipYellow())
	end)

	WarMenu.CreateMenu('travel', 'Fast Travel')
	WarMenu.SetSubTitle('travel', 'Select destination')
	WarMenu.SetTitleBackgroundColor('travel', Color.GetHudFromBlipColor(Color.BlipYellow()).r, Color.GetHudFromBlipColor(Color.BlipYellow()).g, Color.GetHudFromBlipColor(Color.BlipYellow()).b, Color.GetHudFromBlipColor(Color.BlipYellow()).a)
	WarMenu.SetMenuButtonPressedSound('travel', 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET')

	local currentTravelIndex = nil

	while true do
		Citizen.Wait(0)

		if WarMenu.IsMenuOpened('travel') then
			table.iforeach(Settings.travel.places, function(place, travelIndex)
				local isHere = currentTravelIndex == travelIndex
				if WarMenu.Button(place.name, isHere and 'Here' or getTravelPrice()) then
					if isHere then
						Gui.DisplayPersonalNotification('You are already here.')
					else
						TriggerServerEvent('lsv:useFastTravel', travelIndex)
						transaction:WaitForEnding()
					end
				end
			end)

			WarMenu.Display()
		elseif not IsPlayerDead(PlayerId()) then
			local isFastTravelAvailable = Player.IsInFreeroam()
			table.iforeach(Settings.travel.places, function(place, travelIndex)
				if Player.DistanceTo(place.inPosition, true) < Settings.placeMarkerRadius then
					if not WarMenu.IsAnyMenuOpened() then
						if not isFastTravelAvailable then
							Gui.DisplayHelpText('Fast Travel is not available right now.')
						else
							Gui.DisplayHelpText('Press ~INPUT_PICKUP~ to open Fast Travel menu.')

							if IsControlJustReleased(0, 38) then
								currentTravelIndex = travelIndex
								Gui.OpenMenu('travel')
							end
						end
					end
				elseif WarMenu.IsMenuOpened('travel') and travelIndex == currentTravelIndex then
					WarMenu.CloseMenu()
					transaction:Finish()
				end
			end)
		end
	end
end)


RegisterNetEvent('lsv:useFastTravel')
AddEventHandler('lsv:useFastTravel', function(travelIndex, success)
	if success then
		if WarMenu.IsMenuOpened('travel') then WarMenu.CloseMenu() end

		Player.SetFreeze(true)
		DoScreenFadeOut(1000)
		Citizen.Wait(1500)
		Player.Teleport(Settings.travel.places[travelIndex].outPosition)
		Citizen.Wait(1000)
		DoScreenFadeIn(1000)
		Player.SetFreeze(false)
	else Gui.DisplayPersonalNotification('You don\'t have enough cash.') end

	transaction:Finish()
end)