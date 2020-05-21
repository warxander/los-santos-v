Crew = { }
Crew.__index = Crew

local _crews = { }
local _crewMembers = { }

local _crewRaces = { }

local function addToCrew(player, leader)
	_crewMembers[player] = leader
	table.insert(_crews[leader], player)
end

local function disbandCrew(leader)
	table.iforeach(_crews[leader], function(member)
		_crewMembers[member] = nil
		TriggerClientEvent('lsv:crewDisbanded', member)
	end)
	_crews[leader] = nil
	_crewRaces[leader] = nil
end

local function leaveCrew(player, disconnected)
	local leader = _crewMembers[player]
	local memberIndex = nil
	table.iforeach(_crews[leader], function(member, index)
		if member == player then
			memberIndex = index
		end
		TriggerClientEvent('lsv:crewMemberLeft', member, player, disconnected)
	end)
	table.remove(_crews[leader], memberIndex)
	_crewMembers[player] = nil
end

function Crew.IsCrewLeader(player)
	return _crews[player]
end

function Crew.ForEachMember(leader, func)
	table.iforeach(_crews[leader], func)
end

RegisterNetEvent('lsv:startCrewRace')
AddEventHandler('lsv:startCrewRace', function(coords)
	local player = source

	if _crewRaces[player] or not _crews[player] then
		return
	end

	_crewRaces[player] = true
	table.iforeach(_crews[player], function(member)
		TriggerClientEvent('lsv:crewRaceStarted', member, coords)
	end)
end)

RegisterNetEvent('lsv:finishCrewRace')
AddEventHandler('lsv:finishCrewRace', function()
	local player = source
	local leader = _crewMembers[player]

	if not leader or not _crewRaces[leader] then
		return
	end

	_crewRaces[leader] = nil
	table.iforeach(_crews[leader], function(member)
		TriggerClientEvent('lsv:crewRaceFinished', member, player)
	end)
end)

RegisterNetEvent('lsv:formCrew')
AddEventHandler('lsv:formCrew', function()
	local player = source
	if not _crews[player] and not _crewMembers[player] then
		_crews[player] = { }
		addToCrew(player, player)
		TriggerClientEvent('lsv:crewFormed', player)
	end
end)

RegisterNetEvent('lsv:disbandCrew')
AddEventHandler('lsv:disbandCrew', function()
	local player = source
	if _crews[player] then
		disbandCrew(player)
	end
end)

RegisterServerEvent('lsv:leaveCrew')
AddEventHandler('lsv:leaveCrew', function()
	local player = source
	if _crewMembers[player] then
		leaveCrew(player)
	end
end)

RegisterServerEvent('lsv:inviteToCrew')
AddEventHandler('lsv:inviteToCrew', function(player)
	local leader = source
	if _crewMembers[player] then
		TriggerClientEvent('lsv:crewInvitationDeclined', leader, player)
		return
	end

	TriggerClientEvent('lsv:invitedToCrew', player, leader)
end)

RegisterServerEvent('lsv:declineCrewInvitation')
AddEventHandler('lsv:declineCrewInvitation', function(leader)
	local player = source
	TriggerClientEvent('lsv:crewInvitationDeclined', leader, player)
end)

RegisterServerEvent('lsv:acceptCrewInvitation')
AddEventHandler('lsv:acceptCrewInvitation', function(leader)
	local player = source
	local crewMembers = _crews[leader]
	if crewMembers then
		table.iforeach(crewMembers, function(member)
			TriggerClientEvent('lsv:crewMemberJoined', member, player)
		end)

		addToCrew(player, leader)
		TriggerClientEvent('lsv:crewInvitationAccepted', player, leader, crewMembers)
	end
end)

AddSignalHandler('lsv:playerDropped', function(player)
	if _crews[player] then
		disbandCrew(player)
	elseif _crewMembers[player] then
		leaveCrew(player, true)
	end
end)
