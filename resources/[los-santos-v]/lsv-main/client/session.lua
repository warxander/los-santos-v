AddEventHandler('playerSpawned', function()
	local playerPed = PlayerPedId()

	if Settings.giveArmorAtSpawn then
		SetPedArmour(playerPed, Settings.maxArmour)
	end

	if Settings.giveParachuteAtSpawn then
		GiveWeaponToPed(playerPed, GetHashKey('GADGET_PARACHUTE'), 1, false, false)
	end

	while not HasCollisionLoadedAroundEntity(playerPed) do
		Citizen.Wait(0)
	end
	PlaceObjectOnGroundProperly(playerPed)

	if Player.Loaded then
		Player.SetFreeze(false)
	end
end)


Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end

	NetworkSetVoiceActive(Settings.enableVoiceChat)

	SetManualShutdownLoadingScreenNui(true)
	StartAudioScene('MP_LEADERBOARD_SCENE')

	SwitchOutPlayer(PlayerPedId(), 32, 1)
	while GetPlayerSwitchState() ~= 5 do
		HideHudAndRadarThisFrame()
		Citizen.Wait(0)
	end

	DoScreenFadeOut(0)
	while not IsScreenFadedOut() do
		Citizen.Wait(0)
	end

	TriggerServerEvent('lsv:loadPlayer')
	Prompt.ShowAsync('Loading profile')
end)


RegisterNetEvent('lsv:playerLoaded')
AddEventHandler('lsv:playerLoaded', function(playerData, isRegistered)
	local seed = tonumber(string.match(playerData.Identifier, '[0-9]+'))

	math.randomseed(seed)
	math.random(); math.random(); math.random();

	SetRandomSeed(math.floor(math.random()))

	ShutdownLoadingScreen()

	StopAudioScene('MP_LEADERBOARD_SCENE')

	Player.Init(playerData)
	Prompt.Hide()

	spawnPlayer(playerData.SpawnPoint) -- TODO Module ?

	SwitchInPlayer(PlayerPedId())
	while GetPlayerSwitchState() ~= 12 do
		HideHudAndRadarThisFrame()
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
