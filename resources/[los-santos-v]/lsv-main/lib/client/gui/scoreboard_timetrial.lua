ScoreboardTT = { }
ScoreboardTT.__index = ScoreboardTT

local _scoreboardtt = { }
local _needUpdate = true

local _headerTableSpacing = 0.0075

local _tableSpacing = 0.001875
local _tableHeight = 0.02625

local _tablePositionWidth = 0.019
local _tablePlayerNameWidth = 0.2
local _tableTimeWidth = 0.09

local _tableTextHorizontalMargin = 0.00225
local _tableTextVerticalMargin = 0.00245
local _playerStatusWidth = 0.00225
local _rankWidth = 0.0175
local _rankHeight = 0.0325

local _tableWidth = _tablePositionWidth + _tablePlayerNameWidth + _tableTimeWidth

local _headerScale = 0.2625
local _positionScale = 0.375
local _playernameScale = 0.2625
local _timeScale = 0.2625

-- Colors
local _tableOverallHeaderColor = { ['r'] = 10, ['g'] = 60, ['b'] = 170, ['a'] = 255 }
local _tableOverallHeaderTextColor = { ['r'] = 255, ['g'] = 255, ['b'] = 255, ['a'] = 255 }

local _tableHeaderColor = { ['r'] = 25, ['g'] = 118, ['b'] = 210, ['a'] = 255 }
local _tableHeaderTextColor = { ['r'] = 255, ['g'] = 255, ['b'] = 255, ['a'] = 225 }

local _tablePositionColor = { ['r'] = 0, ['g'] = 0, ['b'] = 0, ['a'] = 185 }

local _tablePlayerNameColor = { ['r'] = 0, ['g'] = 0, ['b'] = 0, ['a'] = 185 }

local _tableTimeColor = { ['r'] = 0, ['g'] = 0, ['b'] = 0, ['a'] = 185 }

local _recordColors = {
	[1] = { ['r'] = 201, ['g'] = 176, ['b'] = 55, ['a'] = 255 }, -- Gold
	[2] = { ['r'] = 215, ['g'] = 215, ['b'] = 215, ['a'] = 255 }, -- Silver
	[3] = { ['r'] = 173, ['g'] = 138, ['b'] = 86, ['a'] = 255 }, -- Bronze
}

local _recordColorDefault = { ['r'] = 180, ['g'] = 180, ['b'] = 180, ['a'] = 255 }

