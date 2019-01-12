local Bar = { }
Bar.__index = Bar

Bar.Width = 0.145
Bar.Height = 0.035

Bar.ProgressWidth = Bar.Width / 2.65
Bar.ProgressHeight = Bar.Height / 3.25

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
	local scale = isPlayerText and 0.5 or 0.3
	local margin = isPlayerText and 0.015 or 0.007

	DrawSprite(Bar.TextureDict, Bar.Texture, x, y, Bar.Width, Bar.Height, 0.0, 255, 255, 255, 160)

	Gui.SetTextParams(font, color, scale, isPlayerText, false, false)
	Gui.DrawText(title, { x = SafeZone.Right() - Bar.Width / 2, y = y - margin }, Bar.Width / 2)
	Gui.SetTextParams(0, color, 0.5, false, false, false)
	Gui.DrawText(text, { x = SafeZone.Right() - 0.00285, y = y - 0.0175 }, Bar.Width / 2)
end


function Gui.DrawTimerBar(text, seconds, isPlayerText, index)
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

	Gui.SetTextParams(0, Color.GetHudFromBlipColor(Color.BlipWhite()), 0.3, false, false, false)
	Gui.DrawText(title, { x = SafeZone.Right() - Bar.Width / 2, y = y - 0.011 }, Bar.Width / 2)

	local color = color or { r = 255, g = 255, b = 255 }
	local progressX = x + Bar.Width / 2 - Bar.ProgressWidth / 2 - 0.00285 * 2
	DrawRect(progressX, y, Bar.ProgressWidth, Bar.ProgressHeight, color.r, color.g, color.b, 96)

	local progress = math.max(0.0, math.min(1.0, progress))
	local progressWidth = Bar.ProgressWidth * progress
	DrawRect(progressX - (Bar.ProgressWidth - progressWidth) / 2, y, progressWidth, Bar.ProgressHeight, color.r, color.g, color.b, 255)
end