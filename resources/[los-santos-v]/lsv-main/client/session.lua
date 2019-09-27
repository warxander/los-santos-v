local loadingTransaction = RemoteTransaction.New()


AddEventHandler('playerSpawned', function()
	local playerPed = PlayerPedId()

	if Settings.giveArmorAtSpawn then
		SetPedArmour(playerPed, Settings.maxArmour)
	end

	if Settings.giveParachuteAtSpawn then
		GiveWeaponToPed(playerPed, GetHashKey('GADGET_PARACHUTE'), 1, false, false)
	end

	if not Player.Loaded and not Player.Loading then
		Player.Loading = true
		TriggerServerEvent('lsv:loadPlayer')
		loadingTransaction:WaitForEnding('Loading profile')
	else Player.SetFreeze(false) end
end)


Citizen.CreateThread(function()
	NetworkSetVoiceActive(Settings.enableVoiceChat)

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
	math.randomseed(GetNetworkTime())
	SetRandomSeed(GetNetworkTime())

	while GetPlayerSwitchState() ~= 5 do
		HideHudAndRadarThisFrame()
		SetCloudHatOpacity(0.01)
		Citizen.Wait(0)
	end

	if not GetIsLoadingScreenActive() then
		DoScreenFadeOut(0)
		while not IsScreenFadedOut() do Citizen.Wait(0) end
	end

	ShutdownLoadingScreen()
	ShutdownLoadingScreenNui()

	DoScreenFadeIn(500)
	while not IsScreenFadedIn() do Citizen.Wait(0) end

	StopAudioScene('MP_LEADERBOARD_SCENE')

	Player.Init(playerData)
	loadingTransaction:Finish()

	SwitchInPlayer(PlayerPedId())
	while GetPlayerSwitchState() ~= 12 do
		HideHudAndRadarThisFrame()
		SetCloudHatOpacity(0.01)
		Citizen.Wait(0)
	end

	Player.Loaded = true
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


AddEventHandler('lsv:init', function()
	local lastVehicle = nil

	while true do
		Citizen.Wait(0)

		local vehicle = GetVehiclePedIsTryingToEnter(PlayerPedId())
		local vehicleClass = GetVehicleClass(vehicle)

		if DoesEntityExist(vehicle) and (vehicleClass == 19 or vehicleClass == 15 or vehicleClass == 16) and GetSeatPedIsTryingToEnter(PlayerPedId()) == -1 then
			local isPlayerAbleToUseIt = Player.Rank >= Settings.specialVehicleMinRank -- This is vunerable for cheaters
			if not isPlayerAbleToUseIt and lastVehicle ~= vehicle then
				Gui.DisplayHelpText('You need to have Rank '..Settings.specialVehicleMinRank..' or higher to use this vehicle.')
			end
			SetVehicleDoorsLockedForPlayer(vehicle, PlayerId(), not isPlayerAbleToUseIt)
			lastVehicle = vehicle
		end
	end
end)
