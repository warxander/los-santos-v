local logger = Logger.New('Travel')


RegisterNetEvent('lsv:useFastTravel')
AddEventHandler('lsv:useFastTravel', function(travelIndex)
	local player = source
	if not Scoreboard.IsPlayerOnline(player) then return end

	local travelCost = Scoreboard.GetPlayerRank(player) * Settings.travel.cashPerRank

	if Scoreboard.GetPlayerCash(player) > travelCost then
		Db.UpdateCash(player, -travelCost, function()
			TriggerClientEvent('lsv:useFastTravel', player, travelIndex, true)
		end)
		logger:Info('Use { '..travelIndex..', '..travelCost..' }')
	else TriggerClientEvent('lsv:useFastTravel', player, travelIndex, nil) end
end)