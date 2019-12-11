local killedMessage = {
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
	'raped',
	'assassinated',
	'fucked up',
}

local function getKilledMessage()
	return killedMessage[math.random(#killedMessage)]
end


RegisterNetEvent('baseevents:onPlayerDied')
AddEventHandler('baseevents:onPlayerDied', function()
	local player = source
	Db.UpdateDeaths(player, function()
		if Scoreboard.IsPlayerOnline(player) then
			TriggerClientEvent('lsv:onPlayerDied', -1, player, true)
		end
	end)
end)


RegisterNetEvent('baseevents:onPlayerKilled')
AddEventHandler('baseevents:onPlayerKilled', function(killer, data)
	local victim = source

	if killer ~= -1 then
		Db.UpdateKills(killer, function()
			if Scoreboard.IsPlayerOnline(killer) then
				local killerCash = math.min(Settings.maxCashPerKillstreak, Settings.cashPerKill + (Settings.cashPerKillstreak * Scoreboard.GetPlayerKillstreak(killer)))
				local killerExp = math.min(Settings.maxExpPerKillstreak, Settings.expPerKill + (Settings.expPerKillstreak * Scoreboard.GetPlayerKillstreak(killer)))

				if data.killerheadshot then
					killerCash = killerCash + Settings.cashPerHeadshot
					killerExp = killerExp + Settings.expPerHeadshot
				end

				if MissionManager.IsPlayerOnMission(victim) then
					killerCash = killerCash + Settings.cashPerMission
					killerExp = killerExp + Settings.expPerMission
				end

				killerCash = killerCash + math.min(Settings.maxCashPerKillstreak, Settings.cashPerKill + (Settings.cashPerKillstreak * Scoreboard.GetPlayerKillstreak(victim)))
				killerExp = killerExp + math.min(Settings.maxExpPerKillstreak, Settings.expPerKill + (Settings.expPerKillstreak * Scoreboard.GetPlayerKillstreak(victim)))

				Db.UpdateCash(killer, killerCash, function()
					local deathMessage = nil
					if data.killerheadshot then deathMessage = 'headshot'
					else deathMessage = getKilledMessage() end

					TriggerClientEvent('lsv:onPlayerKilled', -1, victim, killer, deathMessage)
				end, victim)
				Db.UpdateExperience(killer, killerExp)
			end
		end)
	end

	Db.UpdateDeaths(victim, function()
		if killer ~= -1 then return end
		TriggerClientEvent('lsv:onPlayerDied', -1, victim)
	end)
end)
