Scoreboard = { }
Scoreboard.__index = Scoreboard

local _scoreboard = { }
local _needUpdate = true

local _headerTableSpacing = 0.0075

local _tableSpacing = 0.001875
local _tableHeight = 0.02625
local _tablePositionWidth = 0.13125
local _tableCashWidth = 0.075
local _tableKdRatioWidth = 0.075
local _tableKillsWidth = 0.075
local _tableTextHorizontalMargin = 0.00225
local _tableTextVerticalMargin = 0.00245
local _playerStatusWidth = 0.00225
local _rankWidth = 0.0175
local _rankHeight = 0.0325

local _voiceIndicatorWidth = 0.004
local _playerNameMargin = 0.006
if Settings.enableVoiceChat then
	_voiceIndicatorWidth = 0.01
	_playerNameMargin = 0.0125
end

local _tableWidth = _tablePositionWidth + _tableCashWidth + _tableKdRatioWidth + _tableKillsWidth

local _headerScale = 0.2625
local _positionScale = 0.375
local _rankScale = 0.325
local _cashScale = 0.2625
local _kdRatioScale = 0.2625
local _killsScale = 0.2625

-- Colors
local _tableHeaderColor = { ['r'] = 25, ['g'] = 118, ['b'] = 210, ['a'] = 255 }
local _tableHeaderTextColor = { ['r'] = 255, ['g'] = 255, ['b'] = 255, ['a'] = 255 }

local _tablePositionTextColor = { ['r'] = 255, ['g'] = 255, ['b'] = 255, ['a'] = 255 }

local _tableCashColor = { ['r'] = 0, ['g'] = 0, ['b'] = 0, ['a'] = 160 }
local _tableCashTextColor = { ['r'] = 255, ['g'] = 255, ['b'] = 255, ['a'] = 255 }

local _tableKdRatioColor = { ['r'] = 0, ['g'] = 0, ['b'] = 0, ['a'] = 160 }
local _tableKdRatioTextColor = { ['r'] = 255, ['g'] = 255, ['b'] = 255, ['a'] = 255 }

local _tableKillsColor = { ['r'] = 0, ['g'] = 0, ['b'] = 0, ['a'] = 160 }
local _tableKillsTextColor = { ['r'] = 255, ['g'] = 255, ['b'] = 255, ['a'] = 255 }

local _activeVoiceIndicatorColor = { ['r'] = 255, ['g'] = 255, ['b'] = 255, ['a'] = 255 }
local _inactiveVoiceIndicatorColor = { ['r'] = 10, ['g'] = 10, ['b'] = 10, ['a'] = 255 }

local _prestigeColor = { ['r'] = 240, ['g'] = 200, ['b'] = 80, ['a'] = 255 }
local _maxPrestigeColor = { ['r'] = 224, ['g'] = 50, ['b'] = 50, ['a'] = 255 }
local _prestigeBlendColor = {
	['r'] = math.floor((_maxPrestigeColor.r - _prestigeColor.r) / Settings.maxPrestige),
	['g'] = math.floor((_maxPrestigeColor.g - _prestigeColor.g) / Settings.maxPrestige),
	['b'] = math.floor((_maxPrestigeColor.b - _prestigeColor.b) / Settings.maxPrestige),
	['a'] = 255,
}

local _rankColor = { ['r'] = 44, ['g'] = 109, ['b'] = 184, ['a'] = 255 }
local _rankTextColor = { ['r'] = 255, ['g'] = 255, ['b'] = 255, ['a'] = 255 }

