-- Manifest
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'


-- WarMenu resource
client_script "@warmenu/warmenu.lua"


-- MySQL Async library
server_script '@mysql-async/lib/MySQL.lua'


-- Server modules
server_scripts {
	"modules/utils.lua",
	"modules/blip.lua",
	"modules/settings.lua",
}


-- Server scripts
server_scripts {
	"server/main.lua",
	"server/player.lua",
	"server/spawn.lua",
	"server/scoreboard.lua",
	"server/cratedrop.lua",
	"server/bounty.lua",
	"server/guard.lua",
	"server/crew.lua",
}


-- Client modules
client_scripts {
	"modules/utils.lua",
	"modules/blip.lua",
	"modules/settings.lua",
	"modules/color.lua",
	"modules/player.lua",
	"modules/weapon.lua",
	"modules/scaleform.lua",
	"modules/gui.lua",
	"modules/map.lua",
	"modules/pickup.lua",
	"modules/skin.lua",
	"modules/scoreboard.lua",
}


-- Client scripts
client_scripts {
	"client/enviroment.lua",
	"client/player.lua",
	"client/map.lua",
	"client/pickup.lua",
	"client/afk.lua",
	"client/spawn.lua",
	"client/hud.lua",
	"client/playertags.lua",
	"client/robbery.lua",
	"client/cratedrop.lua",
	"client/skinshop.lua",
	"client/ammunation.lua",
	"client/vehicle.lua",
	"client/interactionmenu.lua",
	"client/bounty.lua",
	"client/abilities.lua",
	"client/guard.lua",
	"client/crew.lua",
}
