local _reportedPlayers = { }
local _reportingPlayer = nil
local _reportingReasons = { 'Inappropriate Player Name', 'Harassment', 'Cheating', 'Spam', 'Abusing Game Mechanics' }

local function weaponTintPrice(tint, weaponHash)
	if GetPedWeaponTintIndex(PlayerPedId(), weaponHash) == tint.index then
		return 'Used'
	end

	if Player.Kills < tint.kills then
		return 'Kill '..tint.kills..' players'
	end

	return '$'..tint.cash
end

local function weaponComponentPrice(componentIndex, weapon, componentHash)
	local weaponHash = GetHashKey(weapon)
	if HasPedGotWeaponComponent(PlayerPedId(), weaponHash, componentHash) then
		return ''
	end

	local component = Weapon[weapon].components[componentIndex]
	if component.rank and Player.Rank < component.rank then
		return 'Rank '..component.rank
	end

	return '$'..component.cash
end

local function weaponPrice(weapon)
	if HasPedGotWeapon(PlayerPedId(), GetHashKey(weapon), false) then
		return ''
	end

	local weapon = Weapon[weapon]
	if weapon.rank and Player.Rank < weapon.rank then
		return 'Rank '..weapon.rank
	end

	if weapon.prestige and Player.Prestige < weapon.prestige then
		return 'Prestige '..weapon.prestige
	end

	return '$'..weapon.cash
end

local function weaponAmmoPrice(ammoType, ammo, maxAmmo)
	if ammo == maxAmmo then
		return 'Maxed'
	end

	return '$'..Settings.ammuNationRefillAmmo[ammoType].price
end

local function fullWeaponAmmoPrice(ammoType, ammoClipCount)
	if ammoClipCount == 0 then
		return 'Maxed'
	end

	return '$'..tostring(ammoClipCount * Settings.ammuNationRefillAmmo[ammoType].price)
end

RegisterNetEvent('lsv:weaponTintUpdated')
AddEventHandler('lsv:weaponTintUpdated', function(weaponHash, tintIndex)
	if weaponHash then
		SetPedWeaponTintIndex(PlayerPedId(), weaponHash, tintIndex)
		Player.SaveWeapons()
	else
		Gui.DisplayPersonalNotification('You don\'t have enough cash.')
	end

	Prompt.Hide()
end)

RegisterNetEvent('lsv:weaponComponentUpdated')
AddEventHandler('lsv:weaponComponentUpdated', function(weapon, componentIndex)
	if weapon then
		GiveWeaponComponentToPed(PlayerPedId(), GetHashKey(weapon), Weapon[weapon].components[componentIndex].hash)
		Player.SaveWeapons()
	else
		Gui.DisplayPersonalNotification('You don\'t have enough cash.')
	end

	Prompt.Hide()
end)

RegisterNetEvent('lsv:weaponPurchased')
AddEventHandler('lsv:weaponPurchased', function(weapon)
	if weapon then
		local weaponHash = GetHashKey(weapon)
		GiveWeaponToPed(PlayerPedId(), weaponHash, WeaponUtility.GetSpawningAmmo(weaponHash), false, true)
		Player.SaveWeapons()
	else
		Gui.DisplayPersonalNotification('You don\'t have enough cash.')
	end

	Prompt.Hide()
end)

RegisterNetEvent('lsv:weaponSold')
AddEventHandler('lsv:weaponSold', function(weapon)
	RemoveWeaponFromPed(PlayerPedId(), GetHashKey(weapon))
	Player.SaveWeapons()
	Prompt.Hide()
end)

RegisterNetEvent('lsv:ammoRefilled')
AddEventHandler('lsv:ammoRefilled', function(weapon, amount, fullAmmo)
	if amount then
		if not fullAmmo then
			AddAmmoToPed(PlayerPedId(), GetHashKey(weapon), amount)
		else
			local weaponHash = GetHashKey(weapon)
			local _, maxAmmo = GetMaxAmmo(PlayerPedId(), weaponHash)
			SetPedAmmo(PlayerPedId(), weaponHash, maxAmmo)
		end
	else
		Gui.DisplayPersonalNotification('You don\'t have enough cash.')
	end

	Prompt.Hide()
end)

