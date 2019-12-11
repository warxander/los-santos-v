local markerColor = Color.GetHudFromBlipColor(Color.BLIP_YELLOW)

local beastData = nil


RegisterNetEvent('lsv:startHuntTheBeast')
AddEventHandler('lsv:startHuntTheBeast', function(data, passedTime)
	if beastData then return end

	beastData = { }

	World.BeastPlayer = data.beast

	beastData.landmarks = data.landmarks
	table.iforeach(beastData.landmarks, function(landmark)
		if landmark.picked then return end
		landmark.blip = Map.CreateEventBlip(Blip.STANDARD, landmark.position.x, landmark.position.y, landmark.position.z, 'Landmark', Color.BLIP_YELLOW)
		SetBlipScale(landmark.blip, 1.0)
		if World.BeastPlayer == Player.ServerId() then Map.SetBlipFlashes(landmark.blip) end
	end)

	beastData.livesLeft = data.livesLeft
	beastData.totalLandmarks = data.totalLandmarks
	beastData.landmarksPicked = data.landmarksPicked

	beastData.startTime = GetGameTimer()
	if passedTime then beastData.startTime = beastData.startTime - passedTime end

	-- GUI
	Citizen.CreateThread(function()
		if Player.IsInFreeroam() and not passedTime then
			Gui.StartEvent('Hunt The Beast', World.BeastPlayer == Player.ServerId() and 'You are the Beast. Visit '..beastData.totalLandmarks..' Landmarks in the given time.'
				or 'Track down the Beast and kill him '..beastData.livesLeft..' times.')
		end

		while true do
			Citizen.Wait(0)

			if not beastData then return end

			if Player.IsInFreeroam() then
				Gui.DisplayObjectiveText(World.BeastPlayer == Player.ServerId() and 'Go to each ~y~Landmark~w~.' or 'Hunt the ~r~Beast~w~.')

				Gui.DrawTimerBar('EVENT END', math.max(0, Settings.huntTheBeast.duration - GetGameTimer() + beastData.startTime), 1)
				Gui.DrawBar('LANDMARKS REMAINING', beastData.totalLandmarks - beastData.landmarksPicked, 2)
				Gui.DrawBar('BEAST LIVES', beastData.livesLeft, 3)
			end
		end
	end)


	-- Logic
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)

			if not beastData or World.BeastPlayer ~= Player.ServerId() then return end

			local playerPosition = Player.Position(true)
			local landmark, index = table.ifind_if(beastData.landmarks, function(landmark) return not landmark.picked and Vdist(playerPosition.x, playerPosition.y, playerPosition.z, landmark.position.x, landmark.position.y, landmark.position.z) <= Settings.huntTheBeast.radius end)
			if landmark then
				landmark.picked = true
				TriggerServerEvent('lsv:huntTheBeastLandmarkCollected', index)
			else
				table.iforeach(beastData.landmarks, function(landmark)
					if landmark.picked then return end

					if IsSphereVisible(landmark.position.x, landmark.position.y, landmark.position.z, Settings.huntTheBeast.radius) then
						Gui.DrawPlaceMarker(landmark.position.x, landmark.position.y, landmark.position.z - 1, Settings.huntTheBeast.radius, markerColor.r, markerColor.g, markerColor.b, Settings.placeMarkerOpacity)
					end
				end)
			end
		end
	end)
end)


RegisterNetEvent('lsv:finishHuntTheBeast')
AddEventHandler('lsv:finishHuntTheBeast', function(winner)
	if beastData then
		table.iforeach(beastData.landmarks, function(landmark)
			if landmark.blip then RemoveBlip(landmark.blip) end
		end)
	end

	World.BeastPlayer = nil

	beastData = nil

	local isPlayerWinner = Player.ServerId() == winner
	local messageText = winner and Gui.GetPlayerName(winner)..' has won Hunt The Beast.' or 'The Beast has lost.'
	if Player.IsInFreeroam() then
		if isPlayerWinner then PlaySoundFrontend(-1, 'Mission_Pass_Notify', 'DLC_HEISTS_GENERAL_FRONTEND_SOUNDS', true)
		else PlaySoundFrontend(-1, 'ScreenFlash', 'MissionFailedSounds', true) end

		local scaleform = Scaleform:Request('MIDSIZED_MESSAGE')
		scaleform:Call('SHOW_SHARD_MIDSIZED_MESSAGE', isPlayerWinner and 'WINNER' or 'EVENT OVER', messageText, 21)
		scaleform:RenderFullscreenTimed(10000)
		scaleform:Delete()
	else
		Gui.DisplayNotification(messageText)
	end
end)


RegisterNetEvent('lsv:huntTheBeastLandmarkCollected')
AddEventHandler('lsv:huntTheBeastLandmarkCollected', function(index)
	if not beastData then return end

	local landmark = beastData.landmarks[index]

	RemoveBlip(landmark.blip)
	landmark.blip = nil

	beastData.landmarksPicked = beastData.landmarksPicked + 1

	if World.BeastPlayer == Player.ServerId() then
		PlaySoundFrontend(-1, 'CHECKPOINT_AHEAD', 'HUD_MINI_GAME_SOUNDSET', false)
		Gui.DisplayPersonalNotification('You have visited a Landmark.')
	else
		Gui.DisplayNotification('The Beast has visited a Landmark.')
	end
end)


RegisterNetEvent('lsv:huntTheBeastKilled')
AddEventHandler('lsv:huntTheBeastKilled', function()
	if not beastData then return end
	beastData.livesLeft = beastData.livesLeft - 1
end)
