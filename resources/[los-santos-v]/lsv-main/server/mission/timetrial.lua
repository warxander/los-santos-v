local logger = Logger.New('TimeTrial')

local _trialRecords = { }
local _playerRecords = { }

RegisterNetEvent('lsv:finishTimeTrial')
AddEventHandler('lsv:finishTimeTrial', function(trialId, time, place)
	local player = source
	if not MissionManager.IsPlayerOnMission(player) or not Settings.timeTrial.tracks[trialId] then
		return
	end

	local isNewRecord = false
	local isNewPersonal = false
	local rewardMessage = 'Time: '

	local currentRecord = PlayerData.GetRecord(player, trialId)
	if not currentRecord or time < currentRecord then
		isNewPersonal = true
		PlayerData.UpdateRecord(player, trialId, time)
		rewardMessage = 'New Personal Best: '
	end

	if not _trialRecords[trialId] or time < _trialRecords[trialId].Time then
		isNewRecord = true

		_trialRecords[trialId] = { }
		_trialRecords[trialId].PlayerName = PlayerData.GetName(player)
		_trialRecords[trialId].Time = time

		local recordData = _trialRecords[trialId]

		vSql.Async.execute('REPLACE INTO TimeTrialRecords (TrialID, PlayerName, Time) VALUES (@trialId, @playerName, @time)', { ['@trialId'] = trialId, ['@playerName'] = recordData.PlayerName, ['@time'] = recordData.Time })
		Discord.ReportNewTimeTrialRecord(player, Settings.timeTrial.tracks[trialId].name, string.from_ms(time, true))
		TriggerClientEvent('lsv:updateTimeTrialRecord', -1, trialId, recordData)

		logger:info('New record { '..trialId..', '..recordData.PlayerName..', '..recordData.Time..' }')
	end

	local cash = Settings.timeTrial.reward[place].cash
	local exp = Settings.timeTrial.reward[place].exp

	if isNewRecord or isNewPersonal then
		if not _playerRecords[player] or _playerRecords[player]:elapsed() >= Settings.timeTrial.recordReward.timeout then
			if isNewRecord then
				cash = Settings.timeTrial.recordReward.cash
				exp = Settings.timeTrial.recordReward.exp
			end

			if isNewPersonal then
				cash = cash + Settings.timeTrial.personalReward.cash
				exp = exp + Settings.timeTrial.personalReward.exp
			end

			_playerRecords[player] = Timer.New()
		end
	end

	PlayerData.UpdateCash(player, cash)
	PlayerData.UpdateExperience(player, exp)

	if isNewRecord then
		rewardMessage = 'New Server Best: '
	end

	rewardMessage = rewardMessage..string.from_ms(time, true)

	TriggerClientEvent('lsv:finishTimeTrial', player, true, rewardMessage)
end)

Citizen.CreateThread(function()
	vSql.Async.fetchAll('SELECT * FROM TimeTrialRecords', nil, function(data)
		table.iforeach(data, function(record)
			_trialRecords[record.TrialID] = { PlayerName = record.PlayerName, Time = record.Time }
		end)
		logger:info('Loaded '..table.length(data)..' records')
	end)
end)

AddEventHandler('lsv:playerConnected', function(player)
	TriggerClientEvent('lsv:initTimeTrialRecords', player, _trialRecords)
end)

AddEventHandler('lsv:playerDropped', function(player)
	_playerRecords[player] = nil
end)
