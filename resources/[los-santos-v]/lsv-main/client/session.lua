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


RegisterNetEvent('lsv:playerLoaded')
AddEventHandler('lsv:playerLoaded', function(playerData, isRegistered)
	SetRandomSeed(GetNetworkTime())

	Skin.ChangePlayerSkin(playerData.SkinModel)

	Player.serverId = GetPlayerServerId(PlayerId())

	Player.RP = playerData.RP

	Player.kills = playerData.Kills
	Player.deaths = playerData.Deaths

	Player.GiveWeapons(playerData.Weapons)

	Player.SetFreeze(false)

	TriggerEvent('lsv:init', isRegistered)
end)


AddEventHandler('lsv:init', function()
	NetworkSetFriendlyFireOption(true)
	SetCanAttackFriendly(PlayerPedId(), true, true)

	SetIgnoreLowPriorityShockingEvents(-1, true)

	World.SetWantedLevel(0)

	if Settings.disableHealthRegen then SetPlayerHealthRechargeMultiplier(PlayerId(), 0) end

	if Settings.infinitePlayerStamina then
		while true do
			Citizen.Wait(0)

			ResetPlayerStamina(PlayerId())
		end
	end
end)