ChallengeManager = { }

local requestTimer = nil


function ChallengeManager.Request(opponent, challengeName, acceptEventName, ...)
	if not Player.IsActive() or World.ChallengingPlayer or requestTimer then return end

	requestTimer = Timer.New()

	local opponentId = GetPlayerFromServerId(opponent)

	local handle = RegisterPedheadshot(GetPlayerPed(opponentId))
	while not IsPedheadshotReady(handle) or not IsPedheadshotValid(handle) do Citizen.Wait(0) end
	local txd = GetPedheadshotTxdString(handle)

	FlashMinimapDisplay()
	PlaySoundFrontend(-1, 'EVENT_START_TEXT', 'GTAO_FM_EVENTS_SOUNDSET', true)
	Gui.DisplayPersonalNotification(string.upper(challengeName), txd, GetPlayerName(opponentId), '', 7)

	requestTimer:Restart()

	while requestTimer and requestTimer:Elapsed() < Settings.challenge.requestTimeout do
		Citizen.Wait(0)

		Gui.DisplayHelpText('Press ~INPUT_VEH_HEADLIGHT~ to accept '..challengeName..'.')

		if IsControlJustReleased(0, 74) then
			TriggerServerEvent(acceptEventName, opponent, ...)
			requestTimer = nil
		end
	end

	requestTimer = nil
end

function ChallengeManager.Finish(winner, looser, challengeName)
	if winner and winner ~= Player.ServerId() and looser ~= Player.ServerId() then
		Gui.DisplayNotification(Gui.GetPlayerName(winner)..' has defeated '..Gui.GetPlayerName(looser)..' in '..challengeName..'.')
		return false
	end

	World.ChallengingPlayer = nil

	if not winner then return true end

	local isWinner = winner == Player.ServerId()

	if Player.IsActive() then
		if isWinner then PlaySoundFrontend(-1, 'Mission_Pass_Notify', 'DLC_HEISTS_GENERAL_FRONTEND_SOUNDS', true)
		else PlaySoundFrontend(-1, 'ScreenFlash', 'MissionFailedSounds', true) end

		local scaleform = Scaleform:Request('MIDSIZED_MESSAGE')
		scaleform:Call('SHOW_SHARD_MIDSIZED_MESSAGE', isWinner and 'WINNER' or 'LOOSER', '')
		scaleform:RenderFullscreenTimed(10000)
		scaleform:Delete()
	else
		Gui.DisplayPersonalNotification(isWinner and 'You have won '..challengeName..'.' or 'You have lost '..challengeName..'.')
	end

	return true
end


RegisterNetEvent('lsv:challengeRejected')
AddEventHandler('lsv:challengeRejected', function(message)
	FlashMinimapDisplay()
	Gui.DisplayPersonalNotification(message)
end)