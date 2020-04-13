local logger = Logger.New('SharpShooter')

local _sharpShooterData = nil

local function getPlayerIndexById(id)
	for i, v in pairs(_sharpShooterData.players) do
		if v.id == id then
			return i
		end
	end

	return nil
end

local function sortPlayersByPoints(l, r)
	if not l then return false end
	if not r then return true end

	return l.points > r.points
end

AddEventHandler('lsv:startSharpShooter', function()
	_sharpShooterData = { }

	_sharpShooterData.players = { }
	_sharpShooterData.eventStartTimer = Timer.New()

	logger:info('Start { }')

	TriggerClientEvent('lsv:startSharpShooter', -1, _sharpShooterData)

	while true do
		Citizen.Wait(0)

		if not _sharpShooterData then
			return
		end

		if _sharpShooterData.eventStartTimer:elapsed() >= Settings.sharpShooter.duration then
			local winners = nil

			if #_sharpShooterData.players ~= 0 then
				winners = { }

				for i = 1, #Settings.sharpShooter.rewards.top do
					if _sharpShooterData.players[i] then
						logger:info('Winner { '.._sharpShooterData.players[i].id..', '.._sharpShooterData.players[i].points..' }')

						PlayerData.UpdateCash(_sharpShooterData.players[i].id, Settings.sharpShooter.rewards.top[i].cash)
						PlayerData.UpdateExperience(_sharpShooterData.players[i].id, Settings.sharpShooter.rewards.top[i].exp)
						PlayerData.UpdateEventsWon(_sharpShooterData.players[i].id)

						table.insert(winners, _sharpShooterData.players[i].id)
					else
						break
					end
				end

				for i = 4, #_sharpShooterData.players do
					PlayerData.UpdateCash(_sharpShooterData.players[i].id, math.min(Settings.sharpShooter.rewards.point.cash * _sharpShooterData.players[i].points, Settings.sharpShooter.rewards.top[3].cash))
					PlayerData.UpdateExperience(_sharpShooterData.players[i].id, math.min(Settings.sharpShooter.rewards.point.exp * _sharpShooterData.players[i].points, Settings.sharpShooter.rewards.top[3].exp))
				end
			else
				logger:info('No winners')
			end

			_sharpShooterData = nil
			TriggerClientEvent('lsv:finishSharpShooter', -1, winners)

			EventScheduler.StopEvent()

			return
		end
	end
end)

AddEventHandler('lsv:onPlayerKilled', function(killer, data)
	if not _sharpShooterData or killer == -1 or not data.killerheadshot then
		return
	end

	local player = killer
	local playerIndex = getPlayerIndexById(player)
	if not playerIndex then
		table.insert(_sharpShooterData.players, { id = player, points = 1 })
	else
		_sharpShooterData.players[playerIndex].points = _sharpShooterData.players[playerIndex].points + 1
	end

	table.sort(_sharpShooterData.players, sortPlayersByPoints)
	TriggerClientEvent('lsv:updateSharpShooterPlayers', -1, _sharpShooterData.players)
end)

AddSignalHandler('lsv:playerConnected', function(player)
	if not _sharpShooterData then
		return
	end

	TriggerClientEvent('lsv:startSharpShooter', player, _sharpShooterData, _sharpShooterData.eventStartTimer:elapsed())
end)

AddSignalHandler('lsv:playerDropped', function(player)
	if not _sharpShooterData then
		return
	end

	if PlayerData.GetCount() == 0 then
		_sharpShooterData = nil
		EventScheduler.StopEvent()
		return
	end

	local playerIndex = getPlayerIndexById(player)
	if not playerIndex then
		return
	end

	table.remove(_sharpShooterData.players, playerIndex)
	table.sort(_sharpShooterData.players, sortPlayersByPoints)
	TriggerClientEvent('lsv:updateSharpShooterPlayers', -1, _sharpShooterData.players)
end)
