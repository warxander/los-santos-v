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

	if killData.isKillerInVehicle then
		PlayerData.UpdateVehicleKills(killer)
	end

	local killerKillstreak = PlayerData.GetKillstreak(killer)
	local killerCash = Settings.cashPerKill
	local killerExp = Settings.expPerKill

	if killerKillstreak > 1 then
		killerCash = killerCash + math.min(Settings.maxCashPerKillstreak, Settings.cashPerKillstreak * (killerKillstreak - 1))
		killerExp = killerExp + math.min(Settings.maxExpPerKillstreak, Settings.expPerKillstreak * (killerKillstreak - 1))
		table.insert(killDetails, 'KILLSTREAK x'..killerKillstreak)

		if killerKillstreak == Settings.bounty.killstreak then
			TriggerClientEvent('lsv:bountyWasSet', -1, killer)
		end
	end

	if killData.headshot then
		PlayerData.UpdateHeadshots(killer)

		killerCash = killerCash + Settings.cashPerHeadshot
		killerExp = killerExp + Settings.expPerHeadshot
		table.insert(killDetails, 'HEADSHOT')
	end

	if killData.weaponGroup == -1609580060 or killData.weaponGroup == -728555052 then -- MELEE
		killerCash = killerCash + Settings.cashPerMelee
		killerExp = killerExp + Settings.expPerMelee
		table.insert(killDetails, 'MELEE KILL')
	end

	if MissionManager.IsPlayerOnMission(victim) then
		killerCash = killerCash + Settings.cashPerMission
		killerExp = killerExp + Settings.expPerMission
		table.insert(killDetails, 'BROKEN DEAL')
	end

	if PlayerData.GetKillstreak(victim) >= Settings.bounty.killstreak then
		killerCash = killerCash + Settings.bounty.reward.cash
		killerExp = killerExp + Settings.bounty.reward.exp
		table.insert(killDetails, 'BOUNTY HUNTER')
	end

	local patreonTier = PlayerData.GetPatreonTier(killer)
	if patreonTier ~= 0 then
		table.insert(killDetails, 'PATREON BONUS x'..Settings.patreon.reward[patreonTier])
	end

	if #killDetails == 0 then
		table.insert(killDetails, 'PLAYER KILL')
	end

	PlayerData.UpdateCash(killer, killerCash, killDetails)
	PlayerData.UpdateExperience(killer, killerExp)

	local deathMessage = killData.headshot and 'headshot' or table.random(_killedMessages)

	local killstreak = nil
	if killerKillstreak >= Settings.minKillstreakNotification then
		killstreak = killerKillstreak
	end
	TriggerClientEvent('lsv:onPlayerKilled', -1, victim, killer, deathMessage, killstreak)

	PlayerData.UpdateDeaths(victim)
end)
