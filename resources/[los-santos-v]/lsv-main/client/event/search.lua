local searchData = nil

local instructionsText = 'Enter the area and survive or kill the target to earn cash.'

local isPlayerOutOfArea = false
local outOfAreaTime = nil
local outOfAreaSound = nil


RegisterNetEvent('lsv:startExecutiveSearch')
AddEventHandler('lsv:startExecutiveSearch', function(data, passedTime)
	if searchData then return end

	searchData = { }

	searchData.place = Settings.executiveSearch.places[data.placeIndex]
	searchData.startTime = GetGameTimer()
	if passedTime then searchData.startTime = searchData.startTime - passedTime end

	World.ExecutiveSearchPlayer = data.target

	-- GUI
	Citizen.CreateThread(function()
		PlaySoundFrontend(-1, 'MP_5_SECOND_TIMER', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)

		if Player.IsInFreeroam() and not passedTime then
			local scaleform = Scaleform:Request('MIDSIZED_MESSAGE')
			scaleform:Call('SHOW_SHARD_MIDSIZED_MESSAGE', 'Executive Search started', instructionsText)
			scaleform:RenderFullscreenTimed(10000)
			scaleform:Delete()

			if not searchData then return end
		else
			Gui.DisplayNotification(instructionsText)
		end

		FlashMinimapDisplay()

		searchData.zoneBlip = Map.CreateRadiusBlip(searchData.place.x, searchData.place.y, searchData.place.z, Settings.executiveSearch.radius, Color.BlipPurple())
		searchData.blip = Map.CreateEventBlip(Blip.Target(), searchData.place.x, searchData.place.y, searchData.place.z, 'Executive Search', Color.BlipPurple())
		Map.SetBlipFlashes(searchData.blip)

		while true do
			Citizen.Wait(0)

			if not searchData then return end

			if Player.IsInFreeroam() then
				Gui.DrawTimerBar('EVENT END', math.max(0, Settings.executiveSearch.duration - GetGameTimer() + searchData.startTime))

				local eventObjectiveText = 'Enter the ~p~area~w~.'
				if World.ExecutiveSearchPlayer then
					if World.ExecutiveSearchPlayer == Player.ServerId() then eventObjectiveText = isPlayerOutOfArea and 'Go back to the ~p~area~w~.' or 'Stay hidden and survive in the ~p~area~s~.'
					else eventObjectiveText = 'Find and kill '..Gui.GetPlayerName(World.ExecutiveSearchPlayer, '~r~')..' in the ~p~area~w~.' end
				end
				Gui.DisplayObjectiveText(eventObjectiveText)
			end

			if isPlayerOutOfArea then
				Gui.DrawTimerBar('OUT OF AREA', outOfAreaTime:Elapsed(), false, 2)
			end
		end
	end)

	-- Logic
	if not World.ExecutiveSearchPlayer then
		Citizen.CreateThread(function()
			while true do
				Citizen.Wait(0)

				if not searchData or World.ExecutiveSearchPlayer then return end

				if Player.DistanceTo(searchData.place, true) <= Settings.executiveSearch.radius then
					TriggerServerEvent('lsv:onExecutiveSearchAreaEntered')
					return
				end
			end
		end)
	end

	Citizen.CreateThread(function()
		outOfAreaSound = GetSoundId()

		while true do
			Citizen.Wait(0)

			if not searchData then return end

			if World.ExecutiveSearchPlayer then
				if World.ExecutiveSearchPlayer ~= Player.ServerId() then return end

				if Player.DistanceTo(searchData.place, true) > Settings.executiveSearch.radius then
					if not outOfAreaTime then
						outOfAreaTime = Timer.New()
						PlaySoundFrontend(outOfAreaSound, '5s_To_Event_Start_Countdown', 'GTAO_FM_Events_Soundset', false)
					end

					if outOfAreaTime:Elapsed() >= Settings.executiveSearch.outOfAreaTimeout then
						isPlayerOutOfArea = true
					else
						TriggerServerEvent('lsv:onExecutiveSearchAreaLeft')
						Player.Kill()
						outOfAreaTime = nil
						isPlayerOutOfArea = false
						return
					end
				else
					outOfAreaTime = nil
					isPlayerOutOfArea = false
					StopSound(outOfAreaSound)
				end
			end
		end
	end)
end)


RegisterNetEvent('lsv:finishExecutiveSearch')
AddEventHandler('lsv:finishExecutiveSearch', function(victim, killer)
	World.ExecutiveSearchPlayer = nil

	if searchData then
		RemoveBlip(searchData.zoneBlip)
		RemoveBlip(searchData.blip)
	end

	ReleaseSoundId(outOfAreaSound)
	outOfAreaSound = nil

	searchData = nil

	if not victim or not killer then
		Gui.DisplayNotification('Executive Search has ended.')
		return
	end

	local isPlayerWinner = killer == Player.ServerId()
	local messageText = Gui.GetPlayerName(killer)..' won Executive Search by killing the target '..Gui.GetPlayerName(victim, '~p~')..'.'
	if killer == victim then messageText = Gui.GetPlayerName(killer, '~p~')..' won Executive Search by surviving the search.' end

	if isPlayerWinner then PlaySoundFrontend(-1, 'Mission_Pass_Notify', 'DLC_HEISTS_GENERAL_FRONTEND_SOUNDS', true)
	else PlaySoundFrontend(-1, 'ScreenFlash', 'MissionFailedSounds', true) end

	if Player.IsInFreeroam() then
		local scaleform = Scaleform:Request('MIDSIZED_MESSAGE')
		scaleform:Call('SHOW_SHARD_MIDSIZED_MESSAGE', isPlayerWinner and 'WINNER' or 'YOU LOSE', messageText, 21)
		scaleform:RenderFullscreenTimed(10000)
		scaleform:Delete()
	else
		Gui.DisplayNotification(messageText)
	end	
end)


RegisterNetEvent('lsv:onExecutiveSearchAreaEntered')
AddEventHandler('lsv:onExecutiveSearchAreaEntered', function(target)
	World.ExecutiveSearchPlayer = target

	if not searchData then return end
	RemoveBlip(searchData.blip)

	if World.ExecutiveSearchPlayer ~= Player.ServerId() then return end
	Gui.DisplayHelpText('Keep moving or you will become visible on the Radar to other players.')
end)