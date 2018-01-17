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
	TriggerClientEvent('lsv:onPlayerDied', -1, source, true)
	TriggerClientEvent('lsv:increaseDeaths', source)
end)


RegisterServerEvent('baseevents:onPlayerKilled')
AddEventHandler('baseevents:onPlayerKilled', function(killer)
	if killer ~= -1 then
		TriggerClientEvent('lsv:onPlayerKilled', -1, source, killer, getKilledMessage())
		TriggerClientEvent('lsv:increaseKills', killer)
	else
		TriggerClientEvent('lsv:onPlayerDied', -1, source)
	end

	TriggerClientEvent('lsv:increaseDeaths', source)
end)


RegisterServerEvent('lsv:updatePlayerSkin')
AddEventHandler('lsv:updatePlayerSkin', function(skin)
	local playerId = GetPlayerIdentifiers(source)[1]
	MySQL.ready(function()
		MySQL.Async.execute('UPDATE Players SET SkinModel=@skinModel WHERE PlayerID=@playerId', {['@playerId'] = playerId, ['@skinModel'] = skin}) --TODO Callback ?
	end)
end)


RegisterServerEvent('lsv:updatePlayerVehicleModel')
AddEventHandler('lsv:updatePlayerVehicleModel', function(vehicleModel)
	local playerId = GetPlayerIdentifiers(source)[1]
	MySQL.ready(function()
		MySQL.Async.execute('UPDATE Players SET VehicleModel=@vehicleModel WHERE PlayerID=@playerId', {['@playerId'] = playerId, ['@vehicleModel'] = vehicleModel}) --TODO Callback ?
	end)
end)


RegisterServerEvent('lsv:updatePlayerStartingWeapon')
AddEventHandler('lsv:updatePlayerStartingWeapon', function(weaponId)
	local playerId = GetPlayerIdentifiers(source)[1]
	MySQL.ready(function()
		MySQL.Async.execute('UPDATE Players SET WeaponID=@weaponId WHERE PlayerID=@playerId', {['@playerId'] = playerId, ['@weaponId'] = weaponId}) --TODO Callback ?
	end)
end)