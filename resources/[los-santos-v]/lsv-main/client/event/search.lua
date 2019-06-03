local searchData = nil

local instructionsText = 'Enter the area and survive or kill the target to earn reward.'

local isPlayerOutOfArea = false
local outOfAreaTime = nil
local outOfAreaSound = nil
local wasPlayerInArea = false

local helpHandler = nil


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
		if Player.IsInFreeroam() and not passedTime then Gui.StartEvent('Executive Search', instructionsText) end

		searchData.zoneBlip = Map.CreateRadiusBlip(searchData.place.x, searchData.place.y, searchData.place.z, Settings.executiveSearch.radius, Color.BlipPurple())
		searchData.blip = Map.CreateEventBlip(Blip.ExecutiveSearch(), searchData.place.x, searchData.place.y, searchData.place.z, 'Executive Search', Color.BlipPurple())
		Map.SetBlipFlashes(searchData.blip)

		while true do
			Citizen.Wait(0)

			if not searchData then return end

			if Player.IsInFreeroam() then
				Gui.DrawTimerBar('EVENT END', math.max(0, Settings.executiveSearch.duration - GetGameTimer() + searchData.startTime))

				if isPlayerOutOfArea then Gui.DrawTimerBar('OUT OF AREA', outOfAreaTime:Elapsed()) end

				local eventObjectiveText = 'Enter the ~p~area~w~.'
				if World.ExecutiveSearchPlayer then
					if World.ExecutiveSearchPlayer == Player.ServerId() then eventObjectiveText = isPlayerOutOfArea and 'Go back to the ~p~area~w~.' or 'Stay hidden and survive in the ~p~area~s~.'
					else eventObjectiveText = 'Find and kill '..Gui.GetPlayerName(World.ExecutiveSearchPlayer)..' in the ~p~area~w~.' end
				end
				Gui.DisplayObjectiveText(eventObjectiveText)
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
		wasPlayerInArea = false

		while true do
			Citizen.Wait(0)

			if not searchData then return end

			if Player.DistanceTo(searchData.place, true) <= Settings.executiveSearch.radius then
				wasPlayerInArea = true
				return
			end
		end
	end)

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

	if helpHandler then helpHandler:Cancel() end

	if searchData then
		RemoveBlip(searchData.zoneBlip)
		RemoveBlip(searchData.blip)
	end

	ReleaseSoundId(outOfAreaSound)
	outOfAreaSound = nil

	searchData = nil

	if not victim or not killer then return end

	local isPlayerWinner = killer == Player.ServerId()
	local messageText = Gui.GetPlayerName(killer)..' has won Executive Search by killing '..Gui.GetPlayerName(victim, '~p~', true)..'.'
	if killer == victim then messageText = Gui.GetPlayerName(killer, '~p~')..' has won Executive Search by surviving the search.' end

	if Player.IsInFreeroam() and wasPlayerInArea then
		if isPlayerWinner then PlaySoundFrontend(-1, 'Mission_Pass_Notify', 'DLC_HEISTS_GENERAL_FRONTEND_SOUNDS', true)
		else PlaySoundFrontend(-1, 'ScreenFlash', 'MissionFailedSounds', true) end

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
	helpHandler = HelpQueue.PushFront('Keep walking or you will become visible on the Radar to other players.')
end)