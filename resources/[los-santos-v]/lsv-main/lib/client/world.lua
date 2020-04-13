World = { }
World.__index = World

World.HotPropertyPlayer = nil
World.BeastPlayer = nil
World.ChallengingPlayer = nil

local _wantedEnabled = true

local function enumerateEntitiesAsync(initFunc, moveFunc, disposeFunc, func)
	local iter, entity = initFunc()

	if iter == -1 or not entity or entity == 0 then
		disposeFunc(iter)
		return
	end

	local finished = false
	repeat
		if func(entity) then
			break
		end

		Citizen.Wait(0)
		finished, entity = moveFunc(iter)
	until not finished

	disposeFunc(iter)
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

function World.ForEachObjectAsync(func)
	enumerateEntitiesAsync(FindFirstObject, FindNextObject, EndFindObject, func)
end

function World.ForEachPedAsync(func)
	enumerateEntitiesAsync(FindFirstPed, FindNextPed, EndFindPed, func)
end

function World.ForEachVehicleAsync(func)
	enumerateEntitiesAsync(FindFirstVehicle, FindNextVehicle, EndFindVehicle, func)
end

function World.ForEachPickupAsync(func)
	enumerateEntitiesAsync(FindFirstPickup, FindNextPickup, EndFindPickup, func)
end
