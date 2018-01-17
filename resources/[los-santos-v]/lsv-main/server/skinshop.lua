RegisterServerEvent('lsv:updatePlayerSkin')
AddEventHandler('lsv:updatePlayerSkin', function(skin)
	local player = source

	Db.SetValue(player, "SkinModel", Db.ToString(skin), function()
		TriggerClientEvent('lsv:playerSkinUpdated', player, skin)
	end)
end)