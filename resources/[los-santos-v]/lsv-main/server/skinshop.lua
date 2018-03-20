RegisterServerEvent('lsv:updatePlayerSkin')
AddEventHandler('lsv:updatePlayerSkin', function(id)
	local player = source

	if Scoreboard.GetPlayerStats(player).RP >= Settings.skins[id].RP then
		Db.SetValue(player, "SkinModel", Db.ToString(id), function()
			TriggerClientEvent('lsv:playerSkinUpdated', player, id)
		end)
	else TriggerClientEvent('lsv:playerSkinUpdated', player, nil) end
end)