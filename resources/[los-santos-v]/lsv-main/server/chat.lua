local systemMessageColor = { 114, 204, 114 }
local privateMessageColor = { 232, 142, 155 }
local emoteMessageColor = { 240, 200, 80 }

local playerMutes = { }


local function RegisterEmote(command, soloMessage, targetMessage)
	RegisterCommand(command, function(source, args)
		local message = nil
		local playerName = GetPlayerName(source)
		if not args[1] or not targetMessage then message = string.format(soloMessage, playerName)
		elseif GetPlayerName(args[1]) then message = string.format(targetMessage, playerName, GetPlayerName(args[1])) end

		if message then
			TriggerEvent('lsv:addMessage', source, -1, {
				color = emoteMessageColor,
				args = { message },
			})
		end
	end)
end


RegisterNetEvent('_chat:messageEntered')
AddEventHandler('_chat:messageEntered', function(author, color, message)
	if not message or not author or message == '' then return end

	local message = {
		color = { 255, 255, 255 },
		args = { '['..author..']: '..message }
	}

	TriggerEvent('lsv:addMessage', source, -1, message)
end)


RegisterNetEvent('lsv:addCrewMessage')
AddEventHandler('lsv:addCrewMessage', function(members, message)
	local player = source
	if not Scoreboard.IsPlayerOnline(player) then return end

	local message = {
		color = { 123, 196, 255 },
		args = { '['..GetPlayerName(player)..']: '..message }
	}

	table.insert(members, player)
	table.foreach(members, function(member) TriggerEvent('lsv:addMessage', player, member, message) end)
end)


AddEventHandler('lsv:addMessage', function(from, to, message)
	local players = { }
	if to ~= -1 then table.insert(players, tonumber(to))
	else
		for i = 0, GetNumPlayerIndices() do table.insert(players, i) end
		players = table.map(players, function(playerIndex) return tonumber(GetPlayerFromIndex(playerIndex)) end)
	end

	players = table.filter(players, function(player) return not playerMutes[player] or not playerMutes[player][tonumber(from)] end)

	table.foreach(players, function(player) TriggerClientEvent('chat:addMessage', player, message) end)
end)


AddEventHandler('lsv:playerDropped', function(player)
	playerMutes[player] = nil
end)


RegisterCommand('t', function(source, args)
	if not args[1] or not args[2] then return end

	local text = ''
	for i = 2, #args do text = text..args[i]..' ' end

	local message = {
		color = privateMessageColor,
		args = { '['..GetPlayerName(source)..']: '..text:sub(1, -2) },
	}

	TriggerClientEvent('chat:addMessage', source, message)
	TriggerEvent('lsv:addMessage', source, args[1], message)
end)


RegisterCommand('c', function(source, args)
	if not args[1] then return end

	local player = source
	if not Scoreboard.IsPlayerOnline(player) then return end

	local text = ''
	for i = 1, #args do text = text..args[i]..' ' end

	TriggerClientEvent('lsv:addCrewMessage', player, text)
end)


RegisterCommand('unban', function(source, args)
	if not args[1] then return end

	if not Scoreboard.IsPlayerOnline(source) or not Scoreboard.IsPlayerModerator(source) or Scoreboard.GetPlayerModeratorLevel(source) ~= Settings.moderatorLevel.Administrator then return end

	local playerId = args[1]
	Db.UnbanPlayerById(playerId, function()
		local message = {
			color = systemMessageColor,
			args = { playerId..' was unbanned.' },
		}

		TriggerClientEvent('chat:addMessage', source, message)
	end)
end)


RegisterCommand('mute', function(source, args)
	if not args[1] then return end

	local mutedPlayer = tonumber(args[1])
	if mutedPlayer == source or not Scoreboard.IsPlayerOnline(mutedPlayer) then return end

	if not playerMutes[source] then playerMutes[source] = { } end
	playerMutes[source][mutedPlayer] = true

	local message = {
		color = systemMessageColor,
		args = { GetPlayerName(mutedPlayer)..' muted.' },
	}

	TriggerClientEvent('chat:addMessage', source, message)
end)


RegisterCommand('unmute', function(source, args)
	if not args[1] then return end

	local unmutedPlayer = tonumber(args[1])
	if unmutedPlayer == source or not Scoreboard.IsPlayerOnline(unmutedPlayer) then return end

	if not playerMutes[source] then return end
	playerMutes[source][unmutedPlayer] = nil

	local message = {
		color = systemMessageColor,
		args = { GetPlayerName(unmutedPlayer)..' unmuted.' },
	}

	TriggerClientEvent('chat:addMessage', source, message)
end)


