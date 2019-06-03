local function RegisterEmoteSuggestion(command, withoutParam)
	local param = nil
	if not withoutParam then param = { { name = 'playerid', help = 'Optional' } } end

	TriggerEvent('chat:addSuggestion', command, '', param)
end


AddEventHandler('lsv:init', function()
	TriggerEvent('chat:addSuggestion', '/say', 'Send message to General channel', {
		{ name = 'message' },
	})

	TriggerEvent('chat:addSuggestion', '/tell', 'Send private message to player', {
		{ name = 'playerid' },
		{ name = 'message' },
	})

	RegisterEmoteSuggestion('/agree')
	RegisterEmoteSuggestion('/amaze')
	RegisterEmoteSuggestion('/angry')
	RegisterEmoteSuggestion('/apologize')
	RegisterEmoteSuggestion('/applaud')
	RegisterEmoteSuggestion('/attack')

	RegisterEmoteSuggestion('/bashful')
	RegisterEmoteSuggestion('/beckon')
	RegisterEmoteSuggestion('/beg')
	RegisterEmoteSuggestion('/bite')
	RegisterEmoteSuggestion('/bleed', true)
	RegisterEmoteSuggestion('/blow')
	RegisterEmoteSuggestion('/blush')
	RegisterEmoteSuggestion('/bored')
	RegisterEmoteSuggestion('/bounce')
	RegisterEmoteSuggestion('/bow')
	RegisterEmoteSuggestion('/brb')
	RegisterEmoteSuggestion('/bye')

	RegisterEmoteSuggestion('/cackle')
	RegisterEmoteSuggestion('/calm')
	RegisterEmoteSuggestion('/cat')
	RegisterEmoteSuggestion('/charge', true)
	RegisterEmoteSuggestion('/cheer')
	RegisterEmoteSuggestion('/chew')
	RegisterEmoteSuggestion('/chicken')
	RegisterEmoteSuggestion('/chuckle')
	RegisterEmoteSuggestion('/clap')
	RegisterEmoteSuggestion('/cold')
	RegisterEmoteSuggestion('/comfort')
	RegisterEmoteSuggestion('/commend')
	RegisterEmoteSuggestion('/confused')
	RegisterEmoteSuggestion('/congrats')
	RegisterEmoteSuggestion('/cough')
	RegisterEmoteSuggestion('/cower')
	RegisterEmoteSuggestion('/crack')
	RegisterEmoteSuggestion('/cringe')
	RegisterEmoteSuggestion('/cry')
	RegisterEmoteSuggestion('/cuddle')
	RegisterEmoteSuggestion('/curious')

	RegisterEmoteSuggestion('/dance')
	RegisterEmoteSuggestion('/disappointed')
	RegisterEmoteSuggestion('/doom')
	RegisterEmoteSuggestion('/drink')
	RegisterEmoteSuggestion('/duck')

	RegisterEmoteSuggestion('/facepalm')

	RegisterEmoteSuggestion('/helpme', true)
	RegisterEmoteSuggestion('/hi')

	RegisterEmoteSuggestion('/jk')

	RegisterEmoteSuggestion('/laugh')

	RegisterEmoteSuggestion('/money', true) -- Not an emote at all
	RegisterEmoteSuggestion('/mute') -- Not an emote at all
	RegisterEmoteSuggestion('/unmute') -- Not an emote at all

	RegisterEmoteSuggestion('/ping') -- Not an emote at all

	RegisterEmoteSuggestion('/help', true) -- Not an emote at all
	RegisterEmoteSuggestion('/ammo', true) -- Not an emote at all
	RegisterEmoteSuggestion('/report', true) -- Not an emote at all
	RegisterEmoteSuggestion('/cash', true) -- Not an emote at all
	RegisterEmoteSuggestion('/quit', true) -- Not an emote at all
	RegisterEmoteSuggestion('/vehicle', true) -- Not an emote at all
	RegisterEmoteSuggestion('/repair', true) -- Not an emote at all

	RegisterEmoteSuggestion('/crew', true) -- Not an emote at all
end)


AddEventHandler('lsv:setupHud', function(hud)
	if hud.discordUrl ~= '' then
		TriggerEvent('chat:addSuggestion', '/discord', 'Copy-paste Discord invite link', {
			{ name = hud.discordUrl },
		})
	end
end)