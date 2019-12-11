local gamerTags = { }


local function isCrewMemberAimingAt(ped)
	for _, member in ipairs(Player.CrewMembers) do
		if IsPlayerFreeAimingAtEntity(GetPlayerFromServerId(member), ped) then return true end
	end

	return false
end


AddEventHandler('lsv:init', function()
	while true do
		for _, id in ipairs(GetActivePlayers()) do
			if id ~= PlayerId() then
				local playerPed = GetPlayerPed(id)

				local isCrewMember = Player.IsCrewMember(GetPlayerServerId(id))

				local healthBarVisible = IsPlayerFreeAimingAtEntity(PlayerId(), playerPed) or isCrewMember or isCrewMemberAimingAt(playerPed)
				local isPlayerTalking = NetworkIsPlayerTalking(id)
				local visible = healthBarVisible or isPlayerTalking

				local patreonTier = Scoreboard.GetPlayerPatreonTier(id) or 0

				if not gamerTags[id] or gamerTags[id].ped ~= playerPed or not IsMpGamerTagActive(gamerTags[id].tag) then
					if gamerTags[id] then RemoveMpGamerTag(gamerTags[id].tag) end

					gamerTags[id] = {
						tag = CreateMpGamerTag(playerPed, '', false, false, '', 0),
						ped = playerPed
					}
				end

				local gamerTag = gamerTags[id].tag

				local color = 0
				if isCrewMember then color = 10
				elseif patreonTier ~= 0 then color = 31 end

				-- https://runtime.fivem.net/doc/reference.html#_0x63BB75ABEDC1F6A0
				local playerName = GetPlayerName(id)
				local rank = Scoreboard.GetPlayerRank(id)
				if rank then playerName = '['..rank..'] '..playerName end
				SetMpGamerTagName(gamerTag, playerName)

				SetMpGamerTagColour(gamerTag, 0, color)
				SetMpGamerTagColour(gamerTag, 2, color)
				SetMpGamerTagColour(gamerTag, 4, color)
				SetMpGamerTagColour(gamerTag, 7, color)
				SetMpGamerTagHealthBarColour(gamerTag, color)

				SetMpGamerTagAlpha(gamerTag, 0, 255)
				SetMpGamerTagAlpha(gamerTag, 2, 255)
				SetMpGamerTagAlpha(gamerTag, 4, 255)
				SetMpGamerTagAlpha(gamerTag, 7, 255)

				SetMpGamerTagVisibility(gamerTag, 0, visible) -- GAMER_NAME
				SetMpGamerTagVisibility(gamerTag, 2, healthBarVisible) -- HEALTH/ARMOR
				SetMpGamerTagVisibility(gamerTag, 4, isPlayerTalking) -- AUDIO_ICON
				SetMpGamerTagVisibility(gamerTag, 7, healthBarVisible and patreonTier ~= 0) -- WANTED_STARS
			elseif gamerTags[id] then
				RemoveMpGamerTag(gamerTags[id].tag)
				gamerTags[id] = nil
			end
		end

		Citizen.Wait(0)
	end
end)
