local logger = Logger.New('Penned')

local _pennedData = nil

local function getPlayerIndexById(id)
	for i, v in pairs(_pennedData.players) do
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

AddEventHandler('lsv:startPennedIn', function()
	_pennedData = { }

	_pennedData.players = { }
	_pennedData.eventStartTimer = Timer.New()

	logger:info('Start { }')

	TriggerClientEvent('lsv:startPennedIn', -1, _pennedData)

	while true do
		Citizen.Wait(0)

		if not _pennedData then
			return
		end

		if _pennedData.eventStartTimer:elapsed() >= Settings.penned.duration then
			local winners = nil

			if #_pennedData.players ~= 0 then
				winners = { }

				for i = 1, #Settings.penned.rewards.top do
					if _pennedData.players[i] then
						logger:info('Winner { '.._pennedData.players[i].id..', '.._pennedData.players[i].points..' }')

						PlayerData.UpdateCash(_pennedData.players[i].id, Settings.penned.rewards.top[i].cash)
						PlayerData.UpdateExperience(_pennedData.players[i].id, Settings.penned.rewards.top[i].exp)
						PlayerData.UpdateEventsWon(_pennedData.players[i].id)

						table.insert(winners, _pennedData.players[i].id)
					else
						break
					end
				end

				for i = 4, #_pennedData.players do
					PlayerData.UpdateCash(_pennedData.players[i].id, math.min(Settings.penned.rewards.point.cash * _pennedData.players[i].points, Settings.penned.rewards.top[3].cash))
					PlayerData.UpdateExperience(_pennedData.players[i].id, math.min(Settings.penned.rewards.point.exp * _pennedData.players[i].points, Settings.penned.rewards.top[3].exp))
				end
			else
				logger:info('No winners')
			end

			_pennedData = nil
			TriggerClientEvent('lsv:finishPennedIn', -1, winners)

			EventScheduler.StopEvent()

			return
		end
	end
end)

AddEventHandler('lsv:onPlayerKilled', function(killData)
	if not _pennedData or not killData.isKillerInVehicle then
		return
	end

	local player = killData.killer
	local playerIndex = getPlayerIndexById(player)
	if not playerIndex then
		table.insert(_pennedData.players, { id = player, points = 1 })
	else
		_pennedData.players[playerIndex].points = _pennedData.players[playerIndex].points + 1
	end

	table.sort(_pennedData.players, sortPlayersByPoints)
	TriggerClientEvent('lsv:updatePennedInPlayers', -1, _pennedData.players)
end)

AddSignalHandler('lsv:playerConnected', function(player)
	if not _pennedData then
		return
	end

	TriggerClientEvent('lsv:startPennedInGame', player, _pennedData, _pennedData.eventStartTimer:elapsed())
end)

AddSignalHandler('lsv:playerDropped', function(player)
	if not _pennedData then
		return
	end

	if PlayerData.GetCount() == 0 then
		_pennedData = nil
		EventScheduler.StopEvent()
		return
	end

	local playerIndex = getPlayerIndexById(player)
	if not playerIndex then
		return
	end

	table.remove(_pennedData.players, playerIndex)
	table.sort(_pennedData.players, sortPlayersByPoints)
	TriggerClientEvent('lsv:updatePennedInPlayers', -1, _pennedData.players)
end)
