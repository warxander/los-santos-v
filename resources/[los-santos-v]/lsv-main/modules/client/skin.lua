Skin = { }


function Skin.ChangePlayerSkin(id)
	ResetPedMovementClipset(PlayerPedId(), 0.0)

	local model = GetHashKey(id)
	RequestModel(model)
	while not HasModelLoaded(model) do Citizen.Wait(1) end

	local weapons = Player.GetPlayerWeapons()
	local health = GetEntityHealth(PlayerPedId())
	local armor = GetPedArmour(PlayerPedId())
	local isHasParachute = HasPedGotWeapon(PlayerPedId(), GetHashKey("GADGET_PARACHUTE"), false)

	SetPlayerModel(PlayerId(), model)
	SetPedDefaultComponentVariation(PlayerPedId())

	Player.skin = id
	SetPedArmour(PlayerPedId(), armor)
	SetEntityHealth(PlayerPedId(), health)

	if Settings.giveParachuteAtSpawn then
		if isHasParachute then
			GiveWeaponToPed(PlayerPedId(), GetHashKey("GADGET_PARACHUTE"), 1, false, false)
		end
	end

	Player.GiveWeapons(weapons)

	SetModelAsNoLongerNeeded(model)
end