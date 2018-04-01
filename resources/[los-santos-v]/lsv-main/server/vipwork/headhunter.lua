RegisterServerEvent('lsv:headhunterFinished')
AddEventHandler('lsv:headhunterFinished', function()
	local player = source

	Db.UpdateRP(player, Settings.headhunter.reward, function()
		TriggerClientEvent('lsv:headhunterFinished', player, true)
	end)
end)