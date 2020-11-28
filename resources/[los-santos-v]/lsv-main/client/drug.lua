local _businessData = {
	['weed'] = {
		blip = Blip.BUSINESS_WEED,
		blipColour = Color.BLIP_DARK_GREEN,
		color = Color.DARK_GREEN,
	},

	['cocaine'] = {
		blip = Blip.BUSINESS_COCAINE,
		blipColour = Color.BLIP_LIGHT_BLUE,
		color = Color.LIGHT_BLUE,
	},

	['meth'] = {
		blip = Blip.BUSINESS_METH,
		blipColour = Color.BLIP_LIGHT_GREY,
		color = Color.LIGHT_GREY,
	},
}

local _businessBlips = { }

local _businessId = nil
local _businessType = nil

RegisterNetEvent('lsv:drugBusinessPurchased')
AddEventHandler('lsv:drugBusinessPurchased', function(id)
	WarMenu.CloseMenu()
	Prompt.Hide()

	if id then
		PlaySoundFrontend(-1, 'PROPERTY_PURCHASE', 'HUD_AWARDS')

		local blip = _businessBlips[id]
		local businessType = Settings.drugBusiness.businesses[id].type
		local businessName = Settings.drugBusiness.types[businessType].name
		Map.SetBlipText(blip, 'Owned '..businessName)
		Map.SetBlipFlashes(blip)

		table.foreach(_businessBlips, function(blip, id)
			local type = Settings.drugBusiness.businesses[id].type
			if Player.HasDrugBusiness(type) and Player.DrugBusiness[type].id ~= id then
				RemoveBlip(blip)
				_businessBlips[id] = nil
			end
		end)

		local scaleform = Scaleform.NewAsync('MIDSIZED_MESSAGE')
		scaleform:call('SHOW_SHARD_MIDSIZED_MESSAGE', string.upper(businessName)..' PURCHASED', '')
		scaleform:renderFullscreenTimed(7000)
	else
		Gui.DisplayPersonalNotification('You don\'t have enough cash.')
	end
end)

RegisterNetEvent('lsv:drugBusinessUpgraded')
AddEventHandler('lsv:drugBusinessUpgraded', function(name)
	Prompt.Hide()

	if name then
		Gui.DisplayPersonalNotification('Installed '..name)
	else
		Gui.DisplayPersonalNotification('You don\'t have enough cash.')
	end
end)

RegisterNetEvent('lsv:drugBusinessSupplyPurchased')
AddEventHandler('lsv:drugBusinessSupplyPurchased', function(success)
	Prompt.Hide()

	if not success then
		Gui.DisplayPersonalNotification('You don\'t have enough cash.')
	end
end)

RegisterNetEvent('lsv:drugBusinessSupplyRewarded')
AddEventHandler('lsv:drugBusinessSupplyRewarded', function(type)
	Gui.DisplayPersonalNotification('+ 1 Supply Unit for '..Settings.drugBusiness.types[type].name)
end)

RegisterNetEvent('lsv:drugExportStarted')
AddEventHandler('lsv:drugExportStarted', function(data)
	WarMenu.CloseMenu()
	Prompt.Hide()

	MissionManager.StartMission('DrugExport', Settings.drugBusiness.export.missionName)
	TriggerEvent('lsv:startDrugExport', data)
end)

-- Production cycle
AddEventHandler('lsv:init', function()
	while true do
		Citizen.Wait(100)

		for type, business in pairs(Player.DrugBusiness) do
			if business.supplies == 0 or business.stockMax == Settings.drugBusiness.limits.stock then
				business.timer = nil
			else
				if not business.timer then
					business.timer = Timer.New()
				end

				local productionTime = business.upgrades.security and Settings.drugBusiness.types[type].time.upgraded or Settings.drugBusiness.types[type].time.default
				if business.timer:elapsed() >= productionTime then
					TriggerServerEvent('lsv:drugBusinessProduced', type)
					business.timer:restart()
				end
			end
		end
	end
end)

AddEventHandler('lsv:init', function()
	table.foreach(Settings.drugBusiness.businesses, function(business, id)
		local blipName = nil
		if Player.HasDrugBusiness(business.type) then
			if Player.DrugBusiness[business.type].id == id then
				blipName = 'Owned '..Settings.drugBusiness.types[business.type].name
			end
		else
			blipName = Settings.drugBusiness.types[business.type].name..' For Sale'
		end

		if blipName then
			_businessBlips[id] = Map.CreatePlaceBlip(_businessData[business.type].blip, business.location.x, business.location.y, business.location.z, blipName, _businessData[business.type].blipColour)
		end
	end)

	while true do
		Citizen.Wait(0)

		local blipAlpha = Player.IsInFreeroam() and 255 or 0
		for _, blip in pairs(_businessBlips) do
			if GetBlipAlpha(blip) ~= blipAlpha then
				SetBlipAlpha(blip, blipAlpha)
			end
		end
	end
end)

AddEventHandler('lsv:init', function()
	Gui.CreateMenu('drug_business_purchase', 'Drug Business')

	while true do
		Citizen.Wait(0)

		if WarMenu.IsMenuOpened('drug_business_purchase') then
			if WarMenu.Button('Purchase', '$'..Settings.drugBusiness.businesses[_businessId].price) then
				TriggerServerEvent('lsv:purchaseDrugBusiness', _businessId)
				Prompt.ShowAsync()
			end

			WarMenu.Display()
		end
	end
end)

