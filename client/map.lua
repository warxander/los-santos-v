Citizen.CreateThread(function()
   while true do
      for id = 0, Settings.maxPlayerCount do
         if id ~= PlayerId() then
            local ped = GetPlayerPed(id)
            local blip = GetBlipFromEntity(ped)

            if NetworkIsPlayerActive(id) and ped ~= nil then
               if not DoesBlipExist(blip) then
                  blip = AddBlipForEntity(ped)
                  SetBlipHighDetail(blip, true)
                  SetBlipScale(blip, 0.9)
                  SetBlipShowCone(blip, false)
               end

               local IsPedDead = IsPedDeadOrDying(ped, true)
               local blipSprite = Blip.Standard()

               if IsPedDead then
                  blipSprite = Blip.Dead()
               elseif BountyPlayerId and (GetPlayerServerId(id) == BountyPlayerId) then
                  blipSprite = Blip.BountyHit()
               end

               SetBlipSprite(blip, blipSprite)

               if GetPedStealthMovement(ped) then
                  SetBlipAlpha(blip, 0)
               else
                  SetBlipAlpha(blip, 255)
               end

               SetBlipAsShortRange(blip, IsPedDead)
               SetBlipColour(blip, id + 1)
               SetBlipNameToPlayerName(blip, id)
            else
               SetBlipAlpha(blip, 0)
            end
         end
      end

      Citizen.Wait(0)
   end
end)