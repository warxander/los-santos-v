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
		TriggerServerEvent('lsv:loadPlayer')
	end
end)


RegisterNetEvent('lsv:playerLoaded')
AddEventHandler('lsv:playerLoaded', function(playerData, isRegistered)
	SetEntityAlpha(PlayerPedId(), 128)

	SetRandomSeed(GetNetworkTime())

	Skin.ChangePlayerSkin(playerData.SkinModel)

	Player.RP = playerData.RP

	Player.kills = playerData.Kills
	Player.deaths = playerData.Deaths

	Player.GiveWeapons(playerData.Weapons)

	SetEntityAlpha(PlayerPedId(), 255)

	TriggerEvent('lsv:init', isRegistered)
end)


AddEventHandler('lsv:init', function()
	while true do
		Citizen.Wait(0)

		if GetEntityHeightAboveGround(PlayerPedId()) < Settings.autoParachutingHeight and IsPedInParachuteFreeFall(PlayerPedId()) then
			ForcePedToOpenParachute(PlayerPedId())
		end
	end
end)


AddEventHandler('lsv:init', function()
	NetworkSetFriendlyFireOption(true)
	SetCanAttackFriendly(PlayerPedId(), true, true)

	SetIgnoreLowPriorityShockingEvents(-1, true)

	World.SetWantedLevel(0)
end)


AddEventHandler('lsv:init', function()
	if Settings.disableHealthRegen then
		SetPlayerHealthRechargeMultiplier(PlayerId(), 0)
	end

	SetPlayerTargetingMode(2) --free aim
end)


AddEventHandler('lsv:init', function()
	if Settings.infinitePlayerStamina then
		while true do
			Citizen.Wait(0)

			ResetPlayerStamina(PlayerId())
		end
	end
end)