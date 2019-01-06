Scoreboard = { }

-- Format: { id, name, cash, kdRatio, kills, deaths }
local scoreboard = { }

local function sortScoreboard(l, r)
	if not l then return false end
	if not r then return true end

	if l.cash > r.cash then return true end
	if l.cash < r.cash then return false end

	if not l.kdRatio then return false end
	if not r.kdRatio then return true end

	if l.kdRatio > r.kdRatio then return true end
	if l.kdRatio < r.kdRatio then return false end

	if l.kills > r.kills then return true end
	if l.kills < r.kills then return false end

	if l.deaths > r.deaths then return false end
	if l.deaths < r.deaths then return true end

	return l.name < r.name
end


local function calculateKdRatio(kills, deaths)
	if kills + deaths < Settings.kdRatioMinStat then
		return nil
	else
		return kills / deaths
	end
end


local function updateScoreboard()
	local clientScoreboard = { }

	for _, player in pairs(scoreboard) do table.insert(clientScoreboard, player) end

	table.sort(clientScoreboard, sortScoreboard)

	TriggerClientEvent('lsv:updateScoreboard', -1, clientScoreboard)
end


function Scoreboard.AddPlayer(player, playerStats)
	if not scoreboard[player] then
		scoreboard[player] = {
			id = player,
			name = GetPlayerName(player),
			cash = playerStats.Cash,
			kdRatio = calculateKdRatio(playerStats.Kills, playerStats.Deaths),
			kills = playerStats.Kills,
			deaths = playerStats.Deaths,
			killstreak = 0,
		}

		updateScoreboard()
	end
end


function Scoreboard.RemovePlayer(player)
	if scoreboard[player] then
		scoreboard[player] = nil
		updateScoreboard()
	end
end


function Scoreboard.GetPlayersCount()
	return Utils.GetTableLength(scoreboard)
end


function Scoreboard.IsPlayerOnline(player)
	return scoreboard[player]
end


function Scoreboard.GetRandomPlayer()
	return Utils.GetRandom(scoreboard).id
end


function Scoreboard.GetPlayerCash(player)
	return scoreboard[player].cash
end


function Scoreboard.GetPlayerKillstreak(player)
	return scoreboard[player].killstreak
end


function Scoreboard.GetPlayerKills(player)
	return scoreboard[player].kills
end


function Scoreboard.UpdateCash(player, cash)
	if scoreboard[player] then
		scoreboard[player].cash = scoreboard[player].cash + cash
		updateScoreboard()
	end
end


function Scoreboard.UpdateKills(player)
	if scoreboard[player] then
		scoreboard[player].kills = scoreboard[player].kills + 1
		scoreboard[player].kdRatio = calculateKdRatio(scoreboard[player].kills, scoreboard[player].deaths)

		updateScoreboard()
	end
end


function Scoreboard.UpdateDeaths(player)
	if scoreboard[player] then
		scoreboard[player].deaths = scoreboard[player].deaths + 1
		scoreboard[player].kdRatio = calculateKdRatio(scoreboard[player].kills, scoreboard[player].deaths)

		updateScoreboard()
	end
end


function Scoreboard.UpdateKillstreak(player)
	if scoreboard[player] then
		scoreboard[player].killstreak = scoreboard[player].killstreak + 1
	end
end


function Scoreboard.ResetKillstreak(player)
	if scoreboard[player] then
		scoreboard[player].killstreak = 0
	end
end