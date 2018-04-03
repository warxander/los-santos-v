-- Manifest
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'


-- WarMenu resource
client_script "@warmenu/warmenu.lua"


-- MySQL Async library
server_script '@mysql-async/lib/MySQL.lua'


-- Server modules
server_scripts {
	"modules/logger.lua",
	"modules/utils.lua",
	"modules/weapon.lua",
	"modules/blip.lua",
	"modules/settings.lua",

	"modules/server/db.lua",
	"modules/server/scoreboard.lua",
	"modules/server/autosave.lua",
}


-- Server scripts
server_scripts {
	"server/main.lua",
	"server/baseevents.lua",
	"server/session.lua",
	"server/report.lua",
	"server/cratedrop.lua",
	"server/bounty.lua",
	"server/guard.lua",
	"server/crew.lua",
	"server/pingkick.lua",

	"server/shop/ammunation.lua",
	"server/shop/skinshop.lua",

	"server/jobs/jobs.lua",
	"server/jobs/mostwanted.lua",
	"server/jobs/assetrecovery.lua",
	"server/jobs/headhunter.lua",
	"server/jobs/velocity.lua",
}


-- Client modules
client_scripts {
	"modules/logger.lua",
	"modules/utils.lua",
	"modules/blip.lua",
	"modules/settings.lua",
	"modules/weapon.lua",

	"modules/client/world.lua",
	"modules/client/streaming.lua",
	"modules/client/scaleform.lua",
	"modules/client/skin.lua",
	"modules/client/color.lua",
	"modules/client/player.lua",
	"modules/client/gui.lua",
	"modules/client/pickup.lua",
	"modules/client/map.lua",
	"modules/client/scoreboard.lua",
}


-- Client scripts
client_scripts {
	"client/enviroment.lua",
	"client/pickup.lua",
	"client/afk.lua",
	"client/session.lua",
	"client/report.lua",
	"client/hud.lua",
	"client/playertags.lua",
	"client/cratedrop.lua",
	"client/interactionmenu.lua",
	"client/bounty.lua",
	"client/guard.lua",
	"client/crew.lua",
	"client/pingkick.lua",

	"client/shop/skinshop.lua",
	"client/shop/ammunation.lua",

	"client/jobs/jobs.lua",
	"client/jobs/mostwanted.lua",
	"client/jobs/assetrecovery.lua",
	"client/jobs/headhunter.lua",
	"client/jobs/velocity.lua",
}