AddEventHandler('lsv:init', function()
	local selectedWeapon = nil
	local selectedWeaponHash = nil
	local selectedWeaponCategory = nil
	local selectedWeaponComponent = nil
	local selectedAmmoType = nil

	local challengeTarget = nil

	WarMenu.CreateMenu('interaction', GetPlayerName(PlayerId()))
	WarMenu.SetMenuMaxOptionCountOnScreen('interaction', Settings.maxMenuOptionCount)
	WarMenu.SetTitleColor('interaction', 255, 255, 255)
	WarMenu.SetTitleBackgroundColor('interaction', Color.WHITE.r, Color.WHITE.g, Color.WHITE.b, Color.WHITE.a)
	WarMenu.SetTitleBackgroundSprite('interaction', 'commonmenu', 'interaction_bgd')

	WarMenu.CreateSubMenu('interaction_confirm', 'interaction', 'Are you sure?')

	WarMenu.CreateSubMenu('inviteToCrew', 'interaction', 'Invite to Crew')

	WarMenu.CreateSubMenu('stats', 'interaction', 'Statistics')

	WarMenu.CreateSubMenu('reportPlayer', 'interaction', 'Report Player')
	WarMenu.CreateSubMenu('reportReason', 'reportPlayer', 'Select a reason for reporting')

	WarMenu.CreateSubMenu('ammunation', 'interaction', 'Ammu-Nation')
	WarMenu.SetTitleColor('ammunation', 0, 0, 0, 0)
	WarMenu.SetTitleBackgroundSprite('ammunation', 'shopui_title_gr_gunmod', 'shopui_title_gr_gunmod')

	WarMenu.CreateSubMenu('ammunation_weaponCategories', 'ammunation', 'Weapons')

	WarMenu.CreateSubMenu('ammunation_weapons', 'ammunation_weaponCategories', '')
	WarMenu.SetMenuButtonPressedSound('ammunation_weapons', 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET')

	WarMenu.CreateSubMenu('ammunation_sell', 'ammunation_weapons')
	WarMenu.SetMenuButtonPressedSound('ammunation_sell', 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET')

	WarMenu.CreateSubMenu('ammunation_ammunition', 'ammunation', 'Ammunition')

	WarMenu.CreateSubMenu('ammunation_ammunition_ammo', 'ammunation_ammunition', 'Ammunition')
	WarMenu.SetMenuButtonPressedSound('ammunation_ammunition_ammo', 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET')

	WarMenu.CreateSubMenu('ammunation_upgradeWeapons', 'ammunation', 'Weapon Upgrades')

	WarMenu.CreateSubMenu('ammunation_weaponUpgrades', 'ammunation_upgradeWeapons', '')
	WarMenu.SetMenuButtonPressedSound('ammunation_weaponUpgrades', 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET')

	WarMenu.CreateSubMenu('ammunation_removeUpgradeConfirm', 'ammunation_weaponUpgrades', '')
	WarMenu.SetMenuButtonPressedSound('ammunation_weaponUpgrades', 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET')

	WarMenu.CreateSubMenu('challenges', 'interaction', 'Select player to compete')
	WarMenu.CreateSubMenu('challenges_list', 'challenges', 'Select challenge')

	while true do
		if WarMenu.IsMenuOpened('interaction') then
			if IsPlayerDead(PlayerId()) then
				WarMenu.CloseMenu()
				Prompt.Hide()
			elseif WarMenu.MenuButton('Ammu-Nation', 'ammunation') then
			elseif Player.IsInFreeroam() and WarMenu.MenuButton('Challenges', 'challenges') then
			elseif Player.Faction ~= Settings.faction.Neutral and WarMenu.Button('Leave Faction') then
				Player.ResetModel()
				TriggerServerEvent('lsv:leaveFaction')
				WarMenu.CloseMenu()
			elseif WarMenu.MenuButton('Invite to Crew', 'inviteToCrew') then
			elseif #Player.CrewMembers ~= 0 and WarMenu.Button('Leave Crew') then
				TriggerServerEvent('lsv:leaveCrew')
				WarMenu.CloseMenu()
			elseif WarMenu.MenuButton('Statistics', 'stats') then
			elseif WarMenu.Button('Kill Yourself') then
				SetEntityHealth(PlayerPedId(), 0)

				WarMenu.CloseMenu()
			elseif WarMenu.MenuButton('Report Player', 'reportPlayer') then
			elseif Player.Rank >= Settings.minPrestigeRank and Player.Prestige < Settings.maxPrestige and WarMenu.MenuButton('~y~Up Prestige To Level '..(Player.Prestige + 1), 'interaction_confirm') then
			elseif MissionManager.Mission and WarMenu.Button('~r~Cancel Mission') then
				MissionManager.FinishMission()
				WarMenu.CloseMenu()
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('interaction_confirm') then
			if WarMenu.Button('Yes') then
				if Player.Rank < Settings.minPrestigeRank then
					Gui.DisplayPersonalNotification('You need to be at least Rank '..Settings.minPrestigeRank..'.')
				elseif Player.Prestige >= Settings.maxPrestige then
					Gui.DisplayPersonalNotification('You already have maximum Prestige level. Wow.')
				else
					TriggerServerEvent('lsv:upPrestigeLevel')
					Prompt.ShowAsync()
				end
			elseif WarMenu.MenuButton('No', 'interaction') then
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('stats') then
			local timePlayedMin = Player.TimePlayed / (1000 * 60);

			if WarMenu.Button('Time Played', string.format('%02d:%02d', math.floor(timePlayedMin / 60), math.floor(timePlayedMin % 60))) then
			elseif WarMenu.Button('Kills', Player.Kills) then
			elseif WarMenu.Button('Deaths', Player.Deaths) then
			elseif WarMenu.Button('Headshots', Player.Headshots..' ('..string.format('%02.2f', (Player.Headshots / Player.Kills) * 100)..'%)') then
			elseif WarMenu.Button('Max Killstreak', Player.MaxKillstreak) then
			elseif WarMenu.Button('Missions Done', Player.MissionsDone) then
			elseif WarMenu.Button('Events Won', Player.EventsWon) then
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('ammunation') then
			if WarMenu.MenuButton('Weapons', 'ammunation_weaponCategories') then
			elseif WarMenu.MenuButton('Ammunition', 'ammunation_ammunition') then
			elseif WarMenu.MenuButton('Weapon Upgrades', 'ammunation_upgradeWeapons') then
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('ammunation_weaponCategories') then
			table.foreach(Settings.ammuNationWeapons, function(_, weaponCategory)
				if WarMenu.MenuButton(weaponCategory, 'ammunation_weapons') then
					WarMenu.SetSubTitle('ammunation_weapons', weaponCategory)
					selectedWeaponCategory = weaponCategory
				end
			end)

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('ammunation_weapons') then
			table.foreach(Settings.ammuNationWeapons[selectedWeaponCategory], function(weapon)
				if Weapon[weapon].cash and WarMenu.MenuButton(Weapon[weapon].name, 'ammunation_sell', weaponPrice(weapon)) then
					if not HasPedGotWeapon(PlayerPedId(), GetHashKey(weapon), false) then
						WarMenu.OpenMenu('ammunation_weapons')
						if Weapon[weapon].rank and Weapon[weapon].rank > Player.Rank then
							Gui.DisplayPersonalNotification('Your Rank is too low.')
						elseif Weapon[weapon].prestige and Weapon[weapon].prestige > Player.Prestige then
							Gui.DisplayPersonalNotification('Your Prestige is too low.')
						else
							TriggerServerEvent('lsv:purchaseWeapon', weapon, selectedWeaponCategory)
							Prompt.ShowAsync()
						end
					else
						selectedWeapon = weapon
						local sellPrice = math.floor(Weapon[weapon].cash * Settings.sellWeaponRatio)
						WarMenu.SetSubTitle('ammunation_sell', 'Sell '..Weapon[weapon].name..' for $'..sellPrice..'?')
					end
				end
			end)

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('ammunation_sell') then
			if WarMenu.MenuButton('Yes', 'ammunation_weapons') then
				TriggerServerEvent('lsv:sellWeapon', selectedWeapon)
				Prompt.ShowAsync()
			elseif WarMenu.MenuButton('No', 'ammunation_weapons') then
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('ammunation_ammunition') then
			table.foreach(Settings.ammuNationRefillAmmo, function(data, ammoType)
				local playerWeaponByAmmoType = table.find_if(data.weapons, function(weapon)
					return HasPedGotWeapon(PlayerPedId(), GetHashKey(weapon), false)
				end)

				if playerWeaponByAmmoType and WarMenu.MenuButton(ammoType, 'ammunation_ammunition_ammo') then
					WarMenu.SetSubTitle('ammunation_ammunition_ammo', ammoType)
					selectedWeapon = playerWeaponByAmmoType
					selectedAmmoType = ammoType
					SetCurrentPedWeapon(PlayerPedId(), selectedWeapon, true)
				end
			end)

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('ammunation_ammunition_ammo') then
			local weaponHash = GetHashKey(selectedWeapon)
			local _, maxAmmo = GetMaxAmmo(PlayerPedId(), weaponHash)
			local weaponAmmoType = GetPedAmmoTypeFromWeapon(PlayerPedId(), weaponHash)
			local playerAmmo = GetPedAmmoByType(PlayerPedId(), weaponAmmoType)

			local ammoClipCount = 0
			if playerAmmo ~= maxAmmo then
				ammoClipCount = math.max(1, math.floor((maxAmmo - playerAmmo) / Settings.ammuNationRefillAmmo[selectedAmmoType].ammo))
			end

			if WarMenu.Button('Full Ammo', fullWeaponAmmoPrice(selectedAmmoType, ammoClipCount)) then
				if playerAmmo == maxAmmo then
					Gui.DisplayPersonalNotification('You already have max ammo.')
				else
					TriggerServerEvent('lsv:refillAmmo', selectedAmmoType, selectedWeapon, ammoClipCount)
					Prompt.ShowAsync()
				end
			elseif WarMenu.Button(selectedAmmoType..' x'..Settings.ammuNationRefillAmmo[selectedAmmoType].ammo,
				weaponAmmoPrice(selectedAmmoType, playerAmmo, maxAmmo)) then
				if playerAmmo == maxAmmo then
					Gui.DisplayPersonalNotification('You already have max ammo.')
				else
					TriggerServerEvent('lsv:refillAmmo', selectedAmmoType, selectedWeapon)
					Prompt.ShowAsync()
				end
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('ammunation_upgradeWeapons') then
			local playerWeapons = Player.GetPlayerWeapons()

			table.foreach(playerWeapons, function(weapon)
				local weaponName = Weapon[weapon.id].name
				if WarMenu.MenuButton(weaponName, 'ammunation_weaponUpgrades') then
					WarMenu.SetSubTitle('ammunation_weaponUpgrades', weaponName..' UPGRADES')
					SetCurrentPedWeapon(PlayerPedId(), GetHashKey(weapon.id), true)
					selectedWeapon = weapon.id
				end
			end)

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('ammunation_weaponUpgrades') then
			selectedWeaponHash = GetHashKey(selectedWeapon)

			table.foreach(Weapon[selectedWeapon].components, function(component, componentIndex)
				if HasPedGotWeaponComponent(PlayerPedId(), selectedWeaponHash, component.hash) then
					if WarMenu.MenuButton(component.name, 'ammunation_removeUpgradeConfirm') then
						selectedWeaponComponent = component.hash
						WarMenu.SetSubTitle('ammunation_removeUpgradeConfirm', 'Remove '..component.name..'?')
					end
				elseif WarMenu.Button(component.name, weaponComponentPrice(componentIndex, selectedWeapon, component.hash)) then
					if component.rank and component.rank > Player.Rank then
						Gui.DisplayPersonalNotification('Your Rank is too low.')
					else
						TriggerServerEvent('lsv:updateWeaponComponent', selectedWeapon, componentIndex)
						Prompt.ShowAsync()
					end
				end
			end)

			if GetWeaponTintCount(selectedWeaponHash) == table.length(Settings.weaponTints) then
				table.iforeach(Settings.weaponTints, function(tint, tintIndex)
					if WarMenu.Button(tint.name or Settings.weaponTintNames[tint.index], weaponTintPrice(tint, selectedWeaponHash)) then
						if GetPedWeaponTintIndex(PlayerPedId(), selectedWeaponHash) == tint.index then
							Gui.DisplayPersonalNotification('You already use this tint.')
						elseif tint.kills > Player.Kills then
							Gui.DisplayPersonalNotification('You don\'t have enough kills.')
						else
							TriggerServerEvent('lsv:updateWeaponTint', selectedWeaponHash, tintIndex)
							Prompt.ShowAsync()
						end
					end
				end)
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('ammunation_removeUpgradeConfirm') then
			if WarMenu.MenuButton('Yes', 'ammunation_weaponUpgrades') then
				RemoveWeaponComponentFromPed(PlayerPedId(), selectedWeaponHash, selectedWeaponComponent)
				Player.SaveWeapons()
			elseif WarMenu.MenuButton('No', 'ammunation_weaponUpgrades') then
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('challenges') then
			for _, i in ipairs(GetActivePlayers()) do
				if i ~= PlayerId() then
					if WarMenu.MenuButton(GetPlayerName(i), 'challenges_list') then
						challengeTarget = GetPlayerServerId(i)
					end
				end
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('challenges_list') then
			if WarMenu.Button('One on One Deathmatch') then
				TriggerServerEvent('lsv:requestDuel', challengeTarget)
				WarMenu.CloseMenu()
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('inviteToCrew') then
			for _, i in ipairs(GetActivePlayers()) do
				if i ~= PlayerId() then
					local player = GetPlayerServerId(i)
					if not Player.IsCrewMember(player) and WarMenu.Button(GetPlayerName(i)) then
						Gui.DisplayPersonalNotification('You have sent Crew Invitation to '..Gui.GetPlayerName(player))
						TriggerServerEvent('lsv:inviteToCrew', player)
						WarMenu.CloseMenu()
					end
				end
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('reportPlayer') then
			for _, i in ipairs(GetActivePlayers()) do
				if i ~= PlayerId() then
					local target = GetPlayerServerId(i)
					if not table.find(_reportedPlayers, target) and WarMenu.MenuButton(GetPlayerName(i), 'reportReason') then
						_reportingPlayer = target
					end
				end
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('reportReason') then
			table.foreach(_reportingReasons, function(reason)
				if WarMenu.Button(reason) then
					TriggerServerEvent('lsv:reportPlayer', _reportingPlayer, reason)
					table.insert(_reportedPlayers, _reportingPlayer)
					_reportingPlayer = nil
					WarMenu.CloseMenu()
				end
			end)

			WarMenu.Display()
		end

		Citizen.Wait(0)
	end
end)

AddEventHandler('lsv:init', function()
	while true do
		Citizen.Wait(0)

		if IsControlJustReleased(1, 244) then
			Gui.OpenMenu('interaction')
		end
	end
end)
