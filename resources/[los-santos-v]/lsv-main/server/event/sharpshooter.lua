local logger = Logger.New('SharpShooter')

local sharpShooterData = nil

local function getPlayerIndexById(id)
	for i, v in pairs(sharpShooterData.players) do
		if v.id == id then return i end
	end

	return nil
end

local function sortPlayersByPoints(l, r)
	if not l then return false end
	if not r then return true end
	return l.points > r.points
end


AddEventHandler('lsv:startSharpShooter', function()
	sharpShooterData = { }
	sharpShooterData.players = { }
	sharpShooterData.eventStartTime = Timer.New()

	logger:Info('Start { }')

	TriggerClientEvent('lsv:startSharpShooter', -1, sharpShooterData)

	while true do
		Citizen.Wait(0)

		if not sharpShooterData then return end

		if sharpShooterData.eventStartTime:Elapsed() >= Settings.sharpShooter.duration then
			local winners = nil

			if #sharpShooterData.players ~= 0 then
				winners = { }

				for i = 1, #Settings.sharpShooter.rewards do
					if sharpShooterData.players[i] then
						logger:Info('Winner { '..sharpShooterData.players[i].id..', '..sharpShooterData.players[i].points..' }')
						Db.UpdateCash(sharpShooterData.players[i].id, Settings.sharpShooter.rewards[i].cash)
						Db.UpdateExperience(sharpShooterData.players[i].id, Settings.sharpShooter.rewards[i].exp)
						table.insert(winners, sharpShooterData.players[i].id)
					else break end
				end
			else logger:Info('No winners') end

			sharpShooterData = nil
			TriggerClientEvent('lsv:finishSharpShooter', -1, winners)
			EventManager.StopEvent(winners)
			return
		end
	end
end)


AddEventHandler('lsv:playerConnected', function(player)
	if not sharpShooterData then return end
	TriggerClientEvent('lsv:startSharpShooter', player, sharpShooterData, sharpShooterData.eventStartTime:Elapsed())
end)


AddEventHandler('baseevents:onPlayerKilled', function(killer, data)
	if not sharpShooterData or killer == -1 or not data.killerheadshot then return end

	local player = killer
	local playerIndex = getPlayerIndexById(player)
	if not playerIndex then table.insert(sharpShooterData.players, { id = player, points = 1 })
	else sharpShooterData.players[playerIndex].points = sharpShooterData.players[playerIndex].points + 1 end

	table.sort(sharpShooterData.players, sortPlayersByPoints)
	TriggerClientEvent('lsv:updateSharpShooterPlayers', -1, sharpShooterData.players)
end)


AddEventHandler('lsv:playerDropped', function(player)
	if not sharpShooterData then return end

	if Scoreboard.GetPlayersCount() == 0 then
		sharpShooterData = nil
		EventManager.StopEvent()
		return
	end

	local playerIndex = getPlayerIndexById(player)
	if not playerIndex then return end

	table.remove(sharpShooterData.players, playerIndex)
	table.sort(sharpShooterData.players, sortPlayersByPoints)
	TriggerClientEvent('lsv:updateSharpShooterPlayers', -1, sharpShooterData.players)
end)
