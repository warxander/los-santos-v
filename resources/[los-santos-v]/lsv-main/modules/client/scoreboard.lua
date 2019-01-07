RegisterNetEvent('lsv:updateScoreboard')


Scoreboard = { }


local scoreboard = { }


-- Sizes
local headerTableSpacing = 0.0075

local tableSpacing = 0.001875
local tableHeight = 0.02625
local tablePositionWidth = 0.13125
local tableCashWidth = 0.075
local tableKdRatioWidth = 0.075
local tableKillsWidth = 0.075
local tableDeathsWidth = 0.075
local tableTextHorizontalMargin = 0.00225
local tableTextVerticalMargin = 0.00245
local onlineStatusWidth = 0.00225

local tableWidth = tablePositionWidth + tableCashWidth + tableKdRatioWidth + tableKillsWidth + tableDeathsWidth

local headerScale = 0.2625
local positionScale = 0.375
local rankScale = 0.3375
local cashScale = 0.2625
local kdRatioScale = 0.2625
local killsScale = 0.2625
local deathsScale = 0.2625


-- Colors
local tableHeaderColor = { ['r'] = 25, ['g'] = 118, ['b'] = 210, ['a'] = 255 }
local tableHeaderTextColor = { ['r'] = 255, ['g'] = 255, ['b'] = 255, ['a'] = 255 }

local tablePositionTextColor = { ['r'] = 255, ['g'] = 255, ['b'] = 255, ['a'] = 255 }

local tablePositionRankBackgroundColor = { ['r'] = 0, ['g'] = 0, ['b'] = 0, ['a'] = 255 }
local tablePositionRankColor = { ['r'] = 63, ['g'] = 81, ['b'] = 181, ['a'] = 255 }
local tablePositionRankTextColor = { ['r'] = 255, ['g'] = 255, ['b'] = 255, ['a'] = 255 }

local tableCashColor = { ['r'] = 0, ['g'] = 0, ['b'] = 0, ['a'] = 160 }
local tableCashTextColor = { ['r'] = 255, ['g'] = 255, ['b'] = 255, ['a'] = 255 }

local tableKdRatioColor = { ['r'] = 0, ['g'] = 0, ['b'] = 0, ['a'] = 160 }
local tableKdRatioTextColor = { ['r'] = 255, ['g'] = 255, ['b'] = 255, ['a'] = 255 }

local tableKillsColor = { ['r'] = 0, ['g'] = 0, ['b'] = 0, ['a'] = 160 }
local tableKillsTextColor = { ['r'] = 255, ['g'] = 255, ['b'] = 255, ['a'] = 255 }

local tableDeathsColor = { ['r'] = 0, ['g'] = 0, ['b'] = 0, ['a'] = 160 }
local tableDeathsTextColor = { ['r'] = 255, ['g'] = 255, ['b'] = 255, ['a'] = 255 }


AddEventHandler('lsv:updateScoreboard', function(serverScoreboard)
	scoreboard = serverScoreboard

	for i = Utils.GetTableLength(scoreboard), 1, -1 do
		local id = GetPlayerFromServerId(scoreboard[i].id)

		if not NetworkIsPlayerActive(id) and id ~= PlayerId() then
			table.remove(scoreboard, i)
		else
			scoreboard[i].id = id
		end
	end
end)


