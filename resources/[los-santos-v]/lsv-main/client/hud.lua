local _discordUrl = nil

local _cashGained = 0
local _expGained = 0

local _gainedTimer = Timer.New()

local _killstreak = 0
local _lastKillTimer = Timer.New()
local _lastKillDetails = nil

local _lastEventTime = nil

local _factionColors = {
	[Settings.faction.Neutral] = '~w~',
	[Settings.faction.Enforcer] = '~d~',
	[Settings.faction.Criminal] = '~r~',
}

RegisterNetEvent('lsv:setupHud')
AddEventHandler('lsv:setupHud', function(hud)
	if hud.pauseMenuTitle ~= '' then
		AddTextEntry('FE_THDR_GTAO', hud.pauseMenuTitle)
	end

	if hud.discordUrl ~= '' then
		_discordUrl = hud.discordUrl

		if Player.PatreonTier ~= 0 then return end

		while true do
			Citizen.Wait(Settings.discordNotificationInterval)
			PlaySoundFrontend(-1, 'EVENT_START_TEXT', 'GTAO_FM_EVENTS_SOUNDSET', true)
			FlashMinimapDisplay()
			Gui.DisplayPersonalNotification('Join our Discord to read about latest changes and stay together with community.', 'CHAR_MP_STRIPCLUB_PR', 'VIP Invitation', _discordUrl, 2)

			Citizen.Wait(Settings.discordNotificationInterval)
			PlaySoundFrontend(-1, 'EVENT_START_TEXT', 'GTAO_FM_EVENTS_SOUNDSET', true)
			FlashMinimapDisplay()
			Gui.DisplayPersonalNotification('Earn more rewards and get exclusive in-game bonuses.\nRead more details in our Discord.', 'CHAR_MP_STRIPCLUB_PR', 'Become My Patron', _discordUrl, 2)
		end
	end
end)

RegisterNetEvent('lsv:updateLastEventTime')
AddEventHandler('lsv:updateLastEventTime', function(time)
	_lastEventTime = time
end)

RegisterNetEvent('lsv:patreonDailyRewarded')
AddEventHandler('lsv:patreonDailyRewarded', function()
	Gui.DisplayPersonalNotification('Please accept this small gift as a token of my appreciation.', 'CHAR_MP_STRIPCLUB_PR', 'Welcome back', '', 2)
end)

RegisterNetEvent('lsv:playerDisconnected')
AddEventHandler('lsv:playerDisconnected', function(name, player, reason)
	Gui.DisplayNotification('<C>'..name..'</C> left ~m~('..reason..')')
end)

RegisterNetEvent('lsv:playerConnected')
AddEventHandler('lsv:playerConnected', function(player)
	local playerId = GetPlayerFromServerId(player)
	if PlayerId() ~= playerId and NetworkIsPlayerActive(playerId) then
		Gui.DisplayNotification(Gui.GetPlayerName(player)..' connected.')
		Map.SetBlipFlashes(GetBlipFromEntity(GetPlayerPed(playerId)))
	end
end)

RegisterNetEvent('lsv:onPlayerDied')
AddEventHandler('lsv:onPlayerDied', function(player, suicide)
	if NetworkIsPlayerActive(GetPlayerFromServerId(player)) then
		if suicide then
			Gui.DisplayNotification(Gui.GetPlayerName(player)..' committed suicide.')
		else
			Gui.DisplayNotification(Gui.GetPlayerName(player)..' died.')
		end
	end

	if player ~= Player.ServerId() then
		return
	end

	Player.Deaths = Player.Deaths + 1
	Player.Deathstreak = Player.Deathstreak + 1
	Player.Killstreak = 0
	_killstreak = 0
end)

