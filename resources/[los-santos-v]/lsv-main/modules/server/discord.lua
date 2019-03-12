Discord = { }


local logger = Logger:CreateNamedLogger('Discord')

local discordUrl = nil
Citizen.CreateThread(function()
	discordUrl = GetConvar('discord_reporting_url')
end)


local function buildReportMessage(reporter, target, reason)
	return '**'..GetPlayerName(reporter)..'** ||('..GetPlayerIdentifiers(reporter)[1]..', '..GetPlayerPing(reporter)..' ms)|| reported'..
		' **'..GetPlayerName(target)..'** ||('..GetPlayerIdentifiers(target)[1]..', '..GetPlayerPing(target)..' ms)|| for **'..reason..'**'
end

local function buildKickMessage(target, moderator, reason)
	local whoKickedName = moderator and 'moderator **'..GetPlayerName(moderator)..'** ||('..GetPlayerIdentifiers(moderator)[1]..')||' or 'other players.'
	local message = '**'..GetPlayerName(target)..'** ||('..GetPlayerIdentifiers(target)[1]..', '..GetPlayerPing(target)..' ms)|| has been kicked from the session by '..whoKickedName
	if reason then message = message..' for **'..reason..'**' end
	return message
end

local function buildTempBanMessage(target, moderator, reason)
	return '**'..GetPlayerName(target)..'** ||('..GetPlayerIdentifiers(target)[1]..', '..GetPlayerPing(target)..' ms)|| has been banned from the server by moderator **'..GetPlayerName(moderator)..'** ||('..GetPlayerIdentifiers(moderator)[1]..')|| for **'..reason..'**'
end

local function performDiscordRequest(content, callback)
	if not discordUrl then return end

	PerformHttpRequest(discordUrl, function(statusCode)
		if statusCode >= 400 then
			logger:Error('Status code: '..statusCode)
			return
		end
		if callback then callback() end
	end, 'POST', json.encode({ content = content }), { ['Content-Type'] = 'application/json' })
end


function Discord.ReportPlayer(reporter, target, reason)
	performDiscordRequest(buildReportMessage(reporter, target, reason))
end


function Discord.ReportKickedPlayer(target, moderator, reason)
	performDiscordRequest(buildKickMessage(target, moderator, reason))
end


function Discord.ReportTempBanPlayer(target, moderator, reason)
	performDiscordRequest(buildTempBanMessage(target, moderator, reason))
end