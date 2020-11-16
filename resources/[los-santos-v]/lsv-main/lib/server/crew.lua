Crew = { }
Crew.__index = Crew

local _crews = { }

local _crewRaces = { }
local _crewSalaries = { }

local function addToCrew(player, leader)
	PlayerData.UpdateCrewLeader(player, leader)
	table.insert(_crews[leader], player)
end

local function disbandCrew(leader)
	table.iforeach(_crews[leader], function(member)
		PlayerData.UpdateCrewLeader(member, nil)
		TriggerClientEvent('lsv:crewDisbanded', member)
	end)
	TriggerEvent('lsv:crewDisbanded', leader)
	_crews[leader] = nil
	_crewRaces[leader] = nil
	_crewSalaries[leader] = nil
end

local function leaveCrew(player, disconnected)
	local leader = PlayerData.GetCrewLeader(player)
	local memberIndex = nil
	table.iforeach(_crews[leader], function(member, index)
		if member == player then
			memberIndex = index
		end
		TriggerClientEvent('lsv:crewMemberLeft', member, player, disconnected)
	end)
	table.remove(_crews[leader], memberIndex)
	PlayerData.UpdateCrewLeader(player, nil)
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
	if not PlayerData.IsExists(player) then
		return
	end

	local leader = PlayerData.GetCrewLeader(player)
	if not leader or not _crewRaces[leader] then
		return
	end

	_crewRaces[leader] = nil
	table.iforeach(_crews[leader], function(member)
		TriggerClientEvent('lsv:finishCrewRace', member, player)
	end)
end)

RegisterNetEvent('lsv:formCrew')
AddEventHandler('lsv:formCrew', function()
	local player = source
	if not PlayerData.IsExists(player) then
		return
	end

	if not _crews[player] and not PlayerData.GetCrewLeader(player) then
		_crews[player] = { }
		_crewSalaries[player] = Timer.New()
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
	if not PlayerData.IsExists(player) then
		return
	end

	if PlayerData.GetCrewLeader(player) then
		leaveCrew(player)
	end
end)

RegisterServerEvent('lsv:inviteToCrew')
AddEventHandler('lsv:inviteToCrew', function(player)
	if not PlayerData.IsExists(player) then
		return
	end

	local leader = source

	if PlayerData.GetCrewLeader(player) or table.length(_crews[leader]) == Settings.crew.memberLimit then
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
	if not PlayerData.IsExists(player) or not PlayerData.IsExists(leader) then
		return
	end

	local crewMembers = _crews[leader]
	if crewMembers then
		table.iforeach(crewMembers, function(member)
			TriggerClientEvent('lsv:crewMemberJoined', member, player)
		end)

		addToCrew(player, leader)
		TriggerClientEvent('lsv:crewInvitationAccepted', player, leader, crewMembers)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)

		table.foreach(_crewSalaries, function(timer, leader)
			if timer:elapsed() >= Settings.crew.salary.timeout then
				Crew.ForEachMember(leader, function(member)
					if member ~= leader then
						PlayerData.UpdateCash(member, Settings.crew.salary.cash, true)
						PlayerData.UpdateExperience(member, Settings.crew.salary.exp, true)
					end
				end)
				timer:restart()
			end
		end)
	end
end)

AddEventHandler('lsv:playerDropped', function(player)
	if not PlayerData.IsExists(player) then
		return
	end

	if _crews[player] then
		disbandCrew(player)
	elseif PlayerData.GetCrewLeader(player) then
		leaveCrew(player, true)
	end
end)
