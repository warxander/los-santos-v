local titles = { 'WINNER', '2ND PLACE', '3RD PLACE' }
local playerColors = { Color.BlipYellow(), Color.BlipGrey(), Color.BlipBrown() }
local playerPositions = { '1st: ', '2nd: ', '3rd: ' }
local instructionsText = 'Collect the briefcase and hold it for as long as possible for cash reward.'

local propertyData = nil


local function createBriefcase(x, y, z)
	propertyData.pickup = CreatePickupRotate(GetHashKey('PICKUP_MONEY_CASE'), x, y, z, 0.0, 0.0, 0.0, 8, 1)
	propertyData.blip = Map.CreatePickupBlip(propertyData.pickup, 'PICKUP_MONEY_CASE', Color.BlipGreen())
	SetBlipAsShortRange(propertyData.blip, false)
	SetBlipScale(propertyData.blip, 1.1)
end

local function removeBriefcase()
	if propertyData.pickup then
		RemovePickup(propertyData.pickup)
		propertyData.pickup = nil

		RemoveBlip(propertyData.blip)
		propertyData.blip = nil
	end
end

local function getPlayerTime()
	local player = table.find_if(propertyData.players, function(player) return player.id == Player.ServerId() end)
	return ms_to_string(player and player.totalTime or 0)
end


RegisterNetEvent('lsv:startHotProperty')
AddEventHandler('lsv:startHotProperty', function(placeIndex, passedTime, players, currentPlayer)
	-- Preparations
	local place = Settings.property.places[placeIndex]

	propertyData = { }

	propertyData.startTime = GetGameTimer()
	if passedTime then propertyData.startTime = propertyData.startTime - passedTime end

	propertyData.players = { }
	if players then propertyData.players = players end

	World.HotPropertyPlayer = currentPlayer

	-- This is shit. New players will not see briefcase. Should fix in 1s
	if not currentPlayer and not passedTime then
		createBriefcase(place.x, place.y, place.z)
		SetBlipAlpha(propertyData.blip, 0)
	end

	-- GUI
	Citizen.CreateThread(function()
		PlaySoundFrontend(-1, 'MP_5_SECOND_TIMER', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)

		if Player.IsInFreeroam() and not passedTime then
			local scaleform = Scaleform:Request('MIDSIZED_MESSAGE')
			scaleform:Call('SHOW_SHARD_MIDSIZED_MESSAGE', 'Hot Property started', instructionsText)
			scaleform:RenderFullscreenTimed(10000)
			scaleform:Delete()

			if not propertyData then return end
		else
			Gui.DisplayNotification(instructionsText)
		end

		if propertyData.blip then
			FlashMinimapDisplay()
			SetBlipAlpha(propertyData.blip, 255)
			Map.SetBlipFlashes(propertyData.blip)
		end

		while true do
			Citizen.Wait(0)

			if not propertyData then return end

			if Player.IsInFreeroam() then
				local eventObjectiveText = 'Collect the ~g~briefcase~w~ and hold on to it.'
				if World.HotPropertyPlayer then
					if World.HotPropertyPlayer == Player.ServerId() then
						eventObjectiveText = 'Hold on to the briefcase for as long as possible.'
					else eventObjectiveText = Gui.GetPlayerName(World.HotPropertyPlayer, '~w~')..' has the ~r~briefcase~w~. Take it from him.' end
				end
				Gui.DisplayObjectiveText(eventObjectiveText)

				if propertyData.pickup then
					local pickupPosition = GetPickupCoords(propertyData.pickup)
					DrawMarker(20, pickupPosition.x, pickupPosition.y, pickupPosition.z + 0.25, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.85, 0.85, 0.85, 114, 204, 114, 96, true, true)
				end

				Gui.DrawTimerBar('EVENT END', math.max(0, Settings.property.duration - GetGameTimer() + propertyData.startTime))
				Gui.DrawBar('TIME HELD', getPlayerTime(), Color.GetHudFromBlipColor(Color.BlipWhite()), 2)

				local barPosition = 3
				for i = barPosition, 1, -1 do
					if propertyData.players[i] then
						Gui.DrawBar(playerPositions[i]..GetPlayerName(GetPlayerFromServerId(propertyData.players[i].id)), ms_to_string(propertyData.players[i].totalTime),
							Color.GetHudFromBlipColor(playerColors[i]), barPosition, true)
						barPosition = barPosition + 1
					end
				end
			end
		end
	end)

	-- Logic
	Citizen.CreateThread(function()
		local lastTime = nil

		while true do
			Citizen.Wait(0)

			if not propertyData then return end

			if propertyData.pickup and HasPickupBeenCollected(propertyData.pickup) then
				TriggerServerEvent('lsv:hotPropertyCollected')
				removeBriefcase()
			end

			if World.HotPropertyPlayer == Player.ServerId() then
				if not lastTime then lastTime = GetGameTimer()
				elseif GetTimeDifference(GetGameTimer(), lastTime) >= 1000 then
					TriggerServerEvent('lsv:hotPropertyTimeUpdated')
					lastTime = GetGameTimer()
				end
			else lastTime = nil end
		end
	end)
end)


RegisterNetEvent('lsv:updateHotPropertyPlayers')
AddEventHandler('lsv:updateHotPropertyPlayers', function(players)
	if propertyData then propertyData.players = players end
end)


RegisterNetEvent('lsv:hotPropertyCollected')
AddEventHandler('lsv:hotPropertyCollected', function(player)
	if not propertyData then return end

	removeBriefcase()

	World.HotPropertyPlayer = player
end)


RegisterNetEvent('lsv:hotPropertyDropped')
AddEventHandler('lsv:hotPropertyDropped', function(player)
	if not propertyData then return end

	local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(player))))
	removeBriefcase()
	createBriefcase(x, y, z)

	World.HotPropertyPlayer = nil
end)


RegisterNetEvent('lsv:finishHotProperty')
AddEventHandler('lsv:finishHotProperty', function(winners)
	World.HotPropertyPlayer = nil

	if propertyData then removeBriefcase() end

	if not winners then
		propertyData = nil
		Gui.DisplayNotification('Hot Property has ended.')
		return
	end

	local playerTime = getPlayerTime()
	propertyData = nil

	local isPlayerWinner = false
	for i = 1, math.min(3, #winners) do
		if winners[i] == Player.ServerId() then
			isPlayerWinner = i
			break
		end
	end

	local messageText = Gui.GetPlayerName(winners[1])..' won Hot Property.'
	if isPlayerWinner then messageText = 'You won Hot Property with a time of '..playerTime end

	if isPlayerWinner then PlaySoundFrontend(-1, 'Mission_Pass_Notify', 'DLC_HEISTS_GENERAL_FRONTEND_SOUNDS', true)
	else PlaySoundFrontend(-1, 'ScreenFlash', 'MissionFailedSounds', true) end

	if Player.IsInFreeroam() then
		local scaleform = Scaleform:Request('MIDSIZED_MESSAGE')
		scaleform:Call('SHOW_SHARD_MIDSIZED_MESSAGE', isPlayerWinner and titles[isPlayerWinner] or 'YOU LOSE', messageText, 21)
		scaleform:RenderFullscreenTimed(10000)
		scaleform:Delete()
	else
		Gui.DisplayNotification(messageText)
	end
end)