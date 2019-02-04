local discordUrl = nil

local cashGained = 0
local cashGainedTime = nil
local cashGainedEffects = { }


Citizen.CreateThread(function()
	AddTextEntry('MONEY_ENTRY', '$~1~')
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
	cashGainedTime = GetGameTimer()
end)


AddEventHandler('lsv:init', function()
	cashGainedTime = GetGameTimer()

	Streaming.RequestStreamedTextureDict('MPHud')

	local screenWidth, screenHeight = GetScreenResolution()
	local spriteScale = 18.0
	local textScale = 0.5

	while true do
		Citizen.Wait(0)

		if GetTimeDifference(GetGameTimer(), cashGainedTime) < Settings.cashGainedNotificationTime then
			if cashGained ~=0 and not IsPlayerDead(PlayerId()) then
				local playerPosition = Player.Position()
				local z = playerPosition.z + 1.0
				local color = cashGained > 0 and Color.GetHudFromBlipColor(Color.BlipWhite()) or Color.GetHudFromBlipColor(Color.BlipRed())

				SetDrawOrigin(playerPosition.x, playerPosition.y, z, 0)
				DrawSprite('MPHud', 'mp_anim_cash', 0.0, 0.0, spriteScale / screenWidth, spriteScale / screenHeight, 0.0, 255, 255, 255, 255)
				Gui.SetTextParams(4, color, textScale, true, true)
				Gui.DrawText(math.abs(cashGained), { x = spriteScale / 2 / screenWidth, y = -spriteScale / 2 / screenHeight - 0.004 })
				ClearDrawOrigin()
			end
		else cashGained = 0 end
	end
end)


AddEventHandler('lsv:init', function()
	--https://pastebin.com/amtjjcHb
	local tips = {
		'Hold ~INPUT_MULTIPLAYER_INFO~ to view the scoreboard.',
		"Performing Missions and taking out enemy players will give your cash.",
		"Get extra cash for killing players who are doing a Mission.",
		'Stunt Jumps will give you a small amount of cash.',
		'Press ~INPUT_INTERACTION_MENU~ to open Interaction menu.',
		'Use Interaction Menu or visit ~BLIP_GUN_SHOP~ to customize your loadout.',
		'Press ~INPUT_ENTER_CHEAT_CODE~ to enlarge the Radar.',
		'Press ~INPUT_DUCK~ to enter stealth mode.',
		'Visit ~BLIP_CLOTHES_STORE~ to change your character.',
		'Use Report Player option from Interaction menu to improve your overall game experience.',
	}
	local tipTime = 10000
	local tipInterval = 30000

	table.foreach(tips, function(tip)
		SetTimeout(tipTime, function()
			Gui.DisplayHelpText(tip)
		end)

		tipTime = tipTime + tipInterval
	end)
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
end)


RegisterNetEvent('lsv:onPlayerKilled')
AddEventHandler('lsv:onPlayerKilled', function(player, killer, message)
	if NetworkIsPlayerActive(GetPlayerFromServerId(player)) and NetworkIsPlayerActive(GetPlayerFromServerId(killer)) then
		Gui.DisplayNotification(Gui.GetPlayerName(killer)..' '..message..' '..Gui.GetPlayerName(player, nil, true))
	end
end)


-- GUI
AddEventHandler('lsv:init', function()
	while true do
		Citizen.Wait(0)

		RemoveMultiplayerBankCash()
		RemoveMultiplayerHudCash()

		if discordUrl and Player.PatreonTier == 0 then
			Gui.SetTextParams(7, { r = 254, g = 254, b = 254, a = 196 }, 0.25, true, false, true)
			Gui.DrawText(discordUrl, { x = 0.5, y = 0.9825 })
		end

		if IsControlPressed(0, 20) then
			Scoreboard.DisplayThisFrame()
		elseif IsPlayerDead(PlayerId()) and DeathTimer then
			if IsControlJustReleased(0, 24) then DeathTimer = DeathTimer - Settings.spawn.respawnFasterPerControlPressed end
			Gui.DrawProgressBar('RESPAWNING', GetTimeDifference(GetGameTimer(), DeathTimer) / TimeToRespawn, Color.GetHudFromBlipColor(Color.BlipRed()))
		end
	end
end)


