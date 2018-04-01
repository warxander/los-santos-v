RegisterServerEvent('lsv:distractCopsFinished')
AddEventHandler('lsv:distractCopsFinished', function()
	local player = source

	Db.UpdateRP(player, Settings.distractCops.reward, function()
		TriggerClientEvent('lsv:distractCopsFinished', player, true)
	end)
end)