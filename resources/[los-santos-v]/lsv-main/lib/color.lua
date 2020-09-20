Color = { }
Color.__index = Color

Color.BLIP_WHITE = 0
Color.BLIP_RED = 1
Color.BLIP_GREEN = 2
Color.BLIP_BLUE = 3
Color.BLIP_YELLOW = 5
Color.BLIP_ORANGE = 17
Color.BLIP_PURPLE = 19
Color.BLIP_GREY = 20
Color.BLIP_BROWN = 21
Color.BLIP_PINK = 23
Color.BLIP_LIME = 24
Color.BLIP_LIGHT_BLUE = 26
Color.BLIP_LIGHT_RED = 35
Color.BLIP_LIGHT_GREY = 45
Color.BLIP_DARK_GREEN = 52
Color.BLIP_DARK_BLUE = 54

local _blipColors = {
	{ r = 254, g = 254, b = 254, a = 255 },
	{ r = 224, g = 50, b = 50, a = 255 },
	{ r = 114, g = 204, b = 114, a = 255 },
	{ r = 93, g = 182, b = 229, a = 255 },
	{ r = 240, g = 240, b = 240, a = 255 },
	{ r = 240, g = 200, b = 80, a = 255 },
	{ r = 194, g = 80, b = 80, a = 255 },
	{ r = 156, g = 110, b = 175, a = 255 },
	{ r = 255, g = 123, b = 196, a = 255 },
	{ r = 247, g = 159, b = 123, a = 255 },
	{ r = 178, g = 144, b = 132, a = 255 },
	{ r = 141, g = 206, b = 167, a = 255 },
	{ r = 113, g = 169, b = 175, a = 255 },
	{ r = 211, g = 209, b = 231, a = 255 },
	{ r = 144, g = 127, b = 153, a = 255 },
	{ r = 106, g = 196, b = 191, a = 255 },
	{ r = 214, g = 196, b = 153, a = 255 },
	{ r = 234, g = 142, b = 80, a = 255 },
	{ r = 152, g = 203, b = 234, a = 255 },
	{ r = 178, g = 98, b = 135, a = 255 },
	{ r = 144, g = 142, b = 122, a = 255 },
	{ r = 166, g = 117, b = 94, a = 255 },
	{ r = 175, g = 168, b = 168, a = 255 },
	{ r = 232, g = 142, b = 155, a = 255 },
	{ r = 187, g = 214, b = 91, a = 255 },
	{ r = 12, g = 123, b = 86, a = 255 },
	{ r = 123, g = 196, b = 255, a = 255 },
	{ r = 171, g = 60, b = 230, a = 255 },
	{ r = 206, g = 169, b = 13, a = 255 },
	{ r = 71, g = 99, b = 173, a = 255 },
	{ r = 42, g = 166, b = 185, a = 255 },
	{ r = 186, g = 157, b = 125, a = 255 },
	{ r = 201, g = 225, b = 255, a = 255 },
	{ r = 240, g = 240, b = 150, a = 255 },
	[46] = { r = 240, g = 240, b = 240, a = 255 }, -- Lazy bitch
	[53] = { r = 66, g = 109, b = 66, a = 255 }, -- Lazy bitch
	[55] = { r = 57, g = 100, b = 121, a = 255 }, -- Lazy bitch
}

