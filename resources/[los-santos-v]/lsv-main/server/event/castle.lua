local logger = Logger.New('Castle')

local _castleData = nil

local function getPlayerIndexById(id)
	for i, v in pairs(_castleData.players) do
		if v.id == id then
			return i end
	end

	return nil
end

local function sortPlayersByPoints(l, r)
	if not l then return false end
	if not r then return true end

	return l.points > r.points
end

RegisterNetEvent('lsv:castleAddPoint')
AddEventHandler('lsv:castleAddPoint', function()
	if not _castleData then
		return
	end

	local player = source
	local playerIndex = getPlayerIndexById(player)

	if not playerIndex then
		table.insert(_castleData.players, { id = player, points = 1 })
	else
		_castleData.players[playerIndex].points = _castleData.players[playerIndex].points + 1
	end

	table.sort(_castleData.players, sortPlayersByPoints)
	TriggerClientEvent('lsv:updateCastlePlayers', -1, _castleData.players)
end)

AddEventHandler('lsv:startCastle', function()
	_castleData = { }

	_castleData.players = { }
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

				for i = 1, #Settings.castle.rewards.top do
					if _castleData.players[i] then
						logger:info('Winner { '.._castleData.players[i].id..', '.._castleData.players[i].points..' }')

						PlayerData.UpdateCash(_castleData.players[i].id, Settings.castle.rewards.top[i].cash)
						PlayerData.UpdateExperience(_castleData.players[i].id, Settings.castle.rewards.top[i].exp)
						PlayerData.UpdateEventsWon(_castleData.players[i].id)

						table.insert(winners, _castleData.players[i].id)
					else
						break
					end
				end

				for i = 4, #_castleData.players do
					PlayerData.UpdateCash(_castleData.players[i].id, math.min(Settings.castle.rewards.point.cash * _castleData.players[i].points, Settings.castle.rewards.top[3].cash))
					PlayerData.UpdateExperience(_castleData.players[i].id, math.min(Settings.castle.rewards.point.exp * _castleData.players[i].points, Settings.castle.rewards.top[3].exp))
				end
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

AddSignalHandler('lsv:playerConnected', function(player)
	if not _castleData then
		return
	end

	TriggerClientEvent('lsv:startCastle', player, _castleData, _castleData.eventStartTimer:elapsed())
end)

AddSignalHandler('lsv:playerDropped', function(player)
	if not _castleData then
		return
	end

	if PlayerData.GetCount() == 0 then
		_castleData = nil
		EventScheduler.StopEvent()
		return
	end

	local playerIndex = getPlayerIndexById(player)
	if not playerIndex then
		return
	end

	table.remove(_castleData.players, playerIndex)
	table.sort(_castleData.players, sortPlayersByPoints)
	TriggerClientEvent('lsv:updateCastlePlayers', -1, _castleData.players)
end)
