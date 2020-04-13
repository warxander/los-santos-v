local _gamerTags = { }

local function isPlayerCrewMemberAimingAt(ped)
	for _, member in ipairs(Player.CrewMembers) do
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
				local isPlayerHasBounty = false
				local isPlayerOnMission = false
				local isHealthBarVisible = false
				local isPlayerTalking = false
				local faction = Settings.faction.Neutral
				local isPlayerEnforcer = false
				local isPlayerCriminal = false
				local isPlayerInPlane = false
				local isPlayerInHeli = false
				local isPlayerInVehicle = false
				local patreonTier = 0

				if isPlayerActive then
					isPlayerCrewMember = Player.IsCrewMember(serverId)
					isPlayerBeast = serverId == World.BeastPlayer
					isPlayerHotProperty = serverId == World.HotPropertyPlayer
					isPlayerHasBounty = PlayerData.GetKillstreak(serverId) >= Settings.bounty.killstreak
					isPlayerOnMission = MissionManager.IsPlayerOnMission(serverId)
					isHealthBarVisible = not isPlayerDead and (IsPlayerFreeAimingAtEntity(PlayerId(), ped) or isPlayerCrewMember or isPlayerCrewMemberAimingAt(ped))
					isPlayerTalking = NetworkIsPlayerTalking(id)
					faction = PlayerData.GetFaction(serverId)
					if Player.Faction ~= Settings.faction.Neutral then
						isPlayerEnforcer = faction == Settings.faction.Enforcer
						isPlayerCriminal = faction == Settings.faction.Criminal
					end
					isPlayerInPlane = IsPedInAnyPlane(ped)
					if not isPlayerInPlane then
						isPlayerInHeli = IsPedInAnyHeli(ped)
						if not isPlayerInHeli then
							isPlayerInVehicle = IsPedInAnyVehicle(ped)
						end
					end
					patreonTier = PlayerData.GetPatreonTier(serverId)

					-- https://runtime.fivem.net/doc/natives/?_0x5927F96A78577363
					if GetEntityLodDist(ped) ~= 0xFFFF then
						SetEntityLodDist(ped, 0xFFFF)
					end
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
				elseif isPlayerEnforcer then
					color = 11
				elseif isPlayerHotProperty or isPlayerBeast or isChallengingPlayer or isPlayerHasBounty or isPlayerCriminal then
					color = 6
				elseif isPlayerOnMission then
					color = 29
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

				-- TODO: Add distance check?
				local isGamerTagVisible = isHealthBarVisible
				if not isGamerTagVisible then
					if Player.Faction ~= Settings.faction.Neutral then
						isGamerTagVisible = Player.Faction == faction
					end
				end
				if not isGamerTagVisible then
					isGamerTagVisible = HasEntityClearLosToEntity(playerPed, ped, 17)
				end

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
					elseif not isChallengingPlayer then
						if isPlayerHotProperty then blipSprite = Blip.HOT_PROPERTY
						elseif isPlayerBeast then blipSprite = Blip.BEAST
						elseif isPlayerOnMission then blipSprite = Blip.PLAYER_ON_MISSION
						elseif isPlayerHasBounty then blipSprite = Blip.BOUNTY_HIT
						elseif isPlayerInPlane then blipSprite = Blip.PLANE
						elseif isPlayerInHeli then blipSprite = Blip.HELI
						elseif isPlayerInVehicle then blipSprite = Blip.CAR
						end
					end
					if GetBlipSprite(blip) ~= blipSprite then
						SetBlipSprite(blip, blipSprite)
					end

					-- local rotation = 0.0
					-- if isPlayerInVehicle or isPlayerInPlane or isPlayerInHeli then
					-- 	rotation = GetEntityHeading(ped)
					-- end
					-- SetBlipSquaredRotation(blip, rotation)

					local scale = 0.7
					if isChallengingPlayer then
						scale = 0.8
					elseif isPlayerHotProperty or isPlayerOnMission or isPlayerBeast or isPlayerHasBounty then
						scale = 0.9
					elseif isPlayerInVehicle or isPlayerInPlane or isPlayerInHeli then
						scale = 0.9
					end
					SetBlipScale(blip, scale)

					local blipColor = Color.BLIP_WHITE
					if isPlayerCrewMember then
						blipColor = Color.BLIP_BLUE
					elseif isPlayerEnforcer then
						blipColor = Color.BLIP_DARK_BLUE
					elseif isPlayerHotProperty or isPlayerBeast or isChallengingPlayer or isPlayerHasBounty or isPlayerCriminal then
						blipColor = Color.BLIP_RED
					elseif isPlayerOnMission then
						blipColor = Color.BLIP_PURPLE
					end
					SetBlipColour(blip, blipColor)

					local blipAlpha = isPlayerActive and 255 or 0
					if not isPlayerCrewMember then
						if not isPlayerHotProperty and not isPlayerBeast and not isPlayerHasBounty and not isPlayerOnMission then
							if GetPedStealthMovement(ped) or GetPlayerInvincible(id) then
								blipAlpha = 25
							end
						end
					end
					if GetBlipAlpha(blip) ~= blipAlpha then
						SetBlipAlpha(blip, blipAlpha)
					end

					ShowCrewIndicatorOnBlip(blip, isPlayerCrewMember)
					ShowFriendIndicatorOnBlip(blip, Player.Faction ~= Settings.faction.Neutral and Player.Faction == faction)

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