RegisterCommand('money', function(source)
	if not Scoreboard.IsPlayerOnline(source) then return end

	local message = {
		color = systemMessageColor,
		args = { 'You have $'..Scoreboard.GetPlayerCash(source)..'. Hold Z to show Scoreboard.' },
	}

	TriggerClientEvent('chat:addMessage', source, message)
end)


RegisterCommand('ping', function(source, args)
	local player = source
	if args[1] then player = tonumber(args[1]) end

	if not Scoreboard.IsPlayerOnline(player) then return end

	TriggerClientEvent('chat:addMessage', source, {
		color = systemMessageColor,
		args = { 'Checking '..GetPlayerName(player)..'\'s ping...' },
	})

	local pingMeasurers = { }
	local count = 10
	while count ~= 0 do
		if not Scoreboard.IsPlayerOnline(player) then return end

		local ping = GetPlayerPing(player)
		if not ping then return end
		table.insert(pingMeasurers, ping)

		count = count - 1
		Citizen.Wait(500)
	end

	local message = {
		color = systemMessageColor,
		args = { GetPlayerName(player)..'\'s average ping is '..math.average(pingMeasurers)..' ms' },
	}

	TriggerClientEvent('chat:addMessage', source, message)
end)


RegisterCommand('help', function(source)
	if not Scoreboard.IsPlayerOnline(source) then return end

	local message = {
		color = systemMessageColor,
		args = { 'Looks like you missed all in-game and loading screen tips.\nJoin our Discord to read a full #wiki guide.' },
	}

	TriggerClientEvent('chat:addMessage', source, message)
end)


RegisterCommand('ammo', function(source)
	if not Scoreboard.IsPlayerOnline(source) then return end

	local message = {
		color = systemMessageColor,
		args = { 'Use Interaction menu (M by default) to buy ammo.' },
	}

	TriggerClientEvent('chat:addMessage', source, message)
end)


RegisterCommand('report', function(source)
	if not Scoreboard.IsPlayerOnline(source) then return end

	local message = {
		color = systemMessageColor,
		args = { 'Use Interaction menu (M by default) to report other players.' },
	}

	TriggerClientEvent('chat:addMessage', source, message)
end)


RegisterCommand('cash', function(source)
	if not Scoreboard.IsPlayerOnline(source) then return end

	local message = {
		color = systemMessageColor,
		args = { 'Hold Z (by default) to view the scoreboard.' },
	}

	TriggerClientEvent('chat:addMessage', source, message)
end)


RegisterCommand('quit', function(source)
	if not Scoreboard.IsPlayerOnline(source) then return end

	local message = {
		color = systemMessageColor,
		args = { 'Use Pause Menu to exit the server. Hope to see you soon!' },
	}

	TriggerClientEvent('chat:addMessage', source, message)
end)


RegisterCommand('vehicle', function(source)
	if not Scoreboard.IsPlayerOnline(source) then return end

	local message = {
		color = systemMessageColor,
		args = { 'Use Personal Vehicle menu (Y by default) to customize and control your Personal Vehicle.' },
	}

	TriggerClientEvent('chat:addMessage', source, message)
end)


RegisterCommand('id', function(source)
	if not Scoreboard.IsPlayerOnline(source) then return end

	local identifier = Scoreboard.GetPlayerIdentifier(source)

	local message = {
		color = systemMessageColor,
		args = { 'Your id is '..identifier },
	}

	TriggerClientEvent('chat:addMessage', source, message)
end)


RegisterEmote('agree', '%s agrees.', '%s agrees with %s.')
RegisterEmote('amaze', '%s is amazed!', '%s is amazed by %s.')
RegisterEmote('angry', '%s raises his fist in anger.', '%s raises his fist in anger at %s.')
RegisterEmote('apologize', '%s apologizes to everyone. Sorry!', '%s apologizes to %s. Sorry!')
RegisterEmote('applaud', '%s applauds. Bravo!', '%s applauds at %s. Bravo!')
RegisterEmote('attack', '%s tells everyone to attack something.', '%s tells everyone to attack %s.')

