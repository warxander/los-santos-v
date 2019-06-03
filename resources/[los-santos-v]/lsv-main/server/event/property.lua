local logger = Logger:CreateNamedLogger('HotProperty')

local propertyData = nil

local function getPlayerIndexById(id)
	local _, index = table.find_if(propertyData.players, function(player) return player.id == id end)
	return index
end

local function sortPlayersByTotalTime(l, r)
	if not l then return false end
	if not r then return true end
	return l.totalTime > r.totalTime
end


AddEventHandler('lsv:startHotProperty', function()
	propertyData = { }
	propertyData.players = { }
	propertyData.currentPlayer = nil
	propertyData.placeIndex = math.random(#Settings.castle.places)
	propertyData.eventStartTime = Timer.New()

	logger:Info('Start { '..propertyData.placeIndex..' }')

	TriggerClientEvent('lsv:startHotProperty', -1, propertyData)

	while true do
		Citizen.Wait(0)

		if not propertyData then return end

		if propertyData.eventStartTime:Elapsed() >= Settings.property.duration then
			local winners = nil

			if #propertyData.players ~= 0 then
				winners = { }

				for i = 1, #Settings.property.rewards do
					if propertyData.players[i] then
						logger:Info('Winner { '..propertyData.players[i].id..', '..propertyData.players[i].totalTime..' }')
						Db.UpdateCash(propertyData.players[i].id, Settings.property.rewards[i].cash)
						Db.UpdateExperience(propertyData.players[i].id, Settings.property.rewards[i].exp)
						table.insert(winners, propertyData.players[i].id)
					else break end
				end
			else logger:Info('No winners') end

			propertyData = nil
			TriggerClientEvent('lsv:finishHotProperty', -1, winners)
			EventManager.StopEvent(winners)
			return
		end
	end
end)


AddEventHandler('lsv:playerConnected', function(player)
	if not propertyData then return end
	TriggerClientEvent('lsv:startHotProperty', player, propertyData, propertyData.eventStartTime:Elapsed())
end)


RegisterNetEvent('lsv:hotPropertyCollected')
AddEventHandler('lsv:hotPropertyCollected', function()
	if not propertyData or propertyData.currentPlayer then return end
	local player = source
	local playerIndex = getPlayerIndexById(player)
	if not playerIndex then table.insert(propertyData.players, { id = player, totalTime = 0 }) end
	propertyData.currentPlayer = player
	logger:Info('Collected { '..player..' }')
	table.sort(propertyData.players, sortPlayersByTotalTime)
	TriggerClientEvent('lsv:updateHotPropertyPlayers', -1, propertyData.players)
	TriggerClientEvent('lsv:hotPropertyCollected', -1, player)
end)


RegisterNetEvent('lsv:hotPropertyDropped')
AddEventHandler('lsv:hotPropertyDropped', function(player)
	if not player then player = source end
	if not propertyData or not propertyData.currentPlayer or propertyData.currentPlayer ~= player then return end
	logger:Info('Dropped { '..player..' }')
	propertyData.currentPlayer = nil
	TriggerClientEvent('lsv:hotPropertyDropped', -1, player)
end)


RegisterNetEvent('lsv:hotPropertyTimeUpdated')
AddEventHandler('lsv:hotPropertyTimeUpdated', function()
	if not propertyData then return end
	local player = source
	local playerIndex = getPlayerIndexById(player)
	if playerIndex then
		propertyData.players[playerIndex].totalTime = propertyData.players[playerIndex].totalTime + 1000
		table.sort(propertyData.players, sortPlayersByTotalTime)
		TriggerClientEvent('lsv:updateHotPropertyPlayers', -1, propertyData.players)
	end
end)


AddEventHandler('baseevents:onPlayerDied', function()
	local player = source
	TriggerEvent('lsv:hotPropertyDropped', player)
end)


AddEventHandler('baseevents:onPlayerKilled', function()
	local player = source
	if not propertyData or not propertyData.currentPlayer or propertyData.currentPlayer ~= player then return end
	logger:Info('Dropped { '..player..' }')
	propertyData.currentPlayer = nil
	TriggerClientEvent('lsv:hotPropertyDropped', -1, player)
end)


AddEventHandler('lsv:playerDropped', function(player)
	if not propertyData then return end

	if Scoreboard.GetPlayersCount() == 0 then
		propertyData = nil
		EventManager.StopEvent()
		return
	end

	local playerIndex = getPlayerIndexById(player)
	if playerIndex then
		table.remove(propertyData.players, playerIndex)
		table.sort(propertyData.players, sortPlayersByTotalTime)
		TriggerClientEvent('lsv:updateHotPropertyPlayers', -1, propertyData.players)
	end

	if propertyData.currentPlayer == player then
		logger:Info('Dropped { '..player..' }')
		propertyData.currentPlayer = nil
		TriggerClientEvent('lsv:hotPropertyDropped', -1, player)
	end
end)
