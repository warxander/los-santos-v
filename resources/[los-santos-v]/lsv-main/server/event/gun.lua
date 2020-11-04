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
				local pointCash = nil
				local pointExp = nil

				table.iforeach(_gunGameData.players, function(playerData, index)
					if index < 4 then
						logger:info('Winner { '..playerData.id..', '..index..' }')

						PlayerData.UpdateCash(playerData.id, Settings.gun.rewards.top[index].cash)
						PlayerData.UpdateExperience(playerData.id, Settings.gun.rewards.top[index].exp)
						PlayerData.GiveDrugBusinessSupply(playerData.id)
						PlayerData.UpdateEventsWon(playerData.id)

						table.insert(winners, playerData.id)
						pointCash = math.floor(Settings.gun.rewards.top[index].cash / playerData.points)
						pointExp = math.floor(Settings.gun.rewards.top[index].exp / playerData.points)
					else
						PlayerData.UpdateCash(playerData.id, playerData.points * pointCash)
						PlayerData.UpdateExperience(playerData.id, playerData.points * pointExp)
					end
				end)
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

AddEventHandler('lsv:onPlayerKilled', function(killData)
	if not _gunGameData or not killData.weaponHash or
		not table.ifind_if(Settings.ammuNationWeapons[_gunGameData.category], function(weapon) return GetHashKey(weapon) == killData.weaponHash end) then
			return
	end

	local player = killData.killer
	local playerIndex = getPlayerIndexById(player)
	if not playerIndex then
		table.insert(_gunGameData.players, { id = player, points = 1 })
	else
		_gunGameData.players[playerIndex].points = _gunGameData.players[playerIndex].points + 1
	end

	table.sort(_gunGameData.players, sortPlayersByPoints)
	TriggerClientEvent('lsv:updateGunGamePlayers', -1, _gunGameData.players)
end)

AddEventHandler('lsv:playerConnected', function(player)
	if not _gunGameData then
		return
	end

	TriggerClientEvent('lsv:startGunGame', player, _gunGameData, _gunGameData.eventStartTimer:elapsed())
end)

AddEventHandler('lsv:playerDropped', function(player)
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