AddEventHandler('lsv:init', function()
	Gui.CreateMenu('drug_business', 'Drug Business')
	WarMenu.SetTitleBackgroundColor('drug_business', Color.GREEN.r, Color.GREEN.g, Color.GREEN.b, Color.GREEN.a)

	WarMenu.CreateSubMenu('drug_business_upgrades', 'drug_business')
	WarMenu.SetMenuButtonPressedSound('drug_business_upgrades', 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET')

	while true do
		Citizen.Wait(0)

		if WarMenu.IsMenuOpened('drug_business') then
			local profitPerUnit = Player.DrugBusiness[_businessType].upgrades.staff and Settings.drugBusiness.types[_businessType].price.upgraded or Settings.drugBusiness.types[_businessType].price.default
			local stockCount = Player.DrugBusiness[_businessType].stock

			WarMenu.Button('Export '..Settings.drugBusiness.types[_businessType].productName, '$'..(profitPerUnit * stockCount))
			if WarMenu.IsItemHovered() then
				Gui.ToolTip('Deliver product to the Buyer.')

				if WarMenu.IsItemSelected() then
					if stockCount == 0 then
						Gui.DisplayPersonalNotification('Nothing to export.')
					else
						TriggerServerEvent('lsv:startDrugExport', _businessType)
						Prompt.ShowAsync()
					end
				end
			end

			if WarMenu.Button('Buy 1 Supply Unit', '$'..Settings.drugBusiness.types[_businessType].price.supply) then
				if Player.DrugBusiness[_businessType].supplies == Settings.drugBusiness.limits.supplies then
					Gui.DisplayPersonalNotification('Supplies is full.')
				else
					TriggerServerEvent('lsv:purchaseDrugBusinessSupply', _businessType)
					Prompt.ShowAsync()
				end
			end

			if WarMenu.MenuButton('Buy Upgrades', 'drug_business_upgrades') then
				local businessColor = _businessData[_businessType].color
				WarMenu.SetTitleBackgroundColor('drug_business_upgrades', businessColor.r, businessColor.g, businessColor.b, businessColor.a)
				WarMenu.SetSubTitle('drug_business_upgrades', Settings.drugBusiness.types[_businessType].name..' UPGRADES')
			end

			WarMenu.Button('Supplies Level', Player.DrugBusiness[_businessType].supplies..' of '..Settings.drugBusiness.limits.supplies)
			if WarMenu.IsItemHovered() then
				Gui.ToolTip('You need Supplies to make a product.\nBuy it or participate in game activities.')
			end

			WarMenu.Button('Stock Level', Player.DrugBusiness[_businessType].stock..' of '..Settings.drugBusiness.limits.stock)
			if WarMenu.IsItemHovered() then
				local productionTime = Player.DrugBusiness[_businessType].upgrades.security and Settings.drugBusiness.types[_businessType].time.upgraded or Settings.drugBusiness.types[_businessType].time.default
				Gui.ToolTip('Production rate is 1 '..Settings.drugBusiness.types[_businessType].productName..' in '..math.floor(productionTime / 1000)..' seconds.')
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('drug_business_upgrades') then
			for id, data in pairs(Settings.drugBusiness.upgrades) do
				local isOwned = Player.DrugBusiness[_businessType].upgrades[id] ~= nil
				WarMenu.Button(data.name, isOwned and 'Owned' or '$'..data.prices[_businessType])
				if WarMenu.IsItemHovered() then
					Gui.ToolTip(data.toolTip)

					if WarMenu.IsItemSelected() then
						if not isOwned then
							TriggerServerEvent('lsv:upgradeDrugBusiness', _businessType, id)
							Prompt.ShowAsync()
						end
					end
				end
			end

			WarMenu.Display()
		end
	end
end)

AddEventHandler('lsv:init', function()
	while true do
		Citizen.Wait(0)

		local isPlayerInFreeroam = Player.IsInFreeroam()

		for id, business in pairs(Settings.drugBusiness.businesses) do
			local isOwnedBusiness = Player.HasDrugBusiness(business.type)

			if (not isOwnedBusiness or Player.DrugBusiness[business.type].id == id) and isPlayerInFreeroam then
				Gui.DrawPlaceMarker(business.location, _businessData[business.type].color)

				if Player.DistanceTo(business.location, true) <= Settings.placeMarker.radius then
					if not WarMenu.IsAnyMenuOpened() then
						Gui.DisplayHelpText('Press ~INPUT_TALK~ to open '..Settings.drugBusiness.types[business.type].name..' menu.')

						if IsControlJustReleased(0, 46) then
							_businessId = id
							_businessType = business.type

							local businessColor = _businessData[_businessType].color
							local businessName = Settings.drugBusiness.types[_businessType].name

							if isOwnedBusiness then
								WarMenu.SetSubTitle('drug_business', businessName)
								WarMenu.SetTitleBackgroundColor('drug_business', businessColor.r, businessColor.g, businessColor.b, businessColor.a)
								Gui.OpenMenu('drug_business')
							else
								WarMenu.SetSubTitle('drug_business_purchase', businessName)
								WarMenu.SetTitleBackgroundColor('drug_business_purchase', businessColor.r, businessColor.g, businessColor.b, businessColor.a)
								Gui.OpenMenu('drug_business_purchase')
							end
						end
					end
				elseif (WarMenu.IsMenuOpened('drug_business_purchase') or WarMenu.IsMenuOpened('drug_business') or WarMenu.IsMenuOpened('drug_business_upgrades')) and _businessId == id then
					WarMenu.CloseMenu()
					Prompt.Hide()
				end
			end
		end
	end
end)
