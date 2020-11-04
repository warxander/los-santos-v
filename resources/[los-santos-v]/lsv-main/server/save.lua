local _players = { }
local _prohibitedWeapons = {
	'WEAPON_RAILGUN',
	'WEAPON_GUSENBERG',
}

RegisterNetEvent('lsv:savePlayerWeapons')
AddEventHandler('lsv:savePlayerWeapons', function(weapons)
	local player = source
	if not PlayerData.IsExists(player) then
		return
	end

	if not weapons or type(weapons) ~= 'table' or #weapons == 0 then
		return
	end

	local prohibitedWeapon = table.ifind_if(weapons, function(weapon)
		return table.ifind(_prohibitedWeapons, weapon.id)
	end)

	if prohibitedWeapon then
		DropPlayer(player, 'You have received a prohibited weapon due to hacker activity.\nYour progress is saved, but you need to manually reconnect to the server.')
		return
	end

	Db.UpdateWeapons(player, weapons)
end)

RegisterNetEvent('lsv:playerSaved')
AddEventHandler('lsv:playerSaved', function()
	local player = source

	if PlayerData.IsExists(player) then
		_players[player]:restart()
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)

		table.foreach(_players, function(lastSavedTime, player)
			if lastSavedTime:elapsed() > Settings.autoSavingInterval then
				TriggerClientEvent('lsv:savePlayer', player)
			end
		end)
	end
end)

AddEventHandler('lsv:playerConnected', function(player)
	_players[player] = Timer.New()
end)

AddEventHandler('lsv:playerDropped', function(player)
	_players[player] = nil
end)
