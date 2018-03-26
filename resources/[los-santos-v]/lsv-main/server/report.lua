local discordUrl = nil
local reportedPlayers = { }

local function buildReportMessage(playerId, playerName, targetId, targetName, reason)
	return '**REPORTER ID**: '..playerId..'\n**REPORTER NAME**: '..playerName..'\n\n'..
		'**TARGET ID**: '..targetId..'\n**TARGET NAME**: '..targetName..'\n'..
		'**REPORTING REASON**: '..reason
end

local function buildKickMessage(playerName)
	return '**'..playerName..'** has been kicked from the session by other players.'
end


RegisterServerEvent('lsv:reportPlayer')
AddEventHandler('lsv:reportPlayer', function(target, reason)
	local player = source
	local playerName = GetPlayerName(player)
	local playerId = GetPlayerIdentifiers(player)[1]

	local targetId = GetPlayerIdentifiers(target)[1]
	local targetName = GetPlayerName(target)

	Db.UpdateReports(target, function()
		if not reportedPlayers[target] then return end

		reportedPlayers[target] = reportedPlayers[target] + 1

		TriggerClientEvent('lsv:reportSuccess', -1, targetName)

		PerformHttpRequest(discordUrl, function() end, 'POST', json.encode({ content = buildReportMessage(playerId, playerName, targetId, targetName, reason) }), { ['Content-Type'] = 'application/json' })

		if Scoreboard.GetPlayersCount() > 3 and reportedPlayers[target] > Scoreboard.GetPlayersCount() / 2 then
			DropPlayer(target, "You have been kicked from the session by other players.")
			TriggerClientEvent('lsv:playerKicked', -1, targetName)
			PerformHttpRequest(discordUrl, function() end, 'POST', json.encode({ content = buildKickMessage(targetName) }), { ['Content-Type'] = 'application/json' })
		end
	end)
end)


AddEventHandler('lsv:playerConnected', function(player)
	reportedPlayers[player] = 0
end)


AddEventHandler('lsv:playerDropped', function(player)
	reportedPlayers[player] = nil
end)


Citizen.CreateThread(function()
	discordUrl = GetConvar("discord_reporting_url")
end)