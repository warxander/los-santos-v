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
	else SetCurrentPedWeapon(playerPed, GetHashKey(Player.primaryWeapon), true) end
end)


RegisterNetEvent('lsv:playerLoaded')
AddEventHandler('lsv:playerLoaded', function(playerData)
	SetRandomSeed(GetNetworkTime())

	Skin.ChangePlayerSkin(playerData.SkinModel)

	Player.money = playerData.Money
	StatSetInt(GetHashKey("MP0_WALLET_BALANCE"), math.floor(Player.money), true)

	Player.kills = playerData.Kills
	Player.deaths = playerData.Deaths

	Player.UpdateMeleeWeapon(playerData.MeleeWeapon)
	Player.UpdatePrimaryWeapon(playerData.PrimaryWeapon)
	Player.UpdateSecondaryWeapon(playerData.SecondaryWeapon)
	Player.UpdateGadget1(playerData.Gadget1)
	Player.UpdateGadget2(playerData.Gadget2)

	SetCurrentPedWeapon(PlayerPedId(), GetHashKey(Player.primaryWeapon), true)

	TriggerEvent('lsv:init')
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