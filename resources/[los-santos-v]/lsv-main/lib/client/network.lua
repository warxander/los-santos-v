Network = { }
Network.__index = Network

local _netIds = { }

local function deleteEntity(entity, netId)
	World.DeleteEntity(entity)

	if _netIds[netId] then
		_netIds[netId] = nil
		TriggerServerEvent('lsv:netIdRemoved', netId)
	end
end

local function tryDeleteEntity(entity, toNetFunc)
	if not NetworkGetEntityIsNetworked(entity) then
		return
	end

	local netId = toNetFunc(entity)
	if not _netIds[netId] or not _netIds[netId].delete or not NetworkDoesEntityExistWithNetworkId(netId) or not NetworkHasControlOfNetworkId(netId) then
		return
	end

	deleteEntity(entity, netId)
end

local function makeNetData(netId, data)
	local netData = {
		creator = Player.ServerId(),
	}

	if data then
		table.foreach(data, function(v, k)
			netData[k] = v
		end)
	end

	return netData
end

local function registerEntity(entity, toNetFunc, data)
	if not DoesEntityExist(entity) then
		return nil
	end

	if NetworkGetEntityIsNetworked(entity) then
		return toNetFunc(entity)
	end

	NetworkRegisterEntityAsNetworked(entity)

	local netId = toNetFunc(entity)
	if not NetworkDoesNetworkIdExist(netId) then
		return nil
	end

	TriggerServerEvent('lsv:netIdCreated', netId, makeNetData(netId, data))

	return netId
end

RegisterNetEvent('lsv:initNetworkIds')
AddEventHandler('lsv:initNetworkIds', function(netIds)
	_netIds = netIds
end)

RegisterNetEvent('lsv:netIdCreated')
AddEventHandler('lsv:netIdCreated', function(netId, netData)
	_netIds[netId] = netData
end)

RegisterNetEvent('lsv:netIdsRemoved')
AddEventHandler('lsv:netIdsRemoved', function(netIds)
	table.iforeach(netIds, function(netId)
		_netIds[netId] = nil
	end)
end)

RegisterNetEvent('lsv:removeNetIds')
AddEventHandler('lsv:removeNetIds', function(netIds)
	table.iforeach(netIds, function(netId)
		if _netIds[netId] then
			_netIds[netId].delete = true
		end
	end)
end)

function Network.RegisterVehicle(vehicle, data)
	return registerEntity(vehicle, VehToNet, data)
end

function Network.RegisterPed(ped, data)
	return registerEntity(ped, PedToNet, data)
end

function Network.CreatePedAsync(pedType, modelHash, position, heading, data)
	Streaming.RequestModelAsync(modelHash)

	if not CanRegisterMissionPeds(1) then
		return nil
	end

	local ped = CreatePed(pedType, modelHash, position.x, position.y, position.z, heading or GetRandomFloatInRange(0., 360.), true, true)
	local netId = PedToNet(ped)

	if not NetworkDoesNetworkIdExist(netId) then
		return nil
	end

	SetNetworkIdExistsOnAllMachines(netId, true)

	TriggerServerEvent('lsv:netIdCreated', netId, makeNetData(netId, data))

	return netId
end

function Network.CreateVehicleAsync(modelHash, position, heading, data)
	Streaming.RequestModelAsync(modelHash)

	if not CanRegisterMissionVehicles(1) then
		return nil
	end

	local vehicle = CreateVehicle(modelHash, position.x, position.y, position.z, heading or GetRandomFloatInRange(0., 360.), true, true)
	local netId = VehToNet(vehicle)

	if not NetworkDoesNetworkIdExist(netId) then
		return nil
	end

	SetNetworkIdExistsOnAllMachines(netId, true)
	TriggerServerEvent('lsv:netIdCreated', netId, makeNetData(netId, data))

	return netId
end

function Network.DeletePed(netId, timeout)
	SetTimeout(timeout or 0, function()
		if NetworkDoesNetworkIdExist(netId) then
			if NetworkHasControlOfNetworkId(netId) then
				deleteEntity(NetToPed(netId), netId)
			elseif _netIds[netId] then
				TriggerServerEvent('lsv:removeNetId', netId)
			end
		end
	end)
end

function Network.DeleteVehicle(netId, timeout)
	SetTimeout(timeout or 0, function()
		if NetworkDoesNetworkIdExist(netId) then
			if NetworkHasControlOfNetworkId(netId) then
				deleteEntity(NetToVeh(netId), netId)
			elseif _netIds[netId] then
				TriggerServerEvent('lsv:removeNetId', netId)
			end
		end
	end)
end

-- Network Removals
AddEventHandler('lsv:init', function()
	World.AddPedHandler(function(ped)
		if not IsPedAPlayer(ped) then
			tryDeleteEntity(ped, PedToNet)
		end
	end)

	World.AddVehicleHandler(function(vehicle)
		tryDeleteEntity(vehicle, VehToNet)
	end)
end)
