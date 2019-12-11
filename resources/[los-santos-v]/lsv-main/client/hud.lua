local discordUrl = nil

local cashGained = 0
local cashGainedTime = nil
local cashGainedEffects = { }

local killstreak = 0
local playerStreakScaleform = nil
local lastKillTime = nil

local eventFinishedTime = nil


AddEventHandler('lsv:init', function()
	if Settings.enableVoiceChat then return end

	while true do
		Citizen.Wait(0)
		DisableControlAction(0, 249, true)
	end
end)


RegisterNetEvent('lsv:eventFinishedTimeUpdated')
AddEventHandler('lsv:eventFinishedTimeUpdated', function(time)
	eventFinishedTime = time
end)


AddEventHandler('lsv:init', function()
	while true do
		Citizen.Wait(0)

		if eventFinishedTime then
			if Player.IsInFreeroam() then
				local timePassed = Settings.event.timeout - eventFinishedTime
				if timePassed > 0 then
					Gui.DrawTimerBar('NEXT EVENT IN', timePassed, 1)
				end
			end
		end
	end
end)


Citizen.CreateThread(function()
	local timePassed = Timer.New()

	while true do
		Citizen.Wait(500)

		if eventFinishedTime then
			eventFinishedTime = eventFinishedTime + timePassed:Elapsed()
		end

		timePassed:Restart()
	end
end)


-- Thanks Sheo for this stuff example
AddEventHandler('lsv:init', function()
	RequestStreamedTextureDict('MPHud')
	local w = 18.0
	local h = 18.0

	while true do
		Citizen.Wait(0)

		local sw, sh = GetScreenResolution()

		table.foreach(cashGainedEffects, function(cashEffect)
			local sY = cashEffect.fade

			SetDrawOrigin(cashEffect.x, cashEffect.y, cashEffect.z, 0)
			SetTextFont(4)
			SetTextColour(255, 255, 255, 255)
			SetTextScale(0.45, 0.45)
			SetTextDropShadow(2, 2, 0, 0, 0)
			SetTextOutline()
			SetTextEntry('STRING')
			AddTextComponentString(cashEffect.cash)
			DrawText(8 / sw, (-10.0 - sY) / sh)
			DrawSprite('MPHud', 'mp_anim_cash', 0.0, -sY / sh, w / sw, h / sh, 0.0, 255, 255, 255, 255)
			ClearDrawOrigin()

			if cashEffect.fadeAfter <= 0 then cashEffect.fade = cashEffect.fade * 1.15 end
			cashEffect.ticks = cashEffect.ticks - 1
			cashEffect.fadeAfter = cashEffect.fadeAfter - 1
		end)

		cashGainedEffects = table.filter(cashGainedEffects, function(effect) return effect.ticks > 0 end)
	end
end)


AddEventHandler('lsv:cashUpdated', function(cash, victim)
	if victim then
		local victimPosition = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(victim)))
		table.insert(cashGainedEffects, {
			x = victimPosition.x,
			y = victimPosition.y,
			z = victimPosition.z + 0.25,
			cash = tostring(cash),
			fade = 1.0,
			fadeAfter = 25,
			ticks = 60,
		})
		return
	end
	cashGained = cashGained + cash
	if cashGainedTime then cashGainedTime:Restart() end
end)


