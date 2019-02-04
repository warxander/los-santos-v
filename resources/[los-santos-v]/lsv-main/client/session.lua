AddEventHandler('playerSpawned', function()
	local playerPed = PlayerPedId()

	if Settings.giveArmorAtSpawn then
		SetPedArmour(playerPed, Settings.maxArmour)
	end

	if Settings.giveParachuteAtSpawn then
		GiveWeaponToPed(playerPed, GetHashKey('GADGET_PARACHUTE'), 1, false, false)
	end

	if not Player.Loaded then
		Player.Loaded = true
		Player.SetFreeze(true)
		TriggerServerEvent('lsv:loadPlayer')
	end
end)


Citizen.CreateThread(function()
	SetManualShutdownLoadingScreenNui(true)
	StartAudioScene('MP_LEADERBOARD_SCENE')

	while true do
		Citizen.Wait(0)

		if PlayerPedId() ~= -1 then
			SwitchOutPlayer(PlayerPedId(), 0, 1)
			return
		end
	end
end)


RegisterNetEvent('lsv:playerLoaded')
AddEventHandler('lsv:playerLoaded', function(playerData, isRegistered)
	SetRandomSeed(GetNetworkTime())

	while GetPlayerSwitchState() ~= 5 do
		HideHudAndRadarThisFrame()
		SetCloudHatOpacity(0.01)
		Citizen.Wait(0)
	end
	ShutdownLoadingScreen()
	DoScreenFadeOut(0)
	ShutdownLoadingScreenNui()
	DoScreenFadeIn(500)
	StopAudioScene('MP_LEADERBOARD_SCENE')
	Player.Init(playerData)
	SwitchInPlayer(PlayerPedId())
	while GetPlayerSwitchState() ~= 12 and not HasCollisionLoadedAroundEntity(PlayerPedId()) do
		HideHudAndRadarThisFrame()
		SetCloudHatOpacity(0.01)
		Citizen.Wait(0)
	end
	PlaceObjectOnGroundProperly(PlayerPedId())
	Player.SetFreeze(false)

	TriggerEvent('lsv:init')
end)


AddEventHandler('lsv:init', function()
	World.EnablePvp(true)
	World.SetWantedLevel(0)

	if Settings.disableHealthRegen then SetPlayerHealthRechargeMultiplier(PlayerId(), 0) end
	if Settings.giveArmorAtSpawn then
		SetPedArmour(PlayerPedId(), Settings.maxArmour)
	end

	if Settings.infinitePlayerStamina then
		while true do
			Citizen.Wait(0)

			ResetPlayerStamina(PlayerId())
		end
	end
end)


-- As I understood, events start triggering twice when player session is broken
-- So this is my attempt to fix those players (by kicking them, ha-ha-ha)
local initialized = false
AddEventHandler('lsv:init', function()
	if not initialized then initialized = true
	else TriggerServerEvent('lsv:playerSessionFailed') end
end)
