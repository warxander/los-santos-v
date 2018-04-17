RegisterServerEvent('lsv:updatePlayerSkin')
AddEventHandler('lsv:updatePlayerSkin', function(id)
	local player = source

	if Scoreboard.GetPlayerKills(player) >= Settings.skins[id].kills then
		Db.SetValue(player, "SkinModel", Db.ToString(id), function()
			TriggerClientEvent('lsv:playerSkinUpdated', player, id)
		end)
	else TriggerClientEvent('lsv:playerSkinUpdated', player, nil) end
end)