AddEventHandler('lsv:showExperience', function(exp)
	local rank = Player.Rank
	local playerExp = Player.Experience

	while not HasHudScaleformLoaded(19) do
		RequestHudScaleform(19)
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


AddEventHandler('lsv:rankUp', function()
	local scaleform = Scaleform:Request('MIDSIZED_MESSAGE')
	PlaySoundFrontend(-1, 'MP_RANK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false)
	scaleform:Call('SHOW_SHARD_MIDSIZED_MESSAGE', 'RANK UP', 'Rank '..Player.Rank, 21)
	scaleform:RenderFullscreenTimed(10000)
	scaleform:Delete()
end)


AddEventHandler('lsv:init', function()
	cashGainedTime = Timer.New()
	lastKillTime = Timer.New()

	Streaming.RequestStreamedTextureDict('MPHud')

	local screenWidth, screenHeight = GetScreenResolution()
	local spriteScale = 18.0
	local textScale = 0.5

	while true do
		Citizen.Wait(0)

		if cashGained ~= 0 then
			if IsPlayerDead(PlayerId()) then cashGainedTime:Restart()
			elseif cashGainedTime:Elapsed() < Settings.cashGainedNotificationTime then
				local playerPosition = Player.Position()
				local z = playerPosition.z + 1.0

				local cash = tostring(cashGained)
				if cashGained > 0 then cash = '+'..cash end

				SetDrawOrigin(playerPosition.x, playerPosition.y, z, 0)
				DrawSprite('MPHud', 'mp_anim_cash', 0.0, 0.0, spriteScale / screenWidth, spriteScale / screenHeight, 0.0, 255, 255, 255, 255)
				Gui.SetTextParams(4, Color.GetHudFromBlipColor(Color.BLIP_WHITE), textScale, true, true)
				Gui.DrawText(cash, { x = spriteScale / 2 / screenWidth, y = -spriteScale / 2 / screenHeight - 0.004 })
				ClearDrawOrigin()
			else
				cashGained = 0
			end
		end
	end
end)


AddEventHandler('lsv:init', function()
	--https://pastebin.com/amtjjcHb
	local tips = {
		'Hold ~INPUT_MULTIPLAYER_INFO~ to view the scoreboard.',
		'Performing Missions and taking out enemy players will give you cash and experience.',
		'Get extra reward for killing players who are doing a Mission.',
		'Challenges allows you to compete with another players to prove your skills.',
		'Press ~INPUT_INTERACTION_MENU~ to open Interaction menu.',
		'Visit ~BLIP_GUN_SHOP~ to purchase Special Weapons ammo.',
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

	if player ~= Player.ServerId() then return end

	Player.Deathstreak = Player.Deathstreak + 1
	Player.Killstreak = 0
	killstreak = 0
end)


RegisterNetEvent('lsv:onPlayerKilled')
AddEventHandler('lsv:onPlayerKilled', function(player, killer, message)
	if NetworkIsPlayerActive(GetPlayerFromServerId(player)) and NetworkIsPlayerActive(GetPlayerFromServerId(killer)) then
		Gui.DisplayNotification(Gui.GetPlayerName(killer)..' '..message..' '..Gui.GetPlayerName(player, nil, true))
	end

	if player == Player.ServerId() then
		Player.Deathstreak = Player.Deathstreak + 1
		Player.Killstreak = 0
		killstreak = 0
		return
	elseif killer ~= Player.ServerId() then return end

	Player.Deathstreak = 0

	Player.Kills = Player.Kills + 1
	Player.Killstreak = Player.Killstreak + 1

	if lastKillTime:Elapsed() > Settings.killstreakInterval then
		killstreak = 1
		lastKillTime:Restart()
		return
	end

	killstreak = killstreak + 1
	lastKillTime:Restart()

	if killstreak < 2 or not Player.IsInFreeroam() then return end

	local killstreakMessage = 'DOUBLE KILL'
	if killstreak == 3 then killstreakMessage = 'TRIPLE KILL'
	elseif killstreak == 4 then killstreakMessage = 'MEGA KILL'
	elseif killstreak == 5 then killstreakMessage = 'ULTRA KILL'
	elseif killstreak == 6 then killstreakMessage = 'MONSTER KILL'
	elseif killstreak == 7 then killstreakMessage = 'LUDICROUS KILL'
	elseif killstreak == 8 then killstreakMessage = 'HOLY SHIT'
	elseif killstreak == 9 then killstreakMessage = 'RAMPAGE'
	elseif killstreak > 9 then killstreakMessage = 'GODLIKE' end

	if playerStreakScaleform and playerStreakScaleform:IsValid() then playerStreakScaleform:Delete() end
	playerStreakScaleform = Scaleform:Request('MIDSIZED_MESSAGE')
	playerStreakScaleform:Call('SHOW_SHARD_MIDSIZED_MESSAGE', killstreakMessage)
	playerStreakScaleform:RenderFullscreenTimed(5000)
end)


-- GUI
AddEventHandler('lsv:init', function()
	while true do
		Citizen.Wait(0)

		RemoveMultiplayerBankCash()
		RemoveMultiplayerHudCash()

		if Player.PatreonTier == 0 then
			if discordUrl then
				Gui.SetTextParams(4, { r = 255, g = 255, b = 255, a = 255 }, 0.45, true, false, true)
				Gui.DrawText(discordUrl, { x = SafeZone.Left() + 0.785, y = SafeZone.Top() })
			end

			Gui.SetTextParams(4, { r = 255, g = 255, b = 255, a = 255 }, 0.45, true, false, true)
			Gui.DrawText('~c~Press ~w~M ~c~or ~w~Y~c~ to open Menu', { x =SafeZone.Left() + 0.785, y = SafeZone.Top() + 0.025 })
		end

		Gui.SetTextParams(4, Color.GetHudFromBlipColor(Color.BLIP_WHITE), 0.3, true, true, true)
		Gui.DrawText(Player.Experience..' / '..Rank.GetRequiredExperience(Player.Rank + 1)..'         $'..Player.Cash,
			{ x = SafeZone.Left() + 0.1025, y = SafeZone.Bottom() - 0.004 }, 0.25)

		if IsControlPressed(0, 20) then
			Scoreboard.DisplayThisFrame()
		elseif IsPlayerDead(PlayerId()) and DeathTimer then
			if IsControlJustReleased(0, 24) then
				DeathTimer = DeathTimer - Settings.spawn.respawnFasterPerControlPressed
				PlaySoundFrontend(-1, DeathTimer > 0 and 'Faster_Click' or 'Faster_Bar_Full', 'RESPAWN_ONLINE_SOUNDSET', true)
			end
			Gui.DrawProgressBar('RESPAWNING', GetTimeDifference(GetGameTimer(), DeathTimer) / TimeToRespawn, 0, Color.GetHudFromBlipColor(Color.BLIP_RED))
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


AddEventHandler('lsv:init', function()
	local scaleform = Scaleform:Request('MP_BIG_MESSAGE_FREEMODE')

	local respawnFasterScaleform = Scaleform:Request('INSTRUCTIONAL_BUTTONS')
	respawnFasterScaleform:Call('SET_DATA_SLOT', 0, '~INPUT_ATTACK~', 'Respawn Faster')
	respawnFasterScaleform:Call('DRAW_INSTRUCTIONAL_BUTTONS')

	RequestScriptAudioBank('MP_WASTED', 0)

	while true do
		Citizen.Wait(0)

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
						deathDetails = 'Killed with '..weaponName..'\n'..deathDetails
					end
				end
			end

			scaleform:Call('SHOW_SHARD_WASTED_MP_MESSAGE', '~r~WASTED', deathDetails)

			respawnFasterScaleform:RenderFullscreenTimed(500)

			while IsPlayerDead(PlayerId()) do
				scaleform:RenderFullscreen()
				respawnFasterScaleform:RenderFullscreen()
				Citizen.Wait(0)
			end

			StopScreenEffect('DeathFailOut')
			StopGameplayCamShaking(true)
		end
	end
end)


RegisterNetEvent('lsv:setupHud')
AddEventHandler('lsv:setupHud', function(hud)
	if hud.pauseMenuTitle ~= '' then
		AddTextEntry('FE_THDR_GTAO', hud.pauseMenuTitle)
	end

	if hud.discordUrl ~= '' then
		discordUrl = hud.discordUrl

		if Player.PatreonTier ~= 0 then return end

		while true do
			Citizen.Wait(Settings.discordNotificationTimeout)
			PlaySoundFrontend(-1, 'EVENT_START_TEXT', 'GTAO_FM_EVENTS_SOUNDSET', true)
			FlashMinimapDisplay()
			Gui.DisplayPersonalNotification('Join our Discord to read about latest changes and stay together with community.', 'CHAR_MP_STRIPCLUB_PR', 'VIP Invitation', discordUrl, 2)

			Citizen.Wait(Settings.discordNotificationTimeout)
			PlaySoundFrontend(-1, 'EVENT_START_TEXT', 'GTAO_FM_EVENTS_SOUNDSET', true)
			FlashMinimapDisplay()
			Gui.DisplayPersonalNotification('Earn more rewards and get exclusive in-game bonuses.\nRead more details in our Discord.', 'CHAR_MP_STRIPCLUB_PR', 'Become My Patron', discordUrl, 2)
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


AddEventHandler('lsv:init', function()
	while true do
		for _, id in ipairs(GetActivePlayers()) do
			if id ~= PlayerId() then
				local ped = GetPlayerPed(id)

				if ped and ped ~= 0 then
					local blip = GetBlipFromEntity(ped)
					if not DoesBlipExist(blip) then
						blip = AddBlipForEntity(ped)
						SetBlipHighDetail(blip, true)
					end

					local isPlayerDead = IsPlayerDead(id)

					local serverId = GetPlayerServerId(id)
					local isPlayerBeast = serverId == World.BeastPlayer
					local isPlayerHotProperty = serverId == World.HotPropertyPlayer
					local isPlayerOnMission = MissionManager.IsPlayerOnMission(serverId)
					local isChallengingPlayer = World.ChallengingPlayer == serverId
					local isPlayerCrewMember = Player.IsCrewMember(serverId)

					local blipSprite = Blip.STANDARD
					if isPlayerDead then blipSprite = Blip.PLAYER_DEAD
					elseif not isChallengingPlayer then
						if isPlayerHotProperty then blipSprite = Blip.HOT_PROPERTY
						elseif isPlayerBeast then blipSprite = Blip.BEAST
						elseif isPlayerOnMission then blipSprite = Blip.PLAYER_ON_MISSION end
					end

					local scale = nil
					if isChallengingPlayer then scale = 0.8
					elseif isPlayerHotProperty or isPlayerOnMission or isPlayerBeast then scale = 0.9
					else
						scale = 0.7
						local killstreak = Scoreboard.GetPlayerKillstreak(id)
						if killstreak then
							scale = scale + math.min(0.3, killstreak * 0.03)
						end
					end
					SetBlipScale(blip, scale)

					local blipColor = Color.BLIP_WHITE
					if isPlayerCrewMember then blipColor = Color.BLIP_BLUE
					elseif isPlayerHotProperty or isPlayerBeast or isChallengingPlayer or isPlayerOnMission then blipColor = Color.BLIP_RED end

					local blipAlpha = 255
					if not isPlayerCrewMember then
						if not isPlayerHotProperty and not isPlayerBeast then
							if GetPedStealthMovement(ped) or GetPlayerInvincible(id) then blipAlpha = 25 end
						end
					end

					if GetBlipSprite(blip) ~= blipSprite then SetBlipSprite(blip, blipSprite) end
					if GetBlipAlpha(blip) ~= blipAlpha then SetBlipAlpha(blip, blipAlpha) end

					ShowHeadingIndicatorOnBlip(blip, blipSprite == Blip.STANDARD)
					ShowCrewIndicatorOnBlip(blip, isPlayerCrewMember)
					SetBlipColour(blip, blipColor)
					SetBlipNameToPlayerName(blip, id)
				else
					SetBlipAlpha(blip, 0)
				end
			end
		end

		Citizen.Wait(0)
	end
end)
