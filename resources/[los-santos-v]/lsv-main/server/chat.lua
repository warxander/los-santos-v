local _systemMessageColor = { 114, 204, 114 }
local _privateMessageColor = { 232, 142, 155 }
local _emoteMessageColor = { 240, 200, 80 }

local _playerMutes = { }

local function registerEmote(command, soloMessage, targetMessage)
	RegisterCommand(command, function(source, args)
		local message = nil
		local playerName = GetPlayerName(source)

		if not args[1] or not targetMessage then
			message = string.format(soloMessage, playerName)
		elseif GetPlayerName(args[1]) then
			message = string.format(targetMessage, playerName, GetPlayerName(args[1]))
		end

		if message then
			TriggerEvent('lsv:addMessage', source, -1, {
				color = _emoteMessageColor,
				args = { message },
			})
		end
	end)
end

RegisterNetEvent('_chat:messageEntered')
AddEventHandler('_chat:messageEntered', function(author, color, message)
	if not message or not author or message == '' then
		return
	end

	local sourceName = GetPlayerName(source)
	if sourceName and sourceName ~= author then
		Guard.BanPlayer(source, 'Cheating', 'TriggerServerEvent(\'_chat:messageEntered\', '..author)
		CancelEvent()
		return
	end

	local message = {
		color = { 255, 255, 255 },
		args = { '['..author..']: '..message }
	}

	TriggerEvent('lsv:addMessage', source, -1, message)
end)

RegisterNetEvent('lsv:addCrewMessage')
AddEventHandler('lsv:addCrewMessage', function(members, message)
	local player = source
	if not PlayerData.IsExists(player) then
		return
	end

	local message = {
		color = { 123, 196, 255 },
		args = { '['..GetPlayerName(player)..']: '..message }
	}

	table.insert(members, player)
	table.foreach(members, function(member)
		TriggerEvent('lsv:addMessage', player, member, message)
	end)
end)

RegisterCommand('t', function(source, args)
	if not args[1] or not args[2] then
		return
	end

	local text = ''
	for i = 2, #args do text = text..args[i]..' ' end

	local message = {
		color = _privateMessageColor,
		args = { '['..GetPlayerName(source)..']: '..text:sub(1, -2) },
	}

	TriggerClientEvent('chat:addMessage', source, message)
	TriggerEvent('lsv:addMessage', source, args[1], message)
end)

RegisterCommand('c', function(source, args)
	if not args[1] or not PlayerData.IsExists(source) then
		return
	end

	local text = ''
	table.iforeach(args, function(arg)
		text = text..arg..' '
	end)

	TriggerClientEvent('lsv:addCrewMessage', source, text)
end)

RegisterCommand('unban', function(source, args)
	if not args[1] or not PlayerData.IsExists(source) or not PlayerData.IsModerator(source) or PlayerData.GetModeratorLevel(source) ~= Settings.moderator.levels.Administrator then
		return
	end

	local playerId = args[1]
	Db.UnbanPlayerById(playerId, function()
		local message = {
			color = _systemMessageColor,
			args = { playerId..' was unbanned.' },
		}

		TriggerClientEvent('chat:addMessage', source, message)
	end)
end)

RegisterCommand('mute', function(source, args)
	if not args[1] then
		return
	end

	local mutedPlayer = tonumber(args[1])
	if mutedPlayer == source or not PlayerData.IsExists(mutedPlayer) then
		return
	end

	if not _playerMutes[source] then
		_playerMutes[source] = { }
	end

	_playerMutes[source][mutedPlayer] = true

	local message = {
		color = _systemMessageColor,
		args = { GetPlayerName(mutedPlayer)..' muted.' },
	}

	TriggerClientEvent('chat:addMessage', source, message)
end)

RegisterCommand('unmute', function(source, args)
	if not args[1] then
		return
	end

	local unmutedPlayer = tonumber(args[1])
	if unmutedPlayer == source or not PlayerData.IsExists(unmutedPlayer) then
		return
	end

	if not _playerMutes[source] then
		return
	end

	_playerMutes[source][unmutedPlayer] = nil

	local message = {
		color = _systemMessageColor,
		args = { GetPlayerName(unmutedPlayer)..' unmuted.' },
	}

	TriggerClientEvent('chat:addMessage', source, message)
end)

RegisterCommand('money', function(source)
	if not PlayerData.IsExists(source) then
		return
	end

	local message = {
		color = _systemMessageColor,
		args = { 'You have $'..PlayerData.GetCash(source)..'. Hold Z to show PlayerData.' },
	}

	TriggerClientEvent('chat:addMessage', source, message)
end)

