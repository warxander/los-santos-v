RegisterServerEvent('lsv:assetRecoveryFinished')
AddEventHandler('lsv:assetRecoveryFinished', function()
	local player = source

	Db.UpdateRP(player, Settings.assetRecovery.reward, function()
		TriggerClientEvent('lsv:assetRecoveryFinished', player, true)
	end)
end)