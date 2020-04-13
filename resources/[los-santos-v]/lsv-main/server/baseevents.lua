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
AddEventHandler('lsv:onPlayerDied', function()
	local player = source

	if not PlayerData.IsExists(player) then
		return
	end

	PlayerData.UpdateDeaths(player)
	TriggerClientEvent('lsv:onPlayerDied', -1, player, true)
end)

RegisterNetEvent('lsv:onPlayerKilled')
AddEventHandler('lsv:onPlayerKilled', function(killer, data)
	local victim = source

	if killer ~= -1 then
		if not PlayerData.IsExists(killer) or not PlayerData.IsExists(victim) then
			return
		end

		local killerFaction = PlayerData.GetFaction(killer)
		local victimFaction = PlayerData.GetFaction(victim)

		local isFriendlyFactionKill = killerFaction ~= Settings.faction.Neutral and killerFaction == victimFaction

		if not isFriendlyFactionKill then
			local killDetails = { }

			PlayerData.UpdateKills(killer)

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

			if data.killerheadshot then
				PlayerData.UpdateHeadshots(killer)

				killerCash = killerCash + Settings.cashPerHeadshot
				killerExp = killerExp + Settings.expPerHeadshot
				table.insert(killDetails, 'HEADSHOT')
			end

			if data.weapongroup == 2685387236 then -- MELEE
				killerCash = killerCash + Settings.cashPerMelee
				killerExp = killerExp + Settings.expPerMelee
				table.insert(killDetails, 'MELEE KILL')
			end

			if killerFaction ~= Settings.faction.Neutral and victimFaction ~= Settings.faction.Neutral and killerFaction ~= victimFaction then
				killerCash = killerCash + Settings.cashPerFaction
				killerExp = killerExp + Settings.expPerFaction
				table.insert(killDetails, 'FACTION KILL')
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
		end

		local deathMessage = data.killerheadshot and 'headshot' or table.random(_killedMessages)
		TriggerClientEvent('lsv:onPlayerKilled', -1, victim, killer, deathMessage, isFriendlyFactionKill)
	else
		TriggerClientEvent('lsv:onPlayerDied', -1, victim)
	end

	PlayerData.UpdateDeaths(victim)
end)