AddEventHandler('lsv:init', function()
	local scaleform = Scaleform:Request('MP_BIG_MESSAGE_FREEMODE')
	scaleform:Call('SHOW_SHARD_WASTED_MP_MESSAGE', '~r~WASTED')

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

			local scaleformTimer = GetGameTimer()
			while GetTimeDifference(GetGameTimer(), scaleformTimer) <= 500 do
				respawnFasterScaleform:RenderFullscreen()
				Citizen.Wait(0)
			end

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

	if hud.discordUrl ~= '' then discordUrl = hud.discordUrl end
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
		for id = 0, Settings.maxPlayerCount do
			if id ~= PlayerId() then
				local ped = GetPlayerPed(id)

				if NetworkIsPlayerActive(id) and ped ~= nil then
					local blip = GetBlipFromEntity(ped)
					if not DoesBlipExist(blip) then
						blip = AddBlipForEntity(ped)
						SetBlipHighDetail(blip, true)
						SetBlipCategory(blip, 7)
					end

					local isPlayerDead = IsPlayerDead(id)

					local serverId = GetPlayerServerId(id)
					local isPlayerBounty = serverId == World.BountyPlayer
					local isPlayerHotProperty = serverId == World.HotPropertyPlayer
					local isPlayerOnMission = MissionManager.IsPlayerOnMission(serverId)
					local patreonTier = Scoreboard.GetPlayerPatreonTier(id) or 0

					local blipSprite = Blip.Standard()
					if isPlayerDead then blipSprite = Blip.Dead()
					elseif isPlayerHotProperty then blipSprite = Blip.HotProperty()
					elseif isPlayerBounty then blipSprite = Blip.BountyHit()
					elseif isPlayerOnMission then blipSprite = Blip.PolicePlayer() end

					local scale = 0.7
					if isPlayerHotProperty or isPlayerBounty or isPlayerOnMission then scale = 0.95 end
					SetBlipScale(blip, scale)

					local blipColor = Color.BlipWhite()
					if isPlayerHotProperty or isPlayerBounty then blipColor = Color.BlipRed()
					elseif isPlayerOnMission then blipColor = Color.BlipPurple() end

					local blipAlpha = GetPedStealthMovement(ped) and 0 or 255
					if isPlayerBounty or isPlayerHotProperty or isPlayerDead or isPlayerOnMission then blipAlpha = 255 end

					if GetBlipSprite(blip) ~= blipSprite then SetBlipSprite(blip, blipSprite) end
					if GetBlipAlpha(blip) ~= blipAlpha then SetBlipAlpha(blip, blipAlpha) end

					ShowHeadingIndicatorOnBlip(blip, blipSprite == Blip.Standard())
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


AddEventHandler('lsv:init', function()
	local policeStations = {
		{ x = 846.52661132813, y = -1295.9696044922, z = 38.743499755859 },
		{ x = 446.75616455078, y = -984.17645263672, z = 30.68959236145 },
		{ x = 367.18963623047, y = -1598.8682861328, z = 36.948822021484 },
		{ x = -1089.6934814453, y = -830.94616699219, z = 37.675407409668 },
		{ x = -561.96240234375, y = -131.09330749512, z = 38.431869506836 },
		{ x = 611.2099609375, y = -2.3961148262024, z = 101.24975585938 },
		{ x = -441.35147094727, y = 6004.3837890625, z = 40.493244171143 },
		{ x = 1852.5891113281, y = 3691.5615234375, z = 38.9833984375 },
	}

	table.foreach(policeStations, function(place)
		Map.CreatePlaceBlip(Blip.PoliceStation(), place.x, place.y, place.z)
	end)
end)
