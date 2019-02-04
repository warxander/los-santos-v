-- Manifest
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'


-- WarMenu resource
client_script '@warmenu/warmenu.lua'


-- MySQL Async library
server_script '@mysql-async/lib/MySQL.lua'


-- Server modules
server_scripts {
	'modules/logger.lua',
	'modules/utils.lua',
	'modules/weapon.lua',
	'modules/blip.lua',
	'modules/settings.lua',

	'modules/server/db.lua',
	'modules/server/scoreboard.lua',
	'modules/server/autosave.lua',
}


-- Server scripts
server_scripts {
	'server/main.lua',
	'server/baseevents.lua',
	'server/session.lua',
	'server/chat.lua',
	'server/report.lua',
	'server/cratedrop.lua',
	'server/bounty.lua',
	'server/guard.lua',
	'server/castle.lua',
	'server/property.lua',
	'server/event.lua',
	'server/pingkick.lua',
	'server/stunt.lua',

	'server/shop/ammunation.lua',
	'server/shop/skinshop.lua',

	'server/mission/missionmanager.lua',
	'server/mission/assetrecovery.lua',
	'server/mission/headhunter.lua',
	'server/mission/marketmanipulation.lua',
	'server/mission/mostwanted.lua',
	'server/mission/velocity.lua',
}


-- Client modules
client_scripts {
	'modules/logger.lua',
	'modules/utils.lua',
	'modules/blip.lua',
	'modules/settings.lua',
	'modules/weapon.lua',

	'modules/client/gui/safezone.lua',
	'modules/client/gui/gui.lua',
	'modules/client/gui/bar.lua',

	'modules/client/world.lua',
	'modules/client/streaming.lua',
	'modules/client/scaleform.lua',
	'modules/client/skin.lua',
	'modules/client/color.lua',
	'modules/client/player.lua',
	'modules/client/map.lua',
	'modules/client/scoreboard.lua',
}


-- Client scripts
client_scripts {
	'client/spawn.lua',
	'client/enviroment.lua',
	'client/afk.lua',
	'client/session.lua',
	'client/chat.lua',
	'client/report.lua',
	'client/hud.lua',
	'client/pickup.lua',
	'client/playertags.lua',
	'client/cratedrop.lua',
	'client/interactionmenu.lua',
	'client/bounty.lua',
	'client/castle.lua',
	'client/property.lua',
	'client/guard.lua',
	'client/pingkick.lua',
	'client/stunt.lua',

	'client/shop/skinshop.lua',
	'client/shop/ammunation.lua',

	'client/mission/missionmanager.lua',
	'client/mission/assetrecovery.lua',
	'client/mission/headhunter.lua',
	'client/mission/marketmanipulation.lua',
	'client/mission/mostwanted.lua',
	'client/mission/velocity.lua',
}
