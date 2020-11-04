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
	if not _netIds[netId] or not _netIds[netId].delete or not NetworkDoesEntityExistWithNetworkId(netId) or not Network.RequestEntityControl(netId) then
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

local function setupNetworkedEntity(netId, data)
	SetNetworkIdExistsOnAllMachines(netId, true)
	TriggerServerEvent('lsv:netIdCreated', netId, makeNetData(netId, data))
end

local function scheduleDeleteNetId(netId, timeout, toEntityFunc)
	SetTimeout(timeout or 0, function()
		if NetworkDoesEntityExistWithNetworkId(netId) and NetworkHasControlOfNetworkId(netId) then
			deleteEntity(toEntityFunc(netId), netId)
		elseif _netIds[netId] and not _netIds[netId].delete then
			TriggerServerEvent('lsv:removeNetId', netId)
		end
	end)
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
	setupNetworkedEntity(netId, data)

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

function Network.DoesEntityExistWithNetworkId(netId)
	local netData = _netIds[netId]
	return netData and not netData.delete and NetworkDoesEntityExistWithNetworkId(netId)
end

function Network.RequestEntityControl(netId)
	NetworkRequestControlOfNetworkId(netId)
	return NetworkHasControlOfNetworkId(netId)
end

function Network.GetData(netId, dataKey)
	return _netIds[netId][dataKey]
end

function Network.GetCreator(netId)
	return _netIds[netId].creator
end

function Network.RegisterVehicle(vehicle, data)
	return registerEntity(vehicle, VehToNet, data)
end

function Network.CreatePed(pedType, modelHash, position, heading, data)
	if not CanRegisterMissionPeds(1) then
		return nil
	end

	RequestCollisionAtCoord(position.x, position.y, position.z)
	local ped = CreatePed(pedType, modelHash, position.x, position.y, position.z, heading or GetRandomFloatInRange(0., 360.), true, true)

	local netId = PedToNet(ped)
	setupNetworkedEntity(netId, data)

	return netId
end

function Network.CreatePedInsideVehicle(vehicleNet, pedType, modelHash, seat, data)
	if not CanRegisterMissionPeds(1) then
		return nil
	end

	if not NetworkDoesNetworkIdExist(vehicleNet) then
		return nil
	end

	local vehicle = NetToVeh(vehicleNet)
	if not IsVehicleDriveable(vehicle, false) then
		return nil
	end

	local ped = CreatePedInsideVehicle(vehicle, pedType, modelHash, seat, true, true)

	local netId = PedToNet(ped)
	setupNetworkedEntity(netId, data)

	return netId
end

function Network.CreateVehicle(modelHash, position, heading, data)
	if not CanRegisterMissionVehicles(1) then
		return nil
	end

	RequestCollisionAtCoord(position.x, position.y, position.z)
	local vehicle = CreateVehicle(modelHash, position.x, position.y, position.z, heading or GetRandomFloatInRange(0., 360.), true, true)

	local netId = VehToNet(vehicle)
	setupNetworkedEntity(netId, data)

	return netId
end

function Network.DeletePed(netId, timeout)
	scheduleDeleteNetId(netId, timeout, NetToPed)
end

function Network.DeleteVehicle(netId, timeout)
	scheduleDeleteNetId(netId, timeout, NetToVeh)
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
