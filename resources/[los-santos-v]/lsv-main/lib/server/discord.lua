Discord = { }
Discord.__index = Discord

local logger = Logger.New('Discord')

local _discordBotToken = nil
local _discordGuildId = nil
local _discordReportWebhook = nil

local function buildReportMessage(reporter, target, reason)
	return '**'..GetPlayerName(reporter)..'** ||('..PlayerData.GetIdentifier(reporter)..', '..GetPlayerPing(reporter)..' ms)|| reported'..
		' **'..GetPlayerName(target)..'** ||('..PlayerData.GetIdentifier(target)..', '..GetPlayerPing(target)..' ms)|| for **'..reason..'**'
end

local function buildKickMessage(target, moderator, reason)
	local whoKickedName = moderator and 'moderator **'..GetPlayerName(moderator)..'** ||('..PlayerData.GetIdentifier(moderator)..')||' or 'other players.'
	local message = '**'..GetPlayerName(target)..'** ||('..PlayerData.GetIdentifier(target)..', '..GetPlayerPing(target)..' ms)|| has been kicked from the session by '..whoKickedName

	if reason then
		message = message..' for **'..reason..'**'
	end

	return message
end

local function buildBanMessage(target, moderator, reason, duration)
	if duration then
		return '**'..GetPlayerName(target)..'** ||('..PlayerData.GetIdentifier(target)..', '..GetPlayerPing(target)..' ms)|| has been temporarily banned from the server by moderator **'..GetPlayerName(moderator)..'** ||('..PlayerData.GetIdentifier(moderator)..')|| for **'..reason..'** (Ban duration: **'..duration..' Day(s)**)'
	else
		return '**'..GetPlayerName(target)..'** ||('..PlayerData.GetIdentifier(target)..', '..GetPlayerPing(target)..' ms)|| has been permanently banned from the server by moderator **'..GetPlayerName(moderator)..'** ||('..PlayerData.GetIdentifier(moderator)..')|| for **'..reason..'**'
	end
end

local function performDiscordRequest(method, endPoint, data, callback)
	if string.len(endPoint) == 0 then
		return
	end

	if not _discordBotToken then
		_discordBotToken = GetConvar('discord_botToken', '')
	end

	data = data and json.encode({ content = data }) or ''

	PerformHttpRequest('https://discordapp.com/api/'..endPoint, function(statusCode, data, headers)
		if statusCode and statusCode >= 400 then
			logger:warn('Unwanted status code '..statusCode..' for '..endPoint..' endpoint')
		end

		if callback then
			callback({
				statusCode = statusCode,
				data = data,
				headers = headers,
			})
		end
	end, method, data, { ['Content-Type'] = 'application/json', ['Authorization'] = 'Bot '.._discordBotToken})
end

local function performDiscordReport(message)
	if not _discordReportWebhook then
		_discordReportWebhook = GetConvar('discord_reportWebhook', '')
	end

	if string.len(_discordReportWebhook) == 0 then
		return
	end

	performDiscordRequest('POST', _discordReportWebhook, message)
end

function Discord.GetIdentifier(player)
	local id = table.ifind_if(GetPlayerIdentifiers(player), function(id)
		return string.find(id, 'discord')
	end)

	if id then
		return string.gsub(id, 'discord:', '')
	end

	return nil
end

function Discord.GetRolesById(id, callback)
	local roles = { }

	if not _discordGuildId then
		_discordGuildId = GetConvar('discord_guildId', '')
	end

	if string.len(_discordGuildId) == 0 or not id then
		callback(roles)
		return
	end

	local endPoint = string.format('guilds/%s/members/%s', _discordGuildId, id)
	performDiscordRequest('GET', endPoint, nil, function(response)
		if response.statusCode == 200 then
			local data = json.decode(response.data)

			if data.roles then
				roles = data.roles
			end
		end

		callback(roles)
	end)
end

function Discord.ReportPlayer(reporter, target, reason)
	performDiscordReport(buildReportMessage(reporter, target, reason))
end

function Discord.ReportKickedPlayer(target, moderator, reason)
	performDiscordReport(buildKickMessage(target, moderator, reason))
end

function Discord.ReportBanPlayer(target, moderator, reason, duration)
	performDiscordReport(buildBanMessage(target, moderator, reason, duration))
end

function Discord.ReportAutoBanPlayer(target, reason)
	local message = '**'..GetPlayerName(target)..'** ||('..PlayerData.GetIdentifier(target)..')|| has been permanently banned from the server for **'..reason..'**'
	performDiscordReport(message)
end
