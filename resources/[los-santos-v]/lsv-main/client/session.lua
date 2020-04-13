local function getSkinRequirements(skin)
	if skin.id == Player.Skin then
		return 'Used'
	end

	if skin.rank and Player.Rank < skin.rank then
		return 'Rank '..skin.rank
	end

	return ''
end

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

	WarMenu.CreateMenu('faction', GetPlayerName(PlayerId()))
	WarMenu.SetSubTitle('faction', 'Select Your Faction')
	WarMenu.SetMenuMaxOptionCountOnScreen('faction', Settings.maxMenuOptionCount)
	WarMenu.SetTitleColor('faction', 255, 255, 255)
	WarMenu.SetTitleBackgroundColor('faction', Color.WHITE.r, Color.WHITE.g, Color.WHITE.b, Color.WHITE.a)
	WarMenu.SetTitleBackgroundSprite('faction', 'commonmenu', 'interaction_bgd')

	WarMenu.CreateSubMenu('faction_skin', 'faction', 'Select Your Skin')
	WarMenu.SetMenuButtonPressedSound('faction_skin', 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET')

	Gui.DisplayPersonalNotification('Your Faction choice is not permanent!')

	Player.SetModel(playerData.SkinModel)
	spawnPlayer(playerData.SpawnPoint) -- TODO Module ?

	WarMenu.OpenMenu('faction')

	local selectedFaction = nil

	while true do
		Citizen.Wait(0)

		if not WarMenu.IsMenuOpened('faction') and not WarMenu.IsMenuOpened('faction_skin') then
			break
		elseif WarMenu.IsMenuOpened('faction') then
			if WarMenu.Button('Neutral') then
				WarMenu.CloseMenu()
			elseif WarMenu.MenuButton('Enforcer', 'faction_skin') then
				selectedFaction = Settings.faction.Enforcer
			elseif WarMenu.MenuButton('Criminal', 'faction_skin') then
				selectedFaction = Settings.faction.Criminal
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('faction_skin') then
			if WarMenu.Button('Default') then
				TriggerServerEvent('lsv:joinFaction', selectedFaction)
				WarMenu.CloseMenu()
			else
				for _, skin in ipairs(Settings.factionSkins[selectedFaction]) do
					if WarMenu.Button(skin.name, getSkinRequirements(skin)) then
						if skin.rank and skin.rank > Player.Rank then
							Gui.DisplayPersonalNotification('Your Rank is too low.')
						else
							TriggerServerEvent('lsv:joinFaction', selectedFaction)
							Player.SetModel(skin.id, true)
							WarMenu.CloseMenu()
						end
					end
				end
			end

			WarMenu.Display()
		end
	end

	Player.SetPassiveMode(true)

	SwitchInPlayer(PlayerPedId())
	while GetPlayerSwitchState() ~= 12 do
		HideHudAndRadarThisFrame()
		Citizen.Wait(0)
	end

	Player.GiveWeapons(playerData.Weapons)

	Player.Loaded = true

	Player.SetPassiveMode(true, true)
	Citizen.Wait(Settings.spawnProtectionTime)
	Player.SetPassiveMode(false)

	TriggerEvent('lsv:init', playerData)
	TriggerServerEvent('lsv:playerInitialized')
end)

AddEventHandler('playerSpawned', function()
	local playerPed = PlayerPedId()

	if Settings.giveArmorAtSpawn then
		SetPedArmour(playerPed, Settings.armour.max)
	end

	if Settings.giveParachuteAtSpawn then
		GiveWeaponToPed(playerPed, `GADGET_PARACHUTE`, 1, false, false)
	end

	while not HasCollisionLoadedAroundEntity(playerPed) do
		Citizen.Wait(0)
	end
	PlaceObjectOnGroundProperly(playerPed)

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

			local wasPedDamaged = pedArmour < lastPedArmour
			if not wasPedDamaged then
				wasPedDamaged = pedHealth < lastPedHealth
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
