local logger = Logger.New('HuntTheBeast')

local beastData = nil


AddEventHandler('lsv:startHuntTheBeast', function()
	beastData = { }
	beastData.beast = Scoreboard.GetRandomPlayer()

	beastData.landmarks = { }
	table.iforeach(Settings.huntTheBeast.landmarks, function(position)
		table.insert(beastData.landmarks, { position = position, picked = false })
	end)

	beastData.landmarksPicked = 0
	beastData.totalLandmarks = Settings.huntTheBeast.targetLandmarks
	beastData.livesLeft = Settings.huntTheBeast.lives

	beastData.eventStartTime = Timer.New()

	logger:Info('Start { '..beastData.beast..' }')

	TriggerClientEvent('lsv:startHuntTheBeast', -1, beastData)

	while true do
		Citizen.Wait(0)

		if not beastData then return end

		if beastData.livesLeft == 0 then
			beastData = nil
			TriggerClientEvent('lsv:finishHuntTheBeast', -1)
			EventManager.StopEvent()
			return
		end

		if beastData.eventStartTime:Elapsed() < Settings.huntTheBeast.duration then
			if beastData.landmarksPicked == beastData.totalLandmarks then
				logger:Info('Beast won { '..beastData.beast..' }')
				Db.UpdateCash(beastData.beast, Settings.huntTheBeast.rewards.beast.min.cash)
				Db.UpdateExperience(beastData.beast, Settings.huntTheBeast.rewards.beast.min.exp)
				TriggerClientEvent('lsv:finishHuntTheBeast', -1, beastData.beast)
				EventManager.StopEvent(beastData.beast)
				beastData = nil
				return
			end
		else
			logger:Info('Beast lost { '..beastData.beast..' }')
			Db.UpdateCash(beastData.beast, Settings.huntTheBeast.rewards.beast.min.cash)
			Db.UpdateExperience(beastData.beast, Settings.huntTheBeast.rewards.beast.min.exp)
			TriggerClientEvent('lsv:finishHuntTheBeast', -1)
			beastData = nil
			EventManager.StopEvent()
			return
		end
	end
end)


RegisterNetEvent('lsv:huntTheBeastLandmarkCollected')
AddEventHandler('lsv:huntTheBeastLandmarkCollected', function(index)
	local player = source
	if not beastData then return end
	if player ~= beastData.beast or beastData.landmarksPicked == beastData.totalLandmarks then return end
	logger:Info('Collected { '..index..' }')
	Db.UpdateCash(beastData.beast, Settings.huntTheBeast.rewards.beast.landmark.cash)
	Db.UpdateExperience(beastData.beast, Settings.huntTheBeast.rewards.beast.landmark.exp)
	beastData.landmarksPicked = beastData.landmarksPicked + 1
	beastData.landmarks[index].picked = true
	TriggerClientEvent('lsv:huntTheBeastLandmarkCollected', -1, index)
end)


AddEventHandler('lsv:playerConnected', function(player)
	if not beastData then return end
	TriggerClientEvent('lsv:startHuntTheBeast', player, beastData, beastData.eventStartTime:Elapsed())
end)


AddEventHandler('lsv:playerDropped', function(player)
	if not beastData or beastData.beast ~= player then return end
	logger:Info('Beast left { '..player..' }')
	beastData = nil
	TriggerClientEvent('lsv:finishHuntTheBeast', -1)
	EventManager.StopEvent()
end)


AddEventHandler('baseevents:onPlayerDied', function()
	local player = source
	if not beastData or beastData.beast ~= player or beastData.livesLeft == 0 then return end
	logger:Info('Died { '..player..' }')
	beastData.livesLeft = beastData.livesLeft - 1
	TriggerClientEvent('lsv:huntTheBeastKilled', -1)
end)


AddEventHandler('baseevents:onPlayerKilled', function(killer)
	local victim = source
	if not beastData or beastData.beast ~= victim or beastData.livesLeft == 0 then return end
	logger:Info('Killed { '..killer..' }')
	Db.UpdateCash(killer, Settings.huntTheBeast.rewards.killer.cash)
	Db.UpdateExperience(killer, Settings.huntTheBeast.rewards.killer.exp)
	beastData.livesLeft = beastData.livesLeft - 1
	TriggerClientEvent('lsv:huntTheBeastKilled', -1)
end)