RegisterCommand('ping', function(source, args)
	local player = source
	if args[1] then
		player = tonumber(args[1])
	end

	if not PlayerData.IsExists(player) then
		return
	end

	TriggerClientEvent('chat:addMessage', source, {
		color = _systemMessageColor,
		args = { 'Checking '..GetPlayerName(player)..'\'s ping...' },
	})

	local pingMeasurers = { }
	local count = 10

	while count ~= 0 do
		Citizen.Wait(500)

		if not PlayerData.IsExists(player) then
			return
		end

		local ping = GetPlayerPing(player)
		if not ping then
			return
		end

		table.insert(pingMeasurers, ping)
		count = count - 1
	end

	local message = {
		color = _systemMessageColor,
		args = { GetPlayerName(player)..'\'s average ping is '..math.average(pingMeasurers)..' ms' },
	}

	TriggerClientEvent('chat:addMessage', source, message)
end)

RegisterCommand('help', function(source)
	if not PlayerData.IsExists(source) then
		return
	end

	local message = {
		color = _systemMessageColor,
		args = { 'Earn money and ranking up to unlock new weapons and vehicles.\nCompete with other players by doing Free Roam missions, events and deathmatch.\nJoin our Discord for more details.' },
	}

	TriggerClientEvent('chat:addMessage', source, message)
end)

RegisterCommand('ammo', function(source)
	if not PlayerData.IsExists(source) then
		return
	end

	local message = {
		color = _systemMessageColor,
		args = { 'Use Interaction menu (M by default) to buy ammo.' },
	}

	TriggerClientEvent('chat:addMessage', source, message)
end)

RegisterCommand('report', function(source)
	if not PlayerData.IsExists(source) then
		return
	end

	local message = {
		color = _systemMessageColor,
		args = { 'Use Interaction menu (M by default) to report other players.' },
	}

	TriggerClientEvent('chat:addMessage', source, message)
end)

RegisterCommand('skin', function(source)
	if not PlayerData.IsExists(source) then
		return
	end

	local message = {
		color = _systemMessageColor,
		args = { 'Visit Clothes Store to change your character appearance.' },
	}

	TriggerClientEvent('chat:addMessage', source, message)
end)

RegisterCommand('cash', function(source)
	if not PlayerData.IsExists(source) then
		return
	end

	local message = {
		color = _systemMessageColor,
		args = { 'Hold Z (by default) to view the scoreboard.' },
	}

	TriggerClientEvent('chat:addMessage', source, message)
end)

RegisterCommand('quit', function(source)
	if not PlayerData.IsExists(source) then
		return
	end

	local message = {
		color = _systemMessageColor,
		args = { 'Use Pause Menu to exit the server. Hope to see you soon!' },
	}

	TriggerClientEvent('chat:addMessage', source, message)
end)

RegisterCommand('vehicle', function(source)
	if not PlayerData.IsExists(source) then
		return
	end

	local message = {
		color = _systemMessageColor,
		args = { 'Use Personal Vehicle menu (Y by default) to customize and control your Personal Vehicle.' },
	}

	TriggerClientEvent('chat:addMessage', source, message)
end)

RegisterCommand('faction', function(source)
	if not PlayerData.IsExists(source) then
		return
	end

	local message = {
		color = _systemMessageColor,
		args = { 'Use Interaction menu (M by default) to join any Faction and get extra reward for killing opposite faction players.' },
	}

	TriggerClientEvent('chat:addMessage', source, message)
end)

RegisterCommand('id', function(source)
	if not PlayerData.IsExists(source) then
		return
	end

	local identifier = PlayerData.GetIdentifier(source)

	local message = {
		color = _systemMessageColor,
		args = { 'Your id is '..identifier },
	}

	TriggerClientEvent('chat:addMessage', source, message)
end)

registerEmote('agree', '%s agrees.', '%s agrees with %s.')
registerEmote('amaze', '%s is amazed!', '%s is amazed by %s.')
registerEmote('angry', '%s raises his fist in anger.', '%s raises his fist in anger at %s.')
registerEmote('apologize', '%s apologizes to everyone. Sorry!', '%s apologizes to %s. Sorry!')
registerEmote('applaud', '%s applauds. Bravo!', '%s applauds at %s. Bravo!')
registerEmote('attack', '%s tells everyone to attack something.', '%s tells everyone to attack %s.')