RegisterNetEvent('lsv:onPlayerKilled')
AddEventHandler('lsv:onPlayerKilled', function(player, killer, message, isFriendlyFactionKill)
	if NetworkIsPlayerActive(GetPlayerFromServerId(player)) and NetworkIsPlayerActive(GetPlayerFromServerId(killer)) then
		Gui.DisplayNotification(Gui.GetPlayerName(killer)..' '..message..' '..Gui.GetPlayerName(player, nil, true))
	end

	if player == Player.ServerId() then
		Player.Deaths = Player.Deaths + 1
		Player.Deathstreak = Player.Deathstreak + 1
		Player.Killstreak = 0
		_killstreak = 0
		return
	elseif killer ~= Player.ServerId() then
		return
	end

	if isFriendlyFactionKill then
		_lastKillDetails = 'FRIENDLY FACTION KILL'
		_gainedTimer:restart()
		return
	end

	Player.Deathstreak = 0

	Player.Kills = Player.Kills + 1
	Player.Killstreak = Player.Killstreak + 1

	if Player.Killstreak == Settings.bounty.killstreak then
		FlashMinimapDisplay()
		Gui.DisplayPersonalNotification('Watch out, someone has put a Bounty on you.', 'CHAR_LESTER_DEATHWISH', 'Unknown', '', 2)
	end

	if _lastKillTimer:elapsed() > Settings.killstreakTimeout then
		_killstreak = 1
		_lastKillTimer:restart()
		return
	end

	_killstreak = _killstreak + 1
	_lastKillTimer:restart()

	if _killstreak < 2 or not Player.IsInFreeroam() then
		return
	end

	local killstreakMessage = 'DOUBLE KILL'
	if _killstreak == 3 then killstreakMessage = 'TRIPLE KILL'
	elseif _killstreak == 4 then killstreakMessage = 'MEGA KILL'
	elseif _killstreak == 5 then killstreakMessage = 'ULTRA KILL'
	elseif _killstreak == 6 then killstreakMessage = 'MONSTER KILL'
	elseif _killstreak == 7 then killstreakMessage = 'LUDICROUS KILL'
	elseif _killstreak == 8 then killstreakMessage = 'HOLY SHIT'
	elseif _killstreak == 9 then killstreakMessage = 'RAMPAGE'
	elseif _killstreak > 9 then killstreakMessage = 'GODLIKE' end

	local scaleform = Scaleform.NewAsync('MIDSIZED_MESSAGE')
	scaleform:call('SHOW_SHARD_MIDSIZED_MESSAGE', killstreakMessage)
	scaleform:renderFullscreenTimed(5000)
end)

RegisterNetEvent('lsv:bountyWasSet')
AddEventHandler('lsv:bountyWasSet', function(player)
	if player ~= Player.ServerId() and NetworkIsPlayerActive(player) then
		FlashMinimapDisplay()
		Gui.DisplayNotification('A Bounty has been set on '..Gui.GetPlayerName(player)..'.')
	end
end)

RegisterNetEvent('lsv:playerJoinedFaction')
AddEventHandler('lsv:playerJoinedFaction', function(player, faction)
	if faction ~= Settings.faction.Neutral and player ~= Player.ServerId() then
		Gui.DisplayNotification(Gui.GetPlayerName(player)..' has become '..Settings.factionNames[faction]..'.')
	end
end)

Citizen.CreateThread(function()
	local eventTimer = Timer.New()

	while true do
		Citizen.Wait(500)

		if _lastEventTime then
			_lastEventTime = _lastEventTime + eventTimer:elapsed()
		end

		eventTimer:restart()
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		RemoveMultiplayerBankCash()
		RemoveMultiplayerHudCash()

		if IsControlPressed(0, 20) then
			Scoreboard.DisplayThisFrame()
		elseif IsPlayerDead(PlayerId()) and DeathTimer then
			if IsControlJustReleased(0, 24) then
				DeathTimer = DeathTimer - Settings.spawn.respawnFasterPerControlPressed
				PlaySoundFrontend(-1, DeathTimer > 0 and 'Faster_Click' or 'Faster_Bar_Full', 'RESPAWN_ONLINE_SOUNDSET', true)
			end

			Gui.DrawProgressBar('RESPAWNING', GetTimeDifference(GetGameTimer(), DeathTimer) / TimeToRespawn, 0, Color.RED)
		else
			if HasHudScaleformLoaded(19) then
				BeginScaleformMovieMethodHudComponent(19, 'OVERRIDE_ANIMATION_SPEED')
				PushScaleformMovieFunctionParameterInt(2000)
				EndScaleformMovieMethodReturn()

				BeginScaleformMovieMethodHudComponent(19, 'SET_COLOUR')
				PushScaleformMovieFunctionParameterInt(116)
				EndScaleformMovieMethodReturn()
			end
		end
	end
end)

