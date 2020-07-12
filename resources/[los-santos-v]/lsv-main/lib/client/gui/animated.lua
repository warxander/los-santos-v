Animated = { }
Animated.__index = Animated

Animated.EasingTypes = { }
Animated.EasingTypes.Linear = function(x)
	return x
end

function Animated.New(endVal, time, startVal, easingFunc)
	local self = { }
	setmetatable(self, Animated)

	self._startVal = startVal or 0
	self._endVal = endVal
	self._isInt = math.is_integer(self._endVal)
	self._time = time
	self._timer = Timer.New()
	self._easingFunc = easingFunc or Animated.EasingTypes.Linear

	return self
end

function Animated:get()
	local progress = math.min(1.0, self._timer:elapsed() / self._time)

	local value = self._startVal + ((self._endVal - self._startVal) * self._easingFunc(progress))
	if self._isInt then
		value = math.floor(value)
	end

	return self._endVal > self._startVal and math.min(self._endVal, value) or value
end

function Animated:restart()
	self._timer:restart()
end
