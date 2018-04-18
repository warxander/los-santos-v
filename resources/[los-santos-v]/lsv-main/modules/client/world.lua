World = { }

local bountyPlayerId = nil


function World.EnablePvp(enabled)
	NetworkSetFriendlyFireOption(enabled)
	SetCanAttackFriendly(PlayerPedId(), enabled, enabled)
end


function World.SetBountyPlayerId(playerId)
	bountyPlayerId = playerId
end


function World.GetBountyPlayerId()
	return bountyPlayerId
end


function World.SetWantedLevel(level)
	local disable = level == 0
	local player = PlayerId()

	if disable or GetPlayerWantedLevel(player) < level then
		SetIgnoreLowPriorityShockingEvents(player, disable)
		SetPoliceIgnorePlayer(player, disable)
		SetDispatchCopsForPlayer(player, not disable)

		local maxLevel = 5
		if disable then maxLevel = 0 end
		SetMaxWantedLevel(maxLevel)

		SetPlayerWantedLevel(player, level, false)
		SetPlayerWantedLevelNow(player, false)
	end
end