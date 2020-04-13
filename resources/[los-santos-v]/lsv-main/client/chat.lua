local function registerEmoteSuggestion(command, withoutParam)
	local param = nil
	if not withoutParam then
		param = { { name = 'playerid', help = 'Optional' } }
	end

	TriggerEvent('chat:addSuggestion', command, '', param)
end

RegisterNetEvent('lsv:addCrewMessage')
AddEventHandler('lsv:addCrewMessage', function(message)
	if #Player.CrewMembers == 0 then
		return
	end

	TriggerServerEvent('lsv:addCrewMessage', Player.CrewMembers, message)
end)

AddEventHandler('lsv:init', function()
	TriggerEvent('chat:addSuggestion', '/t', 'Send private message to player', {
		{ name = 'playerid' },
		{ name = 'message' },
	})

	TriggerEvent('chat:addSuggestion', '/c', 'Send message to your Crew', {
		{ name = 'message' },
	})

	if Player.Moderator and Player.Moderator == Settings.moderator.levels.Administrator then
		TriggerEvent('chat:addSuggestion', '/unban', 'Unban player', {
			{ name = 'playerid' },
		})
	end

	registerEmoteSuggestion('/agree')
	registerEmoteSuggestion('/amaze')
	registerEmoteSuggestion('/angry')
	registerEmoteSuggestion('/apologize')
	registerEmoteSuggestion('/applaud')
	registerEmoteSuggestion('/attack')

	registerEmoteSuggestion('/bashful')
	registerEmoteSuggestion('/beckon')
	registerEmoteSuggestion('/beg')
	registerEmoteSuggestion('/bite')
	registerEmoteSuggestion('/bleed', true)
	registerEmoteSuggestion('/blow')
	registerEmoteSuggestion('/blush')
	registerEmoteSuggestion('/bored')
	registerEmoteSuggestion('/bounce')
	registerEmoteSuggestion('/bow')
	registerEmoteSuggestion('/brb')
	registerEmoteSuggestion('/bye')

	registerEmoteSuggestion('/cackle')
	registerEmoteSuggestion('/calm')
	registerEmoteSuggestion('/cat')
	registerEmoteSuggestion('/charge', true)
	registerEmoteSuggestion('/cheer')
	registerEmoteSuggestion('/chew')
	registerEmoteSuggestion('/chicken')
	registerEmoteSuggestion('/chuckle')
	registerEmoteSuggestion('/clap')
	registerEmoteSuggestion('/cold')
	registerEmoteSuggestion('/comfort')
	registerEmoteSuggestion('/commend')
	registerEmoteSuggestion('/confused')
	registerEmoteSuggestion('/congrats')
	registerEmoteSuggestion('/cough')
	registerEmoteSuggestion('/cower')
	registerEmoteSuggestion('/crack')
	registerEmoteSuggestion('/cringe')
	registerEmoteSuggestion('/cry')
	registerEmoteSuggestion('/cuddle')
	registerEmoteSuggestion('/curious')

	registerEmoteSuggestion('/dance')
	registerEmoteSuggestion('/disappointed')
	registerEmoteSuggestion('/doom')
	registerEmoteSuggestion('/drink')
	registerEmoteSuggestion('/duck')

	registerEmoteSuggestion('/facepalm')

	registerEmoteSuggestion('/helpme', true)
	registerEmoteSuggestion('/hi')

	registerEmoteSuggestion('/jk')

	registerEmoteSuggestion('/laugh')

	registerEmoteSuggestion('/money', true) -- Not an emote at all
	registerEmoteSuggestion('/mute') -- Not an emote at all
	registerEmoteSuggestion('/unmute') -- Not an emote at all

	registerEmoteSuggestion('/ping') -- Not an emote at all

	registerEmoteSuggestion('/help', true) -- Not an emote at all
	registerEmoteSuggestion('/ammo', true) -- Not an emote at all
	registerEmoteSuggestion('/report', true) -- Not an emote at all
	registerEmoteSuggestion('/skin', true) -- Not an emote at all
	registerEmoteSuggestion('/cash', true) -- Not an emote at all
	registerEmoteSuggestion('/quit', true) -- Not an emote at all
	registerEmoteSuggestion('/vehicle', true) -- Not an emote at all
	registerEmoteSuggestion('/faction', true) -- Not an emote at all

	registerEmoteSuggestion('/id', true) -- Not an emote at all
end)

AddEventHandler('lsv:setupHud', function(hud)
	if hud.discordUrl ~= '' then
		TriggerEvent('chat:addSuggestion', '/discord', 'Copy-paste Discord invite link', {
			{ name = hud.discordUrl },
		})
	end
end)
