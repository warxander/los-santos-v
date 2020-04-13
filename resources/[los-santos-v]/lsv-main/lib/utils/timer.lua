Timer = { }
Timer.__index = Timer

function Timer.New(startTime)
	local self = { }
	setmetatable(self, Timer)

	self._startTime = GetGameTimer()
	if startTime then
		self._startTime = self._startTime + startTime
	end

	return self
end

function Timer:elapsed()
	return GetGameTimer() - self._startTime
end

function Timer:restart()
	local elapsedTime = self:elapsed()
	self._startTime = GetGameTimer()
	return elapsedTime
end
