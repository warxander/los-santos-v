local _players = { }

RegisterNetEvent('lsv:velocityFinished')
AddEventHandler('lsv:velocityFinished', function()
	local player = source

	local cash = Settings.velocity.rewards.cash.max
	local exp = Settings.velocity.rewards.exp.max

	if _players[player] then
		cash = cash - math.min(Settings.velocity.rewards.cash.max - Settings.velocity.rewards.cash.min, _players[player] * Settings.velocity.rewards.cash.perAboutToDetonate)
		exp = exp - math.min(Settings.velocity.rewards.exp.max - Settings.velocity.rewards.exp.min, _players[player] * Settings.velocity.rewards.exp.perAboutToDetonate)
	end

	PlayerData.UpdateCash(player, cash)
	PlayerData.UpdateExperience(player, exp)

	TriggerClientEvent('lsv:velocityFinished', player, true, '')

	_players[player] = nil
end)

RegisterNetEvent('lsv:velocityAboutToDetonate')
AddEventHandler('lsv:velocityAboutToDetonate', function()
	local player = source

	if not _players[player] then
		_players[player] = 0
	end

	_players[player] = _players[player] + 1
end)

AddSignalHandler('lsv:playerDropped', function(player)
	_players[player] = nil
end)
