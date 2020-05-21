RegisterNetEvent('lsv:updateWeaponTint')
AddEventHandler('lsv:updateWeaponTint', function(weaponHash, tintIndex)
	local player = source
	if not PlayerData.IsExists(player) then
		return
	end

	local tint = Settings.weaponTints[tintIndex]
	if PlayerData.GetKills(player) < tint.kills then
		return
	end

	if PlayerData.GetCash(player) >= tint.cash then
		PlayerData.UpdateCash(player, -tint.cash)
		TriggerClientEvent('lsv:weaponTintUpdated', player, weaponHash, tint.index)
	else
		TriggerClientEvent('lsv:weaponTintUpdated', player, nil)
	end
end)

RegisterNetEvent('lsv:updateWeaponComponent')
AddEventHandler('lsv:updateWeaponComponent', function(weapon, componentIndex)
	local player = source
	if not PlayerData.IsExists(player) then
		return
	end

	local component = Weapon[weapon].components[componentIndex]
	if component.rank and component.rank > PlayerData.GetRank(player) then
		return
	end

	if PlayerData.GetCash(player) >= component.cash then
		PlayerData.UpdateCash(player, -component.cash)
		TriggerClientEvent('lsv:weaponComponentUpdated', player, weapon, componentIndex)
	else
		TriggerClientEvent('lsv:weaponComponentUpdated', player, nil)
	end
end)

RegisterNetEvent('lsv:purchaseWeapon')
AddEventHandler('lsv:purchaseWeapon', function(id, category)
	local player = source
	if not PlayerData.IsExists(player) or not Settings.ammuNationWeapons[category] or not table.ifind(Settings.ammuNationWeapons[category], id) then
		return
	end

	local weapon = Weapon[id]

	if weapon.rank and weapon.rank > PlayerData.GetRank(player) then
		return
	end

	if weapon.prestige and weapon.prestige > PlayerData.GetPrestige(player) then
		return
	end

	if PlayerData.GetCash(player) >= weapon.cash then
		PlayerData.UpdateCash(player, -weapon.cash)
		TriggerClientEvent('lsv:weaponPurchased', player, id)
	else
		TriggerClientEvent('lsv:weaponPurchased', player, nil)
	end
end)

RegisterNetEvent('lsv:refillAmmo')
AddEventHandler('lsv:refillAmmo', function(ammoType, weapon, ammoClipCount)
	local player = source
	if not PlayerData.IsExists(player) then
		return
	end

	local fullAmmo = ammoClipCount
	if not ammoClipCount then
		ammoClipCount = 1
	end

	local refillPrice = ammoClipCount * Settings.ammuNationRefillAmmo[ammoType].price

	if PlayerData.GetCash(player) >= refillPrice then
		PlayerData.UpdateCash(player, -refillPrice)
		TriggerClientEvent('lsv:ammoRefilled', player, weapon, Settings.ammuNationRefillAmmo[ammoType].ammo * ammoClipCount, fullAmmo)
	else
		TriggerClientEvent('lsv:ammoRefilled', player, weapon, nil)
	end
end)

RegisterNetEvent('lsv:refillSpecialAmmo')
AddEventHandler('lsv:refillSpecialAmmo', function(weapon, ammoClipCount)
	local player = source
	if not PlayerData.IsExists(player) then
		return
	end

	local fullAmmo = ammoClipCount
	if not ammoClipCount then
		ammoClipCount = 1
	end

	local refillPrice = ammoClipCount * Settings.ammuNationSpecialAmmo[weapon].price

	if PlayerData.GetCash(player) >= refillPrice then
		PlayerData.UpdateCash(player, -refillPrice)
		TriggerClientEvent('lsv:specialAmmoRefilled', player, weapon, Settings.ammuNationSpecialAmmo[weapon].ammo * ammoClipCount, fullAmmo)
	else
		TriggerClientEvent('lsv:specialAmmoRefilled', player, weapon, nil)
	end
end)
