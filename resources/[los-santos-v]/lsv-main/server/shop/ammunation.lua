RegisterServerEvent('lsv:updateWeaponTint')
AddEventHandler('lsv:updateWeaponTint', function(weaponHash, weaponTintIndex)
	local player = source

	local isEnoughKills = Scoreboard.GetPlayerKills(player) >= Settings.weaponTints[weaponTintIndex].kills

	TriggerClientEvent('lsv:weaponTintUpdated', player, isEnoughKills and weaponHash, weaponTintIndex)
end)


RegisterServerEvent('lsv:updateWeaponComponent')
AddEventHandler('lsv:updateWeaponComponent', function(weapon, componentIndex)
	local player = source

	local componentPrice = Weapon.GetWeapon(weapon).components[componentIndex].cash

	if Scoreboard.GetPlayerCash(player) >= componentPrice then
		Db.UpdateCash(player, -componentPrice, function()
			TriggerClientEvent('lsv:weaponComponentUpdated', player, weapon, componentIndex)
		end)
	else TriggerClientEvent('lsv:weaponComponentUpdated', player, nil) end
end)