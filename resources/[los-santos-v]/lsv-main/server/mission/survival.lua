local logger = Logger.New('Survival')

local _survivalRecords = { }

RegisterNetEvent('lsv:finishSurvival')
AddEventHandler('lsv:finishSurvival', function(survivalId, extraWaveCount, lastWaveIndex)
	local player = source
	if not MissionManager.IsPlayerOnMission(player) or not Settings.survival.places[survivalId] then
		return
	end

	local reward = {
		cash = Settings.survival.reward.cash + extraWaveCount * Settings.survival.reward.cashPerWave,
		exp =  Settings.survival.reward.exp + extraWaveCount * Settings.survival.reward.expPerWave,
	}

	local rewardMessage = ''
	if extraWaveCount ~= 0 then
		local playerRecord = PlayerData.GetRecord(player, survivalId)
		if not playerRecord or lastWaveIndex > playerRecord then
			reward.cash = reward.cash + Settings.survival.personalReward.cash
			reward.exp = reward.exp + Settings.survival.personalReward.exp
			PlayerData.UpdateRecord(player, survivalId, lastWaveIndex)
			rewardMessage = 'New Personal Best: '
		end

		if not _survivalRecords[survivalId] or lastWaveIndex > _survivalRecords[survivalId].Waves then
			_survivalRecords[survivalId] = { }
			_survivalRecords[survivalId].PlayerName = PlayerData.GetName(player)
			_survivalRecords[survivalId].Waves = lastWaveIndex

			local recordData = _survivalRecords[survivalId]

			vSql.Async.execute('REPLACE INTO SurvivalRecords (SurvivalID, PlayerName, Waves) VALUES (@survivalId, @playerName, @waves)', { ['@survivalId'] = survivalId, ['@playerName'] = recordData.PlayerName, ['@waves'] = recordData.Waves })
			Discord.ReportNewSurvivalRecord(player, Settings.survival.places[survivalId].name, recordData.Waves)
			TriggerClientEvent('lsv:updateSurvivalRecord', -1, survivalId, recordData)

			reward.cash = reward.cash + Settings.survival.recordReward.cash
			reward.exp = reward.exp + Settings.survival.recordReward.exp
			rewardMessage = 'New Server Best: '

			logger:info('New record { '..survivalId..', '..recordData.PlayerName..', '..recordData.Waves..' }')
		end

		rewardMessage = rewardMessage..'Wave '..lastWaveIndex
	end

	PlayerData.UpdateCash(player, reward.cash)
	PlayerData.UpdateExperience(player, reward.exp)

	TriggerClientEvent('lsv:survivalFinished', player, true, rewardMessage)
end)

Citizen.CreateThread(function()
	vSql.Async.fetchAll('SELECT * FROM SurvivalRecords', nil, function(data)
		table.iforeach(data, function(record)
			_survivalRecords[record.SurvivalID] = { PlayerName = record.PlayerName, Waves = record.Waves }
		end)
		logger:info('Loaded '..table.length(data)..' records')
	end)
end)

AddEventHandler('lsv:playerConnected', function(player)
	TriggerClientEvent('lsv:initSurvivalRecords', player, _survivalRecords)
end)
