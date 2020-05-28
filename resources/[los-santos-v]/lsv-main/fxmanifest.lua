-- Manifest
fx_version 'adamant'
game 'gta5'

resource_type 'gametype' { name = 'Los Santos V' }

-- WarMenu resource
client_script '@warmenu/warmenu.lua'

-- vSql library
server_script '@vSql/vSql.lua'

-- Server files
server_scripts {
	'lib/utils/signal.lua',
	'lib/utils/table.lua',
	'lib/utils/math.lua',
	'lib/utils/string.lua',
	'lib/utils/timer.lua',

	'lib/settings.lua',
	'localsettings.lua',  -- If file exists, is used to override settings in lib/settings.lua
	'lib/logger.lua',
	'lib/weapon.lua',
	'lib/blip.lua',
	'lib/color.lua',
	'lib/rank.lua',

	'lib/server/db.lua',
	'lib/server/guard.lua',
	'lib/server/stat.lua',
	'lib/server/discord.lua',
	'lib/server/crate.lua',
	'lib/server/playerdata.lua',
	'lib/server/eventscheduler.lua',
	'lib/server/missionmanager.lua',
	'lib/server/challengemanager.lua',
	'lib/server/crew.lua',
	'lib/server/network.lua',
}

server_scripts {
	'server/save.lua',
	'server/hud.lua',
	'server/weather.lua',
	'server/baseevents.lua',
	'server/session.lua',
	'server/patreon.lua',
	'server/guard.lua',
	'server/chat.lua',
	'server/report.lua',
	'server/moderator.lua',
	'server/pingkick.lua',
	'server/travel.lua',
	'server/garage.lua',

	'server/event/castle.lua',
	'server/event/gun.lua',
	'server/event/property.lua',
	'server/event/beast.lua',
	'server/event/stockpiling.lua',
	'server/event/sharpshooter.lua',
	'server/event/penned.lua',

	'server/shop/ammunation.lua',
	'server/shop/skinshop.lua',
	'server/shop/vehicle.lua',

	'server/mission/assetrecovery.lua',
	'server/mission/headhunter.lua',
	'server/mission/heist.lua',
	'server/mission/mostwanted.lua',
	'server/mission/velocity.lua',
	'server/mission/cargo.lua',
	'server/mission/import.lua',
	'server/mission/export.lua',
	'server/mission/sightseer.lua',
	'server/mission/survival.lua',
	'server/mission/timetrial.lua',

	'server/challenge/duel.lua',
}

-- Client files
client_scripts {
	'lib/utils/signal.lua',
	'lib/utils/table.lua',
	'lib/utils/math.lua',
	'lib/utils/string.lua',
	'lib/utils/timer.lua',

	'lib/settings.lua',
	'lib/logger.lua',
	'lib/weapon.lua',
	'lib/blip.lua',
	'lib/color.lua',
	'lib/rank.lua',

	'lib/client/prompt.lua',

	'lib/client/gui/safezone.lua',
	'lib/client/gui/gui.lua',
	'lib/client/gui/bar.lua',
	'lib/client/gui/helpqueue.lua',
	'lib/client/gui/scoreboard.lua',

	'lib/client/world.lua',
	'lib/client/streaming.lua',
	'lib/client/scaleform.lua',
	'lib/client/player.lua',
	'lib/client/map.lua',
	'lib/client/playerdata.lua',
	'lib/client/missionmanager.lua',
	'lib/client/challengemanager.lua',
	'lib/client/vehicle.lua',
	'lib/client/network.lua',
	'lib/client/decor.lua',
}

client_scripts {
	'client/spawn.lua',
	'client/enviroment.lua',
	'client/guard.lua',
	'client/afk.lua',
	'client/session.lua',
	'client/baseevents.lua',
	'client/chat.lua',
	'client/report.lua',
	'client/hud.lua',
	'client/playertags.lua',
	'client/pingkick.lua',
	'client/crew.lua',
	'client/travel.lua',
	'client/garage.lua',

	'client/event/castle.lua',
	'client/event/gun.lua',
	'client/event/property.lua',
	'client/event/beast.lua',
	'client/event/stockpiling.lua',
	'client/event/sharpshooter.lua',
	'client/event/penned.lua',

	'client/menu/interaction.lua',
	'client/menu/moderator.lua',
	'client/menu/vehicle.lua',

	'client/shop/skinshop.lua',
	'client/shop/ammunation.lua',

	'client/mission/assetrecovery.lua',
	'client/mission/headhunter.lua',
	'client/mission/heist.lua',
	'client/mission/mostwanted.lua',
	'client/mission/velocity.lua',
	'client/mission/cargo.lua',
	'client/mission/import.lua',
	'client/mission/export.lua',
	'client/mission/sightseer.lua',
	'client/mission/survival.lua',
	'client/mission/timetrial.lua',

	'client/challenge/duel.lua',
}
