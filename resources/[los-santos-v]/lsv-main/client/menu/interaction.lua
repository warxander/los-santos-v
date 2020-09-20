local _actions = {
	{ name = 'Cheer', scenario = 'WORLD_HUMAN_CHEERING' },
	{ name = 'Shocking', scenario = 'WORLD_HUMAN_MOBILE_FILM_SHOCKING' },
	{ name = 'Lean', scenario = 'WORLD_HUMAN_LEANING' },
	{ name = 'Smoke', scenario = 'WORLD_HUMAN_SMOKING' },
	{ name = 'Drink', scenario = 'WORLD_HUMAN_DRINKING' },
	{ name = 'Muscle Flex', scenario = 'WORLD_HUMAN_MUSCLE_FLEX' },
	{ name = 'Party', scenario = 'WORLD_HUMAN_PARTYING' },
	{ name = 'Musician', scenario = 'WORLD_HUMAN_MUSICIAN' },
	{ name = 'Paparazzi', scenario = 'WORLD_HUMAN_PAPARAZZI' },
	{ name = 'Prostitute', scenario = 'WORLD_HUMAN_PROSTITUTE_HIGH_CLASS' },
	{ name = 'Strip Watch', scenario = 'WORLD_HUMAN_STRIP_WATCH_STAND' },
	{ name = 'Fishing', scenario = 'WORLD_HUMAN_STAND_FISHING' },
	{ name = 'Yoga', scenario = 'WORLD_HUMAN_YOGA' },
	{ name = 'Sunbathe', scenario = 'WORLD_HUMAN_SUNBATHE' },
	{ name = 'Picnic', scenario = 'WORLD_HUMAN_PICNIC' },
	{ name = 'Binoculars', scenario = 'WORLD_HUMAN_BINOCULARS' },
	{ name = 'Investigation', scenario = 'CODE_HUMAN_POLICE_INVESTIGATE' },
	{ name = 'Time of Death', scenario = 'CODE_HUMAN_MEDIC_TIME_OF_DEATH' },
	{ name = 'Fire', scenario = 'WORLD_HUMAN_STAND_FIRE' },
}

local _crewRace = { }
local _crewFinishRadius = 10.

local function resetCrewRace()
	if _crewRace.blip then
		RemoveBlip(_crewRace.blip)
	end

	_crewRace = { }
end

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

	if weapon.cash then
		return '$'..weapon.cash
	end

	return nil
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

RegisterNetEvent('lsv:finishCrewRace')
AddEventHandler('lsv:finishCrewRace', function(winner)
	if not Player.IsInCrew() then
		return
	end

	Gui.DisplayPersonalNotification(Gui.GetPlayerName(winner)..' won Crew Race.')

	resetCrewRace()

	if Player.ServerId() == winner then
		PlaySoundFrontend(-1, 'RACE_PLACED', 'HUD_AWARDS', true)

		local scaleform = Scaleform.NewAsync('MIDSIZED_MESSAGE')
		scaleform:call('SHOW_SHARD_MIDSIZED_MESSAGE', 'WINNER', '')
		scaleform:renderFullscreenTimed(7000)
	end
end)

RegisterNetEvent('lsv:crewRaceStarted')
AddEventHandler('lsv:crewRaceStarted', function(finishCoords)
	if not Player.IsInCrew() then
		return
	end

	_crewRace.inProgress = true

	_crewRace.blip = Map.CreatePlaceBlip(Blip.CREW_RACE_FINISH, finishCoords.x, finishCoords.y, finishCoords.z)
	SetBlipAsShortRange(_crewRace.blip, false)
	SetBlipRoute(_crewRace.blip, true)
	Map.SetBlipFlashes(_crewRace.blip)

	_crewRace.finishCoords = finishCoords

	if Player.IsACrewLeader() then
		DeleteWaypoint()
		WarMenu.CloseMenu()
		Prompt.Hide()
	end

	local countdownMessages = { '3...', '2...', '1...' }
	while #countdownMessages ~= 0 do
		PlaySoundFrontend(-1, '3_2_1', 'HUD_MINI_GAME_SOUNDSET', true)
		Gui.DisplayPersonalNotification(countdownMessages[1])
		Citizen.Wait(1000)
		table.remove(countdownMessages, 1)
	end

	PlaySoundFrontend(-1, 'GO', 'HUD_MINI_GAME_SOUNDSET', true)
	Gui.DisplayPersonalNotification('GO!')

	while true do
		Citizen.Wait(0)

		if not _crewRace.inProgress then
			return
		end

		if Player.DistanceTo(_crewRace.finishCoords) < _crewFinishRadius then
			TriggerServerEvent('lsv:finishCrewRace', Player.ServerId())
			return
		end
	end
end)

