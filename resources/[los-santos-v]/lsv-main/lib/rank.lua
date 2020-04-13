Rank = { }
Rank.__index = Rank

-- f(x)=25x^2 + 23575x - 1023150
local _a = 25
local _b = 23575
local _c = -1023150
local _x = math.floor(-_b / (2 * _a))

function Rank.CalculateRank(exp)
	if exp == 0 then
		return 1
	end

	-- TODO: Lower bound?
	for i = 2, #Settings.ranks do
		if exp == Settings.ranks[i] then
			return i
		elseif exp < Settings.ranks[i] then
			return i - 1
		end
	end

	local d = _b ^ 2 - 4 * _a * (_c - exp)

	if d == 0 then
		return _x
	end

	if d > 0 then
		return math.floor(math.max((-_b + math.sqrt(d)) / (2 * _a), (-_b - math.sqrt(d)) / (2 * _a)))
	end
end

function Rank.GetRequiredExperience(rank)
	if rank <= #Settings.ranks then
		return Settings.ranks[rank]
	else
		return _a * rank ^ 2 + _b * rank + _c
	end
end
