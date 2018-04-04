RegisterNetEvent('lsv:updateScoreboard')


Scoreboard = { }


local scoreboard = { }


-- Sizes
local headerTableSpacing = 0.01

local tableSpacing = 0.0025
local tableHeight = 0.035
local tablePositionWidth = 0.175
local tableRPWidth = 0.1
local tableKdRatioWidth = 0.1
local tableKillsWidth = 0.1
local tableDeathsWidth = 0.1
local tableTextHorizontalMargin = 0.003
local onlineStatusWidth = 0.003

local headerScale = 0.35
local positionScale = 0.5
local rankScale = 0.45
local RPScale = 0.35
local kdRatioScale = 0.35
local killsScale = 0.35
local deathsScale = 0.35

local scoreboardPosition = { ['x'] = (1.0 - tablePositionWidth - tableRPWidth - tableKdRatioWidth - tableKillsWidth - tableDeathsWidth) / 2, ['y'] = 0.1 }


-- Colors
local tableHeaderColor = { ['r'] = 25, ['g'] = 118, ['b'] = 210, ['a'] = 255 }
local tableHeaderTextColor = { ['r'] = 255, ['g'] = 255, ['b'] = 255, ['a'] = 255 }

local tablePositionTextColor = { ['r'] = 255, ['g'] = 255, ['b'] = 255, ['a'] = 255 }

local tablePositionRankBackgroundColor = { ['r'] = 0, ['g'] = 0, ['b'] = 0, ['a'] = 255 }
local tablePositionRankColor = { ['r'] = 63, ['g'] = 81, ['b'] = 181, ['a'] = 255 }
local tablePositionRankTextColor = { ['r'] = 255, ['g'] = 255, ['b'] = 255, ['a'] = 255 }

local tableRPColor = { ['r'] = 0, ['g'] = 0, ['b'] = 0, ['a'] = 160 }
local tableRPTextColor = { ['r'] = 255, ['g'] = 255, ['b'] = 255, ['a'] = 255 }

local tableKdRatioColor = { ['r'] = 0, ['g'] = 0, ['b'] = 0, ['a'] = 160 }
local tableKdRatioTextColor = { ['r'] = 255, ['g'] = 255, ['b'] = 255, ['a'] = 255 }

local tableKillsColor = { ['r'] = 0, ['g'] = 0, ['b'] = 0, ['a'] = 160 }
local tableKillsTextColor = { ['r'] = 255, ['g'] = 255, ['b'] = 255, ['a'] = 255 }

local tableDeathsColor = { ['r'] = 0, ['g'] = 0, ['b'] = 0, ['a'] = 160 }
local tableDeathsTextColor = { ['r'] = 255, ['g'] = 255, ['b'] = 255, ['a'] = 255 }


local tableHeader = { ['y'] = scoreboardPosition.y + tableHeight / 2 }
local tableHeaderText = { ['y'] = tableHeader.y - tableHeight / 2 + 0.004 }

local tablePositionHeader = { ['x'] = scoreboardPosition.x + tablePositionWidth / 2, ['y'] = tableHeader.y }
local tableRPHeader = { ['x'] = tablePositionHeader.x + tablePositionWidth / 2 + tableRPWidth / 2 , ['y'] = tableHeader.y }
local tableKdRatioHeader = { ['x'] = tableRPHeader.x + tableRPWidth / 2 + tableKdRatioWidth / 2 , ['y'] = tableHeader.y }
local tableKillsHeader = { ['x'] = tableKdRatioHeader.x + tableKdRatioWidth / 2 + tableKillsWidth / 2 , ['y'] = tableHeader.y }
local tableDeathsHeader = { ['x'] = tableKillsHeader.x + tableKillsWidth / 2 + tableDeathsWidth / 2 , ['y'] = tableHeader.y }

local tableWidth = tablePositionWidth + tableRPWidth + tableKdRatioWidth + tableKillsWidth + tableDeathsWidth


AddEventHandler('lsv:updateScoreboard', function(serverScoreboard)
	scoreboard = serverScoreboard

	for i = Utils.GetTableLength(scoreboard), 1, -1 do
		local id = GetPlayerFromServerId(scoreboard[i].id)

		if not NetworkIsPlayerActive(id) and id ~= PlayerId() then
			TriggerEvent('lsv:playerDisconnected', scoreboard[i].name)
			table.remove(scoreboard, i)
		else
			scoreboard[i].id = id
		end
	end
end)


