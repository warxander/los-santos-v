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
		local pointCash = nil
		local pointExp = nil

		table.iforeach(_stockData.players, function(playerData, index)
			if index < 4 then
				logger:info('Winner { '..playerData.id..', '..index..' }')

				PlayerData.UpdateCash(playerData.id, Settings.stockPiling.rewards.top[index].cash)
				PlayerData.UpdateExperience(playerData.id, Settings.stockPiling.rewards.top[index].exp)
				PlayerData.GiveDrugBusinessSupply(playerData.id)
				PlayerData.UpdateEventsWon(playerData.id)

				table.insert(winners, playerData.id)
				pointCash = math.floor(Settings.stockPiling.rewards.top[index].cash / playerData.points)
				pointExp = math.floor(Settings.stockPiling.rewards.top[index].exp / playerData.points)
			else
				PlayerData.UpdateCash(playerData.id, playerData.points * pointCash)
				PlayerData.UpdateExperience(playerData.id, playerData.points * pointExp)
			end
		end)
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

AddEventHandler('lsv:playerConnected', function(player)
	if not _stockData then
		return
	end

	TriggerClientEvent('lsv:startStockPiling', player, _stockData, _stockData.eventStartTimer:elapsed())
end)

AddEventHandler('lsv:playerDropped', function(player)
	if not _stockData then
		return
	end

	if PlayerData.GetCount() == 0 then
		_stockData = nil
		EventScheduler.StopEvent()
		return
	end

	local _, playerIndex = table.ifind_if(_stockData.players, function(playerData)
		return playerData.id == player
	end)

	if not playerIndex then
		return
	end

	table.remove(_stockData.players, playerIndex)
	table.sort(_stockData.players, sortPlayersByPoints)
	TriggerClientEvent('lsv:updateStockPilingPlayers', -1, _stockData.players)
end)
