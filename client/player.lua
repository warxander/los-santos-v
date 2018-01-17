RegisterNetEvent('lsv:increaseKills')
AddEventHandler('lsv:increaseKills', function()
	local moneyAdd = Settings.moneyPerKill + (Player.killstreak * Settings.moneyPerKillstreak)

	Player.kills = Player.kills + 1
	Player.killstreak = Player.killstreak + 1

	Player.ChangeMoney(moneyAdd)
	Gui.DisplayNotification("You earned ~g~$"..tostring(moneyAdd).."~w~.")
end)


RegisterNetEvent('lsv:increaseDeaths')
AddEventHandler('lsv:increaseDeaths', function()
	Player.killstreak = 0
	Player.deaths = Player.deaths + 1

	local pedMoney = Player.GetMoney()
	local moneyLost = math.min(pedMoney, Settings.moneyPerDeath)

	Player.ChangeMoney(-moneyLost)

	if moneyLost ~= 0 then
		Gui.DisplayNotification("You lost ~g~$"..tostring(moneyLost).."~w~.")
	end
end)