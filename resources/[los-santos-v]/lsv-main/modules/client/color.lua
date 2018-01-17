Color = { }

Color.White = 0
Color.Red = 1
Color.Green = 2
Color.Blue = 3
Color.Orange = 17
Color.Purple = 19
Color.Grey = 20
Color.Brown = 21
Color.Pink = 23

local colors = {
	{ r = 224, g = 50, b = 50 },
	{ r = 114, g = 204, b = 114 },
	{ r = 93, g = 182, b = 229 },
	{ r = 240, g = 240, b = 240 },
	{ r = 240, g = 200, b = 80 },
	{ r = 194, g = 80, b = 80 },
	{ r = 156, g = 110, b = 175 },
	{ r = 255, g = 123, b = 196 },
	{ r = 247, g = 159, b = 123 },
	{ r = 178, g = 144, b = 132 },
	{ r = 141, g = 206, b = 167 },
	{ r = 113, g = 169, b = 175 },
	{ r = 211, g = 209, b = 231 },
	{ r = 144, g = 127, b = 153 },
	{ r = 106, g = 196, b = 191 },
	{ r = 214, g = 196, b = 153 },
	{ r = 234, g = 142, b = 80 },
	{ r = 152, g = 203, b = 234 },
	{ r = 178, g = 98, b = 135 },
	{ r = 144, g = 142, b = 122 },
	{ r = 166, g = 117, b = 94 },
	{ r = 175, g = 168, b = 168 },
	{ r = 232, g = 142, b = 155 },
	{ r = 187, g = 214, b = 91 },
	{ r = 12, g = 123, b = 86 },
	{ r = 123, g = 196, b = 255 },
	{ r = 171, g = 60, b = 230 },
	{ r = 206, g = 169, b = 13 },
	{ r = 71, g = 99, b = 173 },
	{ r = 42, g = 166, b = 185 },
	{ r = 186, g = 157, b = 125 },
	{ r = 201, g = 225, b = 255 },
	{ r = 240, g = 240, b = 150 },
}

function Color.GetHudFromBlipColor(blipColor) --RGB
	return colors[blipColor]
end