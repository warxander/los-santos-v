local logger = Logger.New('SharpShooter')

local _sharpShooterData = nil

local function getPlayerIndexById(id)
	local _, index = table.ifind_if(_sharpShooterData.players, function(player)
		return player.id == id
	end)

	return index
end

local function sortPlayersByPoints(l, r)
	if not l then return false end
	if not r then return true end

	return l.points > r.points
end

AddEventHandler('lsv:startSharpShooter', function()
	_sharpShooterData = { }

	_sharpShooterData.players = { }
	_sharpShooterData.eventStartTimer = Timer.New()

	logger:info('Start { }')

	TriggerClientEvent('lsv:startSharpShooter', -1, _sharpShooterData)

	while true do
		Citizen.Wait(0)

		if not _sharpShooterData then
			return
		end

		if _sharpShooterData.eventStartTimer:elapsed() >= Settings.sharpShooter.duration then
			local winners = nil

			if #_sharpShooterData.players ~= 0 then
				winners = { }
				local pointCash = nil
				local pointExp = nil

				table.iforeach(_sharpShooterData.players, function(playerData, index)
					if index < 4 then
						logger:info('Winner { '..playerData.id..', '..index..' }')

						PlayerData.UpdateCash(playerData.id, Settings.sharpShooter.rewards.top[index].cash)
						PlayerData.UpdateExperience(playerData.id, Settings.sharpShooter.rewards.top[index].exp)
						PlayerData.GiveDrugBusinessSupply(playerData.id)
						PlayerData.UpdateEventsWon(playerData.id)

						table.insert(winners, playerData.id)
						pointCash = math.floor(Settings.sharpShooter.rewards.top[index].cash / playerData.points)
						pointExp = math.floor(Settings.sharpShooter.rewards.top[index].exp / playerData.points)
					else
						PlayerData.UpdateCash(playerData.id, playerData.points * pointCash)
						PlayerData.UpdateExperience(playerData.id, playerData.points * pointExp)
					end
				end)
			else
				logger:info('No winners')
			end

			_sharpShooterData = nil
			TriggerClientEvent('lsv:finishSharpShooter', -1, winners)

			EventScheduler.StopEvent()

			return
		end
	end
end)

AddEventHandler('lsv:onPlayerKilled', function(killData)
	if not _sharpShooterData or not killData.headshot then
		return
	end

	local player = killData.killer
	local playerIndex = getPlayerIndexById(player)
	if not playerIndex then
		table.insert(_sharpShooterData.players, { id = player, points = 1 })
	else
		_sharpShooterData.players[playerIndex].points = _sharpShooterData.players[playerIndex].points + 1
	end

	table.sort(_sharpShooterData.players, sortPlayersByPoints)
	TriggerClientEvent('lsv:updateSharpShooterPlayers', -1, _sharpShooterData.players)
end)

AddEventHandler('lsv:playerConnected', function(player)
	if not _sharpShooterData then
		return
	end

	TriggerClientEvent('lsv:startSharpShooter', player, _sharpShooterData, _sharpShooterData.eventStartTimer:elapsed())
end)

AddEventHandler('lsv:playerDropped', function(player)
	if not _sharpShooterData then
		return
	end

	if PlayerData.GetCount() == 0 then
		_sharpShooterData = nil
		EventScheduler.StopEvent()
		return
	end

	local playerIndex = getPlayerIndexById(player)
	if not playerIndex then
		return
	end

	table.remove(_sharpShooterData.players, playerIndex)
	table.sort(_sharpShooterData.players, sortPlayersByPoints)
	TriggerClientEvent('lsv:updateSharpShooterPlayers', -1, _sharpShooterData.players)
end)