registerEmote('bark', '%s barks. Woof woof!', '%s barks at %s.')
registerEmote('bashful', '%s is bashful.', '%s is bashful...too bashful to get %s\'s attention.')
registerEmote('beckon', '%s beckons everyone over to himself.', '%s beckons %s over.')
registerEmote('beg', '%s begs everyone around him. How pathetic.', '%s begs %s. How pathetic.')
registerEmote('bite', '%s looks around for someone to bite.', '%s bites %s. Ouch!')
registerEmote('bleed', 'Blood oozes from %s wounds.')
registerEmote('blow', '%s blows a kiss into the wind.', '%s blows a kiss to %s.')
registerEmote('blush', '%s blushes.', '%s blushes at %s.')
registerEmote('bored', '%s is overcome with boredom. Oh the drudgery!', '%s is terribly bored with %s.')
registerEmote('bounce', '%s bounces up and down.', '%s bounces up and down in front of %s.')
registerEmote('bow', '%s bows down graciously.', '%s bows before %s.')
registerEmote('brb', '%s lets everyone know he\'ll be right back.', '%s let\'s %s know he\'ll be right back.')
registerEmote('bye', '%s waves goodbye to everyone. Farewell!', '%s waves goodbye to %s. Farewell!')

registerEmote('cackle', '%s cackles maniacally at the situation.', '%s cackles maniacally at %s.')
registerEmote('calm', '%s remains calm.', '%s tries to calm %s down.')
registerEmote('cat', '%s scratches himself. Ah, much better!', '%s scratches %s. How catty!')
registerEmote('charge', '%s starts to charge.')
registerEmote('cheer', '%s cheers.', '%s cheers at %s.')
registerEmote('chew', '%s begins to eat.', '%s begins to eat in front of %s.')
registerEmote('chicken', 'With arms flapping, %s struts around. Cluck, Cluck, Chicken!', 'With arms flapping, %s struts around %s. Cluck, Cluck, Chicken!')
registerEmote('chuckle', '%s lets out a hearty chuckle.', '%s chuckles at %s.')
registerEmote('clap', '%s claps excitedly.', '%s claps excitedly for %s.')
registerEmote('cold', '%s lets everyone know that he is cold.', '%s lets %s know that he is cold.')
registerEmote('comfort', '%s needs to be comforted.', '%s comforts %s.')
registerEmote('commend', '%s commends everyone on a job well done.', '%s commends %s on a job well done.')
registerEmote('confused', '%s is hopelessly confused.', '%s looks at %s with a confused look.')
registerEmote('congrats', '%s congratulates everyone around himself.', '%s congratulates %s.')
registerEmote('cough', '%s lets out a hacking cough.', '%s coughs at %s.')
registerEmote('cower', '%s cowers in fear.', '%s cowers in fear at the sight of %s.')
registerEmote('crack', '%s cracks his knuckles.', '%s cracks his knuckles while staring at %s.')
registerEmote('cringe', '%s cringes in fear.', '%s cringes away from %s.')
registerEmote('cry', '%s cries.', '%s cries on %s\'s shoulder.')
registerEmote('cuddle', '%s needs to be cuddled.', '%s cuddles up against %s.')
registerEmote('curious', '%s expresses his curiosity to those around himself.', '%s is curious what %s is up to.')

registerEmote('dance', '%s bursts into dance.', '%s dances with %s.')
registerEmote('disappointed', '%s frowns.', '%s frowns with disappointment at %s.')
registerEmote('doom', '%s threatens everyone with the wrath of doom.', '%s threatens %s with the wrath of doom.')
registerEmote('drink', '%s raises a drink in the air before chugging it down. Cheers!', '%s raises a drink to %s. Cheers!')
registerEmote('duck', '%s ducks for cover.', '%s ducks behind %s.')

registerEmote('facepalm', '%s covers his face with his palm.', '%s looks over at %s and covers his face with his palm.')

registerEmote('helpme', '%s cries out for help!')
registerEmote('hi', '%s greets everyone with a hearty hello!', '%s greets %s with a hearty hello!')

registerEmote('jk', '%s was just kidding!', '%s lets %s know that he was just kidding!')

registerEmote('laugh', '%s laughs.', '%s laughs at %s.')

AddEventHandler('lsv:addMessage', function(from, to, message)
	local players = { }

	if to ~= -1 then
		table.insert(players, tonumber(to))
	else
		for i = 0, GetNumPlayerIndices() do
			table.insert(players, i)
		end

		players = table.map(players, function(playerIndex)
			return tonumber(GetPlayerFromIndex(playerIndex))
		end)
	end

	players = table.filter(players, function(player)
		return not _playerMutes[player] or not _playerMutes[player][tonumber(from)]
	end)

	table.foreach(players, function(player)
		TriggerClientEvent('chat:addMessage', player, message)
	end)
end)


AddSignalHandler('lsv:playerDropped', function(player)
	_playerMutes[player] = nil
end)
