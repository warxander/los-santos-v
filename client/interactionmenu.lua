local quickGpsLocations = { "None", "Crate Drop", "Ammu-Nation","Los Santos Customs", "Skin Shop", "Robbery" }
local quickGpsCurrentIndex = 1
local quickGpsSelectedIndex = 1
local quickGpsBlip = nil


AddEventHandler('lsv:firstSpawnPlayer', function()
    WarMenu.CreateMenu('interaction', GetPlayerName(PlayerId()))
    WarMenu.SetTitleColor('interaction', 255, 255, 255)
    WarMenu.SetTitleBackgroundColor('interaction', 93, 182, 229)

    WarMenu.CreateSubMenu('inviteToCrew', 'interaction', 'Invite to Crew')
end)


AddEventHandler('lsv:vehicleControlsExplode', function()
    local vehicleNetId = NetworkGetNetworkIdFromEntity(Player.vehicle)

    NetworkRequestControlOfNetworkId(vehicleNetId)
    while not NetworkHasControlOfNetworkId(vehicleNetId) do
        Citizen.Wait(0)
        NetworkRequestControlOfNetworkId(vehicleNetId)
    end

    NetworkExplodeVehicle(Player.vehicle, true, false, false)
end)


Citizen.CreateThread(function()
    while true do
        if WarMenu.IsMenuOpened('interaction') then
            if IsEntityDead(GetPlayerPed(-1)) then
                WarMenu.CloseMenu()
            elseif WarMenu.ComboBox('Quick GPS', quickGpsLocations, quickGpsCurrentIndex, quickGpsSelectedIndex, function(currentIndex, selectedIndex)
                    quickGpsSelectedIndex = selectedIndex
                    quickGpsCurrentIndex = currentIndex
                end) then
                RemoveBlip(quickGpsBlip)

                local blip = nil

                if quickGpsSelectedIndex == 2 then
                    blip = CrateBlip
                elseif quickGpsSelectedIndex ~= 1 then
                    local places = nil

                    if quickGpsSelectedIndex == 3 then
                        places = Ammunations
                    elseif quickGpsSelectedIndex == 4 then
                        places = VehiclePlaces
                    elseif quickGpsSelectedIndex == 5 then
                        places = Skinshops
                    elseif quickGpsSelectedIndex == 6 then
                        places = Robberies
                    end

                    local minDistance = 0xffffffff
                    local playerX, playerY, playerZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
                    for _, place in pairs(places) do
                        local placeX, placeY, placeZ = table.unpack(GetBlipCoords(place.blip))
                        local distance = GetDistanceBetweenCoords(placeX, placeY, placeZ, playerX, playerY, playerZ, false)
                        if distance < minDistance then
                            minDistance = distance
                            blip = place.blip
                        end
                    end
                end

                if blip then
                    local x, y, z = table.unpack(GetBlipCoords(blip))
                    quickGpsBlip = AddBlipForCoord(x, y, z)
                    SetBlipSprite(quickGpsBlip, Blip.Waypoint())
                    SetBlipColour(quickGpsBlip, 3)
                    SetBlipRouteColour(quickGpsBlip, 3)
                    SetBlipHighDetail(quickGpsBlip, true)
                    SetBlipRoute(quickGpsBlip, true)
                end

                WarMenu.CloseMenu()
            elseif WarMenu.Button('Explode Vehicle') then
                if Player.vehicle then
                    TriggerEvent('lsv:vehicleControlsExplode')
                else
                    Gui.DisplayNotification('You don\'t have an owned vehicle.')
                end

                WarMenu.CloseMenu()
            elseif WarMenu.MenuButton('Invite To Crew', 'inviteToCrew') then
            elseif Utils.GetTableLength(Player.crewMembers) ~= 0 and WarMenu.Button('Leave Crew') then
                TriggerServerEvent('lsv:leaveCrew')
                WarMenu.CloseMenu()
            elseif WarMenu.Button('Kill Yourself') then
                SetEntityHealth(GetPlayerPed(-1), 0)
                WarMenu.CloseMenu()
            end

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('inviteToCrew') then
            for i = 0, Settings.maxPlayerCount do
                if i ~= PlayerId() and NetworkIsPlayerActive(i) then
                    local player = GetPlayerServerId(i)
                    if not Utils.Index(Player.crewMembers, player) and WarMenu.Button(GetPlayerName(i)) then
                        Gui.DisplayNotification('You have sent Crew Invitation to '..Gui.GetPlayerName(player))
                        TriggerServerEvent('lsv:inviteToCrew', player)
                        WarMenu.CloseMenu()
                    end
                end
            end

            WarMenu.Display()
        elseif IsControlJustReleased(0, 244) and not IsEntityDead(GetPlayerPed(-1)) and Player.initialized then --M by default
            WarMenu.OpenMenu('interaction')
        end

        if quickGpsBlip and not IsEntityDead(GetPlayerPed(-1)) then
            local x, y, z = GetBlipCoords(quickGpsBlip)
            local playerX, playerY, playerZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))

            if GetDistanceBetweenCoords(playerX, playerY, playerZ, x, y, z, false) < 50.0 then
                RemoveBlip(quickGpsBlip)
                quickGpsSelectedIndex = 1
                quickGpsCurrentIndex = 1
                quickGpsBlip = nil
            end
        end

        Citizen.Wait(0)
    end
end)
