SpecialCrate = { }
SpecialCrate.__index = SpecialCrate

local logger = Logger.New('SpecialCrate')

local _players = { }
local _lastWeaponIndexes = { }

function SpecialCrate.Drop(player)
	if _players[player] then
		return
	end

	local location = table.random(Settings.crate.locations)

	local crate = { }
	crate.location = location.blip
	crate.position = table.random(location.positions)

	local weaponIndex = nil
	if not _lastWeaponIndexes[player] then
		_, weaponIndex = table.random(Settings.crate.weapons)
	else
		weaponIndex = _lastWeaponIndexes[player]
		while weaponIndex == _lastWeaponIndexes[player] do
			_, weaponIndex = table.random(Settings.crate.weapons)
		end
	end

	_lastWeaponIndexes[player] = weaponIndex
	crate.weapon = Settings.crate.weapons[weaponIndex]

	_players[player] = crate
	TriggerClientEvent('lsv:spawnSpecialCrate', player, crate)
	logger:info('Drop { '..player..' }')
end

RegisterNetEvent('lsv:purchaseSpecialCrate')
AddEventHandler('lsv:purchaseSpecialCrate', function()
	local player = source

	if _players[player] then
		return
	end

	if PlayerData.GetCash(player) >= Settings.crate.cash then
		PlayerData.UpdateCash(player, -Settings.crate.cash)
		SpecialCrate.Drop(player)
		TriggerClientEvent('lsv:specialCratePurchased', player, true)
	else
		TriggerClientEvent('lsv:specialCratePurchased', player, nil)
	end
end)

RegisterNetEvent('lsv:specialCratePickedUp')
AddEventHandler('lsv:specialCratePickedUp', function()
	local player = source

	if not _players[player] then
		return
	end

	PlayerData.UpdateCash(player, Settings.crate.reward.cash)
	PlayerData.UpdateExperience(player, Settings.crate.reward.exp)

	local crate = _players[player]
	_players[player] = nil
	TriggerClientEvent('lsv:specialCratePickedUp', player, crate)
end)

AddEventHandler('lsv:playerDropped', function(player)
	_players[player] = nil
	_lastWeaponIndexes[player] = nil
end)
