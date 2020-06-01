Network = { }
Network.__index = Network

local logger = Logger.New('Network')

local _netIds = { }

local _warned = false
local _netIdCountToWarn = 150

RegisterNetEvent('lsv:netIdCreated')
AddEventHandler('lsv:netIdCreated', function(netId, netData)
	local player = source

	if not _netIds[netId] then
		_netIds[netId] = netData

		if not _warned then
			if table.length(_netIds) > _netIdCountToWarn then
				logger:warn('Too many network ids, there\'s probably a leak!')
				_warned = true
			end
		end

		TriggerClientEvent('lsv:netIdCreated', -1, netId, netData)
	end
end)

RegisterNetEvent('lsv:netIdRemoved')
AddEventHandler('lsv:netIdRemoved', function(netId)
	if _netIds[netId] then
		_netIds[netId] = nil
		TriggerClientEvent('lsv:netIdsRemoved', -1, { netId })
	end
end)

RegisterNetEvent('lsv:removeNetId')
AddEventHandler('lsv:removeNetId', function(netId)
	if _netIds[netId] then
		_netIds[netId].delete = true
		TriggerClientEvent('lsv:removeNetIds', -1, { netId })
	end
end)

AddSignalHandler('lsv:playerConnected', function(player)
	TriggerClientEvent('lsv:initNetworkIds', player, _netIds)
end)

AddSignalHandler('lsv:playerDropped', function(player)
	local netIdsToRemove = { }

	table.foreach(_netIds, function(netData, netId)
		if netData.creator == player then
			table.insert(netIdsToRemove, netId)
		end
	end)

	if #netIdsToRemove ~= 0 then
		TriggerClientEvent('lsv:removeNetIds', -1, netIdsToRemove)
	end
end)
