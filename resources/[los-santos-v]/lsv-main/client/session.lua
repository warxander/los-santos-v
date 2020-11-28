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
	math.randomseed(playerData.Seed)
	math.random(); math.random(); math.random();

	SetRandomSeed(playerData.Seed)

	ShutdownLoadingScreen()

	StopAudioScene('MP_LEADERBOARD_SCENE')

	Player.Init(playerData)
	Prompt.Hide()

	Player.SetModelAsync(playerData.SkinModel)
	spawnPlayer(playerData.SpawnPoint) -- TODO Module ?

	Player.SetPassiveMode(true)

	SwitchInPlayer(PlayerPedId())
	while GetPlayerSwitchState() ~= 12 do
		HideHudAndRadarThisFrame()
		Citizen.Wait(0)
	end

	Player.GiveWeapons(playerData.Weapons)

	Player.Loaded = true

	Player.SetPassiveMode(true, true)

	TriggerEvent('lsv:init', playerData)
	TriggerServerEvent('lsv:playerInitialized')

	Citizen.Wait(Settings.spawnProtectionTime)
	Player.SetPassiveMode(false)
end)

AddEventHandler('playerSpawned', function()
	local playerPed = PlayerPedId()

	if Settings.giveArmorAtSpawn then
		SetPedArmour(playerPed, Settings.armour.max)
	end

	if Settings.giveParachuteAtSpawn then
		GiveWeaponToPed(playerPed, `GADGET_PARACHUTE`, 1, false, false)
	end

	Streaming.RequestEntityCollisionAsync(playerPed)

	if Player.Loaded then
		Citizen.Wait(Settings.spawnProtectionTime)
		Player.SetPassiveMode(false)
	end
end)

AddEventHandler('lsv:init', function()
	World.EnablePvp(true)
	World.EnableWanted(false)

	if Settings.disableHealthRegen then
		SetPlayerHealthRechargeMultiplier(PlayerId(), 0)
	end

	if Settings.giveArmorAtSpawn then
		SetPedArmour(PlayerPedId(), Settings.armour.max)
	end

	if Settings.infinitePlayerStamina then
		while true do
			Citizen.Wait(0)

			ResetPlayerStamina(PlayerId())
		end
	end
end)

AddEventHandler('lsv:init', function()
	local lastDamageTimer = nil
	local armourRegenTimer = nil
	local lastPedArmour = Settings.armour.max
	local lastPedHealth = GetEntityMaxHealth(PlayerPedId())
	local needToResetState = true

	while true do
		Citizen.Wait(0)

		if not IsPlayerDead(PlayerId()) then
			needToResetState = true

			local ped = PlayerPedId()
			local pedArmour = GetPedArmour(ped)
			local pedHealth = GetEntityHealth(ped)

			local wasPedDamaged = false
			if not IsPedInAnyVehicle(ped, false) then
				wasPedDamaged = pedArmour < lastPedArmour

				if not wasPedDamaged then
					wasPedDamaged = pedHealth < lastPedHealth
				end
			end

			if not wasPedDamaged then
				if lastDamageTimer and armourRegenTimer then
					if lastDamageTimer:elapsed() >= Settings.armour.regenRate.timeout then
						if pedArmour < Settings.armour.max and armourRegenTimer:elapsed() >= Settings.armour.regenRate.time then
							local armour = math.min(Settings.armour.max, pedArmour + Settings.armour.regenRate.armour)
							SetPedArmour(ped, armour)
							armourRegenTimer:restart()
							lastPedArmour = armour
						end
					end
				else
					lastDamageTimer = Timer.New()
					armourRegenTimer = Timer.New() --TODO: Need better solution here
				end
			else
				lastDamageTimer = nil
				lastPedArmour = pedArmour
				lastPedHealth = pedHealth
			end
		elseif needToResetState then
			lastDamageTimer = nil
			armourRegenTimer = nil
			lastPedArmour = Settings.armour.max
			lastPedHealth = GetEntityMaxHealth(PlayerPedId())
			needToResetState = false
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