AddEventHandler('lsv:init', function(playerData)
	local serverRestartTimer = Timer.New(playerData.ServerRestartIn * 1000)

	while true do
		Citizen.Wait(0)
		local serverRestartIn = math.abs(serverRestartTimer:elapsed())

		if serverRestartIn <= Settings.serverRestart.warnBeforeMs then
			Gui.DrawTimerBar('SERVER RESTART IN', serverRestartIn, 16)
		end
	end
end)

AddEventHandler('lsv:init', function()
	local cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', GetGameplayCamCoord(), 0., 0., 0., GetGameplayCamFov())
	local activated = false
	local wasTipDisplayed = false
	local relZ = nil

	while true do
		Citizen.Wait(0)

		local veh = GetVehiclePedIsIn(PlayerPedId())
		if veh ~= 0 then
			if not wasTipDisplayed then
				Gui.DisplayHelpText('Press ~'..Settings.gta2Cam.key.name..'~ to toggle GTA2 camera.')
				wasTipDisplayed = true
			end

			if IsControlJustReleased(0, Settings.gta2Cam.key.code) then
				activated = not activated
			end
		else
			activated = false
		end

		if activated then
			if not IsCamActive(cam) then
				SetCamActive(cam, true)
				RenderScriptCams(true, true, 1000, true, false)
				relZ = Settings.gta2Cam.min
			end

			local speed = GetEntitySpeed(veh) * 3.6 -- kmh
			if speed > Settings.gta2Cam.minSpeed then
				if relZ < Settings.gta2Cam.max then
					relZ = relZ + Settings.gta2Cam.step
				end
			elseif relZ > Settings.gta2Cam.min then
				relZ = relZ - Settings.gta2Cam.step
			end

			local pos = Player.Position()
			SetCamCoord(cam, pos.x, pos.y, pos.z + relZ)
			PointCamAtCoord(cam, pos.x, pos.y, pos.z + 0.5)
		else
			if IsCamActive(cam) then
				SetCamActive(cam, false)
				RenderScriptCams(false, false, 0)
				relZ = nil
			end
		end
	end
end)

AddEventHandler('lsv:init', function()
	if Settings.enableVoiceChat then
		return
	end

	while true do
		Citizen.Wait(0)
		DisableControlAction(0, 249, true)
	end
end)

AddEventHandler('lsv:init', function()
	while true do
		Citizen.Wait(0)

		if _lastEventTime then
			if Player.IsInFreeroam() then
				local timePassed = Settings.event.interval - _lastEventTime
				if timePassed > 0 then
					Gui.DrawTimerBar('NEXT EVENT IN', timePassed, 1)
				end
			end
		end
	end
end)

AddEventHandler('lsv:cashUpdated', function(cash, killDetails)
	_lastKillDetails = nil

	if cash > 0 then
		_cashGained = _cashGained + cash
	else
		_cashGained = cash
	end

	if killDetails and #killDetails ~= 0 then
		_lastKillDetails = table.concat(killDetails, '\n')
	end

	_gainedTimer:restart()
end)

AddEventHandler('lsv:experienceUpdated', function(exp)
	_expGained = _expGained + exp

	_gainedTimer:restart()
end)

