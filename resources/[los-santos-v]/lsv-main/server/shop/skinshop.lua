RegisterNetEvent('lsv:updatePlayerSkin')
AddEventHandler('lsv:updatePlayerSkin', function(id)
	local player = source

	if not Scoreboard.IsPlayerOnline(player) then return end

	local skin = Settings.skins[id]

	if Scoreboard.GetPlayerRank(player) < skin.rank then return end
	if Scoreboard.GetPlayerKills(player) < skin.kills then return end

	Db.SetValue(player, 'SkinModel', Db.ToString(id), function()
		TriggerClientEvent('lsv:playerSkinUpdated', player, id)
	end)
end)