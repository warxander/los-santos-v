local logger = Logger:CreateNamedLogger('Stunt Jump')


RegisterServerEvent('lsv:stuntJumpCompleted')
AddEventHandler('lsv:stuntJumpCompleted', function(height, distance)
	local player = source

	local reward = math.floor(math.max(height, distance) * Settings.stuntJumpCashPerMeter)
	Db.UpdateCash(player, reward, function()
		TriggerClientEvent('lsv:stuntJumpCompleted', player, height, distance)
		logger:Info('Completed: { player: '..player..', height: '..height..', distance: '..distance..', reward: '..reward..' }')
	end)
end)