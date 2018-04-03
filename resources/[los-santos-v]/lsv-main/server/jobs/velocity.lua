RegisterServerEvent('lsv:velocityFinished')
AddEventHandler('lsv:velocityFinished', function()
	local player = source

	Db.UpdateRP(player, Settings.velocity.reward, function()
		TriggerClientEvent('lsv:velocityFinished', player, true)
	end)
end)