Skin = { }


function Skin.ChangePlayerSkin(id)
	ResetPedMovementClipset(PlayerPedId(), 0.0)

	local model = GetHashKey(id)

	Streaming.RequestModel(id)

	local weapons = Player.GetPlayerWeapons()
	local health = GetEntityHealth(PlayerPedId())
	local armor = GetPedArmour(PlayerPedId())
	local isHasParachute = HasPedGotWeapon(PlayerPedId(), GetHashKey("GADGET_PARACHUTE"), false)

	SetPlayerModel(PlayerId(), model)

	-- https://forum.fivem.net/t/info-invisible-or-glitched-peds-list-wiki/40748/23
	SetPedComponentVariation(PlayerPedId(), 0, 0, 1, 0)
	SetTimeout(1000, function()
		if IsPedModel(PlayerPedId(), model) then SetPedComponentVariation(PlayerPedId(), 0, 0, 0, 0) end
	end)

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