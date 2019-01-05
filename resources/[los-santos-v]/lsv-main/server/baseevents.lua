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
		Scoreboard.ResetKillstreak(player)
		TriggerClientEvent('lsv:onPlayerDied', -1, player, true)
	end)
end)


RegisterServerEvent('baseevents:onPlayerKilled')
AddEventHandler('baseevents:onPlayerKilled', function(killer)
	local victim = source

	if killer ~= -1 then
		Db.UpdateKills(killer, function()
			local killerCash = Settings.cashPerKill + (Settings.cashPerKillstreak * Scoreboard.GetPlayerKillstreak(killer))
			if JobWatcher.IsDoingJob(victim) then killerCash = killerCash + Settings.cashPerMission end

			Scoreboard.UpdateKillstreak(killer)

			Db.UpdateCash(killer, killerCash, function()
				TriggerClientEvent('lsv:onPlayerKilled', -1, victim, killer, getKilledMessage())
			end)
		end)
	end

	Db.UpdateDeaths(victim, function()
		Scoreboard.ResetKillstreak(victim)

		if killer ~= -1 then return end

		TriggerClientEvent('lsv:onPlayerDied', -1, victim)
	end)
end)