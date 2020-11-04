local logger = Logger.New('HotProperty')

local _propertyData = nil

local function getPlayerIndexById(id)
	local _, index = table.ifind_if(_propertyData.players, function(player)
		return player.id == id
	end)

	return index
end

local function sortPlayersByTotalTime(l, r)
	if not l then return false end
	if not r then return true end

	return l.points > r.points
end

RegisterNetEvent('lsv:hotPropertyCollected')
AddEventHandler('lsv:hotPropertyCollected', function()
	if not _propertyData or _propertyData.currentPlayer then
		return
	end

	local player = source
	local playerIndex = getPlayerIndexById(player)
	if not playerIndex then
		table.insert(_propertyData.players, { id = player, points = 0 })
	end

	_propertyData.currentPlayer = player
	_propertyData.position = nil

	logger:info('Collected { '..player..' }')

	table.sort(_propertyData.players, sortPlayersByTotalTime)
	TriggerClientEvent('lsv:updateHotPropertyPlayers', -1, _propertyData.players)
	TriggerClientEvent('lsv:hotPropertyCollected', -1, player)
end)

RegisterNetEvent('lsv:hotPropertyDropped')
AddEventHandler('lsv:hotPropertyDropped', function(position)
	local player = source
	if not _propertyData or not _propertyData.currentPlayer or _propertyData.currentPlayer ~= player then
		return
	end

	logger:info('Dropped { '..player..' }')

	_propertyData.currentPlayer = nil
	_propertyData.position = position

	TriggerClientEvent('lsv:hotPropertyDropped', -1, player, position)
end)

RegisterNetEvent('lsv:hotPropertyTimeUpdated')
AddEventHandler('lsv:hotPropertyTimeUpdated', function()
	if not _propertyData then
		return
	end

	local player = source
	local playerIndex = getPlayerIndexById(player)
	if playerIndex then
		_propertyData.players[playerIndex].points = _propertyData.players[playerIndex].points + 1
		table.sort(_propertyData.players, sortPlayersByTotalTime)
		TriggerClientEvent('lsv:updateHotPropertyPlayers', -1, _propertyData.players)
	end
end)

AddEventHandler('lsv:startHotProperty', function()
	_propertyData = { }

	_propertyData.players = { }
	_propertyData.currentPlayer = nil
	_propertyData.placeIndex = math.random(#Settings.property.places)
	_propertyData.eventStartTimer = Timer.New()

	local place = Settings.property.places[_propertyData.placeIndex]
	_propertyData.initialPosition = place
	_propertyData.position = _propertyData.initialPosition

	logger:info('Start { '.._propertyData.placeIndex..' }')

	TriggerClientEvent('lsv:startHotProperty', -1, _propertyData)

	while true do
		Citizen.Wait(0)

		if not _propertyData then
			return
		end

		if _propertyData.eventStartTimer:elapsed() >= Settings.property.duration then
			local winners = nil

			if #_propertyData.players ~= 0 then
				winners = { }
				local pointCash = nil
				local pointExp = nil

				table.iforeach(_propertyData.players, function(playerData, index)
					if index < 4 then
						logger:info('Winner { '..playerData.id..', '..index..' }')

						PlayerData.UpdateCash(playerData.id, Settings.property.rewards.top[index].cash)
						PlayerData.UpdateExperience(playerData.id, Settings.property.rewards.top[index].exp)
						PlayerData.GiveDrugBusinessSupply(playerData.id)
						PlayerData.UpdateEventsWon(playerData.id)

						table.insert(winners, playerData.id)
						pointCash = math.floor(Settings.property.rewards.top[index].cash / playerData.points)
						pointExp = math.floor(Settings.property.rewards.top[index].exp / playerData.points)
					else
						PlayerData.UpdateCash(playerData.id, playerData.points * pointCash)
						PlayerData.UpdateExperience(playerData.id, playerData.points * pointExp)
					end
				end)
			else
				logger:info('No winners')
			end

			_propertyData = nil
			TriggerClientEvent('lsv:finishHotProperty', -1, winners)

			EventScheduler.StopEvent()

			return
		end
	end
end)

AddEventHandler('lsv:onPlayerDied', function(_, position)
	local player = source
	if not _propertyData or not _propertyData.currentPlayer or _propertyData.currentPlayer ~= player then
		return
	end

	logger:info('Dropped { '..player..' }')

	_propertyData.currentPlayer = nil
	_propertyData.position = position

	TriggerClientEvent('lsv:hotPropertyDropped', -1, player, position)
end)

AddEventHandler('lsv:onPlayerKilled', function(killData)
	local player = source
	if not _propertyData or not _propertyData.currentPlayer or _propertyData.currentPlayer ~= player then
		return
	end

	logger:info('Dropped { '..player..' }')

	_propertyData.currentPlayer = nil
	_propertyData.position = killData.position

	TriggerClientEvent('lsv:hotPropertyDropped', -1, player, _propertyData.position)
end)

AddEventHandler('lsv:playerConnected', function(player)
	if not _propertyData then
		return
	end

	TriggerClientEvent('lsv:startHotProperty', player, _propertyData, _propertyData.eventStartTimer:elapsed())
end)

AddEventHandler('lsv:playerDropped', function(player)
	if not _propertyData then
		return
	end

	if PlayerData.GetCount() == 0 then
		_propertyData = nil
		EventScheduler.StopEvent()
		return
	end

	local playerIndex = getPlayerIndexById(player)
	if playerIndex then
		table.remove(_propertyData.players, playerIndex)
		table.sort(_propertyData.players, sortPlayersByTotalTime)
		TriggerClientEvent('lsv:updateHotPropertyPlayers', -1, _propertyData.players)
	end

	if _propertyData.currentPlayer == player then
		logger:info('Dropped { '..player..' }')

		_propertyData.currentPlayer = nil
		_propertyData.position = _propertyData.initialPosition

		TriggerClientEvent('lsv:hotPropertyDropped', -1, player, _propertyData.position)
	end
end)
