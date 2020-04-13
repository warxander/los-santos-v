local logger = Logger.New('GunGame')

local _gunGameData = nil

local function getPlayerIndexById(id)
	for i, v in pairs(_gunGameData.players) do
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

AddEventHandler('lsv:startGunGame', function()
	_gunGameData = { }

	_gunGameData.players = { }
	_gunGameData.category = table.random(Settings.gun.categories)
	_gunGameData.eventStartTimer = Timer.New()

	logger:info('Start { '.._gunGameData.category..' }')

	TriggerClientEvent('lsv:startGunGame', -1, _gunGameData)

	while true do
		Citizen.Wait(0)

		if not _gunGameData then
			return
		end

		if _gunGameData.eventStartTimer:elapsed() >= Settings.gun.duration then
			local winners = nil

			if #_gunGameData.players ~= 0 then
				winners = { }

				for i = 1, #Settings.gun.rewards.top do
					if _gunGameData.players[i] then
						logger:info('Winner { '.._gunGameData.players[i].id..', '.._gunGameData.players[i].points..' }')

						PlayerData.UpdateCash(_gunGameData.players[i].id, Settings.gun.rewards.top[i].cash)
						PlayerData.UpdateExperience(_gunGameData.players[i].id, Settings.gun.rewards.top[i].exp)
						PlayerData.UpdateEventsWon(_gunGameData.players[i].id)

						table.insert(winners, _gunGameData.players[i].id)
					else
						break
					end
				end

				for i = 4, #_gunGameData.players do
					PlayerData.UpdateCash(_gunGameData.players[i].id, math.min(Settings.gun.rewards.point.cash * _gunGameData.players[i].points, Settings.gun.rewards.top[3].cash))
					PlayerData.UpdateExperience(_gunGameData.players[i].id, math.min(Settings.gun.rewards.point.exp * _gunGameData.players[i].points, Settings.gun.rewards.top[3].exp))
				end
			else
				logger:info('No winners')
			end

			_gunGameData = nil
			TriggerClientEvent('lsv:finishGunGame', -1, winners)

			EventScheduler.StopEvent()

			return
		end
	end
end)

AddEventHandler('lsv:onPlayerKilled', function(killer, data)
	if not _gunGameData or killer == -1 or not data.weaponhash or
		not table.ifind_if(Settings.ammuNationWeapons[_gunGameData.category], function(weapon) return GetHashKey(weapon) == data.weaponhash end) then
			return
	end

	local player = killer
	local playerIndex = getPlayerIndexById(player)
	if not playerIndex then
		table.insert(_gunGameData.players, { id = player, points = 1 })
	else
		_gunGameData.players[playerIndex].points = _gunGameData.players[playerIndex].points + 1
	end

	table.sort(_gunGameData.players, sortPlayersByPoints)
	TriggerClientEvent('lsv:updateGunGamePlayers', -1, _gunGameData.players)
end)

AddSignalHandler('lsv:playerConnected', function(player)
	if not _gunGameData then
		return
	end

	TriggerClientEvent('lsv:startGunGame', player, _gunGameData, _gunGameData.eventStartTimer:elapsed())
end)

AddSignalHandler('lsv:playerDropped', function(player)
	if not _gunGameData then
		return
	end

	if PlayerData.GetCount() == 0 then
		_gunGameData = nil
		EventScheduler.StopEvent()
		return
	end

	local playerIndex = getPlayerIndexById(player)
	if not playerIndex then
		return
	end

	table.remove(_gunGameData.players, playerIndex)
	table.sort(_gunGameData.players, sortPlayersByPoints)
	TriggerClientEvent('lsv:updateGunGamePlayers', -1, _gunGameData.players)
end)
