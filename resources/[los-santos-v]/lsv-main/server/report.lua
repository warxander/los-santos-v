local discordUrl = nil

local function buildReportMessage(player, target, reason)
	return '**REPORTER**: '..GetPlayerIdentifiers(player)[1]..'\n\n'..'**TARGET**: '..GetPlayerIdentifiers(target)[1]..'\n'..'**NAME**: '..
		GetPlayerName(target)..'\n'..'**REASON**: '..reason..'\n\nThank you for reporting.'
end

RegisterServerEvent('lsv:reportPlayer')
AddEventHandler('lsv:reportPlayer', function(target, reason)
	local player = source

	PerformHttpRequest(discordUrl, function(statusCode, responeText, headers)
		if statusCode == 0 or not responeText then TriggerClientEvent('lsv:reportError', player)
		else TriggerClientEvent('lsv:reportSuccess', player) end
	end, 'POST', json.encode({content = buildReportMessage(player, target, reason)}), { ['Content-Type'] = 'application/json' })
end)

Citizen.CreateThread(function()
	discordUrl = GetConvar("discord_reporting_url")
end)