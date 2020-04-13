local logger = Logger.New('StockPiling')

local _stockData = nil

local function sortPlayersByPoints(l, r)
	if not l then return false end
	if not r then return true end

	return l.points > r.points
end

local function finishEvent()
	local winners = nil

	if #_stockData.players ~= 0 then
		winners = { }

		for i = 1, #Settings.stockPiling.rewards.top do
			if _stockData.players[i] then
				logger:info('Winner { '.._stockData.players[i].id..', '.._stockData.players[i].points..' }')

				PlayerData.UpdateCash(_stockData.players[i].id, Settings.stockPiling.rewards.top[i].cash)
				PlayerData.UpdateExperience(_stockData.players[i].id, Settings.stockPiling.rewards.top[i].exp)
				PlayerData.UpdateEventsWon(_stockData.players[i].id)

				table.insert(winners, _stockData.players[i].id)
			else
				break
			end
		end

		for i = 4, #_stockData.players do
			PlayerData.UpdateCash(_stockData.players[i].id, math.min(Settings.stockPiling.rewards.point.cash * _stockData.players[i].points, Settings.stockPiling.rewards.top[3].cash))
			PlayerData.UpdateExperience(_stockData.players[i].id, math.min(Settings.stockPiling.rewards.point.exp * _stockData.players[i].points, Settings.stockPiling.rewards.top[3].exp))
		end
	else
		logger:info('No winners')
	end

	_stockData = nil
	TriggerClientEvent('lsv:finishStockPiling', -1, winners)

	EventScheduler.StopEvent()
end

RegisterNetEvent('lsv:stockPilingCheckPointCollected')
AddEventHandler('lsv:stockPilingCheckPointCollected', function(index)
	if not _stockData or _stockData.checkPoints[index].picked then
		return
	end

	local player = table.ifind_if(_stockData.players, function(player)
		return player.id == source
	end)

	if not player then
		player = { id = source, points = 1 }
		table.insert(_stockData.players, player)
	else
		player.points = player.points + 1
	end

	_stockData.checkPointsCollected = _stockData.checkPointsCollected + 1
	if _stockData.checkPointsCollected == _stockData.totalCheckPoints then
		finishEvent()
	else
		logger:info('Collected { '..player.id..', '..index..' }')

		_stockData.checkPoints[index].picked = true

		table.sort(_stockData.players, sortPlayersByPoints)
		TriggerClientEvent('lsv:updateStockPilingPlayers', -1, _stockData.players, index, player.id)
	end
end)

AddEventHandler('lsv:startStockPiling', function()
	_stockData = { }

	_stockData.players = { }
	_stockData.checkPoints = { }
	table.iforeach(Settings.stockPiling.checkPoints, function(point)
		table.insert(_stockData.checkPoints, { position = point, picked = false })
	end)
	_stockData.totalCheckPoints = #_stockData.checkPoints
	_stockData.checkPointsCollected = 0

	_stockData.eventStartTimer = Timer.New()

	logger:info('Start { '.._stockData.totalCheckPoints..' }')

	TriggerClientEvent('lsv:startStockPiling', -1, _stockData)

	while true do
		Citizen.Wait(0)

		if not _stockData then
			return
		end

		if _stockData.eventStartTimer:elapsed() >= Settings.stockPiling.duration then
			finishEvent()
			return
		end
	end
end)

AddSignalHandler('lsv:playerConnected', function(player)
	if not _stockData then
		return
	end

	TriggerClientEvent('lsv:startStockPiling', player, _stockData, _stockData.eventStartTimer:elapsed())
end)

AddSignalHandler('lsv:playerDropped', function(player)
	if not _stockData then
		return
	end

	if PlayerData.GetCount() == 0 then
		_stockData = nil
		EventScheduler.StopEvent()
		return
	end

	local _, playerIndex = table.ifind_if(_stockData.players, function(player) return player.id == player end)
	if not playerIndex then
		return
	end

	table.remove(_stockData.players, playerIndex)
	table.sort(_stockData.players, sortPlayersByPoints)
	TriggerClientEvent('lsv:updateStockPilingPlayers', -1, _stockData.players)
end)
