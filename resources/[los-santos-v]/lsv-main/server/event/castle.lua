local logger = Logger.New('Castle')

local _castleData = nil

local function getPlayerIndexById(id)
	local _, index = table.ifind_if(_castleData.players, function(player)
		return player.id == id
	end)

	return index
end

local function sortPlayersByPoints(l, r)
	if not l then return false end
	if not r then return true end

	return l.points > r.points
end

RegisterNetEvent('lsv:castleAddPointToKing')
AddEventHandler('lsv:castleAddPointToKing', function()
	local player = source

	if not _castleData or _castleData.king ~= player then
		return
	end

	local playerIndex = getPlayerIndexById(player)

	if not playerIndex then
		table.insert(_castleData.players, { id = player, points = 1 })
	else
		_castleData.players[playerIndex].points = _castleData.players[playerIndex].points + 1
	end

	table.sort(_castleData.players, sortPlayersByPoints)
	TriggerClientEvent('lsv:updateCastlePlayers', -1, _castleData.players)
end)

RegisterNetEvent('lsv:playerInCastleArea')
AddEventHandler('lsv:playerInCastleArea', function()
	local player = source

	if not _castleData then
		return
	end

	if not _castleData.king then
		_castleData.king = player
		TriggerClientEvent('lsv:updateCastleKing', -1, _castleData.king)
	end
end)

RegisterNetEvent('lsv:kingLeftCastleArea')
AddEventHandler('lsv:kingLeftCastleArea', function()
	local player = source

	if _castleData and _castleData.king == player then
		_castleData.king = nil
		TriggerClientEvent('lsv:updateCastleKing', -1, nil)
	end
end)

AddEventHandler('lsv:startCastle', function()
	_castleData = { }

	_castleData.players = { }
	_castleData.king = nil
	_castleData.placeIndex = math.random(#Settings.castle.places)
	_castleData.eventStartTimer = Timer.New()

	logger:info('Start { '.._castleData.placeIndex..' }')

	TriggerClientEvent('lsv:startCastle', -1, _castleData)

	while true do
		Citizen.Wait(0)

		if not _castleData then
			return
		end

		if _castleData.eventStartTimer:elapsed() >= Settings.castle.duration then
			local winners = nil

			if #_castleData.players ~= 0 then
				winners = { }
				local pointCash = nil
				local pointExp = nil

				table.iforeach(_castleData.players, function(playerData, index)
					if index < 4 then
						logger:info('Winner { '..playerData.id..', '..index..' }')

						PlayerData.UpdateCash(playerData.id, Settings.castle.rewards.top[index].cash)
						PlayerData.UpdateExperience(playerData.id, Settings.castle.rewards.top[index].exp)
						PlayerData.GiveDrugBusinessSupply(playerData.id)
						PlayerData.UpdateEventsWon(playerData.id)

						table.insert(winners, playerData.id)
						pointCash = math.floor(Settings.castle.rewards.top[index].cash / playerData.points)
						pointExp = math.floor(Settings.castle.rewards.top[index].exp / playerData.points)
					else
						PlayerData.UpdateCash(playerData.id, playerData.points * pointCash)
						PlayerData.UpdateExperience(playerData.id, playerData.points * pointExp)
					end
				end)
			else
				logger:info('No winners')
			end

			_castleData = nil
			TriggerClientEvent('lsv:finishCastle', -1, winners)

			EventScheduler.StopEvent()

			return
		end
	end
end)

AddEventHandler('lsv:playerConnected', function(player)
	if not _castleData then
		return
	end

	TriggerClientEvent('lsv:startCastle', player, _castleData, _castleData.eventStartTimer:elapsed())
end)

AddEventHandler('lsv:playerDropped', function(player)
	if not _castleData then
		return
	end

	if PlayerData.GetCount() == 0 then
		_castleData = nil
		EventScheduler.StopEvent()
		return
	end

	if _castleData.king == player then
		_castleData.king = nil
		TriggerClientEvent('lsv:updateCastleKing', -1, nil)
	end

	local playerIndex = getPlayerIndexById(player)
	if not playerIndex then
		return
	end

	table.remove(_castleData.players, playerIndex)
	table.sort(_castleData.players, sortPlayersByPoints)
	TriggerClientEvent('lsv:updateCastlePlayers', -1, _castleData.players)
end)
