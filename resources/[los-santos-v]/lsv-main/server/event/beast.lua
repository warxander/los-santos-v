local logger = Logger.New('HuntTheBeast')

local _beastData = nil

RegisterNetEvent('lsv:huntTheBeastLandmarkCollected')
AddEventHandler('lsv:huntTheBeastLandmarkCollected', function(index)
	local player = source

	if not _beastData then
		return
	end

	if player ~= _beastData.beast or _beastData.landmarksPicked == _beastData.totalLandmarks then
		return
	end

	logger:info('Collected { '..index..' }')

	_beastData.landmarksPicked = _beastData.landmarksPicked + 1
	_beastData.landmarks[index].picked = true

	TriggerClientEvent('lsv:huntTheBeastLandmarkCollected', -1, index)
end)

AddEventHandler('lsv:startHuntTheBeast', function()
	_beastData = { }

	_beastData.beast = PlayerData.GetRandom()
	_beastData.landmarks = { }
	table.iforeach(Settings.huntTheBeast.landmarks, function(position)
		table.insert(_beastData.landmarks, { position = position, picked = false })
	end)

	_beastData.landmarksPicked = 0
	_beastData.totalLandmarks = Settings.huntTheBeast.targetLandmarks
	_beastData.livesLeft = Settings.huntTheBeast.lives

	_beastData.eventStartTimer = Timer.New()

	logger:info('Start { '.._beastData.beast..' }')

	TriggerClientEvent('lsv:startHuntTheBeast', -1, _beastData)

	while true do
		Citizen.Wait(0)

		if not _beastData then
			return
		end

		if _beastData.livesLeft == 0 then
			_beastData = nil
			TriggerClientEvent('lsv:finishHuntTheBeast', -1)

			EventScheduler.StopEvent()

			return
		end

		if _beastData.eventStartTimer:elapsed() < Settings.huntTheBeast.duration then
			if _beastData.landmarksPicked == _beastData.totalLandmarks then
				logger:info('Beast won { '.._beastData.beast..' }')

				PlayerData.UpdateCash(_beastData.beast, Settings.huntTheBeast.rewards.beast.landmark.cash * _beastData.landmarksPicked)
				PlayerData.UpdateExperience(_beastData.beast, Settings.huntTheBeast.rewards.beast.landmark.exp * _beastData.landmarksPicked)
				PlayerData.GiveDrugBusinessSupply(_beastData.beast)
				PlayerData.UpdateEventsWon(_beastData.beast)

				TriggerClientEvent('lsv:finishHuntTheBeast', -1, _beastData.beast)

				EventScheduler.StopEvent()
				_beastData = nil

				return
			end
		else
			logger:info('Beast lost { '.._beastData.beast..' }')

			PlayerData.UpdateCash(_beastData.beast, Settings.huntTheBeast.rewards.beast.landmark.cash * _beastData.landmarksPicked)
			PlayerData.UpdateExperience(_beastData.beast, Settings.huntTheBeast.rewards.beast.landmark.exp * _beastData.landmarksPicked)

			TriggerClientEvent('lsv:finishHuntTheBeast', -1)
			_beastData = nil

			EventScheduler.StopEvent()

			return
		end
	end
end)

AddEventHandler('lsv:onPlayerDied', function()
	local player = source

	if not _beastData or _beastData.beast ~= player or _beastData.livesLeft == 0 then
		return
	end

	logger:info('Died { '..player..' }')

	_beastData.livesLeft = _beastData.livesLeft - 1
	TriggerClientEvent('lsv:huntTheBeastKilled', -1)
end)

AddEventHandler('lsv:onPlayerKilled', function(killData)
	local victim = source

	if not _beastData or _beastData.beast ~= victim or _beastData.livesLeft == 0 then
		return
	end

	local killer = killData.killer

	logger:info('Killed { '..killer..' }')

	PlayerData.UpdateCash(killer, Settings.huntTheBeast.rewards.killer.cash)
	PlayerData.UpdateExperience(killer, Settings.huntTheBeast.rewards.killer.exp)

	_beastData.livesLeft = _beastData.livesLeft - 1
	TriggerClientEvent('lsv:huntTheBeastKilled', -1)
end)

AddEventHandler('lsv:playerConnected', function(player)
	if not _beastData then
		return
	end

	TriggerClientEvent('lsv:startHuntTheBeast', player, _beastData, _beastData.eventStartTimer:elapsed())
end)

AddEventHandler('lsv:playerDropped', function(player)
	if not _beastData or _beastData.beast ~= player then
		return
	end

	logger:info('Beast left { '..player..' }')

	_beastData = nil
	TriggerClientEvent('lsv:finishHuntTheBeast', -1)

	EventScheduler.StopEvent()
end)
