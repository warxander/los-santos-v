local _discordUrl = nil

local _killstreak = 0
local _lastKillTimer = Timer.New()

local _killDetailsTimer = Timer.New()
local _killDetailsScale = Animated.New(0.30, 250, 0.55)
local _killDetailsAlpha = Animated.New(255, 250)
local _lastKillDetails = nil

local _lastEventTime = nil

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
	if not Player.Settings.disableKillFeed and NetworkIsPlayerActive(GetPlayerFromServerId(player)) then
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
AddEventHandler('lsv:onPlayerKilled', function(player, killer, message, killstreak)
	if not Player.Settings.disableKillFeed and NetworkIsPlayerActive(GetPlayerFromServerId(player)) and NetworkIsPlayerActive(GetPlayerFromServerId(killer)) then
		local notificationMessage = Gui.GetPlayerName(killer)..' '..message..' '..Gui.GetPlayerName(player, nil, true)
		if killstreak then
			notificationMessage = notificationMessage..' (Killstreak '..killstreak..')'
		end
		Gui.DisplayNotification(notificationMessage)
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

RegisterNetEvent('lsv:tebexPackagePurchased')
AddEventHandler('lsv:tebexPackagePurchased', function()
	FlashMinimapDisplay()
	PlaySoundFrontend(-1, 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET', true)
	Gui.DisplayNotification('Thank You For Your Purchase!', 'CHAR_SOCIAL_CLUB', 'Los Santos V', 'Tebex Webstore', 4)
end)

RegisterNetEvent('lsv:oneSyncEnabled')
AddEventHandler('lsv:oneSyncEnabled', function()
	while true do
		Citizen.Wait(0)

		Gui.SetTextParams(0, { r = Color.WHITE.r, g = Color.WHITE.g, b = Color.WHITE.b, a = 16 }, 0.45, false, false, true)
		Gui.DrawText('ONESYNC ENABLED', { x = 0.5, y = SafeZone.Top() })
	end
end)

RegisterNetEvent('lsv:updateLastKillDetails')
AddEventHandler('lsv:updateLastKillDetails', function(killDetails)
	_lastKillDetails = nil

	if killDetails then
		if table.length(killDetails) == 0 then
			_lastKillDetails = 'PLAYER KILL'
		else
			_lastKillDetails = { }

			if killDetails.killstreak then
				table.insert(_lastKillDetails, 'KILLSTREAK x'..killDetails.killstreak)
			end

			if killDetails.headshot then
				table.insert(_lastKillDetails, 'HEADSHOT')
			end

			if killDetails.meleeKill then
				table.insert(_lastKillDetails, 'MELEE KILL')
			end

			if killDetails.brokenDeal then
				table.insert(_lastKillDetails, 'BROKEN DEAL')
			end

			if killDetails.bountyHunter then
				table.insert(_lastKillDetails, 'BOUNTY HUNTER')
			end

			if killDetails.kingSlayer then
				table.insert(_lastKillDetails, 'KINGSLAYER')
			end

			if killDetails.revenge then
				table.insert(_lastKillDetails, 'REVENGE')
			end

			if killDetails.patreonBonus then
				table.insert(_lastKillDetails, 'PATREON BONUS x'..killDetails.patreonBonus)
			end

			_lastKillDetails = table.concat(_lastKillDetails, '\n')
		end

		_killDetailsTimer:restart()
		_killDetailsAlpha:restart()
		_killDetailsScale:restart()
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
	end
end)

AddEventHandler('lsv:init', function()
	while true do
		Citizen.Wait(0)

		if Player.Settings.disableCrosshair then
			HideHudComponentThisFrame(14)
		end

		if not WarMenu.IsAnyMenuOpened() and IsControlPressed(0, 20) then
			Scoreboard.DisplayThisFrame()
		elseif IsPlayerDead(PlayerId()) and DeathTimer then
			if IsControlJustReleased(0, 24) then
				DeathTimer = DeathTimer - Settings.spawn.respawnFasterPerControlPressed
				PlaySoundFrontend(-1, DeathTimer > 0 and 'Faster_Click' or 'Faster_Bar_Full', 'RESPAWN_ONLINE_SOUNDSET', true)
			end

			Gui.DrawProgressBar('RESPAWNING', GetTimeDifference(GetGameTimer(), DeathTimer) / TimeToRespawn, 2, Color.RED)
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
			Gui.DrawTimerBar('SERVER RESTART IN', serverRestartIn, 17)
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

		if not Player.Settings.disableEventTimer and _lastEventTime then
			if Player.IsInFreeroam() then
				local timePassed = Settings.event.interval - _lastEventTime
				if timePassed > 0 and timePassed <= 120000 then
					Gui.DrawTimerBar('NEXT EVENT IN', timePassed, 1)
				end
			end
		end
	end
end)

AddEventHandler('lsv:cashUpdated', function(cash)
	local backgroundColor = nil
	if cash < 0 then
		backgroundColor = 6
	end

	Gui.DisplayPersonalNotification('<C> $'..math.abs(cash)..'</C>', nil, nil, nil, nil, backgroundColor)
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
	while true do
		Citizen.Wait(0)

		if _lastKillDetails then
			if Player.IsActive() and _killDetailsTimer:elapsed() < Settings.rewardNotificationTime then
				Gui.SetTextParams(0, { r = Color.WHITE.r, g = Color.WHITE.g, b = Color.WHITE.b, a = _killDetailsAlpha:get() }, _killDetailsScale:get(), true, true, true)
				Gui.DrawText(_lastKillDetails, { x = 0.5, y = 0.60 })
			else
				_lastKillDetails = nil
			end
		end
	end
end)

AddEventHandler('lsv:init', function()
	if Player.Settings.disableTips then
		return
	end

	--https://pastebin.com/amtjjcHb
	local tips = {
		'Your Armour will slowly regenerate after a few seconds since last damage.',
		'Performing Missions and taking out enemy players will give you cash and experience.',
		'Visit ~BLIP_GUN_SHOP~ to purchase Special Weapons ammunition.',
		'Press ~INPUT_ENTER_CHEAT_CODE~ to enlarge the Radar.',
		'Press ~INPUT_DUCK~ to enter stealth mode and hide from the Radar.',
		'Visit ~BLIP_CLOTHES_STORE~ to change your character appearance.',
		'Use Interaction Menu to manage Crew.',
	}

	table.iforeach(tips, function(tip)
		HelpQueue.PushBack(tip)
	end)
end)

AddEventHandler('lsv:init', function()
	while true do
		Citizen.Wait(0)

		if Player.PatreonTier == 0 and _discordUrl and not Player.Settings.disableTips then
			Gui.SetTextParams(4, Color.WHITE, 0.45, true)
			Gui.DrawText(_discordUrl, { x = SafeZone.Left() + 0.85, y = SafeZone.Top() }, 1.0)

			Gui.SetTextParams(4, Color.WHITE, 0.45, true)
			Gui.DrawText('~c~Use ~w~/help~c~ command to learn more', { x = SafeZone.Left() + 0.85, y = SafeZone.Top() + 0.025 }, 1.0)
		end

		local statusText = '~b~EXP~w~ '..math.floor(Player.Experience)..' / '..math.floor(Rank.GetRequiredExperience(Player.Rank + 1))..'	~g~$~w~ '..math.floor(Player.Cash)

		local playerPed = PlayerPedId()
		if IsPedInAnyVehicle(playerPed, true) then
			statusText = statusText..'	'..string.to_speed(GetEntitySpeed(GetVehiclePedIsUsing(playerPed)))
		end

		Gui.SetTextParams(4, Color.WHITE, 0.3, true, true, false)
		Gui.DrawText(statusText, { x = SafeZone.Left(), y = SafeZone.Bottom() - 0.004 })
	end
end)

AddEventHandler('lsv:init', function()
	local scaleform = Scaleform.NewAsync('INSTRUCTIONAL_BUTTONS')
	local needToResetScaleform = true

	while true do
		Citizen.Wait(0)

		if not Player.Settings.disableTips then
			if Player.IsActive() and not WarMenu.IsAnyMenuOpened() then
				if needToResetScaleform then
					scaleform:call('CLEAR_ALL')
					scaleform:call('SET_DATA_SLOT', 0, '~INPUT_REPLAY_STARTPOINT~', Player.Moderator and 'Moderator Menu' or 'Report Player')
					scaleform:call('SET_DATA_SLOT', 1, '~INPUT_MP_TEXT_CHAT_TEAM~', 'Personal Vehicle Menu')
					scaleform:call('SET_DATA_SLOT', 2, '~INPUT_INTERACTION_MENU~', 'Interaction Menu')
					scaleform:call('DRAW_INSTRUCTIONAL_BUTTONS')
					needToResetScaleform = false
				end

				scaleform:renderFullscreen()
			elseif not needToResetScaleform then
				needToResetScaleform = true
			end
		end
	end
end)

AddEventHandler('lsv:init', function()
	local isBigMapEnabled = false
	local showFullMap = false

	while true do
		Citizen.Wait(0)

		if IsControlJustReleased(0, 243) then -- `
			if isBigMapEnabled then
				showFullMap = not showFullMap
				if not showFullMap then
					isBigMapEnabled = false
				end
			else
				isBigMapEnabled = true
			end

			SetBigmapActive(isBigMapEnabled, showFullMap)
		end
	end
end)
