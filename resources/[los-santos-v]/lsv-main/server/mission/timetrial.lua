local logger = Logger.New('TimeTrial')

local _trialRecords = { }

RegisterNetEvent('lsv:finishTimeTrial')
AddEventHandler('lsv:finishTimeTrial', function(trialId, time)
	local player = source
	if not PlayerData.IsExists(player) or not Settings.timeTrial.tracks[trialId] then
		return
	end

	local isNewRecord = false

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

	local cash = isNewRecord and Settings.timeTrial.recordReward.cash or Settings.timeTrial.reward.cash
	local exp = isNewRecord and Settings.timeTrial.recordReward.exp or Settings.timeTrial.reward.exp

	PlayerData.UpdateCash(player, cash)
	PlayerData.UpdateExperience(player, exp)

	local message = isNewRecord and 'New Server Record: ' or 'Time: '
	message = message..string.from_ms(time, true)

	TriggerClientEvent('lsv:timeTrialFinished', player, true, message)
end)

Citizen.CreateThread(function()
	vSql.Async.fetchAll('SELECT * FROM TimeTrialRecords', nil, function(data)
		table.iforeach(data, function(record)
			_trialRecords[record.TrialID] = { PlayerName = record.PlayerName, Time = record.Time }
		end)
		logger:info('Loaded '..table.length(data)..' records')
	end)
end)

AddSignalHandler('lsv:playerConnected', function(player)
	TriggerClientEvent('lsv:initTimeTrialRecords', player, _trialRecords)
end)
