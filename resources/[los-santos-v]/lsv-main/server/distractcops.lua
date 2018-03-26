RegisterServerEvent('lsv:distractCopsFinished')
AddEventHandler('lsv:distractCopsFinished', function()
	local player = source

	Db.UpdateRP(player, Settings.distractCopsReward, function()
		TriggerClientEvent('lsv:distractCopsFinished', player, true)
	end)
end)