function Scoreboard.DisplayThisFrame()
	local scoreboardPosition = { ['x'] = (1.0 - tableWidth) / 2, ['y'] = SafeZone.Left() }

	local tableHeader = { ['y'] = scoreboardPosition.y + tableHeight / 2 }
	local tableHeaderText = { ['y'] = tableHeader.y - tableHeight / 2 + tableTextVerticalMargin }

	local tablePositionHeader = { ['x'] = scoreboardPosition.x + tablePositionWidth / 2, ['y'] = tableHeader.y }
	local tableCashHeader = { ['x'] = tablePositionHeader.x + tablePositionWidth / 2 + tableCashWidth / 2 , ['y'] = tableHeader.y }
	local tableKdRatioHeader = { ['x'] = tableCashHeader.x + tableCashWidth / 2 + tableKdRatioWidth / 2 , ['y'] = tableHeader.y }
	local tableKillsHeader = { ['x'] = tableKdRatioHeader.x + tableKdRatioWidth / 2 + tableKillsWidth / 2 , ['y'] = tableHeader.y }
	local tableDeathsHeader = { ['x'] = tableKillsHeader.x + tableKillsWidth / 2 + tableDeathsWidth / 2 , ['y'] = tableHeader.y }

	-- Draw "POSITION" header
	Gui.DrawRect(tablePositionHeader, tablePositionWidth, tableHeight, tableHeaderColor)
	Gui.DrawText("POSITION", { ['x'] = tablePositionHeader.x, ['y'] = tableHeaderText.y }, 0, tableHeaderTextColor, headerScale, false, false, true)

	-- Draw "CASH" header
	Gui.DrawRect(tableCashHeader, tableCashWidth, tableHeight, tableHeaderColor)
	Gui.DrawText("CASH", { ['x'] = tableCashHeader.x, ['y'] = tableHeaderText.y }, 0, tableHeaderTextColor, headerScale, false, false, true)

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

	for index = 1, Utils.GetTableLength(scoreboard) do
		local avatarPosition = { ['x'] = scoreboardPosition.x + tableAvatarPositionWidth / 2, ['y'] = tablePosition.y }
		local playerPosition = { ['x'] = avatarPosition.x + tablePositionWidth / 2, ['y'] = tablePosition.y }
		local onlineStatusPosition = { ['x'] = avatarPosition.x + tableAvatarPositionWidth / 2 + onlineStatusWidth / 2, ['y'] = tablePosition.y }
		local cashPosition = { ['x'] = tableCashHeader.x, ['y'] = tablePosition.y }
		local kdRatioPosition = { ['x'] = tableKdRatioHeader.x, ['y'] = tablePosition.y }
		local killsPosition = { ['x'] = tableKillsHeader.x, ['y'] = tablePosition.y }
		local deathsPosition = { ['x'] = tableDeathsHeader.x, ['y'] = tablePosition.y }
		local tableText = { ['y'] = tablePosition.y - tableHeight / 2 }

		-- Draw avatar
		Gui.DrawRect(avatarPosition, tableAvatarPositionWidth, tableHeight, tableCashColor)
		Gui.DrawText(index, { ['x'] = avatarPosition.x, ['y'] = tableText.y + tableTextVerticalMargin }, 0, tableCashTextColor, cashScale,
			false, false, true)-- TODO Draw avatar here!

		-- Draw player name
		local playerColor = Color.GetHudFromBlipColor(Color.BlipDarkBlue())
		if scoreboard[index].id == PlayerId() then
			playerColor = Color.GetHudFromBlipColor(Color.BlipBlue())
		elseif Player.isCrewMember(GetPlayerServerId(scoreboard[index].id)) then
			playerColor = Color.GetHudFromBlipColor(Color.BlipLightBlue())
		end

		local onlineStatusColor = Color.GetHudFromBlipColor(Color.BlipLightBlue())
		local tablePositionColor = { ['r'] = playerColor.r, ['g'] = playerColor.g, ['b'] = playerColor.b, ['a'] = 160 }

		Gui.DrawRect(playerPosition, tablePositionWidth - tableAvatarPositionWidth, tableHeight, tablePositionColor)
		Gui.DrawText(scoreboard[index].name, { ['x'] = playerPosition.x - (tablePositionWidth - tableAvatarPositionWidth) / 2 + onlineStatusWidth + tableTextHorizontalMargin,
			['y'] = tableText.y }, 4, tablePositionTextColor, positionScale)

		-- Draw online status (make it real)
		Gui.DrawRect(onlineStatusPosition, onlineStatusWidth, tableHeight, onlineStatusColor)

		-- Draw cash
		Gui.DrawRect(cashPosition, tableCashWidth, tableHeight, tableCashColor)
		Gui.DrawText('$'..scoreboard[index].cash, { ['x'] = tableCashHeader.x, ['y'] = tableText.y + tableTextVerticalMargin },
			0, tableCashTextColor, cashScale, false, false, true)

		-- Draw kdRatio
		local kdRatio = '-'
		if scoreboard[index].kdRatio then
			kdRatio = string.format("%.2f", scoreboard[index].kdRatio)
		end
		Gui.DrawRect(kdRatioPosition, tableKdRatioWidth, tableHeight, tableKdRatioColor)
		Gui.DrawText(kdRatio, { ['x'] = tableKdRatioHeader.x, ['y'] = tableText.y + tableTextVerticalMargin },
			0, tableKdRatioTextColor, kdRatioScale, false, false, true)

		-- Draw kills
		Gui.DrawRect(killsPosition, tableKillsWidth, tableHeight, tableKillsColor)
		Gui.DrawText(scoreboard[index].kills, { ['x'] = tableKillsHeader.x, ['y'] = tableText.y + tableTextVerticalMargin },
			0, tableKillsTextColor, killsScale, false, false, true)

		-- Draw deaths
		Gui.DrawRect(deathsPosition, tableDeathsWidth, tableHeight, tableDeathsColor)
		Gui.DrawText(scoreboard[index].deaths, { ['x'] = tableDeathsHeader.x, ['y'] = tableText.y + tableTextVerticalMargin },
			0, tableDeathsTextColor, deathsScale, false, false, true)

		-- Update table position
		tablePosition.y = tablePosition.y + tableSpacing + tableHeight
	end
end
