RegisterServerEvent('lsv:leaveCrew')
AddEventHandler('lsv:leaveCrew', function()
	TriggerClientEvent('lsv:crewLeaved', -1, source)
end)


RegisterServerEvent('lsv:inviteToCrew')
AddEventHandler('lsv:inviteToCrew', function(player)
	if not Scoreboard.IsPlayerOnline(player) then return end
	TriggerClientEvent('lsv:invitedToCrew', player, source)
end)


RegisterServerEvent('lsv:alreadyInCrew')
AddEventHandler('lsv:alreadyInCrew', function(player)
	TriggerClientEvent('lsv:alreadyInCrew', player, source)
end)


RegisterServerEvent('lsv:acceptInvitation')
AddEventHandler('lsv:acceptInvitation', function(player)
	TriggerClientEvent('lsv:invitationAccepted', player, source)
end)


RegisterServerEvent('lsv:addCrewMember')
AddEventHandler('lsv:addCrewMember', function(player)
	TriggerClientEvent('lsv:addedCrewMember', -1, source, player)
end)


RegisterServerEvent('lsv:updateCrewMembers')
AddEventHandler('lsv:updateCrewMembers', function(player, members)
	TriggerClientEvent('lsv:crewMembersUpdated', player, members)
end)


RegisterServerEvent('lsv:declineInvitation')
AddEventHandler('lsv:declineInvitation', function(player)
	TriggerClientEvent('lsv:invitationDeclined', player, source)
end)