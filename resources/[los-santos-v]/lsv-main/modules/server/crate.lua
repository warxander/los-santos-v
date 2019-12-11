Crate = { }
Crate.__index = Crate


local logger = Logger.New('Crate')

local players = { }


function Crate.TrySpawn(player)
	if players[player] and not players[player].crate and players[player].lastTime:Elapsed() >= Settings.crate.timeout and math.random(100) > 100 - Settings.crate.chance then
		local crate = { }

		local location = table.random(Settings.crate.locations)
		crate.location = location.blip
		crate.position = table.random(location.positions)
		crate.weapon = table.random(Settings.crate.weapons)

		players[player].crate = crate
		TriggerClientEvent('lsv:spawnCrate', player, crate)

		logger:Info('Spawn { '..player..' }')
	end
end


RegisterNetEvent('lsv:cratePickedUp')
AddEventHandler('lsv:cratePickedUp', function()
	local player = source
	if not players[player] or not players[player].crate then return end

	Db.UpdateCash(player, Settings.crate.reward.cash)
	Db.UpdateExperience(player, Settings.crate.reward.exp)
	TriggerClientEvent('lsv:cratePickedUp', player, players[player].crate)

	players[player].crate = nil
	players[player].lastTime:Restart()

	logger:Info('Picked up { '..player..' }')
end)


AddEventHandler('lsv:playerConnected', function(player)
	players[player] = { }
	players[player].lastTime = Timer.New()
end)


AddEventHandler('lsv:playerDropped', function(player)
	players[player] = nil
end)
