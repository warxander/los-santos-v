local _killedMessages = {
	'killed',
	'destroyed',
	'finished',
	'ended',
	'murdered',
	'wiped out',
	'executed',
	'erased',
	'whacked',
	'deaded',
	'slayed',
	'atomized',
	'assassinated',
	'fucked up',
	'annihilated',
	'floored',
	'picked off',
	'shutdown',
	'dissolved',
	'devastated',
	'flattened',
	'pulverized',
	'ceased',
	'scrapped',
}

local _lastKillers = { }

RegisterNetEvent('lsv:onPlayerDied')
AddEventHandler('lsv:onPlayerDied', function(isSuicide)
	local player = source

	if not PlayerData.IsExists(player) then
		return
	end

	PlayerData.UpdateDeaths(player, isSuicide)
	TriggerClientEvent('lsv:onPlayerDied', -1, player, isSuicide)
end)

RegisterNetEvent('lsv:onPlayerKilled')
AddEventHandler('lsv:onPlayerKilled', function(killData)
	local victim = source
	local killer = killData.killer

	if not PlayerData.IsExists(killer) or not PlayerData.IsExists(victim) then
		return
	end

	local killDetails = { }

	PlayerData.UpdateKills(killer)
	PlayerData.UpdateLongestKillDistance(killer, killData.killDistance)

	if killData.weaponHash then
		PlayerData.UpdateWeaponStats(killer, killData.weaponHash)
	end

	if killData.isKillerInVehicle then
		PlayerData.UpdateVehicleKills(killer)
	end

	local killerKillstreak = PlayerData.GetKillstreak(killer)
	local killerCash = Settings.cashPerKill
	local killerExp = Settings.expPerKill

	if killerKillstreak > 1 then
		killerCash = killerCash + math.min(Settings.maxCashPerKillstreak, Settings.cashPerKillstreak * (killerKillstreak - 1))
		killerExp = killerExp + math.min(Settings.maxExpPerKillstreak, Settings.expPerKillstreak * (killerKillstreak - 1))
		killDetails.killstreak = killerKillstreak

		if killerKillstreak == Settings.bounty.killstreak then
			TriggerClientEvent('lsv:bountyWasSet', -1, killer)
		end
	end

	if killData.headshot then
		PlayerData.UpdateHeadshots(killer)

		killerCash = killerCash + Settings.cashPerHeadshot
		killerExp = killerExp + Settings.expPerHeadshot

		killDetails.headshot = true
	end

	if killData.weaponGroup == -1609580060 or killData.weaponGroup == -728555052 then -- MELEE
		killerCash = killerCash + Settings.cashPerMelee
		killerExp = killerExp + Settings.expPerMelee

		killDetails.meleeKill = true
	end

	if MissionManager.IsPlayerOnMission(victim) then
		killerCash = killerCash + Settings.cashPerMission
		killerExp = killerExp + Settings.expPerMission

		killDetails.brokenDeal = true
	end

	if PlayerData.GetKillstreak(victim) >= Settings.bounty.killstreak then
		killerCash = killerCash + Settings.bounty.reward.cash
		killerExp = killerExp + Settings.bounty.reward.exp

		killDetails.bountyHunter = true
	end

	if PlayerData.GetCrewLeader(killer) then
		if PlayerData.GetCrewLeader(victim) == victim then
			killerCash = killerCash + Settings.cashPerCrewLeader
			killerExp = killerExp + Settings.expPerCrewLeader

			killDetails.kingSlayer = true
		end
	end

	local lastKiller = _lastKillers[killer]
	if lastKiller == victim then
		killerCash = killerCash + Settings.cashPerRevenge
		killerExp = killerExp + Settings.expPerRevenge

		killDetails.revenge = true

		_lastKillers[killer] = nil
	end

	_lastKillers[victim] = killer

	local patreonTier = PlayerData.GetPatreonTier(killer)
	if patreonTier ~= 0 then
		killDetails.patreonBonus = Settings.patreon.reward[patreonTier]
	end

	if killData.isKillerInVehicle and not killData.isVictimInVehicle then
		killerCash = math.floor(killerCash * Settings.cashVehicleMultiplier)
		killerExp = math.floor(killerExp * Settings.expVehicleMultiplier)
	end

	PlayerData.UpdateCash(killer, killerCash)
	PlayerData.UpdateExperience(killer, killerExp)

	local deathMessage = killData.headshot and 'headshot' or table.random(_killedMessages)

	local killstreak = nil
	if killerKillstreak >= Settings.minKillstreakNotification then
		killstreak = killerKillstreak
	end

	TriggerClientEvent('lsv:onPlayerKilled', -1, victim, killer, deathMessage, killstreak)
	TriggerClientEvent('lsv:updateLastKillDetails', killer, killDetails)

	PlayerData.UpdateDeaths(victim)
end)

AddEventHandler('lsv:playerDropped', function(player)
	_lastKillers[player] = nil
end)
