Timer = { }
Timer.__index = Timer


function Timer.New(startTime)
	local self = { }
	setmetatable(self, Timer)

	self._startTime = GetGameTimer()
	if startTime then self._startTime = GetGameTimer() + startTime end

	return self
end


function Timer:Elapsed()
	return GetGameTimer() - self._startTime
end


function Timer:Restart()
	local elapsedTime = self:Elapsed()
	self._startTime = GetGameTimer()
	return elapsedTime
end