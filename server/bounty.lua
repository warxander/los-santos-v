local bountyPlayerId = nil
local players = { }


AddEventHandler('lsv:setRandomBounty', function()
	if Utils.GetTableLength(players) > 1 and not bountyPlayerId then
		bountyPlayerId = Utils.GetRandom(players)

		Citizen.Trace('>>> setRandomBounty: { '..tostring(GetPlayerName(bountyPlayerId))..', '..tostring(bountyPlayerId)..' }\n')

		TriggerClientEvent('lsv:setBounty', -1, bountyPlayerId)
	end
end)


AddEventHandler('lsv:bountyOnPlayerConnected', function(player)
	table.insert(players, player)
	if bountyPlayerId then
		TriggerClientEvent('lsv:setBounty', player, bountyPlayerId)
	elseif Utils.GetTableLength(players) >= 2 then
		TriggerEvent('lsv:setRandomBounty')
	end
end)


AddEventHandler('lsv:bountyOnPlayerDropped', function(player)
	table.remove(players, Utils.Index(players, player))

	if player == bountyPlayerId then
		Citizen.Trace('>>> bountyDropped: { '..tostring(bountyPlayerId)..' }\n')
		bountyPlayerId = nil
		TriggerClientEvent('lsv:setBounty', -1, bountyPlayerId)
		SetTimeout(Settings.bountyEventTimeout, function()
			TriggerEvent('lsv:setRandomBounty')
		end)
	end
end)


RegisterServerEvent('lsv:bountyKilled')
AddEventHandler('lsv:bountyKilled', function()
	Citizen.Trace('>>> bountyKilled: { '..tostring(GetPlayerName(bountyPlayerId))..', '..tostring(bountyPlayerId)..' }\n')
	bountyPlayerId = nil
	TriggerClientEvent('lsv:bountyKilled', -1, source)
	SetTimeout(Settings.bountyEventTimeout, function()
		TriggerEvent('lsv:setRandomBounty')
	end)
end)