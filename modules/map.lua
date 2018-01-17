Map = { }


function Map.CreatePlaceBlip(blipSprite, x, y, z)
   local blip = AddBlipForCoord(x, y, z)
   SetBlipSprite(blip, blipSprite)
   SetBlipHighDetail(blip, true)
   SetBlipAsShortRange(blip, true)
   return blip
end


function Map.CreatePickupBlip(pickup, itemId, color)
   local blipSprite = Blip.GetPickupBlipSpriteId(itemId)
   local blip = nil

   if blipSprite then
      blip = AddBlipForPickup(pickup)
      SetBlipSprite(blip, blipSprite)
      SetBlipHighDetail(blip, true)
      SetBlipAsShortRange(blip, true)

      if color then
         SetBlipColour(blip, color)
      end
   end

   return blip
end