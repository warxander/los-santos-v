local logger = Logger:CreateNamedLogger('StuntJump')


local isStuntJumpInProcess = false
local stuntJumpHeight = 0.0
local playerVehicle = nil
local startingCoords = nil


local function resetStuntJump()
	logger:Debug('Reset')
	isStuntJumpInProcess = false
	stuntJumpHeight = 0.0
	playerVehicle = nil
	startingCoords = nil
end


AddEventHandler('lsv:init', function()
	while true do
		Citizen.Wait(0)

		local playerPed = PlayerPedId()
		local isPlayerInVehicle = IsPedSittingInAnyVehicle(playerPed)
		if not isPlayerInVehicle then
			if playerVehicle then resetStuntJump() end
		else
			local vehicle = GetVehiclePedIsUsing(playerPed)
			if not playerVehicle then playerVehicle = vehicle
			else
				if playerVehicle ~= vehicle then resetStuntJump() end
				playerVehicle = vehicle
			end
		end

		if playerVehicle and not IsPlayerDead(PlayerId()) then
			if IsEntityInAir(playerVehicle) then
				local height = GetEntityHeightAboveGround(playerVehicle)
				if height > 0.0 then
					if not isStuntJumpInProcess then
						logger:Debug('Started')
						isStuntJumpInProcess = true
						startingCoords = GetEntityCoords(playerPed, true)
					end

					if height > stuntJumpHeight then
						stuntJumpHeight = height
						logger:Debug('Height: '..stuntJumpHeight)
					end
				end
			elseif isStuntJumpInProcess then
				local isStuntJumpHeightEnough = stuntJumpHeight > Settings.stuntJumpMinHeight
				local isStuntJumpSucceeded = isStuntJumpHeightEnough and IsVehicleDriveable(playerVehicle) and not IsVehicleStuckOnRoof(playerVehicle)

				if isStuntJumpSucceeded then
					currentCoords = GetEntityCoords(playerPed, true)
					TriggerServerEvent('lsv:stuntJumpCompleted', stuntJumpHeight, CalculateTravelDistanceBetweenPoints(startingCoords.x, startingCoords.y, startingCoords.z, currentCoords.x, currentCoords.y, currentCoords.z))
				elseif isStuntJumpHeightEnough then Gui.DisplayNotification('Stunt Jump failed.') end

				resetStuntJump()
			end
		end
	end
end)


RegisterNetEvent('lsv:stuntJumpCompleted')
AddEventHandler('lsv:stuntJumpCompleted', function(height, distance)
	FlashMinimapDisplay()
	Gui.DisplayNotification('~b~Stunt Jump completed~w~.\nDistance: '..string.format('%.1f', distance)..'m\nHeight: '..string.format('%.1f', height)..'m')
end)