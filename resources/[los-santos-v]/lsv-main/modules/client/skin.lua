Skin = { }


function Skin.ChangePlayerSkin(id)
	ResetPedMovementClipset(PlayerPedId(), 0.0)

	local model = GetHashKey(id)

	Streaming.RequestModel(id)

	local weapons = Player.GetPlayerWeapons()
	local health = GetEntityHealth(PlayerPedId())
	local armor = GetPedArmour(PlayerPedId())
	local hasParachute = HasPedGotWeapon(PlayerPedId(), GetHashKey('GADGET_PARACHUTE'), false)

	SetPlayerModel(PlayerId(), model)

	Player.Skin = id
	SetPedArmour(ped, armor)
	SetEntityHealth(ped, health)

	if Settings.giveParachuteAtSpawn then
		if hasParachute then
			GiveWeaponToPed(ped, GetHashKey('GADGET_PARACHUTE'), 1, false, false)
		end
	end

	Player.GiveWeapons(weapons)
	SetPedDropsWeaponsWhenDead(PlayerPedId(), false)

	SetModelAsNoLongerNeeded(model)
end
