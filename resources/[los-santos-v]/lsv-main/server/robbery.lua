local robberyData = { }


local function resetPlayer(player)
	robberyData[player] = { }
	robberyData[player].inProgress = false
	robberyData[player].money = 0
end


local function removePlayer(player)
	robberyData[player] = nil
end


local function findSettingsByPickupHash(pickupHash) --TODO Do something better
	for _, settings in pairs(Settings.robberySettings) do
		if settings.hash == pickupHash then return settings end
	end

	return nil
end


RegisterServerEvent('lsv:rob')
AddEventHandler('lsv:rob', function(pickupHash, robPlaceIndex)
	local player = source

	if not robberyData[player].inProgress then
		TriggerClientEvent('lsv:startRobbery', player, robPlaceIndex)
		robberyData[player].inProgress = true
	end

	local settings = findSettingsByPickupHash(pickupHash)
	local money = math.random(settings.money.min, settings.money.max)

	robberyData[player].money = robberyData[player].money + money

	TriggerClientEvent('lsv:robberySucceeded', player, money)
end)


RegisterServerEvent('lsv:robberySucceeded')
AddEventHandler('lsv:robberySucceeded', function()
	local player = source

	Db.UpdateMoney(player, robberyData[player].money, function()
		TriggerClientEvent('lsv:robberyFinished', player, robberyData[player].money)
		resetPlayer(player)
	end)
end)


RegisterServerEvent('lsv:robberyFailed')
AddEventHandler('lsv:robberyFailed', function()
	local player = source

	resetPlayer(player)

	TriggerClientEvent('lsv:robberyFinished', player)
end)


AddEventHandler('lsv:playerConnected', function(player)
	resetPlayer(player)
end)


AddEventHandler('lsv:playerDropped', function(player)
	removePlayer(player)
end)
