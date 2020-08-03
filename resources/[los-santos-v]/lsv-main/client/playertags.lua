local _gamerTags = { }

local function isPlayerCrewMemberAimingAt(ped)
	for member, _ in pairs(Player.CrewMembers) do
		if IsPlayerFreeAimingAtEntity(GetPlayerFromServerId(member), ped) then
			return true
		end
	end

	return false
end

AddEventHandler('lsv:init', function()
	while true do
		local playerPed = PlayerPedId()

		for _, id in ipairs(GetActivePlayers()) do
			if id ~= PlayerId() then
				local ped = GetPlayerPed(id)

				local serverId = GetPlayerServerId(id)
				local isPlayerActive = PlayerData.IsExists(serverId)
				local isPlayerDead = IsPlayerDead(id)

				local isPlayerCrewMember = false
				local isPlayerBeast = false
				local isPlayerHotProperty = false
				local isPlayerKingOfTheCastle = false
				local isPlayerHasBounty = false
				local isPlayerOnMission = false
				local isHealthBarVisible = false
				local isPlayerTalking = false
				local isPlayerInPlane = false
				local isPlayerInHeli = false
				local patreonTier = 0

				local playerWeapon = 0

				if isPlayerActive then
					isPlayerCrewMember = Player.CrewMembers[serverId]
					isPlayerBeast = serverId == World.BeastPlayer
					isPlayerHotProperty = serverId == World.HotPropertyPlayer
					isPlayerKingOfTheCastle = serverId == World.KingOfTheCastlePlayer
					isPlayerHasBounty = PlayerData.GetKillstreak(serverId) >= Settings.bounty.killstreak
					isPlayerOnMission = MissionManager.IsPlayerOnMission(serverId)
					isHealthBarVisible = not isPlayerDead and (IsPlayerFreeAimingAtEntity(PlayerId(), ped) or isPlayerCrewMember or isPlayerCrewMemberAimingAt(ped))
					isPlayerTalking = NetworkIsPlayerTalking(id)
					isPlayerInPlane = IsPedInAnyPlane(ped)
					if not isPlayerInPlane then
						isPlayerInHeli = IsPedInAnyHeli(ped)
					end
					patreonTier = PlayerData.GetPatreonTier(serverId)

					-- https://runtime.fivem.net/doc/natives/?_0x5927F96A78577363
					if GetEntityLodDist(ped) ~= 0xFFFF then
						SetEntityLodDist(ped, 0xFFFF)
					end

					playerWeapon = GetSelectedPedWeapon(ped)
				end

				if not _gamerTags[id] or _gamerTags[id].ped ~= ped or not IsMpGamerTagActive(_gamerTags[id].tag) then
					if _gamerTags[id] then
						RemoveMpGamerTag(_gamerTags[id].tag)
					end

					_gamerTags[id] = {
						tag = CreateMpGamerTag(ped, '', false, false, '', 0),
						ped = ped
					}
				end

				local gamerTag = _gamerTags[id].tag

				local color = 0
				if isPlayerCrewMember then
					color = 10
				elseif isPlayerHotProperty or isPlayerBeast or isPlayerKingOfTheCastle or isPlayerHasBounty or isPlayerOnMission then
					color = 6
				elseif patreonTier ~= 0 then
					color = 15
				end

				-- https://runtime.fivem.net/doc/reference.html#_0x63BB75ABEDC1F6A0
				SetMpGamerTagName(gamerTag, GetPlayerName(id))

				SetMpGamerTagColour(gamerTag, 0, color)
				SetMpGamerTagColour(gamerTag, 2, 0)
				SetMpGamerTagColour(gamerTag, 4, color)
				SetMpGamerTagColour(gamerTag, 7, color)
				SetMpGamerTagHealthBarColour(gamerTag, 0)

				SetMpGamerTagAlpha(gamerTag, 0, 255)
				SetMpGamerTagAlpha(gamerTag, 2, 255)
				SetMpGamerTagAlpha(gamerTag, 4, 255)
				SetMpGamerTagAlpha(gamerTag, 7, 255)

				local isGamerTagVisible = isHealthBarVisible or HasEntityClearLosToEntity(playerPed, ped, 17)

				SetMpGamerTagVisibility(gamerTag, 0, isGamerTagVisible) -- GAMER_NAME
				SetMpGamerTagVisibility(gamerTag, 2, isHealthBarVisible) -- HEALTH/ARMOR
				SetMpGamerTagVisibility(gamerTag, 4, isGamerTagVisible and isPlayerTalking) -- AUDIO_ICON
				SetMpGamerTagVisibility(gamerTag, 7, isGamerTagVisible and patreonTier ~= 0) -- WANTED_STARS

				if ped ~= 0 then
					local blip = GetBlipFromEntity(ped)
					if not DoesBlipExist(blip) then
						blip = AddBlipForEntity(ped)
						SetBlipHighDetail(blip, true)
						ShowHeadingIndicatorOnBlip(blip, true)
					end

					local blipSprite = Blip.STANDARD
					if isPlayerDead then
						blipSprite = Blip.PLAYER_DEAD
					else
						if isPlayerHotProperty then blipSprite = Blip.HOT_PROPERTY
						elseif isPlayerKingOfTheCastle then blipSprite = Blip.CASTLE_KING
						elseif isPlayerBeast then blipSprite = Blip.BEAST
						elseif isPlayerOnMission then blipSprite = Blip.PLAYER_ON_MISSION
						elseif isPlayerHasBounty then blipSprite = Blip.BOUNTY_HIT
						elseif isPlayerInPlane then blipSprite = Blip.PLANE
						elseif isPlayerInHeli then blipSprite = Blip.HELI
						end
					end
					if GetBlipSprite(blip) ~= blipSprite then
						SetBlipSprite(blip, blipSprite)
					end

					-- local rotation = 0.0
					-- if isPlayerInPlane or isPlayerInHeli then
					-- 	rotation = GetEntityHeading(ped)
					-- end
					-- SetBlipSquaredRotation(blip, rotation)

					local scale = 0.7
					if isPlayerHotProperty or isPlayerKingOfTheCastle or isPlayerOnMission or isPlayerBeast or isPlayerHasBounty then
						scale = 0.9
					elseif isPlayerInPlane or isPlayerInHeli then
						scale = 0.9
					end
					SetBlipScale(blip, scale)

					local blipColor = Color.BLIP_WHITE
					if isPlayerCrewMember then
						blipColor = Color.BLIP_BLUE
					elseif isPlayerHotProperty or isPlayerKingOfTheCastle or isPlayerBeast or isPlayerHasBounty or isPlayerOnMission then
						blipColor = Color.BLIP_RED
					end
					SetBlipColour(blip, blipColor)

					local blipAlpha = isPlayerActive and 255 or 0
					if not isPlayerCrewMember then
						if not isPlayerHotProperty and not isPlayerBeast and not isPlayerKingOfTheCastle and not isPlayerHasBounty and not isPlayerOnMission and GetWeapontypeGroup(playerWeapon) ~= -1212426201 then
							if GetPedStealthMovement(ped) or GetPlayerInvincible(id) then
								blipAlpha = 25
							end
						end
					end
					if GetBlipAlpha(blip) ~= blipAlpha then
						SetBlipAlpha(blip, blipAlpha)
					end

					ShowCrewIndicatorOnBlip(blip, isPlayerCrewMember)

					SetBlipNameToPlayerName(blip, id)
				end
			elseif _gamerTags[id] then
				RemoveMpGamerTag(_gamerTags[id].tag)
				_gamerTags[id] = nil
			end
		end

		Citizen.Wait(0)
	end
end)
