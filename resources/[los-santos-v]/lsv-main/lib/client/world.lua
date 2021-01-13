World = { }
World.__index = World

World.HotPropertyPlayer = nil
World.BeastPlayer = nil
World.KingOfTheCastlePlayer = nil

local _wantedEnabled = true

local _pedHandlers = { }
local _vehicleHandlers = { }
local _objectHandlers = { }

local function enumerateEntitiesAsync(initFunc, moveFunc, disposeFunc, func, handlers)
	local iter, entity = initFunc()

	if iter == -1 or not entity or entity == 0 then
		disposeFunc(iter)
		return
	end

	local finished = false
	repeat
		func(entity)
		Citizen.Wait(0)
		finished, entity = moveFunc(iter)
	until not finished

	disposeFunc(iter)
end

local function processHandlers(entity, handlers)
	if DoesEntityExist(entity) then
		for _, handlerFunc in ipairs(handlers) do
			handlerFunc(entity)
		end
	end
end

function World.GetDistance(pos1, pos2, useZ)
	return math.sqrt((pos1.x - pos2.x)^2 + (pos1.y - pos2.y)^2 + (useZ and ((pos1.z - pos2.z)^2) or 0))
end

function World.TryGetClosestVehicleNode(entity, maxDistance)
	local entityPos = GetEntityCoords(entity)
	local success, position, heading = GetNthClosestVehicleNodeWithHeading(entityPos.x, entityPos.y, entityPos.z, GetRandomIntInRange(2, 5))

	if not success or World.GetDistance(entityPos, position, true) > maxDistance then
		return nil
	end

	return { position = position, heading = heading }
end

function World.EnablePvp(enabled)
	NetworkSetFriendlyFireOption(enabled)
	SetCanAttackFriendly(PlayerPedId(), enabled, enabled)
end

function World.EnableWanted(enabled)
	local player = PlayerId()

	SetIgnoreLowPriorityShockingEvents(player, not enabled)
	SetPoliceIgnorePlayer(player, not enabled)
	SetDispatchCopsForPlayer(player, enabled)

	if not enabled then
		SetPlayerWantedLevel(player, 0, false)
		SetPlayerWantedLevelNow(player, false)
	end

	SetMaxWantedLevel(enabled and 5 or 0)

	_wantedEnabled = enabled
end

function World.SetWantedLevel(level, maxLevel, permanent)
	if not _wantedEnabled then
		return
	end

	if not maxLevel then
		maxLevel = 5
	end

	local player = PlayerId()

	if permanent then
		SetPlayerWantedLevelNoDrop(player, level, false)
	else
		SetPlayerWantedLevel(player, level, false)
	end
	SetPlayerWantedLevelNow(player, false)

	SetMaxWantedLevel(maxLevel)
end

function World.DeleteEntity(entity)
	if not DoesEntityExist(entity) then
		return
	end

	if not IsEntityAMissionEntity(entity) then
		SetEntityAsMissionEntity(entity, false, true)
	end
	DeleteEntity(entity)
end

function World.AddPedHandler(handlerFunc)
	table.insert(_pedHandlers, handlerFunc)
end

function World.AddVehicleHandler(handlerFunc)
	table.insert(_vehicleHandlers, handlerFunc)
end

function World.AddObjectHandler(handlerFunc)
	table.insert(_objectHandlers, handlerFunc)
end

AddEventHandler('lsv:init', function()
	Citizen.CreateThread(function()
		while true do
			enumerateEntitiesAsync(FindFirstPed, FindNextPed, EndFindPed, function(ped)
				processHandlers(ped, _pedHandlers)
			end)
		end
	end)

	Citizen.CreateThread(function()
		while true do
			enumerateEntitiesAsync(FindFirstVehicle, FindNextVehicle, EndFindVehicle, function(vehicle)
				processHandlers(vehicle, _vehicleHandlers)
			end)
		end
	end)

	Citizen.CreateThread(function()
		while true do
			enumerateEntitiesAsync(FindFirstObject, FindNextObject, EndFindObject, function(object)
				processHandlers(object, _objectHandlers)
			end)
		end
	end)
end)