function Scoreboard.DisplayThisFrame()
	-- Draw "POSITION" header
	Gui.DrawRect(tablePositionHeader, tablePositionWidth, tableHeight, tableHeaderColor)
	Gui.DrawText("POSITION", { ['x'] = tablePositionHeader.x, ['y'] = tableHeaderText.y }, 0, tableHeaderTextColor, headerScale, false, false, true)

	-- Draw "RP" header
	Gui.DrawRect(tableRPHeader, tableRPWidth, tableHeight, tableHeaderColor)
	Gui.DrawText("RP", { ['x'] = tableRPHeader.x, ['y'] = tableHeaderText.y }, 0, tableHeaderTextColor, headerScale, false, false, true)

	-- Draw "KILLSTREAK" header
	Gui.DrawRect(tableKdRatioHeader, tableKdRatioWidth, tableHeight, tableHeaderColor)
	Gui.DrawText("K/D RATIO", { ['x'] = tableKdRatioHeader.x, ['y'] = tableHeaderText.y }, 0, tableHeaderTextColor, headerScale, false, false, true)

	-- Draw "KILLS" header
	Gui.DrawRect(tableKillsHeader, tableKillsWidth, tableHeight, tableHeaderColor)
	Gui.DrawText("KILLS", { ['x'] = tableKillsHeader.x, ['y'] = tableHeaderText.y }, 0, tableHeaderTextColor, headerScale, false, false, true)

	-- Draw "DEATHS" header
	Gui.DrawRect(tableDeathsHeader, tableDeathsWidth, tableHeight, tableHeaderColor)
	Gui.DrawText("DEATHS", { ['x'] = tableDeathsHeader.x, ['y'] = tableHeaderText.y }, 0, tableHeaderTextColor, headerScale, false, false, true)

	-- Draw table
	local tablePosition = { ['y'] = tablePositionHeader.y + tableHeight + headerTableSpacing }
	local tableAvatarPositionWidth = (tableHeight * 9 / 16)

	for index = 1, math.min(Settings.scoreboardMaxPlayers, Utils.GetTableLength(scoreboard)) do
		local avatarPosition = { ['x'] = scoreboardPosition.x + tableAvatarPositionWidth / 2, ['y'] = tablePosition.y }
		local playerPosition = { ['x'] = avatarPosition.x + tablePositionWidth / 2, ['y'] = tablePosition.y }
		local onlineStatusPosition = { ['x'] = avatarPosition.x + tableAvatarPositionWidth / 2 + onlineStatusWidth / 2, ['y'] = tablePosition.y }
		local RPPosition = { ['x'] = tableRPHeader.x, ['y'] = tablePosition.y }
		local kdRatioPosition = { ['x'] = tableKdRatioHeader.x, ['y'] = tablePosition.y }
		local killsPosition = { ['x'] = tableKillsHeader.x, ['y'] = tablePosition.y }
		local deathsPosition = { ['x'] = tableDeathsHeader.x, ['y'] = tablePosition.y }
		local tableText = { ['y'] = tablePosition.y - tableHeight / 2 }

		-- Draw avatar
		Gui.DrawRect(avatarPosition, tableAvatarPositionWidth, tableHeight, tableRPColor)
		Gui.DrawText(index, { ['x'] = avatarPosition.x, ['y'] = tableText.y + 0.004 }, 0, tableRPTextColor, RPScale,
			false, false, true)-- TODO Draw avatar here!

		-- Draw player name
		local playerColor = Utils.IndexOf(Player.crewMembers, GetPlayerServerId(scoreboard[index].id)) and Color.GetHudFromBlipColor(Color.BlipLightBlue()) or Color.GetHudFromBlipColor(Color.BlipDarkBlue())
		local onlineStatusColor = Color.GetHudFromBlipColor(Color.BlipLightBlue())
		local tablePositionColor = { ['r'] = playerColor.r, ['g'] = playerColor.g, ['b'] = playerColor.b, ['a'] = 160 }

		Gui.DrawRect(playerPosition, tablePositionWidth - tableAvatarPositionWidth, tableHeight, tablePositionColor)
		Gui.DrawText(scoreboard[index].name, { ['x'] = playerPosition.x - (tablePositionWidth - tableAvatarPositionWidth) / 2 + onlineStatusWidth + tableTextHorizontalMargin,
			['y'] = tableText.y }, 4, tablePositionTextColor, positionScale)

		-- Draw online status (make it real)
		Gui.DrawRect(onlineStatusPosition, onlineStatusWidth, tableHeight, onlineStatusColor)

		-- Draw RP
		Gui.DrawRect(RPPosition, tableRPWidth, tableHeight, tableRPColor)
		Gui.DrawText(scoreboard[index].RP, { ['x'] = tableRPHeader.x, ['y'] = tableText.y + 0.004 },
			0, tableRPTextColor, RPScale, false, false, true)

		-- Draw kdRatio
		local kdRatio = '-'
		if scoreboard[index].kdRatio then
			kdRatio = string.format("%.2f", scoreboard[index].kdRatio)
		end
		Gui.DrawRect(kdRatioPosition, tableKdRatioWidth, tableHeight, tableKdRatioColor)
		Gui.DrawText(kdRatio, { ['x'] = tableKdRatioHeader.x, ['y'] = tableText.y + 0.004 },
			0, tableKdRatioTextColor, kdRatioScale, false, false, true)

		-- Draw kills
		Gui.DrawRect(killsPosition, tableKillsWidth, tableHeight, tableKillsColor)
		Gui.DrawText(scoreboard[index].kills, { ['x'] = tableKillsHeader.x, ['y'] = tableText.y + 0.004 },
			0, tableKillsTextColor, killsScale, false, false, true)

		-- Draw deaths
		Gui.DrawRect(deathsPosition, tableDeathsWidth, tableHeight, tableDeathsColor)
		Gui.DrawText(scoreboard[index].deaths, { ['x'] = tableDeathsHeader.x, ['y'] = tableText.y + 0.004 },
			0, tableDeathsTextColor, deathsScale, false, false, true)

		-- Update table position
		tablePosition.y = tablePosition.y + tableSpacing + tableHeight
	end
end