function Scoreboard.DisplayThisFrame()
	if _needUpdate then
		table.clear(_scoreboard)

		PlayerData.ForEach(function(data, id)
			if NetworkIsPlayerActive(GetPlayerFromServerId(id)) then
				table.insert(_scoreboard, data)
			end
		end)

		table.sort(_scoreboard, function(l, r)
			if not l then return false end
			if not r then return true end

			if l.patreonTier > r.patreonTier then return true end
			if l.patreonTier < r.patreonTier then return false end

			if l.prestige > r.prestige then return true end
			if l.prestige < r.prestige then return false end

			if l.rank > r.rank then return true end
			if l.rank < r.rank then return false end

			if l.cash > r.cash then return true end
			if l.cash < r.cash then return false end

			if not l.kdRatio then return false end
			if not r.kdRatio then return true end

			if l.kdRatio > r.kdRatio then return true end
			if l.kdRatio < r.kdRatio then return false end

			if l.kills > r.kills then return true end
			if l.kills < r.kills then return false end

			return l.name < r.name
		end)

		_needUpdate = false
	end

	local scoreboardPosition = { ['x'] = (1.0 - _tableWidth) / 2, ['y'] = SafeZone.Top() }

	local tableHeader = { ['y'] = scoreboardPosition.y + _tableHeight / 2 }
	local tableHeaderText = { ['y'] = tableHeader.y - _tableHeight / 2 + _tableTextVerticalMargin }

	local tablePositionHeader = { ['x'] = scoreboardPosition.x + _tablePositionWidth / 2, ['y'] = tableHeader.y }
	local tableCashHeader = { ['x'] = tablePositionHeader.x + _tablePositionWidth / 2 + _tableCashWidth / 2 , ['y'] = tableHeader.y }
	local tableKdRatioHeader = { ['x'] = tableCashHeader.x + _tableCashWidth / 2 + _tableKdRatioWidth / 2 , ['y'] = tableHeader.y }
	local tableKillsHeader = { ['x'] = tableKdRatioHeader.x + _tableKdRatioWidth / 2 + _tableKillsWidth / 2 , ['y'] = tableHeader.y }

	-- Draw 'POSITION' header
	Gui.DrawRect(tablePositionHeader, _tablePositionWidth, _tableHeight, _tableHeaderColor)
	Gui.SetTextParams(0, _tableHeaderTextColor, _headerScale, false, false, true)
	Gui.DrawText('POSITION', { ['x'] = tablePositionHeader.x, ['y'] = tableHeaderText.y })

	-- Draw 'CASH' header
	Gui.DrawRect(tableCashHeader, _tableCashWidth, _tableHeight, _tableHeaderColor)
	Gui.SetTextParams(0, _tableHeaderTextColor, _headerScale, false, false, true)
	Gui.DrawText('CASH', { ['x'] = tableCashHeader.x, ['y'] = tableHeaderText.y })

	-- Draw 'KILLSTREAK' header
	Gui.DrawRect(tableKdRatioHeader, _tableKdRatioWidth, _tableHeight, _tableHeaderColor)
	Gui.SetTextParams(0, _tableHeaderTextColor, _headerScale, false, false, true)
	Gui.DrawText('K/D RATIO', { ['x'] = tableKdRatioHeader.x, ['y'] = tableHeaderText.y })

	-- Draw 'KILLS' header
	Gui.DrawRect(tableKillsHeader, _tableKillsWidth, _tableHeight, _tableHeaderColor)
	Gui.SetTextParams(0, _tableHeaderTextColor, _headerScale, false, false, true)
	Gui.DrawText('KILLS', { ['x'] = tableKillsHeader.x, ['y'] = tableHeaderText.y })

	-- Draw table
	local tablePosition = { ['y'] = tablePositionHeader.y + _tableHeight + _headerTableSpacing }
	local tableAvatarPositionWidth = (_tableHeight * 9 / 16)

	table.foreach(_scoreboard, function(player)
		local avatarPosition = { ['x'] = scoreboardPosition.x + tableAvatarPositionWidth / 2, ['y'] = tablePosition.y }
		local playerPosition = { ['x'] = avatarPosition.x + _tablePositionWidth / 2, ['y'] = tablePosition.y }
		local voiceIndicatorPosition = { ['x'] = (scoreboardPosition.x + tableAvatarPositionWidth / 2) + 0.015, ['y'] = tablePosition.y }
		local rankPosition = { ['x'] = (scoreboardPosition.x + tableAvatarPositionWidth / 2 + _voiceIndicatorWidth) + 0.015, ['y'] = tablePosition.y + 0.001 }
		local playerNamePosition = { ['x'] = (avatarPosition.x + _tablePositionWidth / 2 + _rankWidth / 2) + _playerNameMargin, ['y'] = tablePosition.y }
		local playerStatusPosition = { ['x'] = avatarPosition.x + tableAvatarPositionWidth / 2 + _playerStatusWidth / 2, ['y'] = tablePosition.y }
		local cashPosition = { ['x'] = tableCashHeader.x, ['y'] = tablePosition.y }
		local kdRatioPosition = { ['x'] = tableKdRatioHeader.x, ['y'] = tablePosition.y }
		local killsPosition = { ['x'] = tableKillsHeader.x, ['y'] = tablePosition.y }
		local tableText = { ['y'] = tablePosition.y - _tableHeight / 2 }

		-- Draw player id
		Gui.DrawRect(avatarPosition, tableAvatarPositionWidth, _tableHeight, _tableCashColor)

		local idColor = Color.WHITE
		if player.moderator then idColor = Color.PURPLE end
		Gui.SetTextParams(0, idColor, _cashScale, false, false, true)
		Gui.DrawNumeric(player.id, { ['x'] = avatarPosition.x, ['y'] = tableText.y + _tableTextVerticalMargin })

		-- Draw player name
		local isPatron = player.patreonTier ~= 0
		local playerColor = Color.DARK_BLUE
		if Player.IsCrewMember(player.id) then
			playerColor = Color.LIGHT_BLUE
		elseif isPatron then
			playerColor = Color.ORANGE
		elseif player.id == Player.ServerId() then
			playerColor = Color.BLUE
		end
		local tablePositionColor = { ['r'] = playerColor.r, ['g'] = playerColor.g, ['b'] = playerColor.b, ['a'] = isPatron and 228 or 160 }

		Gui.DrawRect(playerPosition, _tablePositionWidth - tableAvatarPositionWidth, _tableHeight, tablePositionColor)
		Gui.SetTextParams(4, _tablePositionTextColor, _positionScale, false, isPatron)
		Gui.DrawText(player.name, { ['x'] = playerNamePosition.x - (_tablePositionWidth - tableAvatarPositionWidth) / 2 + _playerStatusWidth + _tableTextHorizontalMargin,
			['y'] = tableText.y })

		-- Draw voice chat indicator
		if Settings.enableVoiceChat then
			local localPlayerId = GetPlayerFromServerId(player.id)
			local isPlayerTalking = NetworkIsPlayerTalking(localPlayerId)
			local voiceIndicatorColor = isPlayerTalking and _activeVoiceIndicatorColor or _inactiveVoiceIndicatorColor
			DrawSprite('mpleaderboard', isPlayerTalking and 'leaderboard_audio_3' or 'leaderboard_audio_inactive', voiceIndicatorPosition.x, voiceIndicatorPosition.y, _voiceIndicatorWidth, _tableHeight, 0.0, voiceIndicatorColor.r, voiceIndicatorColor.g, voiceIndicatorColor.b, voiceIndicatorColor.a)
		end

		-- Draw rank
		local playerRankColor = _rankColor
		if player.prestige ~= 0 then playerRankColor = {
			r = _prestigeColor.r + _prestigeBlendColor.r * player.prestige,
			g = _prestigeColor.g + _prestigeBlendColor.g * player.prestige,
			b = _prestigeColor.b + _prestigeBlendColor.b * player.prestige,
			a = _prestigeBlendColor.a }
		end
		DrawSprite('mprankbadge', 'rankglobe_21x21_colour', rankPosition.x, rankPosition.y, _rankWidth, _rankHeight, 0.0, playerRankColor.r, playerRankColor.g, playerRankColor.b, playerRankColor.a)
		Gui.SetTextParams(4, _rankTextColor, _rankScale, false, false, true)
		Gui.DrawNumeric(player.rank, { ['x'] = rankPosition.x, ['y'] = tableText.y + _tableTextVerticalMargin / 1.25 })

		-- Draw player status
		local playerStatusColor = Color.WHITE
		if player.faction == Settings.faction.Enforcer then playerStatusColor = Color.DARK_BLUE
		elseif player.faction == Settings.faction.Criminal then playerStatusColor = Color.RED end
		Gui.DrawRect(playerStatusPosition, _playerStatusWidth, _tableHeight, playerStatusColor)

		-- Draw cash
		Gui.DrawRect(cashPosition, _tableCashWidth, _tableHeight, _tableCashColor)
		Gui.SetTextParams(0, _tableCashTextColor, _cashScale, false, false, true)
		Gui.DrawTextEntry('MONEY_ENTRY', { ['x'] = tableCashHeader.x, ['y'] = tableText.y + _tableTextVerticalMargin }, player.cash)

		-- Draw kdRatio
		Gui.DrawRect(kdRatioPosition, _tableKdRatioWidth, _tableHeight, _tableKdRatioColor)
		Gui.SetTextParams(0, _tableKdRatioTextColor, _kdRatioScale, false, false, true)
		local kdRatio = '-'
		if player.kdRatio then
			kdRatio = string.format('%.2f', player.kdRatio)
		end
		Gui.DrawText(kdRatio, { ['x'] = tableKdRatioHeader.x, ['y'] = tableText.y + _tableTextVerticalMargin })

		-- Draw kills
		Gui.DrawRect(killsPosition, _tableKillsWidth, _tableHeight, _tableKillsColor)
		Gui.SetTextParams(0, _tableKillsTextColor, _killsScale, false, false, true)
		Gui.DrawNumeric(player.kills, { ['x'] = tableKillsHeader.x, ['y'] = tableText.y + _tableTextVerticalMargin })

		-- Update table position
		tablePosition.y = tablePosition.y + _tableSpacing + _tableHeight
	end)
end

Citizen.CreateThread(function()
	AddTextEntry('MONEY_ENTRY', '$~1~')

	Streaming.RequestStreamedTextureDictAsync('mpleaderboard')
	Streaming.RequestStreamedTextureDictAsync('mprankbadge')
end)

AddEventHandler('lsv:playerDataWasModified', function()
	_needUpdate = true
end)
