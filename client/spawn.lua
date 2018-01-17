AddEventHandler('playerSpawned', function()
	local playerPed = GetPlayerPed(-1)

	if Settings.giveArmorAtSpawn then
		if GetPlayerMaxArmour(PlayerId()) ~= Settings.playerMaxArmour then
			SetPlayerMaxArmour(PlayerId(), Settings.playerMaxArmour)
		end

		SetPedArmour(playerPed, GetPlayerMaxArmour(PlayerId()))
	end

	if Settings.giveParachuteAtSpawn then
		GiveWeaponToPed(playerPed, GetHashKey("GADGET_PARACHUTE"), 1, false, false)
	end

	SetCurrentPedWeapon(playerPed, Player.currentWeaponHash or GetBestPedWeapon(playerPed), true)

	TriggerServerEvent('lsv:playerSpawned')
end)


AddEventHandler('lsv:disablePolice', function()
	local player = PlayerId()

	SetPoliceIgnorePlayer(player, true)
	SetDispatchCopsForPlayer(player, false)
	SetMaxWantedLevel(0)
end)


AddEventHandler('lsv:firstSpawnPlayer', function()
	if Settings.infinitePlayerStamina then
		while true do
			Citizen.Wait(0)

			ResetPlayerStamina(PlayerId())
		end
	end
end)

RegisterNetEvent('lsv:firstSpawnPlayer')
AddEventHandler('lsv:firstSpawnPlayer', function(playerData)
	SetRandomSeed(GetNetworkTime())

	TriggerServerEvent('lsv:playerConnected')

    DisplayCash(true)

	Player.money = playerData.Money
	Player.kills = playerData.Kills
	Player.deaths = playerData.Deaths
	Player.vehicleModel = playerData.VehicleModel
	Player.startingWeapon = playerData.WeaponID
	Player.initialized = true

	Skin.ChangePlayerSkin(playerData.SkinModel)

	NetworkSetFriendlyFireOption(true)
	SetCanAttackFriendly(PlayerPedId(), true, true)

    SetIgnoreLowPriorityShockingEvents(-1, true)

	TriggerEvent('lsv:disablePolice')

	if Settings.randomMeleeWeapon then
		local meleeWeapons = Weapon.GetMeleeWeapons()
		GiveWeaponToPed(PlayerPedId(), GetHashKey(meleeWeapons[GetRandomIntInRange(1, Utils.GetTableLength(meleeWeapons) + 1)].id), 1, false, true)
	end

	if Settings.flashlightAtSpawn then
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_FLASHLIGHT"), 1, false, false)
	end

	local startingWeaponHash = GetHashKey(Player.startingWeapon)
	GiveWeaponToPed(PlayerPedId(), startingWeaponHash, Weapon.GetSpawningAmmo(startingWeaponHash), false, true)
	for _, weapon in pairs(Weapon.GetWeapons()) do
		if weapon.id == Player.startingWeapon then
			Gui.DisplayNotification("You have spawned with "..weapon.name..".")
			break
		end
	end

	if Settings.disableHealthRegen then
		SetPlayerHealthRechargeMultiplier(PlayerId(), 0)
	end

	if Settings.dropWeaponAfterDeath then
		SetPedDropsWeaponsWhenDead(PlayerPedId(), true)
	end

	SetPlayerTargetingMode(2) --free aim
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if GetEntityHeightAboveGround(PlayerPedId()) < Settings.autoParachutingHeight and IsPedInParachuteFreeFall(PlayerPedId()) then
			ForcePedToOpenParachute(PlayerPedId())
		end

		if not IsEntityDead(PlayerPedId()) then
			local currentWeaponHash = GetSelectedPedWeapon(PlayerPedId())
			if Player.currentWeaponHash ~= currentWeaponHash and currentWeaponHash > 0 then Player.currentWeaponHash = currentWeaponHash end
		end
	end
end)