Discord = { }
Discord.__index = Discord

local logger = Logger.New('Discord')

local _discordBotToken = nil

local _webhooks = { }

local _discordGuildId = nil
local _patreonRoles = { }
local _moderatorRoles = { }

local function readConvar(convarName)
	local convar = GetConvar(convarName, '')
	if convar ~= '' then
		return convar
	else
		return nil
	end
end

local function readConvarBool(convarName)
	local convar = GetConvar(convarName, 'false')
	return convar ~= 'false'
end

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

local function buildTimeTrialRecordMessage(player, trialName, time)
	return '**'..GetPlayerName(player)..'** ||('..PlayerData.GetIdentifier(player)..')|| set a new **'..trialName..'** server record of **'..time..'**'
end

local function buildSurvivalRecordMessage(player, survivalName, waves)
	return '**'..GetPlayerName(player)..'** ||('..PlayerData.GetIdentifier(player)..')|| set a new **'..survivalName..'** server record of **'..waves..' Waves**'
end

local function performDiscordRequest(method, endPoint, data, callback)
	data = data and json.encode({ content = data }) or ''

	PerformHttpRequest(endPoint, function(statusCode, data, headers)
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

local function performDiscordReport(message, webhookConvarName)
	local webhook = _webhooks[webhookConvarName]
	if not webhook then
		return
	end

	performDiscordRequest('POST', webhook, message)
end

Citizen.CreateThread(function()
	_discordBotToken = readConvar('discord_botToken')
	if _discordBotToken then
		_webhooks['discord_reportWebhook'] = readConvar('discord_reportWebhook')
		_webhooks['discord_timeTrialWebhook'] = readConvar('discord_timeTrialWebhook')
		_webhooks['discord_survivalWebhook'] = readConvar('discord_survivalWebhook')

		_discordGuildId = readConvar('discord_guildId')

		if _discordGuildId then
			_patreonRoles[1] = readConvar('discord_patreon1RoleId')
			_patreonRoles[2] = readConvar('discord_patreon2RoleId')
			_patreonRoles[3] = readConvar('discord_patreon3RoleId')

			_moderatorRoles[Settings.moderator.levels.Moderator] = readConvar('discord_moderatorRoleId')
			_moderatorRoles[Settings.moderator.levels.Administrator] = readConvar('discord_administatorRoleId')
		end
	end
end)

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
	if not _discordBotToken or not _discordGuildId then
		callback()
		return
	end

	local roles = { }

	if not id then
		callback(roles)
		return
	end

	local endPoint = string.format('https://discordapp.com/api/guilds/%s/members/%s', _discordGuildId, id)
	performDiscordRequest('GET', endPoint, nil, function(response)
		if response.statusCode == 200 then
			local data = json.decode(response.data)

			if data.roles then
				for moderatorLevel = #_moderatorRoles, 1, -1 do
					if table.ifind(data.roles, _moderatorRoles[moderatorLevel]) then
						roles.Moderator = moderatorLevel
						break
					end
				end

				for patreonTier = #_patreonRoles, 1, -1 do
					if table.ifind(data.roles, _patreonRoles[patreonTier]) then
						roles.PatreonTier = patreonTier
						break
					end
				end
			end
		end

		callback(roles)
	end)
end

function Discord.ReportNewTimeTrialRecord(player, trialName, time)
	if _discordBotToken then
		performDiscordReport(buildTimeTrialRecordMessage(player, trialName, time), 'discord_timeTrialWebhook')
	end
end

function Discord.ReportNewSurvivalRecord(player, survivalName, waves)
	if _discordBotToken then
		performDiscordReport(buildSurvivalRecordMessage(player, survivalName, waves), 'discord_survivalWebhook')
	end
end

function Discord.ReportPlayer(reporter, target, reason)
	if _discordBotToken then
		performDiscordReport(buildReportMessage(reporter, target, reason), 'discord_reportWebhook')
	end
end

function Discord.ReportKickedPlayer(target, moderator, reason)
	if _discordBotToken then
		performDiscordReport(buildKickMessage(target, moderator, reason), 'discord_reportWebhook')
	end
end

function Discord.ReportBanPlayer(target, moderator, reason, duration)
	if _discordBotToken then
		performDiscordReport(buildBanMessage(target, moderator, reason, duration), 'discord_reportWebhook')
	end
end

function Discord.ReportAutoBanPlayer(target, reason)
	if _discordBotToken then
		local message = '**'..GetPlayerName(target)..'** ||('..PlayerData.GetIdentifier(target)..')|| has been permanently banned from the server for **'..reason..'**'
		performDiscordReport(message, 'discord_reportWebhook')
	end
end
