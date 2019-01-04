AddEventHandler('playerSpawned', function()
	local playerPed = PlayerPedId()

	if Settings.giveArmorAtSpawn then
		SetPedArmour(playerPed, GetPlayerMaxArmour(PlayerId()))
	end

	if Settings.giveParachuteAtSpawn then
		GiveWeaponToPed(playerPed, GetHashKey("GADGET_PARACHUTE"), 1, false, false)
	end

	if not Player.isLoaded then
		Player.isLoaded = true
		Player.SetFreeze(true)
		TriggerServerEvent('lsv:loadPlayer')
	end
end)

SetManualShutdownLoadingScreenNui(true)
SwitchOutPlayer(PlayerPedId(), 0, 1)
Citizen.CreateThread(function()
	if not IsPlayerSwitchInProgress() then
		SwitchOutPlayer(PlayerPedId(), 0, 1)
	end
end)


RegisterNetEvent('lsv:playerLoaded')
AddEventHandler('lsv:playerLoaded', function(playerData, isRegistered)
	SetRandomSeed(GetNetworkTime())

	while GetPlayerSwitchState() ~= 5 do
		HideHudAndRadarThisFrame()
		Citizen.Wait(0)
	end
	ShutdownLoadingScreen()
	DoScreenFadeOut(0)
	DoScreenFadeIn(500)
	ShutdownLoadingScreenNui()
	Player.Init(playerData)
	SwitchInPlayer(PlayerPedId())
	while GetPlayerSwitchState() ~= 12 and not HasCollisionLoadedAroundEntity(PlayerPedId()) do
		HideHudAndRadarThisFrame()
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

	if Settings.infinitePlayerStamina then
		while true do
			Citizen.Wait(0)

			ResetPlayerStamina(PlayerId())
		end
	end
end)