local _colorPalette = {
	{ r = 8, g = 8, b = 8 },
	{ r = 15, g = 15, b = 15 },
	{ r = 28, g = 30, b = 33 },
	{ r = 41, g = 44, b = 46 },
	{ r = 90, g = 94, b = 102 },
	{ r = 119, g = 124, b = 135 },
	{ r = 81, g = 84, b = 89 },
	{ r = 50, g = 59, b = 71 },
	{ r = 51, g = 51, b = 51 },
	{ r = 31, g = 34, b = 38 },
	{ r = 35, g = 41, b = 46 },
	{ r = 18, g = 17, b = 16 },
	{ r = 5, g = 5, b = 5 },
	{ r = 18, g = 18, b = 18 },
	{ r = 47, g = 50, b = 51 },
	{ r = 8, g = 8, b = 8 },
	{ r = 18, g = 18, b = 18 },
	{ r = 32, g = 34, b = 36 },
	{ r = 87, g = 89, b = 97 },
	{ r = 35, g = 41, b = 46 },
	{ r = 50, g = 59, b = 71 },
	{ r = 15, g = 16, b = 18 },
	{ r = 33, g = 33, b = 33 },
	{ r = 91, g = 93, b = 94 },
	{ r = 136, g = 138, b = 153 },
	{ r = 105, g = 113, b = 135 },
	{ r = 59, g = 70, b = 84 },
	{ r = 105, g = 0, b = 0 },
	{ r = 138, g = 11, b = 0 },
	{ r = 107, g = 0, b = 0 },
	{ r = 97, g = 16, b = 9 },
	{ r = 74, g = 10, b = 10 },
	{ r = 71, g = 14, b = 14 },
	{ r = 56, g = 12, b = 0 },
	{ r = 38, g = 3, b = 11 },
	{ r = 99, g = 0, b = 18 },
	{ r = 128, g = 40, b = 0 },
	{ r = 110, g = 79, b = 45 },
	{ r = 189, g = 72, b = 0 },
	{ r = 120, g = 0, b = 0 },
	{ r = 54, g = 0, b = 0 },
	{ r = 171, g = 63, b = 0 },
	{ r = 222, g = 126, b = 0 },
	{ r = 82, g = 0, b = 0 },
	{ r = 140, g = 4, b = 4 },
	{ r = 74, g = 16, b = 0 },
	{ r = 89, g = 37, b = 37 },
	{ r = 117, g = 66, b = 49 },
	{ r = 33, g = 8, b = 4 },
	{ r = 0, g = 18, b = 7 },
	{ r = 0, g = 26, b = 11 },
	{ r = 0, g = 33, b = 30 },
	{ r = 31, g = 38, b = 30 },
	{ r = 0, g = 56, b = 5 },
	{ r = 11, g = 65, b = 69 },
	{ r = 65, g = 133, b = 3 },
	{ r = 15, g = 31, b = 21 },
	{ r = 2, g = 54, b = 19 },
	{ r = 22, g = 36, b = 25 },
	{ r = 42, g = 54, b = 37 },
	{ r = 69, g = 92, b = 86 },
	{ r = 0, g = 13, b = 20 },
	{ r = 0, g = 16, b = 41 },
	{ r = 28, g = 47, b = 79 },
	{ r = 0, g = 27, b = 87 },
	{ r = 59, g = 78, b = 120 },
	{ r = 39, g = 45, b = 59 },
	{ r = 149, g = 178, b = 219 },
	{ r = 62, g = 98, b = 122 },
	{ r = 28, g = 49, b = 64 },
	{ r = 0, g = 85, b = 196 },
	{ r = 26, g = 24, b = 46 },
	{ r = 22, g = 22, b = 41 },
	{ r = 14, g = 49, b = 109 },
	{ r = 57, g = 90, b = 131 },
	{ r = 9, g = 20, b = 46 },
	{ r = 15, g = 16, b = 33 },
	{ r = 21, g = 42, b = 82 },
	{ r = 50, g = 70, b = 84 },
	{ r = 21, g = 37, b = 99 },
	{ r = 34, g = 59, b = 161 },
	{ r = 31, g = 31, b = 161 },
	{ r = 3, g = 14, b = 46 },
	{ r = 15, g = 30, b = 115 },
	{ r = 0, g = 28, b = 50 },
	{ r = 42, g = 55, b = 84 },
	{ r = 48, g = 60, b = 94 },
	{ r = 59, g = 103, b = 150 },
	{ r = 245, g = 137, b = 15 },
	{ r = 217, g = 166, b = 0 },
	{ r = 74, g = 52, b = 27 },
	{ r = 162, g = 168, b = 39 },
	{ r = 86, g = 143, b = 0 },
	{ r = 87, g = 81, b = 75 },
	{ r = 41, g = 27, b = 6 },
	{ r = 38, g = 33, b = 23 },
	{ r = 18, g = 13, b = 7 },
	{ r = 51, g = 33, b = 17 },
	{ r = 61, g = 48, b = 35 },
	{ r = 94, g = 83, b = 67 },
	{ r = 55, g = 56, b = 43 },
	{ r = 34, g = 25, b = 24 },
	{ r = 87, g = 80, b = 54 },
	{ r = 36, g = 19, b = 9 },
	{ r = 59, g = 23, b = 0 },
	{ r = 110, g = 98, b = 70 },
	{ r = 153, g = 141, b = 115 },
	{ r = 207, g = 192, b = 165 },
	{ r = 31, g = 23, b = 9 },
	{ r = 61, g = 49, b = 29 },
	{ r = 102, g = 88, b = 71 },
	{ r = 240, g = 240, b = 240 },
	{ r = 179, g = 185, b = 201 },
	{ r = 97, g = 95, b = 85 },
	{ r = 36, g = 30, b = 26 },
	{ r = 23, g = 20, b = 19 },
	{ r = 59, g = 55, b = 47 },
	{ r = 59, g = 64, b = 69 },
	{ r = 26, g = 30, b = 33 },
	{ r = 94, g = 100, b = 107 },
	{ r = 0, g = 0, b = 0 },
	{ r = 176, g = 176, b = 176 },
	{ r = 153, g = 153, b = 153 },
	{ r = 181, g = 101, b = 25 },
	{ r = 196, g = 92, b = 51 },
	{ r = 71, g = 120, b = 60 },
	{ r = 186, g = 132, b = 37 },
	{ r = 42, g = 119, b = 161 },
	{ r = 36, g = 48, b = 34 },
	{ r = 107, g = 95, b = 84 },
	{ r = 201, g = 110, b = 52 },
	{ r = 217, g = 217, b = 217 },
	{ r = 240, g = 240, b = 240 },
	{ r = 63, g = 66, b = 40 },
	{ r = 255, g = 255, b = 255 },
	{ r = 176, g = 18, b = 89 },
	{ r = 246, g = 151, b = 153 },
	{ r = 143, g = 47, b = 85 },
	{ r = 194, g = 102, b = 16 },
	{ r = 105, g = 189, b = 69 },
	{ r = 0, g = 174, b = 239 },
	{ r = 0, g = 1, b = 8 },
	{ r = 5, g = 0, b = 8 },
	{ r = 8, g = 0, b = 0 },
	{ r = 86, g = 87, b = 81 },
	{ r = 50, g = 6, b = 66 },
	{ r = 5, g = 0, b = 8 },
	{ r = 8, g = 8, b = 8 },
	{ r = 50, g = 6, b = 66 },
	{ r = 5, g = 0, b = 8 },
	{ r = 107, g = 11, b = 0 },
	{ r = 18, g = 23, b = 16 },
	{ r = 50, g = 51, b = 37 },
	{ r = 59, g = 53, b = 45 },
	{ r = 112, g = 102, b = 86 },
	{ r = 43, g = 48, b = 43 },
	{ r = 65, g = 67, b = 71 },
	{ r = 102, g = 144, b = 181 },
	{ r = 71, g = 57, b = 27 },
	{ r = 71, g = 57, b = 27 },
	{ r = 255, g = 216, b = 89 },
}

