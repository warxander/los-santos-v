local _boosters = { }

local function parseBooster(boosterName)
	local boosterData = GetConvar(boosterName, '')
	if string.len(boosterData) == 0 then
		return
	end

	boosterData = json.decode(boosterData)
	_boosters[boosterData.packageId] = boosterData
end

Citizen.CreateThread(function()
	local tebexSecret = GetConvar('sv_tebexSecret', '')
	if string.len(tebexSecret) == 0 then
		return
	end

	parseBooster('tebex_smallBoosterPack')
	parseBooster('tebex_mediumBoosterPack')
	parseBooster('tebex_largeBoosterPack')

	RegisterCommand('boost', function(_, args)
		local player = args[1]
		local packageId = tonumber(args[2])
		local count = tonumber(args[3])

		local boosterData = _boosters[packageId]
		if not PlayerData.IsExists(player) or not boosterData then
			return
		end

		PlayerData.UpdateCash(player, boosterData.cash * count)
		PlayerData.UpdateExperience(player, boosterData.exp * count)
		TriggerClientEvent('lsv:tebexPackagePurchased', player)
	end, true)
end)
