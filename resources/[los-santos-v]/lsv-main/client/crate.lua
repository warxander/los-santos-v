local crateData = nil


RegisterNetEvent('lsv:spawnCrate')
AddEventHandler('lsv:spawnCrate', function(crate)
	if crateData then return end
	crateData = { }

	Citizen.Wait(5000)

	PlaySoundFrontend(-1, 'CONFIRM_BEEP', 'HUD_MINI_GAME_SOUNDSET', true)
	Gui.DisplayPersonalNotification('We have been dropped a Special Crate for your achievements.', 'CHAR_AMMUNATION', 'Ammu-Nation', '', 2)

	crateData.pickup = CreatePickupRotate(GetHashKey('PICKUP_PORTABLE_CRATE_UNFIXED'), crate.position.x, crate.position.y, crate.position.z, 0.0, 0.0, 0.0, 512)
	crateData.position = crate.position
	crateData.location = crate.location
	crateData.areaBlip = Map.CreateRadiusBlip(crate.location.x, crate.location.y, crate.location.z, Settings.crate.radius, Color.BlipYellow())
	crateData.blip = Map.CreatePlaceBlip(Blip.CrateDrop(), crate.location.x, crate.location.y, crate.location.z, nil, Color.BlipYellow())
	SetBlipAsShortRange(crateData.blip, false)
	SetBlipScale(crateData.blip, 1.5)
	Map.SetBlipFlashes(crateData.blip)

	FlashMinimapDisplay()

	while true do
		Citizen.Wait(0)

		if HasPickupBeenCollected(crateData.pickup) then
			TriggerServerEvent('lsv:cratePickedUp')
			return
		end

		if Player.IsInFreeroam() then
			if Player.DistanceTo(crateData.location) < Settings.crate.radius then
				Gui.DrawProgressBar('CRATE DISTANCE', 1.0 - Player.DistanceTo(crateData.position) / Settings.crate.radius, Color.GetHudFromBlipColor(Color.BlipYellow()))
			end
		end
	end
end)


RegisterNetEvent('lsv:cratePickedUp')
AddEventHandler('lsv:cratePickedUp', function(crate)
	local playerPed = PlayerPedId()

	SetPedArmour(playerPed, GetPlayerMaxArmour(PlayerId()))
	GiveWeaponToPed(playerPed, GetHashKey(crate.weapon.id), crate.weapon.ammo, false, true)

	Gui.DisplayPersonalNotification('Crate Contents:~w~\n+ $'..Settings.crate.reward.cash..'\n+ '..crate.weapon.name..'\n+ Body Armor')
	Player.SaveWeapons()

	RemoveBlip(crateData.areaBlip)
	RemoveBlip(crateData.blip)
	crateData = nil
end)