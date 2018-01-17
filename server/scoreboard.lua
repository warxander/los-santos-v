-- Format: { id, name, money, kdRatio, kills, deaths }
local scoreboard = { }


local function sortScoreboard(l, r)
	if not l then return false end
	if not r then return true end

	if not l.kdRatio then return false end
	if not r.kdRatio then return true end

	if l.kdRatio > r.kdRatio then return true end
	if l.kdRatio < r.kdRatio then return false end

	if l.kills > r.kills then return true end
	if l.kills < r.kills then return false end

	if l.deaths > r.deaths then return false end
	if l.deaths < r.deaths then return true end
	if l.money > r.money then return true end
	if l.money < r.money then return false end

	return l.name < r.name
end


local function calculateKdRatio(kills, deaths)
	if kills + deaths < Settings.kdRatioMinStat then
		return nil
	else
		return kills / deaths
	end
end


AddEventHandler('lsv:updateClientScoreboard', function()
	table.sort(scoreboard, sortScoreboard)
	
	TriggerClientEvent('lsv:updateScoreboard', -1, scoreboard)
end)


AddEventHandler('lsv:firstSpawnPlayer', function(player, playerData)
	table.insert(scoreboard, { ['id'] = tonumber(player), ['name'] = GetPlayerName(player), ['money'] = playerData.Money, ['kdRatio'] = calculateKdRatio(playerData.Kills, playerData.Deaths), 
		['kills'] = playerData.Kills, ['deaths'] = playerData.Deaths })
	TriggerEvent('lsv:updateClientScoreboard')
end)


AddEventHandler('lsv:scoreboardOnPlayerDropped', function(player)
	for index, playerScoreboard in pairs(scoreboard) do
		if playerScoreboard.id == tonumber(player) then
			table.remove(scoreboard, index)
			TriggerEvent('lsv:updateClientScoreboard')
			return
		end
	end
end)


RegisterServerEvent('lsv:updateScoreboard')
AddEventHandler('lsv:updateScoreboard', function(money, kills, deaths)
	local playerIndex = nil

	for index, playerScoreboard in pairs(scoreboard) do
		if playerScoreboard.id == tonumber(source) then
			playerIndex = index
			break
		end
	end

	if playerIndex then
		MySQL.Async.execute('UPDATE Players SET Kills=@kills, Deaths=@deaths, Money=@money WHERE PlayerID=@playerId',
			{['@kills'] = kills, ['@deaths'] = deaths, ['@money'] = money, ['@playerId'] = GetPlayerIdentifiers(source)[1]}, function()
				scoreboard[playerIndex].money = money
				scoreboard[playerIndex].kdRatio = calculateKdRatio(kills, deaths)
				scoreboard[playerIndex].kills = kills
				scoreboard[playerIndex].deaths = deaths

				TriggerEvent('lsv:updateClientScoreboard')
		end)
	end
end)