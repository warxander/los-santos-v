local logger = Logger:CreateNamedLogger('Castle')

local eventFinishedTime = nil
local castleData = nil


local function getPlayerIndexById(id)
	if not castleData then
		logger:Error('Attempt to find player in empty data')
		return nil
	end

	for i, v in pairs(castleData.players) do
		if v.id == id then return i end
	end

	return nil
end

local function sortPlayersByPoints(l, r)
	return l.points > r.points
end


Citizen.CreateThread(function()
	eventFinishedTime = GetGameTimer()

	while true do
		Citizen.Wait(Settings.castle.timeout)

		local timePassedSinceLastEvent = GetGameTimer() - eventFinishedTime
		if timePassedSinceLastEvent < Settings.castle.timeout then Citizen.Wait(Settings.castle.timeout - timePassedSinceLastEvent) end

		if not castleData and Scoreboard.GetPlayersCount() > 2 then
			castleData = { }
			castleData.players = { }
			castleData.placeIndex = math.random(Utils.GetTableLength(Settings.castle.places))
			castleData.eventStartTime = GetGameTimer()

			logger:Info('Start { '..castleData.placeIndex..' }')

			TriggerClientEvent('lsv:startCastle', -1, castleData.placeIndex)
		end
	end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if castleData and GetGameTimer() - castleData.eventStartTime >= Settings.castle.duration then
			local winners = nil

			if not Utils.IsTableEmpty(castleData.players) then
				winners = { }

				for i = 1, 3 do
					local playerId = castleData.players[i] and castleData.players[i].id or nil
					table.insert(winners, playerId)
					if playerId then
						logger:Info('Winner { '..i..', '..playerId..' }')
						Db.UpdateRP(playerId, Settings.castle.rewards[i])
					end
				end
			else logger:Info('No winner') end

			castleData = nil
			eventFinishedTime = GetGameTimer()

			TriggerClientEvent('lsv:finishCastle', -1, winners)
		end
	end
end)


RegisterServerEvent('lsv:castleAddPoint')
AddEventHandler('lsv:castleAddPoint', function()
	local player = source

	if not castleData then
		logger:Error('Attempt to add point for already finished event')
		return
	end

	local playerIndex = getPlayerIndexById(player)
	if not playerIndex then table.insert(castleData.players, { id = player, points = 1 })
	else castleData.players[playerIndex].points = castleData.players[playerIndex].points + 1 end

	table.sort(castleData.players, sortPlayersByPoints)
	TriggerClientEvent('lsv:updateCastlePlayers', -1, castleData.players)
end)


AddEventHandler('lsv:playerConnected', function(player)
	if not castleData then return end

	TriggerClientEvent('lsv:startCastle', player, castleData.placeIndex)
end)


AddEventHandler('lsv:playerDropped', function(player)
	if not castleData then return end

	if Scoreboard.GetPlayersCount() == 0 then
		logger:Info('Stop')
		castleData = nil
		return
	end

	local playerIndex = getPlayerIndexById(player)
	if not playerIndex then return end

	castleData.players[playerIndex] = nil
	table.sort(castleData.players, sortPlayersByPoints)
	TriggerClientEvent('lsv:updateCastlePlayers', -1, castleData.players)
end)