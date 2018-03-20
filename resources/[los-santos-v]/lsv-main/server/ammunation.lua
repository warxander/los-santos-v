local function updateLoadout(dbField, weapon, playerSource, callbackEventName)
	if not weapon then return end
	Db.SetValue(playerSource, dbField, Db.ToString(weapon.id), function()
		TriggerClientEvent(callbackEventName, playerSource, weapon.id)
	end)
end


RegisterServerEvent('lsv:updateMeleeWeapon')
AddEventHandler('lsv:updateMeleeWeapon', function(weaponId)
	updateLoadout('MeleeWeapon', Weapon.GetWeaponById(weaponId), source, 'lsv:meleeWeaponUpdated')
end)


RegisterServerEvent('lsv:updatePrimaryWeapon')
AddEventHandler('lsv:updatePrimaryWeapon', function(weaponId)
	updateLoadout('PrimaryWeapon', Weapon.GetWeaponById(weaponId), source, 'lsv:primaryWeaponUpdated')
end)


RegisterServerEvent('lsv:updateSecondaryWeapon')
AddEventHandler('lsv:updateSecondaryWeapon', function(weaponId)
	updateLoadout('SecondaryWeapon', Weapon.GetWeaponById(weaponId), source, 'lsv:secondaryWeaponUpdated')
end)


RegisterServerEvent('lsv:updateGadget1')
AddEventHandler('lsv:updateGadget1', function(gadget1)
	updateLoadout('Gadget1', Weapon.GetWeaponById(gadget1), source, 'lsv:gadget1Updated')
end)


RegisterServerEvent('lsv:updateGadget2')
AddEventHandler('lsv:updateGadget2', function(gadget2)
	updateLoadout('Gadget2', Weapon.GetWeaponById(gadget2), source, 'lsv:gadget2Updated')
end)