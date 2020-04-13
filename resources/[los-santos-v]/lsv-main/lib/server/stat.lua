Stat = { }
Stat.__index = Stat

local function calculateStat(rank, range)
	return math.min(100, range.min + math.floor(math.min(rank, 100) * (range.max - range.min) / 100))
end

function Stat.CalculateStats(rank)
	local stats = { }

	stats.strength = calculateStat(rank, Settings.stats.strength)
	stats.shooting = calculateStat(rank, Settings.stats.shooting)
	stats.flying = calculateStat(rank, Settings.stats.flying)
	stats.driving = calculateStat(rank, Settings.stats.driving)
	stats.lung = calculateStat(rank, Settings.stats.lung)
	stats.stealth = calculateStat(rank, Settings.stats.stealth)
	stats.stamina = calculateStat(rank, Settings.stats.stamina)

	return stats
end
