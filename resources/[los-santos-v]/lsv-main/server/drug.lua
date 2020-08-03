RegisterNetEvent('lsv:drugBusinessProduced')
AddEventHandler('lsv:drugBusinessProduced', function(type)
	local player = source
	if not PlayerData.IsExists(player) or not PlayerData.HasDrugBusiness(player, type) then
		return
	end

	local business = PlayerData.GetDrugBusiness(player, type)
	if business.supplies == 0 or business.stock == Settings.drugBusiness.limits.stock then
		return
	end

	business.supplies = business.supplies - 1
	business.stock = business.stock + 1

	PlayerData.UpdateDrugBusiness(player, type, business)
end)

RegisterNetEvent('lsv:purchaseDrugBusinessSupply')
AddEventHandler('lsv:purchaseDrugBusinessSupply', function(type)
	local player = source
	if not PlayerData.IsExists(player) or not PlayerData.HasDrugBusiness(player, type) then
		return
	end

	local business = PlayerData.GetDrugBusiness(player, type)
	if business.supplies == Settings.drugBusiness.limits.supplies then
		return
	end

	local price = Settings.drugBusiness.types[type].price.supply
	if PlayerData.GetCash(player) >= price then
		PlayerData.UpdateCash(player, -price)

		business.supplies = business.supplies + 1
		PlayerData.UpdateDrugBusiness(player, type, business)

		TriggerClientEvent('lsv:drugBusinessSupplyPurchased', player, true)
	else
		TriggerClientEvent('lsv:drugBusinessSupplyPurchased', player, nil)
	end
end)

RegisterNetEvent('lsv:drugBusinessResupplied')
AddEventHandler('lsv:drugBusinessResupplied', function(type)
	local player = source
	if not PlayerData.IsExists(player) then
		return
	end

	local business = PlayerData.GetDrugBusiness(player, type)
	business.supplies = business.supplies + 1

	PlayerData.UpdateDrugBusiness(player, type, business)
end)

RegisterNetEvent('lsv:upgradeDrugBusiness')
AddEventHandler('lsv:upgradeDrugBusiness', function(type, id)
	local player = source
	if not PlayerData.IsExists(player) or not PlayerData.HasDrugBusiness(player, type) then
		return
	end

	local business = PlayerData.GetDrugBusiness(player, type)
	if business.upgrades[id] then
		return
	end

	local price = Settings.drugBusiness.upgrades[id].prices[type]
	if PlayerData.GetCash(player) >= price then
		PlayerData.UpdateCash(player, -price)

		business.upgrades[id] = true
		PlayerData.UpdateDrugBusiness(player, type, business)

		TriggerClientEvent('lsv:drugBusinessUpgraded', player, Settings.drugBusiness.upgrades[id].name)
	else
		TriggerClientEvent('lsv:drugBusinessUpgraded', player, nil)
	end
end)

RegisterNetEvent('lsv:purchaseDrugBusiness')
AddEventHandler('lsv:purchaseDrugBusiness', function(id)
	local player = source
	if not PlayerData.IsExists(player) then
		return
	end

	local type = Settings.drugBusiness.businesses[id].type
	if PlayerData.HasDrugBusiness(player, type) then
		return
	end

	local price = Settings.drugBusiness.businesses[id].price
	if PlayerData.GetCash(player) >= price then
		PlayerData.UpdateCash(player, -price)
		PlayerData.UpdateDrugBusiness(player, type, {
			id = id,
			stock = 0,
			supplies = 0,
			upgrades = { },
		})
		TriggerClientEvent('lsv:drugBusinessPurchased', player, id)
	else
		TriggerClientEvent('lsv:drugBusinessPurchased', player, nil)
	end
end)
