AddSignalHandler('lsv:playerConnected', function(player)
	local loginTime = os.time()
	Db.UpdateLoginTime(player, loginTime)

	local patreonTier = PlayerData.GetPatreonTier(player)
	if not PlayerData.IsExists(player) or patreonTier == 0 or PlayerData.GetLoginTime(player) - loginTime < 86400 then
		return
	end

	PlayerData.UpdateCash(player, Settings.patreon.daily[patreonTier].cash)
	PlayerData.UpdateExperience(player, Settings.patreon.daily[patreonTier].exp)

	TriggerClientEvent('lsv:patreonDailyRewarded', player)
end)
