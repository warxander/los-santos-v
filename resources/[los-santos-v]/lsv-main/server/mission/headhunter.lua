RegisterNetEvent('lsv:headhunterFinished')
AddEventHandler('lsv:headhunterFinished', function(targetsLeft)
	local player = source
	if not PlayerData.IsExists(player) or targetsLeft < 0 then
		return
	end

	PlayerData.UpdateCash(player, Settings.headhunter.reward.cash * (Settings.headhunter.count - targetsLeft))
	PlayerData.UpdateExperience(player, Settings.headhunter.reward.exp * (Settings.headhunter.count - targetsLeft))

	TriggerClientEvent('lsv:headhunterFinished', player, true, '')
end)
