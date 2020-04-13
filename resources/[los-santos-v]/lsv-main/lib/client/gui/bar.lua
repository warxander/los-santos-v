local _barWidth = 0.145
local _barHeight = 0.035

local _barProgressWidth = _barWidth / 2.65
local _barProgressHeight = _barHeight / 3.25

local _barTexture = 'all_black_bg'
local _barTextureDict = 'timerbars'

function Gui.DrawBar(title, text, barPosition, color, isPlayerText)
	RequestStreamedTextureDict(_barTextureDict)
	if not HasStreamedTextureDictLoaded(_barTextureDict) then
		return
	end

	local x = SafeZone.Right() - _barWidth / 2
	local y = SafeZone.Bottom() - _barHeight / 2 - barPosition * (_barHeight + 0.0038) - 0.05
	local color = color or Color.WHITE
	local font = isPlayerText and 4 or 0
	local scale = isPlayerText and 0.5 or 0.3
	local margin = isPlayerText and 0.015 or 0.007

	DrawSprite(_barTextureDict, _barTexture, x, y, _barWidth, _barHeight, 0.0, 255, 255, 255, 160)

	Gui.SetTextParams(font, color, scale, isPlayerText, false, false)
	Gui.DrawText(title, { x = SafeZone.Right() - _barWidth / 2, y = y - margin }, SafeZone.Size() - _barWidth / 2)
	Gui.SetTextParams(0, color, 0.5, false, false, false)
	Gui.DrawText(text, { x = SafeZone.Right() - 0.00285, y = y - 0.0175 }, _barWidth / 2)
end

function Gui.DrawTimerBar(text, ms, barPosition, isPlayerText, color)
	if not color then
		color = ms <= 10000 and Color.RED or Color.WHITE
	end
	Gui.DrawBar(text, string.from_ms(ms), barPosition, color, isPlayerText)
end

function Gui.DrawProgressBar(title, progress, barPosition, color)
	RequestStreamedTextureDict(_barTextureDict)
	if not HasStreamedTextureDictLoaded(_barTextureDict) then
		return
	end

	local x = SafeZone.Right() - _barWidth / 2
	local y = SafeZone.Bottom() - _barHeight / 2 - barPosition * (_barHeight + 0.0038) - 0.05

	DrawSprite(_barTextureDict, _barTexture, x, y, _barWidth, _barHeight, 0.0, 255, 255, 255, 160)

	Gui.SetTextParams(0, Color.WHITE, 0.3, false, false, false)
	Gui.DrawText(title, { x = SafeZone.Right() - _barWidth / 2, y = y - 0.011 }, SafeZone.Size() - _barWidth / 2)

	local color = color or { r = 255, g = 255, b = 255 }
	local progressX = x + _barWidth / 2 - _barProgressWidth / 2 - 0.00285 * 2
	DrawRect(progressX, y, _barProgressWidth, _barProgressHeight, color.r, color.g, color.b, 96)

	local progress = math.max(0.0, math.min(1.0, progress))
	local progressWidth = _barProgressWidth * progress
	DrawRect(progressX - (_barProgressWidth - progressWidth) / 2, y, progressWidth, _barProgressHeight, color.r, color.g, color.b, 255)
end
