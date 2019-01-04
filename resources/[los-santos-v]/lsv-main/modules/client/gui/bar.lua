local Bar = { }
Bar.__index = Bar

Bar.Width = 0.165
Bar.Height = 0.035

Bar.ProgressWidth = Bar.Width / 2.65
Bar.ProgressHeight = Bar.Height / 2.65

Bar.Texture = 'all_black_bg'
Bar.TextureDict = 'timerbars'


function Gui.DrawBar(title, text, color, index, isPlayerText)
	RequestStreamedTextureDict(Bar.TextureDict)
	if not HasStreamedTextureDictLoaded(Bar.TextureDict) then return end

	local index = index or 1
	local x = SafeZone.Right() - Bar.Width / 2
	local y = SafeZone.Bottom() - Bar.Height / 2 - (index - 1) * (Bar.Height + 0.0038) - 0.05
	local color = color or Color.GetHudFromBlipColor(Color.BlipWhite())
	local font = isPlayerText and 4 or 0
	local margin = isPlayerText and 0.014 or 0.009

	DrawSprite(Bar.TextureDict, Bar.Texture, x, y, Bar.Width, Bar.Height, 0.0, 255, 255, 255, 160)

	Gui.DrawText(title, { x = SafeZone.Right() - Bar.Width / 2, y = y - margin }, font, color, 0.3, isPlayerText, false, false, true)
	Gui.DrawText(text, { x = SafeZone.Right() - 0.00285, y = y - 0.0165 }, 0, color, 0.425, false, false, false, true)
end


function Gui.DrawTimerBar(text, seconds, index, isPlayerText)
	local color = seconds <= 10 and Color.GetHudFromBlipColor(Color.BlipRed()) or Color.GetHudFromBlipColor(Color.BlipWhite())
	Gui.DrawBar(text, string.format("%02.f", math.floor(seconds / 60))..':'..string.format("%02.f", math.floor(seconds % 60)), color, index, isPlayerText)
end


function Gui.DrawProgressBar(title, progress, color, index)
	RequestStreamedTextureDict(Bar.TextureDict)
	if not HasStreamedTextureDictLoaded(Bar.TextureDict) then return end

	local index = index or 1
	local x = SafeZone.Right() - Bar.Width / 2
	local y = SafeZone.Bottom() - Bar.Height / 2 - (index - 1) * (Bar.Height + 0.0038) - 0.05

	DrawSprite(Bar.TextureDict, Bar.Texture, x, y, Bar.Width, Bar.Height, 0.0, 255, 255, 255, 160)

	Gui.DrawText(title, { x = SafeZone.Right() - Bar.Width / 2, y = y - 0.009 }, 0, Color.GetHudFromBlipColor(Color.BlipWhite()), 0.3, false, false, false, true)

	local color = color or { r = 255, g = 255, b = 255 }
	local progressX = x + Bar.Width / 2 - Bar.ProgressWidth / 2 - 0.00285 * 2
	DrawRect(progressX, y, Bar.ProgressWidth, Bar.ProgressHeight, color.r, color.g, color.b, 96)

	local progress = math.max(0.0, math.min(1.0, progress))
	local progressWidth = Bar.ProgressWidth * progress
	DrawRect(progressX - (Bar.ProgressWidth - progressWidth) / 2, y, progressWidth, Bar.ProgressHeight, color.r, color.g, color.b, 255)
end