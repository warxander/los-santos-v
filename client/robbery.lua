--https://pastebin.com/8EuSv2r1
Robberies = {
	{ pickupId = nil, blip = nil, ['x'] = 27.179788589478, ['y'] = -1340.0749511719, ['z'] = 29.497024536133, settings = Settings.robberyStoreSettings },
	{ pickupId = nil, blip = nil, ['x'] = -42.322410583496, ['y'] = -1749.1009521484, ['z'] = 29.421016693115, settings = Settings.robberyStoreSettings },
	{ pickupId = nil, blip = nil, ['x'] = -708.58825683594, ['y'] = -904.11706542969, ['z'] = 19.215591430664, settings = Settings.robberyStoreSettings },
	{ pickupId = nil, blip = nil, ['x'] = -1219.4338378906, ['y'] = -916.10382080078, ['z'] = 11.326217651367, settings = Settings.robberyStoreSettings },
	{ pickupId = nil, blip = nil, ['x'] = -1479.5504150391, ['y'] = -373.80960083008, ['z'] = 39.163394927979, settings = Settings.robberyStoreSettings },
	{ pickupId = nil, blip = nil, ['x'] = 377.10794067383, ['y'] = 332.92077636719, ['z'] = 103.56636810303, settings = Settings.robberyStoreSettings },
	{ pickupId = nil, blip = nil, ['x'] = 1160.6029052734, ['y'] = -314.04550170898, ['z'] = 69.205139160156, settings = Settings.robberyStoreSettings },
	{ pickupId = nil, blip = nil, ['x'] = 1126.3829345703, ['y'] = -981.70190429688, ['z'] = 45.415824890137, settings = Settings.robberyStoreSettings },
	{ pickupId = nil, blip = nil, ['x'] = -1828.1215820313, ['y'] = 799.11328125, ['z'] = 138.17001342773, settings = Settings.robberyStoreSettings },
	{ pickupId = nil, blip = nil, ['x'] = -2958.9916992188, ['y'] = 388.09457397461, ['z'] = 14.04315662384, settings = Settings.robberyStoreSettings },
	{ pickupId = nil, blip = nil, ['x'] = -3047.0500488281, ['y'] = 585.65979003906, ['z'] = 7.9089307785034, settings = Settings.robberyStoreSettings },
	{ pickupId = nil, blip = nil, ['x'] = -3249.46875, ['y'] = 1003.5993652344, ['z'] = 12.830706596375, settings = Settings.robberyStoreSettings },
	{ pickupId = nil, blip = nil, ['x'] = 1733.5750732422, ['y'] = 6420.5815429688, ['z'] = 35.037227630615, settings = Settings.robberyStoreSettings },
	{ pickupId = nil, blip = nil, ['x'] = 1707.1936035156, ['y'] = 4919.4487304688, ['z'] = 42.063674926758, settings = Settings.robberyStoreSettings },
	{ pickupId = nil, blip = nil, ['x'] = 547.52557373047, ['y'] = 2663.9638671875, ['z'] = 42.156494140625, settings = Settings.robberyStoreSettings },
	{ pickupId = nil, blip = nil, ['x'] = 1959.1160888672, ['y'] = 3748.2690429688, ['z'] = 32.343738555908, settings = Settings.robberyStoreSettings },
	{ pickupId = nil, blip = nil, ['x'] = 2672.8278808594, ['y'] = 3285.5939941406, ['z'] = 55.241142272949, settings = Settings.robberyStoreSettings },
	{ pickupId = nil, blip = nil, ['x'] = 2549.9296875, ['y'] = 384.43780517578, ['z'] = 108.62294769287, settings = Settings.robberyStoreSettings },

	{ pickupId = nil, blip = nil, ['x'] = 146.25691223145, ['y'] = -1044.6046142578, ['z'] = 29.377824783325, settings = Settings.robberyBankSettings },
	{ pickupId = nil, blip = nil, ['x'] = -354.23629760742, ['y'] = -53.998760223389, ['z'] = 49.046318054199, settings = Settings.robberyBankSettings },
	{ pickupId = nil, blip = nil, ['x'] = 1176.9967041016, ['y'] = 2711.8190917969, ['z'] = 38.097778320313, settings = Settings.robberyBankSettings },
	{ pickupId = nil, blip = nil, ['x'] = -104.46595001221, ['y'] = 6477.015625, ['z'] = 32.505443572998, settings = Settings.robberyBankSettings },
}

local isInRobbery = nil
local stolenMoney = 0


AddEventHandler('lsv:firstSpawnPlayer', function()
	for _, robbery in pairs(Robberies) do
		robbery.pickupId = CreatePickupRotate(GetHashKey(robbery.settings.hash), robbery.x, robbery.y, robbery.z, 0.0, 0.0, 0.0, 512)
		robbery.blip = Map.CreatePlaceBlip(Blip.Store(), robbery.x, robbery.y, robbery.z)
	end
end)


Citizen.CreateThread(function()
	while true do
		for _, robbery in pairs(Robberies) do
			if HasPickupBeenCollected(robbery.pickupId) then
				isInRobbery = true

				robbery.pickupId = nil

				SetBlipSprite(robbery.blip, Blip.Completed())

				SetTimeout(robbery.settings.timeout, function()
					robbery.pickupId = CreatePickupRotate(GetHashKey(robbery.settings.hash), robbery.x, robbery.y, robbery.z, 0.0, 0.0, 0.0, 512)
					SetBlipSprite(robbery.blip, Blip.Store())
				end)

				local money = GetRandomIntInRange(robbery.settings.money.min, robbery.settings.money.max)
				Player.ChangeMoney(money)
				stolenMoney = stolenMoney + money

				Gui.DisplayNotification('You stole ~g~$'..tostring(money)..'~w~.')

				if GetPlayerWantedLevel(PlayerId()) < robbery.settings.wantedLevel then
					local player = PlayerId()

					SetPoliceIgnorePlayer(player, false)
					SetDispatchCopsForPlayer(player, true)
					SetMaxWantedLevel(5)
					SetPlayerWantedLevel(player, robbery.settings.wantedLevel)
					SetPlayerWantedLevelNow(player, false)
				end
			end
		end

		if isInRobbery then
			if IsEntityDead(GetPlayerPed(PlayerId())) or GetPlayerWantedLevel(PlayerId()) == 0 then
				if IsEntityDead(GetPlayerPed(PlayerId())) then -- TODO Refactor me
					Player.ChangeMoney(-stolenMoney)
					Gui.DisplayNotification('You lost all the stolen money.')
				end

				isInRobbery = nil
				stolenMoney = 0

				TriggerEvent('lsv:disablePolice')
			end
		end

		Citizen.Wait(0)
	end
end)