function ScoreboardTT.DisplayThisFrame(trialName, vehicleClass, records)
	local scoreboardPosition = { ['x'] = (1.0 - _tableWidth) / 2, ['y'] = SafeZone.Top() }

	-- Trial name and vehicle class
	local tableOverallHeader = { ['x'] = scoreboardPosition.x + _tableWidth / 2, ['y'] = scoreboardPosition.y + _tableHeight / 2 }

	Gui.DrawRect(tableOverallHeader, _tableWidth, _tableHeight, _tableOverallHeaderColor)
	Gui.SetTextParams(0, _tableOverallHeaderTextColor, _headerScale, false, false, true)
	Gui.DrawText('Records for '..trialName..' in '..vehicleClass..' class vehicles', { ['x'] = tableOverallHeader.x, ['y'] = tableOverallHeader.y - _tableHeight / 2 + _tableTextVerticalMargin })

	-- Records headers
	local tablePositionHeader = { ['x'] = scoreboardPosition.x + (_tablePositionWidth / 2), ['y'] = tableOverallHeader.y + _tableHeight +_tableTextVerticalMargin }
	local tablePlayerNameHeader = { ['x'] = tablePositionHeader.x + (_tablePositionWidth / 2) + (_tablePlayerNameWidth / 2), ['y'] = tableOverallHeader.y + _tableHeight + _tableTextVerticalMargin}
	local tableTimeHeader = { ['x'] = tablePlayerNameHeader.x + (_tablePlayerNameWidth / 2) + (_tableTimeWidth / 2), ['y'] = tableOverallHeader.y + _tableHeight + _tableTextVerticalMargin}

	-- Draw 'Position' header
	Gui.DrawRect(tablePositionHeader, _tablePositionWidth, _tableHeight, _tableHeaderColor)
	Gui.SetTextParams(0, _tableHeaderTextColor, _headerScale, false, false, true)
	Gui.DrawText('#', { ['x'] = tablePositionHeader.x, ['y'] = tablePositionHeader.y - _tableHeight / 2 + _tableTextVerticalMargin })

	-- Draw playername header
	Gui.DrawRect(tablePlayerNameHeader, _tablePlayerNameWidth, _tableHeight, _tableHeaderColor)
	Gui.SetTextParams(0, _tableHeaderTextColor, _headerScale, false, false, true)
	Gui.DrawText('Player', { ['x'] = tablePlayerNameHeader.x, ['y'] = tablePlayerNameHeader.y - _tableHeight / 2 + _tableTextVerticalMargin })

	-- Draw 'Time' header
	Gui.DrawRect(tableTimeHeader, _tableTimeWidth, _tableHeight, _tableHeaderColor)
	Gui.SetTextParams(0, _tableHeaderTextColor, _headerScale, false, false, true)
	Gui.DrawText('Time', { ['x'] = tableTimeHeader.x, ['y'] = tableTimeHeader.y - _tableHeight / 2 + _tableTextVerticalMargin })

	-- Draw records table
	local recordTablePosition = { ['x'] = scoreboardPosition.x + (_tablePositionWidth / 2), ['y'] = tablePositionHeader.y + _tableHeight + _headerTableSpacing }

	for position, record in pairs(records.records) do
		local recordTextColor = _recordColorDefault

		if (position <= 3) then
			recordTextColor = _recordColors[position]
		end

		-- Position
		Gui.DrawRect(recordTablePosition, _tablePositionWidth, _tableHeight, _tablePositionColor)
		Gui.SetTextParams(0, recordTextColor, _headerScale, false, false, true)
		Gui.DrawText(position, { ['x'] = recordTablePosition.x, ['y'] = recordTablePosition.y - _tableHeight / 2 + _tableTextVerticalMargin })
		recordTablePosition.x = recordTablePosition.x + (_tablePositionWidth / 2) + (_tablePlayerNameWidth / 2)

		-- Name
		Gui.DrawRect(recordTablePosition, _tablePlayerNameWidth, _tableHeight, _tablePlayerNameColor)
		Gui.SetTextParams(0, recordTextColor, _headerScale, false, false, true)
		Gui.DrawText(record.name, { ['x'] = recordTablePosition.x, ['y'] = recordTablePosition.y - _tableHeight / 2 + _tableTextVerticalMargin })
		recordTablePosition.x = recordTablePosition.x + (_tablePlayerNameWidth / 2) + (_tableTimeWidth / 2)

		-- Time
		Gui.DrawRect(recordTablePosition, _tableTimeWidth, _tableHeight, _tableTimeColor)
		Gui.SetTextParams(0, recordTextColor, _headerScale, false, false, true)
		Gui.DrawText(string.from_ms(record.time, true), { ['x'] = recordTablePosition.x, ['y'] = recordTablePosition.y - _tableHeight / 2 + _tableTextVerticalMargin })
		recordTablePosition.x = recordTablePosition.x + (_tablePlayerNameWidth / 2) + (_tableTimeWidth / 2)

		-- Next row
		recordTablePosition.x = scoreboardPosition.x + (_tablePositionWidth / 2)
		recordTablePosition.y = recordTablePosition.y + _tableHeight + _tableTextVerticalMargin
	end

	-- Show personal best
	recordTablePosition.y = recordTablePosition.y + (_tableHeight / 2)

	Gui.DrawRect(recordTablePosition, _tablePositionWidth, _tableHeight, _tablePositionColor)
	Gui.SetTextParams(0, _recordColorDefault, _headerScale, false, false, true)
	Gui.DrawText('PB', { ['x'] = recordTablePosition.x, ['y'] = recordTablePosition.y - _tableHeight / 2 + _tableTextVerticalMargin })
	recordTablePosition.x = recordTablePosition.x + (_tablePositionWidth / 2) + (_tablePlayerNameWidth / 2)

	local personalBestName = '-'
	local personalBestTime = '-'

	if records.personalBest ~= nil then
		personalBestName = GetPlayerName(PlayerId())
		personalBestTime = string.from_ms(records.personalBest, true)
	end

	Gui.DrawRect(recordTablePosition, _tablePlayerNameWidth, _tableHeight, _tablePlayerNameColor)
	Gui.SetTextParams(0, _recordColorDefault, _headerScale, false, false, true)
	Gui.DrawText(personalBestName, { ['x'] = recordTablePosition.x, ['y'] = recordTablePosition.y - _tableHeight / 2 + _tableTextVerticalMargin })
	recordTablePosition.x = recordTablePosition.x + (_tablePlayerNameWidth / 2) + (_tableTimeWidth / 2)

	Gui.DrawRect(recordTablePosition, _tableTimeWidth, _tableHeight, _tableTimeColor)
	Gui.SetTextParams(0, _recordColorDefault, _headerScale, false, false, true)
	Gui.DrawText(personalBestTime, { ['x'] = recordTablePosition.x, ['y'] = recordTablePosition.y - _tableHeight / 2 + _tableTextVerticalMargin })
	recordTablePosition.x = recordTablePosition.x + (_tablePlayerNameWidth / 2) + (_tableTimeWidth / 2)
end
