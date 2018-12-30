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


RegisterServerEvent('lsv:purchaseWeapon')
AddEventHandler('lsv:purchaseWeapon', function(weapon)
	local player = source

	local weaponPrice = Weapon.GetWeapon(weapon).cash

	if Scoreboard.GetPlayerCash(player) >= weaponPrice then
		Db.UpdateCash(player, -weaponPrice, function()
			TriggerClientEvent('lsv:weaponPurchased', player, weapon)
		end)
	else TriggerClientEvent('lsv:weaponPurchased', player, nil) end
end)




RegisterServerEvent('lsv:refillAmmo')
AddEventHandler('lsv:refillAmmo', function(ammoType, weapon)
	local player = source

	local refillPrice = Settings.ammuNationRefillAmmo[ammoType].price

	if Scoreboard.GetPlayerCash(player) >= refillPrice then
		Db.UpdateCash(player, -refillPrice, function()
			TriggerClientEvent('lsv:ammoRefilled', player, weapon, Settings.ammuNationRefillAmmo[ammoType].ammo)
		end)
	else TriggerClientEvent('lsv:ammoRefilled', player, weapon, nil) end
end)
