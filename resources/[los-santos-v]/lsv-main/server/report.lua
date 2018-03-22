local discordUrl = nil
local reportedPlayers = { }

local function buildReportMessage(player, target, reason)
	return '**REPORTER**: '..GetPlayerIdentifiers(player)[1]..'\n\n'..'**TARGET**: '..GetPlayerIdentifiers(target)[1]..'\n'..'**NAME**: '..
		GetPlayerName(target)..'\n'..'**REASON**: '..reason..'\n\nThank you for reporting.'
end

local function buildKickMessage(player)
	return '**'..GetPlayerName(player)..'** has been kicked from the session by other players.'
end


RegisterServerEvent('lsv:reportPlayer')
AddEventHandler('lsv:reportPlayer', function(target, reason)
	local player = source

	if not reportedPlayers[target] then reportedPlayers[target] = 1
	else reportedPlayers[target] = reportedPlayers[target] + 1 end

	TriggerClientEvent('lsv:reportSuccess', player)
	PerformHttpRequest(discordUrl, function() end, 'POST', json.encode({ content = buildReportMessage(player, target, reason) }), { ['Content-Type'] = 'application/json' })

	if Scoreboard.GetPlayersCount() > 3 and reportedPlayers[target] > Scoreboard.GetPlayersCount() / 2 then
		TriggerClientEvent('lsv:playerKicked', -1, GetPlayerName(target))
		PerformHttpRequest(discordUrl, function() end, 'POST', json.encode({ content = buildKickMessage(player) }), { ['Content-Type'] = 'application/json' })
		DropPlayer(target, "You have been kicked from the session by other players.")
		reportedPlayers[target] = nil
	end
end)

Citizen.CreateThread(function()
	discordUrl = GetConvar("discord_reporting_url")
end)