RegisterServerEvent('lsv:updateWeaponTint')
AddEventHandler('lsv:updateWeaponTint', function(weaponHash, weaponTintIndex)
	local player = source

	local isEnoughRP = Scoreboard.GetPlayerRP(player) >= Settings.weaponTints[weaponTintIndex].RP

	TriggerClientEvent('lsv:weaponTintUpdated', player, isEnoughRP and weaponHash, weaponTintIndex)
end)


RegisterServerEvent('lsv:updateWeaponComponent')
AddEventHandler('lsv:updateWeaponComponent', function(weapon, componentIndex)
	local player = source

	local isEnoughRP = Scoreboard.GetPlayerRP(player) >= Weapon.GetWeapon(weapon).components[componentIndex].RP

	TriggerClientEvent('lsv:weaponComponentUpdated', player, isEnoughRP and weapon, componentIndex)
end)