RegisterNetEvent('lsv:crewMemberLeft')
AddEventHandler('lsv:crewMemberLeft', function(player)
	if not Player.IsInCrew() or player ~= Player.ServerId() then
		return
	end

	resetCrewRace()
end)

RegisterNetEvent('lsv:crewDisbanded')
AddEventHandler('lsv:crewDisbanded', function()
	if not Player.IsInCrew() then
		return
	end

	resetCrewRace()
end)

AddEventHandler('lsv:init', function()
	local killYourselfTimer = Timer.New()

	local selectedWeapon = nil
	local selectedWeaponHash = nil
	local selectedWeaponCategory = nil
	local selectedWeaponComponent = nil
	local selectedAmmoType = nil

	Gui.CreateMenu('interaction', GetPlayerName(PlayerId()))
	WarMenu.SetTitleColor('interaction', 255, 255, 255)
	WarMenu.SetTitleBackgroundColor('interaction', Color.WHITE.r, Color.WHITE.g, Color.WHITE.b, Color.WHITE.a)
	WarMenu.SetTitleBackgroundSprite('interaction', 'commonmenu', 'interaction_bgd')

	WarMenu.CreateSubMenu('interaction_confirm', 'interaction', 'Are you sure?')

	WarMenu.CreateSubMenu('actions', 'interaction', 'Actions')

	WarMenu.CreateSubMenu('manageCrew', 'interaction', 'Manage Crew')
	WarMenu.CreateSubMenu('inviteToCrew', 'manageCrew', 'Invite to Crew')

	WarMenu.CreateSubMenu('stats', 'interaction', 'Statistics')
	WarMenu.CreateSubMenu('stats_drug_business', 'stats', 'Drug Business (Supplies/Stock)')

	WarMenu.CreateSubMenu('settings', 'interaction', 'Player Settings')

	WarMenu.CreateSubMenu('ammunition', 'interaction', 'Ammunition')
	WarMenu.SetTitleColor('ammunition', 0, 0, 0, 0)
	WarMenu.SetTitleBackgroundSprite('ammunition', 'shopui_title_gr_gunmod', 'shopui_title_gr_gunmod')

	WarMenu.CreateSubMenu('ammunition_ammo', 'ammunition', 'Ammunition')
	WarMenu.SetMenuButtonPressedSound('ammunition_ammo', 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET')

	WarMenu.CreateSubMenu('ammunation', 'interaction', 'Ammu-Nation')
	WarMenu.SetTitleColor('ammunation', 0, 0, 0, 0)
	WarMenu.SetTitleBackgroundSprite('ammunation', 'shopui_title_gunclub', 'shopui_title_gunclub')

	WarMenu.CreateSubMenu('ammunation_weapons', 'ammunation', '')

	WarMenu.CreateSubMenu('ammunation_discard', 'ammunation_weapons')
	WarMenu.CreateSubMenu('ammunation_weaponUpgrades', 'ammunation_weapons', '')
	WarMenu.SetMenuButtonPressedSound('ammunation_weaponUpgrades', 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET')

	WarMenu.CreateSubMenu('ammunation_removeUpgradeConfirm', 'ammunation_weaponUpgrades', '')
	WarMenu.SetMenuButtonPressedSound('ammunation_removeUpgradeConfirm', 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET')

	while true do
		if WarMenu.IsMenuOpened('interaction') then
			local killYourselfLeft = Settings.killYourselfInterval - killYourselfTimer:elapsed()

			if IsPlayerDead(PlayerId()) then
				WarMenu.CloseMenu()
				Prompt.Hide()
			elseif WarMenu.MenuButton('Ammunition', 'ammunition') then
			elseif WarMenu.MenuButton('Ammu-Nation', 'ammunation') then
			elseif IsPedActiveInScenario(PlayerPedId()) and WarMenu.Button('Cancel Action') then
				ClearPedTasks(PlayerPedId())
				WarMenu.CloseMenu()
			elseif not IsPedActiveInScenario(PlayerPedId()) and WarMenu.MenuButton('Actions', 'actions') then
			elseif Player.IsACrewLeader() and WarMenu.MenuButton('Manage Crew', 'manageCrew') then
			elseif Player.IsInCrew() and not Player.IsACrewLeader() and WarMenu.Button('Leave Crew') then
				TriggerServerEvent('lsv:leaveCrew')
				Prompt.ShowAsync()
				WarMenu.CloseMenu()
			elseif not Player.IsInCrew() and WarMenu.Button('Form Crew') then
				TriggerServerEvent('lsv:formCrew')
				Prompt.ShowAsync()
			elseif WarMenu.MenuButton('Statistics', 'stats') then
			elseif WarMenu.MenuButton('Settings', 'settings') then
			elseif WarMenu.Button('Kill Yourself', killYourselfLeft > 0 and string.from_ms(killYourselfLeft) or '') then
				if killYourselfLeft <= 0 then
					SetEntityHealth(PlayerPedId(), 0)
					WarMenu.CloseMenu()
					killYourselfTimer:restart()
				end
			elseif Player.Rank >= Settings.prestige.minRank and WarMenu.MenuButton('~o~Up Prestige Level To '..(Player.Prestige + 1), 'interaction_confirm') then
			elseif MissionManager.Mission and WarMenu.Button('~r~Abort Mission') then
				MissionManager.AbortMission()
				WarMenu.CloseMenu()
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('actions') then
			local playerPed = PlayerPedId()
			table.iforeach(_actions, function(actionData)
				if WarMenu.Button(actionData.name) then
					if IsPedInAnyVehicle(playerPed, true) or not IsPedStill(playerPed) then
						Gui.DisplayPersonalNotification('You can\'t play any action right now.')
					else
						TaskStartScenarioInPlace(playerPed, actionData.scenario, 0, true)
						WarMenu.CloseMenu()
					end
				end
			end)

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('manageCrew') then
			if WarMenu.MenuButton('Invite to Crew', 'inviteToCrew') then
			elseif not _crewRace.inProgress and WarMenu.Button('Start Race') then
				local blip = Player.GetWaypoint()
				if DoesBlipExist(blip) then
					TriggerServerEvent('lsv:startCrewRace', GetBlipCoords(blip))
					Prompt.ShowAsync()
				else
					Gui.DisplayPersonalNotification('You need to place Waypoint first.')
				end
			elseif WarMenu.Button('~r~Disband Crew') then
				TriggerServerEvent('lsv:disbandCrew')
				Prompt.ShowAsync()
				WarMenu.CloseMenu()
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('interaction_confirm') then
			if WarMenu.MenuButton('No', 'interaction') then
			elseif WarMenu.Button('~r~Yes') then
				if Player.Rank < Settings.prestige.minRank then
					Gui.DisplayPersonalNotification('You need to be at least Rank '..Settings.prestige.minRank..'.')
				else
					TriggerServerEvent('lsv:upPrestigeLevel')
					Prompt.ShowAsync()
				end
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('stats') then
			local timePlayedMin = Player.TimePlayed / (1000 * 60);

			if WarMenu.MenuButton('Drug Business', 'stats_drug_business') then
			elseif WarMenu.Button('Time Played', string.format('%02d:%02d', math.floor(timePlayedMin / 60), math.floor(timePlayedMin % 60))) then
			elseif WarMenu.Button('Money Wasted', '$'..Player.MoneyWasted) then
			elseif WarMenu.Button('Kills', Player.Kills) then
			elseif WarMenu.Button('Deaths', Player.Deaths) then
			elseif WarMenu.Button('Headshots', Player.Headshots..' ('..string.format('%02.2f', (Player.Headshots / Player.Kills) * 100)..'%)') then
			elseif WarMenu.Button('Max Killstreak', Player.MaxKillstreak) then
			elseif WarMenu.Button('Vehicle Kills', Player.VehicleKills) then
			elseif WarMenu.Button('Longest Kill Distance', string.format('%dm', Player.LongestKillDistance)) then
			elseif WarMenu.Button('Missions Done', Player.MissionsDone) then
			elseif WarMenu.Button('Events Won', Player.EventsWon) then
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('stats_drug_business') then
			table.foreach(Settings.drugBusiness.types, function(data, type)
				if not Player.HasDrugBusiness(type) then
					return
				end

				if WarMenu.Button(data.name, Player.DrugBusiness[type].supplies..'/'..Player.DrugBusiness[type].stock) then
				end
			end)

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('settings') then
			table.foreach(Settings.player, function(name, id)
				local value = Player.Settings[id]
				if WarMenu.CheckBox(name, value) then
					TriggerServerEvent('lsv:updatePlayerSetting', id, not value)
					Prompt.ShowAsync()
				end
			end)

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('ammunition') then
			local playerPed = PlayerPedId()

			table.foreach(Settings.ammuNationRefillAmmo, function(data, ammoType)
				local playerWeaponByAmmoType = table.ifind_if(data.weapons, function(weapon)
					return HasPedGotWeapon(playerPed, GetHashKey(weapon), false)
				end)

				if playerWeaponByAmmoType and WarMenu.MenuButton(ammoType, 'ammunition_ammo') then
					WarMenu.SetSubTitle('ammunition_ammo', ammoType)
					selectedWeapon = playerWeaponByAmmoType
					selectedAmmoType = ammoType
					SetCurrentPedWeapon(playerPed, selectedWeapon, true)
				end
			end)

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('ammunition_ammo') then
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
		elseif WarMenu.IsMenuOpened('ammunation') then
			table.foreach(Settings.ammuNationWeapons, function(_, weaponCategory)
				if WarMenu.MenuButton(weaponCategory, 'ammunation_weapons') then
					WarMenu.SetSubTitle('ammunation_weapons', weaponCategory)
					selectedWeaponCategory = weaponCategory
				end
			end)

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('ammunation_weapons') then
			local playerPed = PlayerPedId()

			table.iforeach(Settings.ammuNationWeapons[selectedWeaponCategory], function(weapon)
				local weaponData = Weapon[weapon]
				local weaponHash = GetHashKey(weapon)
				if HasPedGotWeapon(playerPed, weaponHash, false) then
					if WarMenu.MenuButton(weaponData.name, 'ammunation_weaponUpgrades') then
						WarMenu.SetSubTitle('ammunation_weaponUpgrades', weaponData.name..' UPGRADES')
						SetCurrentPedWeapon(playerPed, weaponHash, true)
						selectedWeapon = weapon
						selectedWeaponHash = weaponHash
					end
				else
					local price = weaponPrice(weapon)
					if price and WarMenu.Button(weaponData.name, price) then
						if weaponData.rank and weaponData.rank > Player.Rank then
							Gui.DisplayPersonalNotification('Your Rank is too low.')
						elseif weaponData.prestige and weaponData.prestige > Player.Prestige then
							Gui.DisplayPersonalNotification('Your Prestige is too low.')
						else
							TriggerServerEvent('lsv:purchaseWeapon', weapon, selectedWeaponCategory)
							Prompt.ShowAsync()
						end
					end
				end
			end)

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('ammunation_weaponUpgrades') then
			if WarMenu.MenuButton('~r~Discard', 'ammunation_discard') then
				WarMenu.SetSubTitle('ammunation_discard', 'Do you want to discard '..Weapon[selectedWeapon].name..'?')
			else
				local playerPed = PlayerPedId()

				table.iforeach(Weapon[selectedWeapon].components, function(component, componentIndex)
					if HasPedGotWeaponComponent(playerPed, selectedWeaponHash, component.hash) then
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
							if GetPedWeaponTintIndex(playerPed, selectedWeaponHash) == tint.index then
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
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('ammunation_discard') then
			if WarMenu.MenuButton('Yes', 'ammunation_weapons') then
				RemoveWeaponFromPed(PlayerPedId(), selectedWeaponHash)
				Player.SaveWeapons()
			elseif WarMenu.MenuButton('No', 'ammunation_weapons') then
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('ammunation_removeUpgradeConfirm') then
			if WarMenu.MenuButton('Yes', 'ammunation_weaponUpgrades') then
				RemoveWeaponComponentFromPed(PlayerPedId(), selectedWeaponHash, selectedWeaponComponent)
				Player.SaveWeapons()
			elseif WarMenu.MenuButton('No', 'ammunation_weaponUpgrades') then
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('inviteToCrew') then
			for _, i in ipairs(GetActivePlayers()) do
				if i ~= PlayerId() then
					local player = GetPlayerServerId(i)
					if not Player.CrewMembers[player] and WarMenu.Button(GetPlayerName(i)) then
						Gui.DisplayPersonalNotification('You have sent Crew Invitation to '..Gui.GetPlayerName(player))
						TriggerServerEvent('lsv:inviteToCrew', player)
						WarMenu.CloseMenu()
					end
				end
			end

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

AddSignalHandler('lsv:settingUpdated', function()
		Prompt.Hide()
end)
