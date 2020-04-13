local _players = { }

RegisterNetEvent('lsv:specialCargoFinished')
AddEventHandler('lsv:specialCargoFinished', function()
	local player = source
	if not _players[player] then
		return
	end

	local crateReward = Settings.cargo.crates[_players[player]].reward
	local playersCount = PlayerData.GetCount()

	PlayerData.UpdateCash(player, crateReward.cash + Settings.cargo.rewardPerPlayer.cash * (playersCount - 1))
	PlayerData.UpdateExperience(player, crateReward.exp + Settings.cargo.rewardPerPlayer.exp * (playersCount - 1))

	_players[player] = nil

	TriggerClientEvent('lsv:specialCargoFinished', player, true)
end)

RegisterNetEvent('lsv:purchaseCargoCrate')
AddEventHandler('lsv:purchaseCargoCrate', function(crateIndex)
	local player = source
	if MissionManager.IsPlayerOnMission(player) then
		return
	end

	local cratePrice = Settings.cargo.crates[crateIndex].price
	if PlayerData.GetCash(player) >= cratePrice then
		PlayerData.UpdateCash(player, -cratePrice)

		_players[player] = crateIndex

		local cargo = { }
		cargo.goods = table.random(Settings.cargo.goods)
		cargo.location = table.random(Settings.cargo.locations)
		cargo.wanted = cargo.location.wanted
		cargo.warehouse = table.random(Settings.cargo.warehouses)
		cargo.vehicle = table.random(Settings.cargo.vehicles)

		TriggerClientEvent('lsv:cargoCratePurchased', player, cargo)
	else
		TriggerClientEvent('lsv:cargoCratePurchased', player, nil)
	end
end)

AddEventHandler('lsv:playerDisconnected', function(player)
	_players[player] = nil
end)
