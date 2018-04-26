local quickGpsLocations = { "None", "Crate Drop", "Ammu-Nation", "Skin Shop" }
local quickGpsCurrentIndex = 1
local quickGpsSelectedIndex = 1
local quickGpsBlip = nil

local walkStyleCurrentIndex = 1
local walkStyleSelectedIndex = 1
local walkStyles = { "Normal", "Femme", "Gangster", "Posh", "Tough Guy" }
local walkStyleClipSets = {
	{ }, -- Normal
	{ maleClipSet = "MOVE_M@FEMME@", femaleClipSet = "MOVE_F@FEMME@" },
	{ maleClipSet = "MOVE_M@GANGSTER@NG", femaleClipSet = "MOVE_F@GANGSTER@NG" },
	{ maleClipSet = "MOVE_M@POSH@", femaleClipSet = "MOVE_F@POSH@" },
	{ maleClipSet = "MOVE_M@TOUGH_GUY@", femaleClipSet = "MOVE_F@TOUGH_GUY@" },
}

local reportedPlayers = { }
local reportingPlayer = nil
local reportingReasons = { "Inappropriate Player Name", "Harassment", "Cheating", "Spam" }

local function getClipSetBySex(clipSetIndex, isMale)
	if isMale then return walkStyleClipSets[clipSetIndex].maleClipSet end
	return walkStyleClipSets[clipSetIndex].femaleClipSet
end


AddEventHandler('lsv:updateWalkStyle', function(animSet)
	Streaming.RequestAnimSet(animSet)

	SetPedMovementClipset(PlayerPedId(), animSet, 1.0)

	RemoveAnimSet(animSet)
end)


AddEventHandler('lsv:init', function()
	WarMenu.CreateMenu('interaction', GetPlayerName(PlayerId()))
	WarMenu.SetTitleColor('interaction', 255, 255, 255)
	WarMenu.SetTitleBackgroundColor('interaction', Color.GetHudFromBlipColor(Color.BlipWhite()).r, Color.GetHudFromBlipColor(Color.BlipWhite()).g, Color.GetHudFromBlipColor(Color.BlipWhite()).b, Color.GetHudFromBlipColor(Color.BlipWhite()).a)
	WarMenu.SetTitleBackgroundSprite('interaction', 'commonmenu', 'interaction_bgd')

	WarMenu.CreateSubMenu('jobs', 'interaction', 'Jobs')
	WarMenu.CreateSubMenu('inviteToCrew', 'interaction', 'Invite to Crew')
	WarMenu.CreateSubMenu('reportPlayer', 'interaction', 'Report Player')
	WarMenu.CreateSubMenu('reportReason', 'reportPlayer', 'Select a reason for reporting')

	while true do
		if WarMenu.IsMenuOpened('interaction') then
			if IsEntityDead(PlayerPedId()) then
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
					local playerX, playerY, playerZ = table.unpack(GetEntityCoords(PlayerPedId(), true))
					for _, place in ipairs(places) do
						local placeX, placeY, placeZ = table.unpack(GetBlipCoords(place.blip))
						local distance = GetDistanceBetweenCoords(placeX, placeY, placeZ, playerX, playerY, playerZ, false)
						if distance < minDistance then
							minDistance = distance
							blip = place.blip
						end
					end
				end

				if blip then
					local x, y, z = table.unpack(GetBlipCoords(blip))
					quickGpsBlip = AddBlipForCoord(x, y, z)
					SetBlipSprite(quickGpsBlip, Blip.Waypoint())
					SetBlipColour(quickGpsBlip, Color.BlipBlue())
					SetBlipRouteColour(quickGpsBlip, Color.BlipBlue())
					SetBlipHighDetail(quickGpsBlip, true)
					SetBlipRoute(quickGpsBlip, true)
				end

				WarMenu.CloseMenu()
			elseif WarMenu.ComboBox('Walk Style', walkStyles, walkStyleCurrentIndex, walkStyleSelectedIndex, function(currentIndex, selectedIndex)
				walkStyleSelectedIndex = selectedIndex
				walkStyleCurrentIndex = currentIndex
			end) then
				if walkStyleSelectedIndex == 1 then
					ResetPedMovementClipset(PlayerPedId(), 0.0)
				else
					TriggerEvent('lsv:updateWalkStyle', getClipSetBySex(walkStyleSelectedIndex, IsPedMale(PlayerPedId())))
				end
			elseif not JobWatcher.IsAnyJobInProgress() and WarMenu.MenuButton('Jobs', 'jobs') then
			elseif WarMenu.MenuButton('Invite To Crew', 'inviteToCrew') then
			elseif Utils.GetTableLength(Player.crewMembers) ~= 0 and WarMenu.Button('Leave Crew') then
				TriggerServerEvent('lsv:leaveCrew')

				WarMenu.CloseMenu()
			elseif WarMenu.Button('Kill Yourself') then
				SetEntityHealth(PlayerPedId(), 0)

				WarMenu.CloseMenu()
			elseif WarMenu.MenuButton('Report Player', 'reportPlayer') then
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('inviteToCrew') then
			for i = 0, Settings.maxPlayerCount do
				if i ~= PlayerId() and NetworkIsPlayerActive(i) then
					local player = GetPlayerServerId(i)
					if not Player.isCrewMember(player) and WarMenu.Button(GetPlayerName(i)) then
						Gui.DisplayNotification('You have sent Crew Invitation to '..Gui.GetPlayerName(player))
						TriggerServerEvent('lsv:inviteToCrew', player)
						WarMenu.CloseMenu()
					end
				end
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('reportPlayer') then
			for i = 0, Settings.maxPlayerCount do
				if i ~= PlayerId() and NetworkIsPlayerActive(i) then
					local target = GetPlayerServerId(i)
					if not Utils.IndexOf(reportedPlayers, target) and WarMenu.MenuButton(GetPlayerName(i), 'reportReason') then
						reportingPlayer = target
					end
				end
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('reportReason') then
			for _, reason in ipairs(reportingReasons) do
				if WarMenu.Button(reason) then
					TriggerServerEvent('lsv:reportPlayer', reportingPlayer, reason)
					table.insert(reportedPlayers, reportingPlayer)
					reportingPlayer = nil
					WarMenu.CloseMenu()
				end
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('jobs') then
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

		if quickGpsBlip and not IsEntityDead(PlayerPedId()) then
			local x, y, z = GetBlipCoords(quickGpsBlip)
			local playerX, playerY, playerZ = table.unpack(GetEntityCoords(PlayerPedId(), true))

			if GetDistanceBetweenCoords(playerX, playerY, playerZ, x, y, z, false) < 50.0 then
				RemoveBlip(quickGpsBlip)
				quickGpsSelectedIndex = 1
				quickGpsCurrentIndex = 1
				quickGpsBlip = nil
			end
		end
	end
end)
