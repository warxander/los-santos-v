AddEventHandler('lsv:firstSpawnPlayer', function()
	--https://pastebin.com/amtjjcHb
	local tips = {
		"Hold ~INPUT_MULTIPLAYER_INFO~ to see the top "..tostring(Settings.scoreboardMaxPlayers).." players.",
		"Tap ~INPUT_ENTER_CHEAT_CODE~ to toggle Expanded Radar.",
		"Press ~INPUT_INTERACTION_MENU~ to open Interaction Menu.",
		"Use stealth to hide yourself from the radar.",
		"Visit Los Santos Customs to purchase your personal car.",
		"Join our Discord to discuss the server and report about hackers as well.",
	}
	local tipTime = 10000
	local tipInterval = 20000

	for _, tip in pairs(tips) do
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
AddEventHandler('lsv:playerConnected', function(source)
	if PlayerId() ~= GetPlayerFromServerId(source) and NetworkIsPlayerActive(GetPlayerFromServerId(source)) then
		Gui.DisplayNotification(Gui.GetPlayerName(source).." connected.")
	end
end)


RegisterNetEvent('lsv:onPlayerDied')
AddEventHandler('lsv:onPlayerDied', function(source, suicide)
	if NetworkIsPlayerActive(GetPlayerFromServerId(source)) then
		if suicide then
			Gui.DisplayNotification(Gui.GetPlayerName(source).." committed suicide.")
		else
			Gui.DisplayNotification(Gui.GetPlayerName(source).." died.")
		end
	end
end)


RegisterNetEvent('lsv:onPlayerKilled')
AddEventHandler('lsv:onPlayerKilled', function(source, killer, message)
	if NetworkIsPlayerActive(GetPlayerFromServerId(source)) and NetworkIsPlayerActive(GetPlayerFromServerId(killer)) then
		Gui.DisplayNotification(Gui.GetPlayerName(killer).." "..message.." "..Gui.GetPlayerName(source, nil, true))
	end
end)


-- GUI
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if IsControlPressed(0, 20) then
			Scoreboard.DisplayThisFrame()
		elseif not IsEntityDead(GetPlayerPed(-1)) then
			Gui.Draw()
		end
	end
end)


local function AddTextEntry(key, value)
	Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), key, value)
end


-- Pause Menu
Citizen.CreateThread(function()
	AddTextEntry('FE_THDR_GTAO', 'Los Santos V | discord.gg/jNJ7rva')
end)


-- PUBG Aim
-- https://forum.fivem.net/t/release-pubg-aim/59082/7
-- https://github.com/indilo53/fxserver-pubg_aim
Citizen.CreateThread(function()
	local aimButtonPressedTimeout = 0
	local lastPedView = nil

	while true do
		Citizen.Wait(1)

		if not IsEntityDead(PlayerPedId()) then
			if not lastPedView then lastPedView = GetFollowPedCamViewMode() end
			if IsControlPressed(0, 25) then aimButtonPressedTimeout = aimButtonPressedTimeout + 1 end --INPUT_AIM
			if IsControlJustReleased(0, 25) then
				if aimButtonPressedTimeout < 25 then
					if GetFollowPedCamViewMode() ~= 4 then
						lastPedView = GetFollowPedCamViewMode()
						SetFollowPedCamViewMode(4)
						SetPlayerForcedAim(PlayerId(), true)
					else
						SetFollowPedCamViewMode(lastPedView)
						SetPlayerForcedAim(PlayerId(), false)
					end
				end
				aimButtonPressedTimeout = 0
			end
		else
			SetPlayerForcedAim(PlayerId(), false)
		end
	end
end)


-- Wasted Screen
-- TODO Rework with spawn manager
Citizen.CreateThread(function()
	local locksound = false
	local scaleform = Scaleform:Request("MP_BIG_MESSAGE_FREEMODE")

	while true do
		Citizen.Wait(0)

		if IsEntityDead(PlayerPedId()) then

				StartScreenEffect("DeathFailOut", 0, 0)

				if not locksound then
					PlaySoundFrontend(-1, "Bed", "WastedSounds", true)
					locksound = true
				end

				ShakeGameplayCam("DEATH_FAIL_IN_EFFECT_SHAKE", 1.0)

				scaleform:Call("SHOW_SHARD_WASTED_MP_MESSAGE", "~r~WASTED")

				Citizen.Wait(1300)

				PlaySoundFrontend(-1, "TextHit", "WastedSounds", true) -- TODO This is not working

				while IsEntityDead(PlayerPedId()) do
					scaleform:RenderFullscreen()
					Citizen.Wait(0)
				end

				StopScreenEffect("DeathFailOut")
				locksound = false
		end
    end
end)


Citizen.CreateThread(function()
	local isBigMapEnabled = false

	while true do
		if IsControlJustReleased(0, 243) then
			isBigMapEnabled = not isBigMapEnabled
			Citizen.InvokeNative(0x231C8F89D0539D8F, isBigMapEnabled, false)
		end

		Citizen.Wait(0)
	end
end)