AddEventHandler('lsv:showExperience', function(exp)
	local rank = Player.Rank
	local playerExp = Player.Experience

	RequestHudScaleform(19)
	while not HasHudScaleformLoaded(19) do
		Citizen.Wait(0)
	end

	BeginScaleformMovieMethodHudComponent(19, 'SET_RANK_SCORES')
	PushScaleformMovieFunctionParameterInt(Rank.GetRequiredExperience(rank))
	PushScaleformMovieFunctionParameterInt(Rank.GetRequiredExperience(rank + 1))
	PushScaleformMovieFunctionParameterInt(playerExp - exp)
	PushScaleformMovieFunctionParameterInt(playerExp)
	PushScaleformMovieFunctionParameterInt(rank)
	EndScaleformMovieMethodReturn()
end)

AddEventHandler('lsv:rankUp', function(rank)
	PlaySoundFrontend(-1, 'MP_RANK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false)

	local scaleform = Scaleform.NewAsync('MIDSIZED_MESSAGE')
	scaleform:call('SHOW_SHARD_MIDSIZED_MESSAGE', 'RANK UP', 'Rank '..rank, 21)
	scaleform:renderFullscreenTimed(10000)
end)

AddEventHandler('lsv:init', function()
	_gainedTimer:restart()
	_lastKillTimer:restart()

	while true do
		Citizen.Wait(0)

		if _cashGained ~= 0 or _expGained ~= 0 or _lastKillDetails then
			if Player.IsActive() and _gainedTimer:elapsed() < Settings.rewardNotificationTime then
				if _cashGained ~= 0 then
					local cash = tostring(_cashGained)
					if _cashGained > 0 then
						cash = '+'..cash
					end

					Gui.SetTextParams(0, Color.GREEN, 0.5, true, true)
					Gui.DrawText(cash, { x = 0.525, y = 0.445 })
				end

				if _expGained ~= 0 then
					local exp = tostring(_expGained)
					if _expGained > 0 then
						exp = '+'..exp
					end

					Gui.SetTextParams(0, Color.BLUE, 0.5, true, true)
					Gui.DrawText(exp, { x = 0.525, y = 0.475 })
				end

				if _lastKillDetails then
					Gui.SetTextParams(0, Color.WHITE, 0.25, true, true)
					Gui.DrawText(_lastKillDetails, { x = 0.585, y = 0.45 })
				end
			else
				_cashGained = 0
				_expGained = 0
				_lastKillDetails = nil
			end
		end
	end
end)

AddEventHandler('lsv:init', function()
	--https://pastebin.com/amtjjcHb
	local tips = {
		'Your Armour will slowly regenerate after a few seconds since last damage.',
		'Performing Missions and taking out enemy players will give you cash and experience.',
		'Get extra reward for killing players who are doing a Mission.',
		'Challenges allows you to compete with other players to prove your skills.',
		'Press ~INPUT_INTERACTION_MENU~ to open Interaction menu.',
		'Join any Faction to get extra reward for killing opposite faction players.',
		'Visit ~BLIP_GUN_SHOP~ to purchase Special Weapons ammunition.',
		'Press ~INPUT_MP_TEXT_CHAT_TEAM~ to open Personal Vehicle menu.',
		'Press ~INPUT_ENTER_CHEAT_CODE~ to enlarge the Radar.',
		'Press ~INPUT_DUCK~ to enter stealth mode and hide from the Radar.',
		'Visit ~BLIP_CLOTHES_STORE~ to change your character appearance.',
		'Use Interaction Menu to manage your Crew.',
		'Use Report Player option from Interaction menu to improve your overall game experience.',
		'Use Prestige option from Interaction menu to reset your progress and get Prestige badge.',
	}

	table.iforeach(tips, function(tip)
		HelpQueue.PushBack(tip)
	end)
end)

AddEventHandler('lsv:init', function()
	while true do
		Citizen.Wait(0)

		if Player.PatreonTier == 0 and _discordUrl then
			Gui.SetTextParams(4, { r = 255, g = 255, b = 255, a = 255 }, 0.45, true)
			Gui.DrawText(_discordUrl, { x = SafeZone.Left() + 0.785, y = SafeZone.Top() }, 1.0)
		end

		Gui.SetTextParams(4, Color.WHITE, 0.3, true, true, false)
		Gui.DrawText('~b~EXP~w~ '..Player.Experience..' / '..Rank.GetRequiredExperience(Player.Rank + 1)..'	~g~$~w~ '..Player.Cash..'	'.._factionColors[Player.Faction]..Settings.factionNames[Player.Faction],
			{ x = SafeZone.Left(), y = SafeZone.Bottom() - 0.004 })
	end
end)

AddEventHandler('lsv:init', function()
	local scaleform = Scaleform.NewAsync('MP_BIG_MESSAGE_FREEMODE')
	local instructionalButtonsScaleform = Scaleform.NewAsync('INSTRUCTIONAL_BUTTONS')

	RequestScriptAudioBank('MP_WASTED', 0)

	while true do
		Citizen.Wait(0)

		instructionalButtonsScaleform:call('CLEAR_ALL')

		if IsPlayerDead(PlayerId()) then
			StartScreenEffect('DeathFailOut', 0, true)
			ShakeGameplayCam('DEATH_FAIL_IN_EFFECT_SHAKE', 1.0)
			PlaySoundFrontend(-1, 'MP_Flash', 'WastedSounds', 1)

			local deathDetails = ''
			local killer, weaponHash = NetworkGetEntityKillerOfPlayer(PlayerId())
			if killer > 0 and killer ~= PlayerPedId() then
				deathDetails = string.format('Distance: %d m', math.floor(Player.DistanceTo(GetEntityCoords(killer))))
				if weaponHash and weaponHash ~= 0 then
					local weaponName = WeaponUtility.GetNameByHash(weaponHash)
					if weaponName then
						local tint = GetPedWeaponTintIndex(killer, weaponHash)
						local tintName = Settings.weaponTintNames[tint]
						if tintName then
							weaponName = weaponName..' ('..tintName..')'
						end
						deathDetails = 'Killed with '..weaponName..'\n'..deathDetails
					end
				end
			end

			scaleform:call('SHOW_SHARD_WASTED_MP_MESSAGE', '~r~WASTED', deathDetails)

			instructionalButtonsScaleform:call('SET_DATA_SLOT', 0, '~INPUT_ATTACK~', 'Respawn Faster')
			instructionalButtonsScaleform:call('DRAW_INSTRUCTIONAL_BUTTONS')

			while IsPlayerDead(PlayerId()) do
				scaleform:renderFullscreen()
				instructionalButtonsScaleform:renderFullscreen()
				Citizen.Wait(0)
			end

			StopScreenEffect('DeathFailOut')
			StopGameplayCamShaking(true)
		elseif Player.IsActive() and not WarMenu.IsAnyMenuOpened() then
			instructionalButtonsScaleform:call('SET_DATA_SLOT', 0, '~INPUT_MP_TEXT_CHAT_TEAM~', 'Personal Vehicle Menu')
			instructionalButtonsScaleform:call('SET_DATA_SLOT', 1, '~INPUT_INTERACTION_MENU~', 'Interaction Menu')
			instructionalButtonsScaleform:call('DRAW_INSTRUCTIONAL_BUTTONS')
			instructionalButtonsScaleform:renderFullscreen()
		end
	end
end)

AddEventHandler('lsv:init', function()
	local isBigMapEnabled = false

	while true do
		if IsControlJustReleased(0, 243) then
			isBigMapEnabled = not isBigMapEnabled
			Citizen.InvokeNative(0x231C8F89D0539D8F, isBigMapEnabled, false)
		end

		Citizen.Wait(0)
	end
end)