RegisterEmote('bark', '%s barks. Woof woof!', '%s barks at %s.')
RegisterEmote('bashful', '%s is bashful.', '%s is bashful...too bashful to get %s\'s attention.')
RegisterEmote('beckon', '%s beckons everyone over to himself.', '%s beckons %s over.')
RegisterEmote('beg', '%s begs everyone around him. How pathetic.', '%s begs %s. How pathetic.')
RegisterEmote('bite', '%s looks around for someone to bite.', '%s bites %s. Ouch!')
RegisterEmote('bleed', 'Blood oozes from %s wounds.')
RegisterEmote('blow', '%s blows a kiss into the wind.', '%s blows a kiss to %s.')
RegisterEmote('blush', '%s blushes.', '%s blushes at %s.')
RegisterEmote('bored', '%s is overcome with boredom. Oh the drudgery!', '%s is terribly bored with %s.')
RegisterEmote('bounce', '%s bounces up and down.', '%s bounces up and down in front of %s.')
RegisterEmote('bow', '%s bows down graciously.', '%s bows before %s.')
RegisterEmote('brb', '%s lets everyone know he\'ll be right back.', '%s let\'s %s know he\'ll be right back.')
RegisterEmote('bye', '%s waves goodbye to everyone. Farewell!', '%s waves goodbye to %s. Farewell!')

RegisterEmote('cackle', '%s cackles maniacally at the situation.', '%s cackles maniacally at %s.')
RegisterEmote('calm', '%s remains calm.', '%s tries to calm %s down.')
RegisterEmote('cat', '%s scratches himself. Ah, much better!', '%s scratches %s. How catty!')
RegisterEmote('charge', '%s starts to charge.')
RegisterEmote('cheer', '%s cheers.', '%s cheers at %s.')
RegisterEmote('chew', '%s begins to eat.', '%s begins to eat in front of %s.')
RegisterEmote('chicken', 'With arms flapping, %s struts around. Cluck, Cluck, Chicken!', 'With arms flapping, %s struts around %s. Cluck, Cluck, Chicken!')
RegisterEmote('chuckle', '%s lets out a hearty chuckle.', '%s chuckles at %s.')
RegisterEmote('clap', '%s claps excitedly.', '%s claps excitedly for %s.')
RegisterEmote('cold', '%s lets everyone know that he is cold.', '%s lets %s know that he is cold.')
RegisterEmote('comfort', '%s needs to be comforted.', '%s comforts %s.')
RegisterEmote('commend', '%s commends everyone on a job well done.', '%s commends %s on a job well done.')
RegisterEmote('confused', '%s is hopelessly confused.', '%s looks at %s with a confused look.')
RegisterEmote('congrats', '%s congratulates everyone around himself.', '%s congratulates %s.')
RegisterEmote('cough', '%s lets out a hacking cough.', '%s coughs at %s.')
RegisterEmote('cower', '%s cowers in fear.', '%s cowers in fear at the sight of %s.')
RegisterEmote('crack', '%s cracks his knuckles.', '%s cracks his knuckles while staring at %s.')
RegisterEmote('cringe', '%s cringes in fear.', '%s cringes away from %s.')
RegisterEmote('cry', '%s cries.', '%s cries on %s\'s shoulder.')
RegisterEmote('cuddle', '%s needs to be cuddled.', '%s cuddles up against %s.')
RegisterEmote('curious', '%s expresses his curiosity to those around himself.', '%s is curious what %s is up to.')

RegisterEmote('dance', '%s bursts into dance.', '%s dances with %s.')
RegisterEmote('disappointed', '%s frowns.', '%s frowns with disappointment at %s.')
RegisterEmote('doom', '%s threatens everyone with the wrath of doom.', '%s threatens %s with the wrath of doom.')
RegisterEmote('drink', '%s raises a drink in the air before chugging it down. Cheers!', '%s raises a drink to %s. Cheers!')
RegisterEmote('duck', '%s ducks for cover.', '%s ducks behind %s.')

RegisterEmote('facepalm', '%s covers his face with his palm.', '%s looks over at %s and covers his face with his palm.')

RegisterEmote('helpme', '%s cries out for help!')
RegisterEmote('hi', '%s greets everyone with a hearty hello!', '%s greets %s with a hearty hello!')

RegisterEmote('jk', '%s was just kidding!', '%s lets %s know that he was just kidding!')

RegisterEmote('laugh', '%s laughs.', '%s laughs at %s.')
