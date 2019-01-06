local killedMessage = {
	"killed",
	"destroyed",
	"finished",
	"ended",
	"murdered",
	"wiped out",
	"executed",
	"erased",
	"whacked",
	"deaded",
	"slain",
	"atomized",
	"raped",
	"assassinated",
	"fucked up",
}

local function getKilledMessage()
	return killedMessage[math.random(Utils.GetTableLength(killedMessage))]
end


RegisterServerEvent('baseevents:onPlayerDied')
AddEventHandler('baseevents:onPlayerDied', function()
	local player = source
	Db.UpdateDeaths(player, function()
		if Scoreboard.IsPlayerOnline(player) then
			Scoreboard.ResetKillstreak(player)
			TriggerClientEvent('lsv:onPlayerDied', -1, player, true)
		end
	end)
end)


RegisterServerEvent('baseevents:onPlayerKilled')
AddEventHandler('baseevents:onPlayerKilled', function(killer)
	local victim = source
	local isVictimDoingJob = JobWatcher.IsDoingJob(victim)

	if killer ~= -1 then
		Db.UpdateKills(killer, function()
			if Scoreboard.IsPlayerOnline(killer) then
				local killerCash = Settings.cashPerKill + (Settings.cashPerKillstreak * Scoreboard.GetPlayerKillstreak(killer))
				if isVictimDoingJob then killerCash = killerCash + Settings.cashPerMission end

				Scoreboard.UpdateKillstreak(killer)

				Db.UpdateCash(killer, killerCash, function()
					TriggerClientEvent('lsv:onPlayerKilled', -1, victim, killer, getKilledMessage())
				end)
			end
		end)
	end

	Db.UpdateDeaths(victim, function()
		if Scoreboard.IsPlayerOnline(victim) then
			Scoreboard.ResetKillstreak(victim)
		end

		if killer ~= -1 then return end

		TriggerClientEvent('lsv:onPlayerDied', -1, victim)
	end)
end)