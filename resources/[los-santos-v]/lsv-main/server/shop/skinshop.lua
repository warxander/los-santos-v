RegisterNetEvent('lsv:updatePlayerSkin')
AddEventHandler('lsv:updatePlayerSkin', function(id)
	local player = source

	if not Scoreboard.IsPlayerOnline(player) then return end

	local skin = Settings.skins[id]

	if skin.rank and Scoreboard.GetPlayerRank(player) < skin.rank then return end
	if skin.kills and Scoreboard.GetPlayerKills(player) < skin.kills then return end
	if skin.prestige and Scoreboard.GetPlayerPrestige(player) < skin.prestige then return end

	Db.SetValue(player, 'SkinModel', Db.ToString(id), function()
		TriggerClientEvent('lsv:playerSkinUpdated', player, id)
	end)
end)