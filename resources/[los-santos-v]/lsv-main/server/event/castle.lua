local logger = Logger.New('Castle')

local castleData = nil

local function getPlayerIndexById(id)
	for i, v in pairs(castleData.players) do
		if v.id == id then return i end
	end

	return nil
end

local function sortPlayersByPoints(l, r)
	if not l then return false end
	if not r then return true end
	return l.points > r.points
end


AddEventHandler('lsv:startCastle', function()
	castleData = { }
	castleData.players = { }
	castleData.placeIndex = math.random(#Settings.castle.places)
	castleData.eventStartTime = Timer.New()

	logger:Info('Start { '..castleData.placeIndex..' }')

	TriggerClientEvent('lsv:startCastle', -1, castleData)

	while true do
		Citizen.Wait(0)

		if not castleData then return end

		if castleData.eventStartTime:Elapsed() >= Settings.castle.duration then
			local winners = nil

			if #castleData.players ~= 0 then
				winners = { }

				for i = 1, #Settings.castle.rewards do
					if castleData.players[i] then
						logger:Info('Winner { '..castleData.players[i].id..', '..castleData.players[i].points..' }')
						Db.UpdateCash(castleData.players[i].id, Settings.castle.rewards[i].cash)
						Db.UpdateExperience(castleData.players[i].id, Settings.castle.rewards[i].exp)
						table.insert(winners, castleData.players[i].id)
					else break end
				end
			else logger:Info('No winners') end

			castleData = nil
			TriggerClientEvent('lsv:finishCastle', -1, winners)
			EventManager.StopEvent(winners)
			return
		end
	end
end)


RegisterNetEvent('lsv:castleAddPoint')
AddEventHandler('lsv:castleAddPoint', function()
	if not castleData then return end

	local player = source

	local playerIndex = getPlayerIndexById(player)
	if not playerIndex then table.insert(castleData.players, { id = player, points = 1 })
	else castleData.players[playerIndex].points = castleData.players[playerIndex].points + 1 end

	table.sort(castleData.players, sortPlayersByPoints)
	TriggerClientEvent('lsv:updateCastlePlayers', -1, castleData.players)
end)


AddEventHandler('lsv:playerConnected', function(player)
	if not castleData then return end
	TriggerClientEvent('lsv:startCastle', player, castleData, castleData.eventStartTime:Elapsed())
end)


AddEventHandler('lsv:playerDropped', function(player)
	if not castleData then return end

	if Scoreboard.GetPlayersCount() == 0 then
		castleData = nil
		EventManager.StopEvent()
		return
	end

	local playerIndex = getPlayerIndexById(player)
	if not playerIndex then return end

	table.remove(castleData.players, playerIndex)
	table.sort(castleData.players, sortPlayersByPoints)
	TriggerClientEvent('lsv:updateCastlePlayers', -1, castleData.players)
end)
