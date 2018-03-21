AddEventHandler('lsv:init', function()
	--https://pastebin.com/amtjjcHb
	local tips = {
		"Hold ~INPUT_MULTIPLAYER_INFO~ to see Scoreboard.",
		"Earn ~BLIP_RP~ by killing other players and join Freemode Events.",
		"Visit ~BLIP_GUN_SHOP~ to customize your Loadout.",
		"Press ~INPUT_INTERACTION_MENU~ to open Interaction Menu.",
		"Visit ~BLIP_CLOTHES_STORE~ to customize your Skin.",
		"Tap ~INPUT_ENTER_CHEAT_CODE~ to toggle Expanded Radar.",
		"Use stealth by pressing ~INPUT_DUCK~ to hide yourself from the radar.",
	}
	local tipTime = 10000
	local tipInterval = 20000

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


RegisterNetEvent('lsv:onRPEarnedPerKill')
AddEventHandler('lsv:onRPEarnedPerKill', function(RP)
	Gui.DisplayNotification("+ "..tostring(RP).."RP")
end)


-- GUI
AddEventHandler('lsv:init', function()
	while true do
		Citizen.Wait(0)

		if IsControlPressed(0, 20) then Scoreboard.DisplayThisFrame() end
	end
end)


local function AddTextEntry(key, value)
	Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), key, value)
end


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
						SetBlipShowCone(blip, false)
					end

					local IsPedDead = IsPedDeadOrDying(ped, true)
					local blipSprite = Blip.Standard()

					if IsPedDead then
						blipSprite = Blip.Dead()
					elseif BountyPlayerId and GetPlayerServerId(id) == BountyPlayerId then
						blipSprite = Blip.BountyHit()
					end

					SetBlipSprite(blip, blipSprite)

					if GetPedStealthMovement(ped) then
						SetBlipAlpha(blip, 0)
					else
						SetBlipAlpha(blip, 255)
					end

					SetBlipAsShortRange(blip, IsPedDead)
					SetBlipColour(blip, id + 1)
					SetBlipNameToPlayerName(blip, id)
				else
					SetBlipAlpha(blip, 0)
				end
			end
		end

		Citizen.Wait(0)
	end
end)