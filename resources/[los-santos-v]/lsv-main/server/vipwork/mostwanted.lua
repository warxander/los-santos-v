RegisterServerEvent('lsv:mostWantedFinished')
AddEventHandler('lsv:mostWantedFinished', function()
	local player = source

	Db.UpdateRP(player, Settings.mostWanted.reward, function()
		TriggerClientEvent('lsv:mostWantedFinished', player, true)
	end)
end)