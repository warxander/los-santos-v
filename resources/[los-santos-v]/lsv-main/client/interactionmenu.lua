local quickGpsLocations = { 'None', 'Crate Drop', 'Ammu-Nation', 'Skin Shop' }
local quickGpsCurrentIndex = 1
local quickGpsSelectedIndex = 1
local quickGpsBlip = nil

local reportedPlayers = { }
local reportingPlayer = nil
local reportingReasons = { 'Inappropriate Player Name', 'Harassment', 'Cheating', 'Spam' }


AddEventHandler('lsv:init', function()
	WarMenu.CreateMenu('interaction', GetPlayerName(PlayerId()))
	WarMenu.SetTitleColor('interaction', 255, 255, 255)
	WarMenu.SetTitleBackgroundColor('interaction', Color.GetHudFromBlipColor(Color.BlipWhite()).r, Color.GetHudFromBlipColor(Color.BlipWhite()).g, Color.GetHudFromBlipColor(Color.BlipWhite()).b, Color.GetHudFromBlipColor(Color.BlipWhite()).a)
	WarMenu.SetTitleBackgroundSprite('interaction', 'commonmenu', 'interaction_bgd')

	WarMenu.CreateSubMenu('missions', 'interaction', 'Missions')

	WarMenu.CreateSubMenu('reportPlayer', 'interaction', 'Report Player')
	WarMenu.CreateSubMenu('reportReason', 'reportPlayer', 'Select a reason for reporting')

	while true do
		if WarMenu.IsMenuOpened('interaction') then
			if IsPlayerDead(PlayerId()) then
				WarMenu.CloseMenu()
			elseif WarMenu.ComboBox('Quick GPS', quickGpsLocations, quickGpsCurrentIndex, quickGpsSelectedIndex, function(currentIndex, selectedIndex) --TODO WTF IS THAT? REFACTOR ME!!!
					quickGpsSelectedIndex = selectedIndex
					quickGpsCurrentIndex = currentIndex
				end) then
				RemoveBlip(quickGpsBlip)

				local blip = nil

				if quickGpsSelectedIndex == 2 then
					blip = CrateBlip
				elseif quickGpsSelectedIndex ~= 1 then
					local places = nil

					if quickGpsSelectedIndex == 3 then
						places = AmmuNation.GetPlaces()
					elseif quickGpsSelectedIndex == 4 then
						places = Skinshop.GetPlaces()
					end

					local minDistance = 0xffffffff
					table.foreach(places, function(place)
						local distance = Player.DistanceTo(GetBlipCoords(place.blip), false)
						if distance < minDistance then
							minDistance = distance
							blip = place.blip
						end
					end)
				end

				if blip then
					local blipPosition = GetBlipCoords(blip)
					quickGpsBlip = AddBlipForCoord(blipPosition.x, blipPosition.y, blipPosition.z)
					SetBlipSprite(quickGpsBlip, Blip.Waypoint())
					SetBlipColour(quickGpsBlip, Color.BlipBlue())
					SetBlipRouteColour(quickGpsBlip, Color.BlipBlue())
					SetBlipHighDetail(quickGpsBlip, true)
					SetBlipRoute(quickGpsBlip, true)
				end

				WarMenu.CloseMenu()
			elseif WarMenu.MenuButton('Ammu-Nation', 'ammunation') then
			elseif not MissionManager.Mission and GetTimeDifference(GetGameTimer(), MissionManager.MissionFinishedTime) >= Settings.missions.timeout and WarMenu.MenuButton('Missions', 'missions') then
			elseif not MissionManager.Mission and GetTimeDifference(GetGameTimer(), MissionManager.MissionFinishedTime) < Settings.missions.timeout and WarMenu.Button('Missions', ms_to_string(Settings.missions.timeout - GetTimeDifference(GetGameTimer(), MissionManager.MissionFinishedTime))) then
				Gui.DisplayNotification('~r~Unable to start mission right now.')
			elseif WarMenu.Button('Kill Yourself') then
				SetEntityHealth(PlayerPedId(), 0)

				WarMenu.CloseMenu()
			elseif WarMenu.MenuButton('Report Player', 'reportPlayer') then
			elseif MissionManager.Mission and WarMenu.Button('~r~Cancel Mission') then
				MissionManager.CancelMission()
				WarMenu.CloseMenu()
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('missions') then
			if WarMenu.Button('Market Manipulation') then
				TriggerEvent('lsv:startMarketManipulation')
				WarMenu.CloseMenu()
			elseif WarMenu.Button('Velocity') then
				TriggerEvent('lsv:startVelocity')
				WarMenu.CloseMenu()
			elseif WarMenu.Button('Most Wanted') then
				TriggerEvent('lsv:startMostWanted')
				WarMenu.CloseMenu()
			elseif WarMenu.Button('Asset Recovery') then
				TriggerEvent('lsv:startAssetRecovery')
				WarMenu.CloseMenu()
			elseif WarMenu.Button('Headhunter') then
				TriggerEvent('lsv:startHeadhunter')
				WarMenu.CloseMenu()
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('reportPlayer') then
			for i = 0, Settings.maxPlayerCount do
				if i ~= PlayerId() and NetworkIsPlayerActive(i) then
					local target = GetPlayerServerId(i)
					if not table.find(reportedPlayers, target) and WarMenu.MenuButton(GetPlayerName(i), 'reportReason') then
						reportingPlayer = target
					end
				end
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('reportReason') then
			table.foreach(reportingReasons, function(reason)
				if WarMenu.Button(reason) then
					TriggerServerEvent('lsv:reportPlayer', reportingPlayer, reason)
					table.insert(reportedPlayers, reportingPlayer)
					reportingPlayer = nil
					WarMenu.CloseMenu()
				end
			end)

			WarMenu.Display()
		end

		Citizen.Wait(0)
	end
end)


AddEventHandler('lsv:init', function()
	while true do
		Citizen.Wait(0)

		if not WarMenu.IsAnyMenuOpened() and IsControlJustPressed(1, 244) then
			WarMenu.OpenMenu('interaction')
		end
	end
end)


AddEventHandler('lsv:init', function()
	while true do
		Citizen.Wait(0)

		if quickGpsBlip and not IsPlayerDead(PlayerId()) then
			if Player.DistanceTo(GetBlipCoords(quickGpsBlip), false) < 50.0 then
				RemoveBlip(quickGpsBlip)
				quickGpsSelectedIndex = 1
				quickGpsCurrentIndex = 1
				quickGpsBlip = nil
			end
		end
	end
end)
