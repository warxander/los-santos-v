local blip = nil
local inProgress = false

AddEventHandler('lsv:distractCops', function()
	if inProgress then
		Gui.DisplayNotification('Event is still in progress.')
		return 
	end

	inProgress = true

	PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", true)
	Gui.DisplayNotification('Distract the cops in the area marked by blue circle.')

	local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))
	blip = Map.CreateRadiusBlip(x, y, z, Settings.distractCopsRadius, Color.Blue)

	Citizen.Wait(3500)

	StartScreenEffect("SuccessMichael", 0, false)

	World.SetWantedLevel(2)

	local eventStartTime = GetGameTimer()

	while true do
		Citizen.Wait(0)

		if GetTimeDifference(GetGameTimer(), eventStartTime) < Settings.distractCopsTime then
			local playerX, playerY, playerZ = table.unpack(GetEntityCoords(PlayerPedId(), true))
			if IsPlayerDead(PlayerId()) or GetPlayerWantedLevel(PlayerId()) == 0 or GetDistanceBetweenCoords(playerX, playerY, playerZ, x, y, z, false) > Settings.distractCopsRadius then
				TriggerEvent('lsv:distractCopsFinished', false)
				return
			else
				local passedTime = GetGameTimer() - eventStartTime
				local secondsLeft = math.floor((Settings.distractCopsTime - passedTime) / 1000)
				Gui.DrawTimerBar(0.13, 'DISTRACT TIME', secondsLeft)
				Gui.DisplayObjectiveText('Stay in the ~b~area~w~.')
				World.SetWantedLevel(math.floor(passedTime / Settings.distractCopsWantedInterval) + 1)
			end
		else
			TriggerServerEvent('lsv:distractCopsFinished')
			return
		end
	end
end)


RegisterNetEvent('lsv:distractCopsFinished')
AddEventHandler('lsv:distractCopsFinished', function(success)
	RemoveBlip(blip)
	World.SetWantedLevel(0)

	StartScreenEffect("SuccessMichael", 0, false)

	Citizen.Wait(500)

	local message = success and '+'..tostring(Settings.distractCopsReward)..' RP' or 'Event failed.'

	local scaleform = Scaleform:Request('MIDSIZED_MESSAGE')

	scaleform:Call('SHOW_SHARD_MIDSIZED_MESSAGE', 'Distract Cops', message)
	scaleform:RenderFullscreenTimed(5000)

	scaleform:Delete()

	inProgress = false
end)