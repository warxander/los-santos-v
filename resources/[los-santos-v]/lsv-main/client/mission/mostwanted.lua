local _missionTimer = nil

AddEventHandler('lsv:finishMostWanted', function(success, reason)
	if _missionTimer:elapsed() > 0 then
		TriggerServerEvent('lsv:finishMostWanted', _missionTimer:elapsed())
	else
		TriggerEvent('lsv:mostWantedFinished', false, reason or '')
	end
end)

RegisterNetEvent('lsv:mostWantedFinished')
AddEventHandler('lsv:mostWantedFinished', function(success, reason)
	MissionManager.FinishMission(success)

	World.EnableWanted(false)

	_missionTimer = nil

	Gui.FinishMission('Most Wanted', success, reason)
end)

AddEventHandler('lsv:startMostWanted', function()
	_missionTimer = Timer.New()

	Gui.StartMission('Most Wanted', 'Survive the longest with a wanted level.')

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)

			if not MissionManager.Mission then
				return
			end

			if Player.IsActive() then
				Gui.DrawBar('REWARD MULTIPLIER', 'x'..tostring(1 + (math.floor(_missionTimer:elapsed() / Settings.mostWanted.minTime) * Settings.mostWanted.rewardMultiplier)), 3)
				Gui.DrawBar('MISSION REWARD', '$'..tostring(math.floor(_missionTimer:elapsed() / 1000) * Settings.mostWanted.rewardPerSecond.cash), 2)
				Gui.DrawTimerBar('TIME SURVIVED', _missionTimer:elapsed(), 1, nil, Color.WHITE)
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

		if IsPlayerDead(PlayerId()) or GetPlayerWantedLevel(PlayerId()) == 0 then
			TriggerEvent('lsv:finishMostWanted', false)
			return
		end
	end
end)
