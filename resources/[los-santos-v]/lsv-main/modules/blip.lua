-- https://marekkraus.sk/gtav/blips/list.html
-- http://www.dev-c.com/nativedb/func/info/03d7fb09e75d6b7e


Blip = { }


local pickupBlips = {
	["PICKUP_WEAPON_APPISTOL"] = 156,
	["PICKUP_WEAPON_ASSAULTSHOTGUN"] = 158,
	["PICKUP_WEAPON_ASSAULTSMG"] = 159,
	["PICKUP_WEAPON_AUTOSHOTGUN"] = 158,
	["PICKUP_WEAPON_BULLPUPSHOTGUN"] = 158,
	["PICKUP_WEAPON_COMBATMG"] = 159,
	["PICKUP_WEAPON_COMBATPDW"] = 159,
	["PICKUP_WEAPON_COMBATPISTOL"] = 156,
	["PICKUP_WEAPON_FLAREGUN"] = 156,
	["PICKUP_WEAPON_DBSHOTGUN"] = 158,
	["PICKUP_WEAPON_GRENADE"] = 152,
	["PICKUP_WEAPON_GUSENBERG"] = 159,
	["PICKUP_WEAPON_HEAVYPISTOL"] = 156,
	["PICKUP_WEAPON_HEAVYSHOTGUN"] = 158,
	["PICKUP_WEAPON_MACHINEPISTOL"] = 159,
	["PICKUP_WEAPON_MARKSMANPISTOL"] = nil, --156,
	["PICKUP_WEAPON_MG"] = 159,
	["PICKUP_WEAPON_MICROSMG"] = 159,
	["PICKUP_WEAPON_MINISMG"] = 159,
	["PICKUP_WEAPON_MOLOTOV"] = 155,
	["PICKUP_WEAPON_PIPEBOMB"] = 152,
	["PICKUP_WEAPON_PISTOL"] = 156,
	["PICKUP_WEAPON_PISTOL50"] = 156,
	["PICKUP_WEAPON_PROXMINE"] = 152,
	["PICKUP_WEAPON_PUMPSHOTGUN"] = 158,
	["PICKUP_WEAPON_REVOLVER"] = nil, --156,
	["PICKUP_WEAPON_RPG"] = nil, --157,
	["PICKUP_WEAPON_HOMINGLAUNCHER"] = nil, --157,
	["PICKUP_WEAPON_SAWNOFFSHOTGUN"] = 158,
	["PICKUP_WEAPON_MUSKET"] = 158,
	["PICKUP_WEAPON_SMG"] = 159,
	["PICKUP_WEAPON_SMOKEGRENADE"] = 152,
	["PICKUP_WEAPON_SNSPISTOL"] = 156,
	["PICKUP_WEAPON_STICKYBOMB"] = 152,
	["PICKUP_WEAPON_VINTAGEPISTOL"] = 156,
	["PICKUP_WEAPON_ADVANCEDRIFLE"] = 150,
	["PICKUP_WEAPON_ASSAULTRIFLE"] = 150,
	["PICKUP_WEAPON_BULLPUPRIFLE"] = 150,
	["PICKUP_WEAPON_CARBINERIFLE"] = 150,
	["PICKUP_WEAPON_COMPACTLAUNCHER"] = nil, --174,
	["PICKUP_WEAPON_COMPACTRIFLE"] = 150,
	["PICKUP_WEAPON_GRENADELAUNCHER"] = nil, --174,
	["PICKUP_WEAPON_HEAVYSNIPER"] = nil, --160,
	["PICKUP_WEAPON_MARKSMANRIFLE"] = nil, --160,
	["PICKUP_WEAPON_SNIPERRIFLE"] = nil, --160,
	["PICKUP_WEAPON_MINIGUN"] = nil, --173,
	["PICKUP_WEAPON_SPECIALCARBINE"] = 150,
	["PICKUP_ARMOUR_STANDARD"] = 175,
	["PICKUP_HEALTH_SNACK"] = 153,
	["PICKUP_HEALTH_STANDARD"] = 153,
	["PICKUP_MONEY_CASE"] = 436,
}


function Blip.GetPickupBlipSpriteId(item)
	return pickupBlips[item]
end


function Blip.Standard()
	return 1
end


function Blip.Dead()
	return 274
end


function Blip.BountyHit()
	return 303
end


function Blip.PolicePlayer()
	return 58
end


function Blip.Helicopter()
	return 64
end


function Blip.Tank()
	return 421
end


function Blip.GunCar()
	return 426
end


function Blip.Plane()
	return 423
end

function Blip.PersonalVehicleCar()
	return 225
end


function Blip.PersonalBikeCar()
	return 226
end


function Blip.Boat()
	return 410
end


function Blip.Completed()
	return 367
end


function Blip.BigCircle()
	return 9
end


function Blip.Waypoint()
	return 8
end


function Blip.Store()
	return 52
end

function Blip.Castle()
	return 176
end


function Blip.CrateDrop()
	return 306
end

function Blip.HotProperty()
	return 436
end

function Blip.AmmuNation()
	return 110
end


function Blip.Clothes()
	return 73
end


function Blip.LosSantosCustoms()
	return 72
end


function Blip.Mission()
	return 304
end


function Blip.RocketVoltic()
	return 533
end


function Blip.Target()
	return 458
end
