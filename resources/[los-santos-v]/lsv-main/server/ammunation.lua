RegisterServerEvent('lsv:updateWeaponTint')
AddEventHandler('lsv:updateWeaponTint', function(weaponHash, weaponTintIndex)
	local player = source

	local isNotEnoughRP = Scoreboard.GetPlayerRP(player) < Settings.weaponTints[weaponTintIndex].RP

	TriggerClientEvent('lsv:weaponTintUpdated', player, isNotEnoughRP or weaponHash, isNotEnoughRP or weaponTintIndex)
end)