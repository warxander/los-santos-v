Rank = { }
Rank.__index = Rank

-- f(x)=25x^2 + 23575x - 1023150

local logger = Logger.New('Rank')


function Rank.CalculateRank(experience)
	if experience == 0 then return 1 end

	for i = 2, #Settings.ranks do
		if Settings.ranks[i] > experience then
			return i - 1
		end
	end

	local a = 25
	local b = 23575
	local c = -1023150 - experience

	local d = b * b - 4 * a * c
	if d == 0 then
		return math.floor(-b/ (2 * a))
	end

	if d > 0 then
		return math.floor(math.max((-b + math.sqrt(d)) / (2 * a), (-b - math.sqrt(d)) / (2 * a)))
	else
		logger:Error('Failed to calculate rank for '..experience..' experience')
		return 1
	end
end


function Rank.GetRequiredExperience(rank)
	if rank <= #Settings.ranks then
		return Settings.ranks[rank]
	else
		return 25 * rank * rank + 23575 * rank - 1023150
	end
end