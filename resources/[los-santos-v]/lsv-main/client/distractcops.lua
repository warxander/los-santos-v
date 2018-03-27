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

	local scaleform = Scaleform:Request('MIDSIZED_MESSAGE')
	local message = success and '+'..tostring(Settings.distractCopsReward)..' RP' or 'Event failed.'
	local time = GetGameTimer()

	scaleform:Call('SHOW_SHARD_MIDSIZED_MESSAGE', 'Distract Cops', message)
	while GetGameTimer() - time < 5500 and not IsPlayerDead(PlayerId()) do
		Citizen.Wait(0)

		if GetGameTimer() - time > 5000 then
			scaleform:Call('SHARD_ANIM_OUT', 1, 0.33)
			time = time + 500

			while GetGameTimer() - time < 5500 do
				Citizen.Wait(0)
				scaleform:RenderFullscreen(255, 255, 255, 255)
			end

			break
		end

		scaleform:RenderFullscreen(255, 255, 255, 255)
	end

	scaleform:Delete()

	inProgress = false
end)