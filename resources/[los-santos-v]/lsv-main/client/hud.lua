AddEventHandler('lsv:init', function()
	--https://pastebin.com/amtjjcHb
	local tips = {
		"Performing Jobs and taking out enemy players will give your cash.",
		"Get extra cash for killing players who are doing a Job.",
		"Stunt Jumps will give you a small amount of cash.",
		"Press ~INPUT_INTERACTION_MENU~ to open Interaction menu.",
		"Use Report Player option from Interaction menu to improve your overall game experience.",
		"Hold ~INPUT_MULTIPLAYER_INFO~ to view the scoreboard.",
		"Press ~INPUT_ENTER_CHEAT_CODE~ to enlarge the Radar.",
		"Press ~INPUT_DUCK~ to enter stealth mode.",
		"Visit ~BLIP_GUN_SHOP~ to buy and customize weapons.",
		"Visit ~BLIP_CLOTHES_STORE~ to change your character.",
	}
	local tipTime = 10000
	local tipInterval = 30000

	for _, tip in ipairs(tips) do
		SetTimeout(tipTime, function()
			Gui.DisplayHelpText(tip)
		end)

		tipTime = tipTime + tipInterval
	end
end)


RegisterNetEvent('lsv:playerDisconnected')
AddEventHandler('lsv:playerDisconnected', function(name)
	Gui.DisplayNotification('<C>'..name..'</C> left.')
end)


RegisterNetEvent('lsv:playerConnected')
AddEventHandler('lsv:playerConnected', function(player)
	local playerId = GetPlayerFromServerId(player)
	if PlayerId() ~= playerId and NetworkIsPlayerActive(playerId) then
		Gui.DisplayNotification(Gui.GetPlayerName(player).." connected.")
		Map.SetBlipFlashes(GetBlipFromEntity(GetPlayerPed(playerId)))
	end
end)


RegisterNetEvent('lsv:onPlayerDied')
AddEventHandler('lsv:onPlayerDied', function(player, suicide)
	if NetworkIsPlayerActive(GetPlayerFromServerId(player)) then
		if suicide then
			Gui.DisplayNotification(Gui.GetPlayerName(player).." committed suicide.")
		else
			Gui.DisplayNotification(Gui.GetPlayerName(player).." died.")
		end
	end
end)


RegisterNetEvent('lsv:onPlayerKilled')
AddEventHandler('lsv:onPlayerKilled', function(player, killer, message)
	if NetworkIsPlayerActive(GetPlayerFromServerId(player)) and NetworkIsPlayerActive(GetPlayerFromServerId(killer)) then
		Gui.DisplayNotification(Gui.GetPlayerName(killer).." "..message.." "..Gui.GetPlayerName(player, nil, true)..'.')
	end
end)


-- GUI
AddEventHandler('lsv:init', function()
	while true do
		Citizen.Wait(0)

		if IsControlPressed(0, 20) then
			Scoreboard.DisplayThisFrame()
		elseif IsPlayerDead(PlayerId()) then
			if DeathTimer then
				if IsControlPressed(0, 24) then DeathTimer = DeathTimer - Settings.spawn.respawnFasterPerControlPressed end
				Gui.DrawProgressBar('RESPAWNING', 1.0 - GetTimeDifference(GetGameTimer(), DeathTimer) / TimeToRespawn, Color.GetHudFromBlipColor(Color.BlipRed()))
			end
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


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		RemoveMultiplayerBankCash()
		RemoveMultiplayerHudCash()
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
		for id = 0, Settings.maxPlayerCount do
			if id ~= PlayerId() then
				local ped = GetPlayerPed(id)
				local blip = GetBlipFromEntity(ped)

				if NetworkIsPlayerActive(id) and ped ~= nil then
					if not DoesBlipExist(blip) then
						blip = AddBlipForEntity(ped)
						SetBlipHighDetail(blip, true)
						SetBlipScale(blip, 0.9)
					end

					local isPlayerDead = IsPlayerDead(id)

					local serverId = GetPlayerServerId(id)
					local isPlayerBounty = serverId == World.GetBountyPlayerId()
					local isPlayerInCrew = Player.isCrewMember(serverId)
					local isPlayerDoingJob = JobWatcher.IsDoingJob(serverId)

					local blipSprite = Blip.Standard()
					if isPlayerDead then blipSprite = Blip.Dead()
					elseif isPlayerBounty then blipSprite = Blip.BountyHit()
					elseif isPlayerDoingJob then blipSprite = Blip.PolicePlayer() end

					local blipColor = Color.BlipWhite()
					if isPlayerInCrew then blipColor = Color.BlipBlue()
					elseif isPlayerBounty then blipColor = Color.BlipRed()
					elseif isPlayerDoingJob then blipColor = Color.BlipPurple() end

					local blipAlpha = 255
					if GetPedStealthMovement(ped) and not isPlayerInCrew then blipAlpha = 0 end

					if GetBlipSprite(blip) ~= blipSprite then SetBlipSprite(blip, blipSprite) end
					if GetBlipAlpha(blip) ~= blipAlpha then SetBlipAlpha(blip, blipAlpha) end

					ShowHeadingIndicatorOnBlip(blip, blipSprite == Blip.Standard())
					SetBlipFriendly(blip, isPlayerInCrew)
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
