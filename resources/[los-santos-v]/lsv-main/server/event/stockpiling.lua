local logger = Logger.New('StockPiling')

local stockData = nil

local function sortPlayersByPoints(l, r)
	if not l then return false end
	if not r then return true end
	return l.points > r.points
end

local function finishEvent()
	local winners = nil

	if #stockData.players ~= 0 then
		winners = { }

		for i = 1, #Settings.stockPiling.rewards do
			if stockData.players[i] then
				logger:Info('Winner { '..stockData.players[i].id..', '..stockData.players[i].points..' }')
				Db.UpdateCash(stockData.players[i].id, Settings.stockPiling.rewards[i].cash)
				Db.UpdateExperience(stockData.players[i].id, Settings.stockPiling.rewards[i].exp)
				table.insert(winners, stockData.players[i].id)
			else break end
		end
	else logger:Info('No winners') end

	stockData = nil
	TriggerClientEvent('lsv:finishStockPiling', -1, winners)
	EventManager.StopEvent(winners)
end


AddEventHandler('lsv:startStockPiling', function()
	stockData = { }
	stockData.players = { }
	stockData.checkPoints = { }

	table.iforeach(Settings.stockPiling.checkPoints, function(point)
		table.insert(stockData.checkPoints, { position = point, picked = false })
	end)
	stockData.totalCheckPoints = #stockData.checkPoints
	stockData.checkPointsCollected = 0

	stockData.eventStartTime = Timer.New()

	logger:Info('Start { '..stockData.totalCheckPoints..' }')

	TriggerClientEvent('lsv:startStockPiling', -1, stockData)

	while true do
		Citizen.Wait(0)

		if not stockData then return end

		if stockData.eventStartTime:Elapsed() >= Settings.stockPiling.duration then
			finishEvent()
			return
		end

	end
end)


RegisterNetEvent('lsv:stockPilingCheckPointCollected')
AddEventHandler('lsv:stockPilingCheckPointCollected', function(index)
	if not stockData or stockData.checkPoints[index].picked then return end

	local player = table.ifind_if(stockData.players, function(player) return player.id == source end)
	if not player then
		player = { id = source, points = 1 }
		table.insert(stockData.players, player)
	else player.points = player.points + 1 end

	Db.UpdateCash(player.id, Settings.stockPiling.rewardPerCheckPoint.cash)
	Db.UpdateExperience(player.id, Settings.stockPiling.rewardPerCheckPoint.exp)

	stockData.checkPointsCollected = stockData.checkPointsCollected + 1
	if stockData.checkPointsCollected == stockData.totalCheckPoints then
		finishEvent()
	else
		logger:Info('Collected { '..player.id..', '..index..' }')
		stockData.checkPoints[index].picked = true
		table.sort(stockData.players, sortPlayersByPoints)
		TriggerClientEvent('lsv:updateStockPilingPlayers', -1, stockData.players, index, player.id)
	end
end)


AddEventHandler('lsv:playerConnected', function(player)
	if not stockData then return end
	TriggerClientEvent('lsv:startStockPiling', player, stockData, stockData.eventStartTime:Elapsed())
end)


AddEventHandler('lsv:playerDropped', function(player)
	if not stockData then return end

	if Scoreboard.GetPlayersCount() == 0 then
		stockData = nil
		EventManager.StopEvent()
		return
	end

	local _, playerIndex = table.ifind_if(stockData.players, function(player) return player.id == player end)
	if not playerIndex then return end

	table.remove(stockData.players, playerIndex)
	table.sort(stockData.players, sortPlayersByPoints)
	TriggerClientEvent('lsv:updateStockPilingPlayers', -1, stockData.players)
end)