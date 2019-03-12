local function isPlayerModerator(player)
	if not Scoreboard.IsPlayerModerator(player) then
		TriggerEvent('lsv:banPlayer', player, 'Fake moderator permission')
		return false
	end

	return true
end


RegisterNetEvent('lsv:kickPlayer')
AddEventHandler('lsv:kickPlayer', function(target, reason)
	local player = source

	if not Scoreboard.IsPlayerOnline(player) or not Scoreboard.IsPlayerOnline(target) then return end
	if not isPlayerModerator(player) then return end

	Discord.ReportKickedPlayer(target, player, reason)

	DropPlayer(target, 'You were kicked from the session by moderator for '..reason..'.')
end)


RegisterNetEvent('lsv:tempBanPlayer')
AddEventHandler('lsv:tempBanPlayer', function(target, reason)
	local player = source

	if not Scoreboard.IsPlayerOnline(player) or not Scoreboard.IsPlayerOnline(target) then return end
	if not isPlayerModerator(player) then return end

	local targetName = GetPlayerName(target)

	Db.BanPlayer(target, function()
		Discord.ReportTempBanPlayer(target, player, reason)
		DropPlayer(target, 'You\'re permanently banned from this server by moderator for '..reason..'.')
		TriggerClientEvent('lsv:playerBanned', -1, targetName, reason)
	end)
end)