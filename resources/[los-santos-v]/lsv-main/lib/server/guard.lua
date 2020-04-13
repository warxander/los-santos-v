Guard = { }
Guard.__index = Guard

local logger = Logger.New('Guard')

function Guard.BanPlayer(player, reason, message)
	if not PlayerData.IsExists(player) then
		return
	end

	Db.BanPlayer(player, function()
		local playerName = GetPlayerName(player)
		if not playerName then
			return
		end

		Discord.ReportAutoBanPlayer(player, reason)

		if message then
			logger:info('Ban { '..player..', '..playerName..', '..message..' }')
		end

		DropPlayer(player, 'You\'re permanently banned from this server for '..reason..'.')
		TriggerClientEvent('lsv:playerBanned', -1, playerName, reason)
	end)
end
