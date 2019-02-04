local discordUrl = nil
local reportedPlayers = { }

local function buildReportMessage(player, playerId, playerName, target, targetId, targetName, reason)
	return '**'..playerName..'** ||('..playerId..', '..GetPlayerPing(player)..' ms)|| reported **'..targetName..'** ||('..targetId..', '..GetPlayerPing(target)..' ms)|| for **'..reason..'**'
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

		PerformHttpRequest(discordUrl, function() end, 'POST', json.encode({ content = buildReportMessage(player, playerId, playerName, target, targetId, targetName, reason) }), { ['Content-Type'] = 'application/json' })

		if Scoreboard.GetPlayersCount() > 3 and reportedPlayers[target] > Scoreboard.GetPlayersCount() / 2 then
			DropPlayer(target, 'You have been kicked from the session by other players.')
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
	discordUrl = GetConvar('discord_reporting_url')
end)