local function blipToHudColor(blipColor)
	return _blipColors[blipColor + 1]
end

function Color.GetRandomRgb()
	return table.random(_colorPalette)
end

function Color.UnpackRgb(color)
	return table.unpack({ color.r, color.g, color.b })
end

Color.WHITE = blipToHudColor(Color.BLIP_WHITE)
Color.RED = blipToHudColor(Color.BLIP_RED)
Color.GREEN = blipToHudColor(Color.BLIP_GREEN)
Color.BLUE = blipToHudColor(Color.BLIP_BLUE)
Color.YELLOW = blipToHudColor(Color.BLIP_YELLOW)
Color.ORANGE = blipToHudColor(Color.BLIP_ORANGE)
Color.PURPLE = blipToHudColor(Color.BLIP_PURPLE)
Color.GREY = blipToHudColor(Color.BLIP_GREY)
Color.BROWN = blipToHudColor(Color.BLIP_BROWN)
Color.PINK = blipToHudColor(Color.BLIP_PINK)
Color.LIME = blipToHudColor(Color.BLIP_LIME)
Color.LIGHT_BLUE = blipToHudColor(Color.BLIP_LIGHT_BLUE)
Color.LIGHT_GREY = blipToHudColor(Color.BLIP_LIGHT_GREY)
Color.DARK_GREEN = blipToHudColor(Color.BLIP_DARK_GREEN)
Color.DARK_BLUE = blipToHudColor(Color.BLIP_DARK_BLUE)
