Settings = { }


-- General
Settings.maxPlayerCount = 31 -- For internal usage only, do not touch it!
Settings.afkTimeout = 300 --in seconds
Settings.autoParachutingHeight = 80

-- Abilities
Settings.equipBodyArmorTimeout = 30 --in seconds
Settings.equipBodyArmorPrice = 500

Settings.refillAmmoPrice = 250

Settings.setAllAttachmentsPrice = 1500

Settings.requestVehicleTimeout = 120 -- in seconds
Settings.requestVehiclePrice = 350
Settings.requestRadius = 5

Settings.repairVehicleTimeout = 60
Settings.repairVehiclePrice = 1000


-- Scoreboard
Settings.scoreboardMaxPlayers = 16
Settings.kdRatioMinStat = 100

-- Player
Settings.randomMeleeWeapon = true
Settings.flashlightAtSpawn = false
Settings.disableHealthRegen = false
Settings.giveArmorAtSpawn = false
Settings.giveParachuteAtSpawn = true
Settings.infinitePlayerStamina = true
Settings.dropWeaponAfterDeath = true
Settings.playerMaxArmour = 200 --100 by default


-- Crew
Settings.crewInvitationTimeout = 10000


-- Pickups
Settings.pickupMaxCount = 5
Settings.pickupMinSpawnRadius = 15
Settings.pickupMaxSpawnRadius = 90
Settings.pickupMinDistance = 10
Settings.weaponClipCount = 5


--Money
Settings.moneyPerKill = 500
Settings.moneyPerDeath = 100
Settings.moneyPerKillstreak = 250


--Crate Drops
Settings.crateDropEventTimeout = 180000
Settings.crateDropWeaponClipCount = 5
Settings.crateDropMoney = 10000


-- Bounties
Settings.bountyEventTimeout = 180000
Settings.bountyEventReward = 2500


--Robberies
Settings.robberyStoreSettings = {
	hash = 'PICKUP_MONEY_PAPER_BAG',
	money = { min = 2500, max = 5000 },
	timeout = 300000,
	wantedLevel = 2
}

Settings.robberyBankSettings = {
	hash = 'PICKUP_MONEY_CASE',
	money = { min = 25000, max = 50000 },
	timeout = 600000,
	wantedLevel = 4
}


--Vehicles
--https://pastebin.com/dutqk6jb
Settings.carSettings = {
	name = 'cars',
	blipId = Blip.LosSantosCustoms(),
	vehicles = {
		{ hash = "pfister811", name = "Pfister 811", price = 1135000 },
		{ hash = "adder", name = "Truffade Adder", price = 1000000 },
		{ hash = "banshee", name = "Bravado Banshee 900R", price = 565000 },
		{ hash = "bullet", name = "Bullet", price = 155000 },
		{ hash = "cheetah", name = "Cheetah", price = 650000 },
		{ hash = "fmj", name = "Vapid FMJ", price = 1750000 },
		{ hash = "infernus", name = "Infernus", price = 440000 },
		{ hash = "italigtb", name = "Itali GTB", price = 1189000 },
		{ hash = "nero", name = "Truffade Nero", price = 1440000 },
		{ hash = "osiris", name = "Pegassi Osiris", price = 1950000 },
		{ hash = "penetrator", name = "Penetrator", price = 880000 },
		{ hash = "le7b", name = "Annis RE-7B", price = 2475000 },
		{ hash = "reaper", name = "Pegassi Reaper", price = 1595000 },
		{ hash = "sultanrs", name = "Karin Sultan RS", price = 795000 },
		{ hash = "t20", name = "Progen T20", price = 2200000 },
		{ hash = "tempesta", name = "Pegassi Tempesta", price = 1329000 },
		{ hash = "turismor", name = "Grotti Turismo R", price = 500000 },
		{ hash = "tyrus", name = "Progen Tyrus", price = 2550000 },
		{ hash = "vacca", name = "Pegassi Vacca", price = 240000 },
		{ hash = "Sheava", name = "Emperor ETR1", price = 1995000 },
		{ hash = "prototipo", name = "Grotti X80 Proto", price = 2700000 },
		{ hash = "entityxf", name = "Överflöd Entity XF", price = 795000 },
		{ hash = "zentorno", name = "Pegassi Zentorno", price = 725000 },
	},
}


Settings.heliSettings = {
	name = 'military helicopters',
	blipId = Blip.Helicopter(),
	vehicles = {
		{ hash = "buzzard", name = "Buzzard" },
		{ hash = "savage", name = "Savage" },
		{ hash = "annihilator", name = "Annihilator" },
	},
}


Settings.planeSettings = {
	name = 'military planes',
	blipId = Blip.Plane(),
	vehicles = {
		{ hash = "hydra", name = "Hydra" },
		{ hash = "lazer", name = "Jobuilt P-996 LAZER" },
	},
}


Settings.boatSettings = {
	name = 'boats',
	blipId = Blip.Boat(),
	vehicles = {
		{ hash = "dinghy", name = "Dinghy" },
		{ hash = "jetmax", name = "Cuban Jetmax" },
		{ hash = "submersible", name = "Submersible" },
		{ hash = "marquis", name = "Marquis" },
		{ hash = "seashark", name = "Speedophile Seashark" },
		{ hash = "speeder", name = "Speeder" },
		{ hash = "squalo", name = "Squalo" },
		{ hash = "suntrap", name = "Shitzu Suntrap" },
		{ hash = "toro", name = "Lampadati Toro" },
		{ hash = "tropic", name = "Tropic" },
		{ hash = "tug", name = "Tug" },
	},
}