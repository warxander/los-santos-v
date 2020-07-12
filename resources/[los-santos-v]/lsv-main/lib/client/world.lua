World = { }
World.__index = World

World.HotPropertyPlayer = nil
World.BeastPlayer = nil
World.KingOfTheCastlePlayer = nil

local _wantedEnabled = true

local _pedHandlers = { }
local _vehicleHandlers = { }

local function enumerateEntities(initFunc, moveFunc, disposeFunc, func, handlers)
	local iter, entity = initFunc()

	if iter == -1 or not entity or entity == 0 then
		disposeFunc(iter)
		return
	end

	local finished = false
	repeat
		func(entity)
		finished, entity = moveFunc(iter)
	until not finished

	disposeFunc(iter)
end

local function processHandlers(entity, handlers)
	if DoesEntityExist(entity) then
		table.iforeach(handlers, function(handlerFunc)
			handlerFunc(entity)
		end)
	end
end

function World.GetDistance(pos1, pos2, useZ)
	return GetDistanceBetweenCoords(pos1.x, pos1.y, pos1.z, pos2.x, pos2.y, pos2.z, useZ)
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

AddEventHandler('lsv:init', function()
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)

			enumerateEntities(FindFirstPed, FindNextPed, EndFindPed, function(ped)
				processHandlers(ped, _pedHandlers)
			end)
		end
	end)

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)

			enumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle, function(vehicle)
				processHandlers(vehicle, _vehicleHandlers)
			end)
		end
	end)
end)
