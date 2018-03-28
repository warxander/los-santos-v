RegisterServerEvent('lsv:updateWeaponTint')
AddEventHandler('lsv:updateWeaponTint', function(weaponHash, weaponTintIndex)
	local player = source

	local isEnoughRP = Scoreboard.GetPlayerRP(player) >= Settings.weaponTints[weaponTintIndex].RP

	TriggerClientEvent('lsv:weaponTintUpdated', player, isEnoughRP and weaponHash, weaponTintIndex)
end)