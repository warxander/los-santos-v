local duelRequestedTimer = nil
local duelData = nil


RegisterNetEvent('lsv:duelRejected')
AddEventHandler('lsv:duelRejected', function(message)
	World.DuelPlayer = nil
	FlashMinimapDisplay()
	Gui.DisplayNotification(message)
end)


RegisterNetEvent('lsv:duelRequested')
AddEventHandler('lsv:duelRequested', function(opponent)
	if duelRequestedTimer then return end

	duelRequestedTimer = Timer.New()

	local opponentId = GetPlayerFromServerId(opponent)

	local handle = RegisterPedheadshot(GetPlayerPed(opponentId))
	while not IsPedheadshotReady(handle) or not IsPedheadshotValid(handle) do Citizen.Wait(0) end
	local txd = GetPedheadshotTxdString(handle)

	StartScreenEffect('SuccessNeutral', 0, false)
	FlashMinimapDisplay()
	PlaySoundFrontend(-1, 'EVENT_START_TEXT', 'GTAO_FM_EVENTS_SOUNDSET', true)
	Gui.DisplayNotification('ONE ON ONE DEATHMATCH', txd, GetPlayerName(opponentId), '', 7)

	Citizen.Wait(1500)
	duelRequestedTimer:Restart()

	while duelRequestedTimer and duelRequestedTimer:Elapsed() < Settings.duel.requestTimeout do
		Citizen.Wait(0)

		Gui.DisplayHelpText('Press ~INPUT_VEH_HEADLIGHT~ to accept a duel invitation.')

		if IsControlJustReleased(0, 74) then
			TriggerServerEvent('lsv:duelAccepted', opponent)
			duelRequestedTimer = nil
		end
	end
	duelRequestedTimer = nil
end)


RegisterNetEvent('lsv:duelUpdated')
AddEventHandler('lsv:duelUpdated', function(data)
	if not duelData then
		World.DuelPlayer = data.opponent
		duelData = data

		Citizen.CreateThread(function()
			PlaySoundFrontend(-1, 'EVENT_START_TEXT', 'GTAO_FM_EVENTS_SOUNDSET', true)
			local scaleform = Scaleform:Request('MIDSIZED_MESSAGE')
			scaleform:Call('SHOW_SHARD_MIDSIZED_MESSAGE', 'ONE ON ONE DEATHMATCH', '')
			scaleform:RenderFullscreenTimed(10000)
			scaleform:Delete()
		end)

		Citizen.CreateThread(function()
			while true do
				Citizen.Wait(0)

				if not duelData then return end

				if Player.IsActive() then
					Gui.DrawBar('TARGET SCORE', Settings.duel.targetScore)
					Gui.DrawBar(GetPlayerName(GetPlayerFromServerId(duelData.opponent)), duelData.opponentScore, Color.GetHudFromBlipColor(Color.BlipRed()), 2, true)
					Gui.DrawBar(GetPlayerName(PlayerId()), duelData.score, Color.GetHudFromBlipColor(Color.BlipBlue()), 3, true)
				end
			end
		end)
	else
		duelData.score = data.score
		duelData.opponentScore = data.opponentScore
	end
end)


RegisterNetEvent('lsv:duelEnded')
AddEventHandler('lsv:duelEnded', function(winner, looser)
	if winner and winner ~= Player.ServerId() and looser ~= Player.ServerId() then
		Gui.DisplayNotification(Gui.GetPlayerName(winner)..' has defeated '..Gui.GetPlayerName(looser)..' in a duel.')
		return
	end

	World.DuelPlayer = nil
	duelData = nil

	if not winner then return end

	local isWinner = winner == Player.ServerId()
	if isWinner then PlaySoundFrontend(-1, 'Mission_Pass_Notify', 'DLC_HEISTS_GENERAL_FRONTEND_SOUNDS', true)
	elseif Player.IsActive() then PlaySoundFrontend(-1, 'ScreenFlash', 'MissionFailedSounds', true) end

	local scaleform = Scaleform:Request('MIDSIZED_MESSAGE')
	scaleform:Call('SHOW_SHARD_MIDSIZED_MESSAGE', isWinner and 'WINNER' or 'LOOSER', '')
	scaleform:RenderFullscreenTimed(10000)
	scaleform:Delete()
end)