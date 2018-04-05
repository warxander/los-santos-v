AddEventHandler('lsv:init', function()
	while true do
		for id = 0, Settings.maxPlayerCount do
			if id ~= PlayerId() and NetworkIsPlayerActive(id) then
				local playerPed = GetPlayerPed(id)
				local isCrewMember = Player.isCrewMember(GetPlayerServerId(id))
				
				local healthBarVisible = IsPlayerFreeAimingAtEntity(PlayerId(), playerPed) or isCrewMember
				local isPlayerTalking = NetworkIsPlayerTalking(id)
				local visible = healthBarVisible or isPlayerTalking or isCrewMember

				local gamerTag = CreateMpGamerTag(playerPed, GetPlayerName(id), false, false, "", 0)

				local color = 0
				if isCrewMember then color = 10 end

				-- https://runtime.fivem.net/doc/reference.html#_0x63BB75ABEDC1F6A0
				SetMpGamerTagName(gamerTag, GetPlayerName(id))
				SetMpGamerTagColour(gamerTag, 0, color)
				SetMpGamerTagColour(gamerTag, 4, color)
				SetMpGamerTagHealthBarColour(gamerTag, color)
				SetMpGamerTagAlpha(gamerTag, 0, 255)
				SetMpGamerTagAlpha(gamerTag, 2, 255)
				SetMpGamerTagAlpha(gamerTag, 4, 255)

				SetMpGamerTagVisibility(gamerTag, 0, visible) -- GAMER_NAME
				SetMpGamerTagVisibility(gamerTag, 2, healthBarVisible) -- HEALTH/ARMOR
				SetMpGamerTagVisibility(gamerTag, 4, isPlayerTalking) -- AUDIO_ICON
			end
		end

		Citizen.Wait(0)
	end
end)