RegisterNetEvent('lsv:finishMostWanted')
AddEventHandler('lsv:finishMostWanted', function(success, reason)
	MissionManager.FinishMission(success)

	World.EnableWanted(false)

	Gui.FinishMission('Most Wanted', success, reason)
end)

AddEventHandler('lsv:startMostWanted', function()
	local missionTimer = Timer.New()

	Gui.StartMission('Most Wanted', 'Survive the longest with a wanted level.')

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)

			if not MissionManager.Mission then
				return
			end

			if Player.IsActive() then
				Gui.DrawTimerBar('MISSION TIME', Settings.mostWanted.time - missionTimer:elapsed(), 1)
				Gui.DrawTimerBar('TIME SURVIVED', missionTimer:elapsed(), 2, nil, Color.WHITE)
				Gui.DisplayObjectiveText('Survive the longest with a wanted level.')
			end
		end
	end)

	World.EnableWanted(true)
	World.SetWantedLevel(3)

	while true do
		Citizen.Wait(0)

		if not MissionManager.Mission then
			return
		end

		if missionTimer:elapsed() < Settings.mostWanted.time then
			if IsPlayerDead(PlayerId()) or GetPlayerWantedLevel(PlayerId()) == 0 then
				TriggerServerEvent('lsv:finishMostWanted', missionTimer:elapsed())
				return
			end
		else
			TriggerServerEvent('lsv:finishMostWanted', Settings.mostWanted.time)
			return
		end
	end
end)
