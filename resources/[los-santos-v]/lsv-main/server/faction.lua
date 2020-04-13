RegisterNetEvent('lsv:joinFaction')
AddEventHandler('lsv:joinFaction', function(faction)
	local player = source
	if not PlayerData.IsExists(player) or PlayerData.GetFaction(player) ~= Settings.faction.Neutral then
		return
	end

	PlayerData.UpdateFaction(player, faction)
	TriggerClientEvent('lsv:playerJoinedFaction', -1, player, faction)
end)

RegisterNetEvent('lsv:leaveFaction')
AddEventHandler('lsv:leaveFaction', function()
	local player = source
	if not PlayerData.IsExists(player) or PlayerData.GetFaction(player) == Settings.faction.Neutral then
		return
	end

	PlayerData.UpdateFaction(player, Settings.faction.Neutral)
	TriggerClientEvent('lsv:playerJoinedFaction', player, player, Settings.faction.Neutral)
end)
