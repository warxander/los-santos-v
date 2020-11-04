local _players = { }

RegisterNetEvent('lsv:finishDrugExport')
AddEventHandler('lsv:finishDrugExport', function()
	local player = source
	if not _players[player] or not PlayerData.IsExists(player) then
		return
	end

	local cash = _players[player]
	local exp = math.floor(Settings.drugBusiness.export.expRate * cash)
	PlayerData.UpdateCash(player, cash)
	PlayerData.UpdateExperience(player, exp)

	_players[player] = nil
	TriggerClientEvent('lsv:finishDrugExport', player, true)
end)

RegisterNetEvent('lsv:startDrugExport')
AddEventHandler('lsv:startDrugExport', function(type)
	local player = source
	if _players[player] or not PlayerData.IsExists(player) or not PlayerData.HasDrugBusiness(player, type) then
		return
	end

	local business = PlayerData.GetDrugBusiness(player, type)
	if business.stock == 0 then
		return
	end

	local profitPerUnit = business.upgrades.staff and Settings.drugBusiness.types[type].price.upgraded or Settings.drugBusiness.types[type].price.default
	local totalProfit = profitPerUnit * business.stock

	business.stock = 0
	PlayerData.UpdateDrugBusiness(player, type, business)

	_players[player] = totalProfit

	local data = {
		type = type,
		location = table.random(Settings.drugBusiness.export.locations),
		totalProfit = totalProfit,
	}

	TriggerClientEvent('lsv:drugExportStarted', player, data)
end)

AddEventHandler('lsv:playerDropped', function(player)
	_players[player] = nil
end)
