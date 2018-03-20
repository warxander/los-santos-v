local function updateLoadout(dbField, id, playerSource, callbackEventName)
	if not id then return end
	local weaponRP = Weapon.GetWeapon(id).RP or 0
	if Scoreboard.GetPlayerStats(playerSource).RP >= weaponRP then
		Db.SetValue(playerSource, dbField, Db.ToString(id), function()
			TriggerClientEvent(callbackEventName, playerSource, id)
		end)
	else TriggerClientEvent('lsv:updateLoadoutFailed', playerSource) end
end


RegisterServerEvent('lsv:updateMeleeWeapon')
AddEventHandler('lsv:updateMeleeWeapon', function(weaponId)
	updateLoadout('MeleeWeapon', weaponId, source, 'lsv:meleeWeaponUpdated')
end)


RegisterServerEvent('lsv:updatePrimaryWeapon')
AddEventHandler('lsv:updatePrimaryWeapon', function(weaponId)
	updateLoadout('PrimaryWeapon', weaponId, source, 'lsv:primaryWeaponUpdated')
end)


RegisterServerEvent('lsv:updateSecondaryWeapon')
AddEventHandler('lsv:updateSecondaryWeapon', function(weaponId)
	updateLoadout('SecondaryWeapon', weaponId, source, 'lsv:secondaryWeaponUpdated')
end)


RegisterServerEvent('lsv:updateGadget1')
AddEventHandler('lsv:updateGadget1', function(gadget1)
	updateLoadout('Gadget1', weaponId, source, 'lsv:gadget1Updated')
end)


RegisterServerEvent('lsv:updateGadget2')
AddEventHandler('lsv:updateGadget2', function(gadget2)
	updateLoadout('Gadget2', weaponId, source, 'lsv:gadget2Updated')
end)