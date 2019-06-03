local logger = Logger:CreateNamedLogger('Session')

local function initPlayer(player, playerStats, isRegistered)
	if not playerStats.Weapons then playerStats.Weapons = Settings.defaultPlayerWeapons
	else playerStats.Weapons = json.decode(playerStats.Weapons) end

	if playerStats.Vehicle then playerStats.Vehicle = json.decode(playerStats.Vehicle) end

	playerStats.Rank = Settings.calculateRank(playerStats.Experience)
	playerStats.SkillStat = Settings.calculateSkillStat(playerStats.Rank)

	if not playerStats.PatreonTier then playerStats.PatreonTier = 0 end

	Scoreboard.AddPlayer(player, playerStats)

	TriggerClientEvent('lsv:playerLoaded', player, playerStats, isRegistered)
	TriggerClientEvent('lsv:playerConnected', -1, player)

	TriggerEvent('lsv:playerConnected', player)
end


AddEventHandler('playerConnecting', function(playerName, setKickReason)
	if string.len(playerName) > Settings.maxPlayerNameLength then
		setKickReason('Your name is too long (limit of '..Settings.maxPlayerNameLength..' characters)')
		CancelEvent()
		return
	end
end)


AddEventHandler('playerDropped', function(reason)
	local player = source
	local playerName = GetPlayerName(player)

	logger:Info('Dropped { '..playerName..', '..player..', '..reason..' }')

	Scoreboard.RemovePlayer(player)

	TriggerClientEvent('lsv:playerDisconnected', -1, playerName, player, reason)

	TriggerEvent('lsv:playerDropped', player)
end)


RegisterNetEvent('lsv:loadPlayer')
AddEventHandler('lsv:loadPlayer', function()
	local player = source
	local playerName = GetPlayerName(player)

	Db.FindPlayer(player, function(data)
		if #data == 0 then
			Db.RegisterPlayer(player, function(data)
				initPlayer(player, data[1], true)
				logger:Info('Register { '..playerName..', '..player..' }')
			end)
		else
			if data[1].Banned then
				if data[1].BanExpiresDate then
					if os.time() <= data[1].BanExpiresDate then
						DropPlayer(player, 'You\'re temporarily banned from this server.\nBan expires in '..os.date('%Y-%m-%d %X '..Settings.serverTimeZone, data[1].BanExpiresDate))
						return
					else
						Db.UnbanPlayer(player)
					end
				else
					DropPlayer(player, 'You\'re permanently banned from this server.')
					return
				end
			end

			initPlayer(player, data[1], false)
			logger:Info('Loaded { '..playerName..', '..player..' }')
		end
	end)
end)


RegisterNetEvent('lsv:savePlayerWeapons')
AddEventHandler('lsv:savePlayerWeapons', function(weapons)
	local player = source

	if #weapons == 0 then return end

	local prohibitedWeapon = table.ifind_if(weapons, function(weapon) return weapon.id == 'WEAPON_RAILGUN' or weapon.id == 'WEAPON_BULLPUPRIFLE' or weapon.id == 'WEAPON_GUSENBERG' end)

	if prohibitedWeapon then
		DropPlayer(player, 'You have received a prohibited weapon due to hacker activity.\nYour progress is saved, but you need to manually reconnect to the server.')
		return
	end

	Db.SetValue(player, 'Weapons', Db.ToString(json.encode(weapons)))
end)


RegisterNetEvent('lsv:kickAFKPlayer')
AddEventHandler('lsv:kickAFKPlayer', function()
	local player = source

	logger:Info('Drop AFK player { '..player..' }')

	DropPlayer(player, 'You were AFK for more than '..math.ceil(Settings.afkTimeout / 60)..' minutes.')
end)