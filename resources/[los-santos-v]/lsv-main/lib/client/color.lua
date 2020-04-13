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
Color.BLIP_LIGHT_BLUE = 26
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
	[55] = { r = 57, g = 100, b = 121, a = 255 }, -- Lazy bitch
}

local function blipToHudColor(blipColor)
	return _blipColors[blipColor + 1]
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
Color.LIGHT_BLUE = blipToHudColor(Color.BLIP_LIGHT_BLUE)
Color.DARK_BLUE = blipToHudColor(Color.BLIP_DARK_BLUE)
