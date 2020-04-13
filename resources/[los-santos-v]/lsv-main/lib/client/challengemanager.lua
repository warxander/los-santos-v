ChallengeManager = { }
ChallengeManager.__index = ChallengeManager

local _requestTimer = nil

function ChallengeManager.Request(opponent, challengeName, acceptEventName, ...)
	if not Player.IsActive() or World.ChallengingPlayer or _requestTimer then
		return
	end

	_requestTimer = Timer.New()

	local opponentId = GetPlayerFromServerId(opponent)

	local handle = RegisterPedheadshot(GetPlayerPed(opponentId))
	while not IsPedheadshotReady(handle) or not IsPedheadshotValid(handle) do
		Citizen.Wait(0)
	end
	local txd = GetPedheadshotTxdString(handle)

	FlashMinimapDisplay()
	PlaySoundFrontend(-1, 'EVENT_START_TEXT', 'GTAO_FM_EVENTS_SOUNDSET', true)
	Gui.DisplayPersonalNotification(string.upper(challengeName), txd, GetPlayerName(opponentId), '', 7)

	_requestTimer:restart()

	while _requestTimer and _requestTimer:elapsed() < Settings.challenge.requestTimeout do
		Citizen.Wait(0)

		Gui.DisplayHelpText('Press ~INPUT_VEH_HEADLIGHT~ to accept '..challengeName..'.')

		if IsControlJustReleased(0, 74) then
			TriggerServerEvent(acceptEventName, opponent, ...)
			_requestTimer = nil
		end
	end

	_requestTimer = nil
end

RegisterNetEvent('lsv:challengeRejected')
AddEventHandler('lsv:challengeRejected', function(message)
	FlashMinimapDisplay()
	Gui.DisplayPersonalNotification(message)
end)
