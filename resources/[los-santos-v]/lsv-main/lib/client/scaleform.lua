--https://scaleform.devtesting.pizza/
Scaleform = { }
Scaleform.__index = Scaleform

local _scaleformPool = { }

-- TODO: Simplify me
local function scaleform_render_timed(scaleform, time, renderFunc, ...)
	local startTime = GetGameTimer()
	local transOutTime = 500

	while Player.IsActive() and GetTimeDifference(GetGameTimer(), startTime) < time + transOutTime do
		Citizen.Wait(0)

		if GetGameTimer() - startTime > time then
			scaleform:call('SHARD_ANIM_OUT', 1, 0.33)
			startTime = startTime + transOutTime

			while GetGameTimer() - startTime < time + transOutTime do
				Citizen.Wait(0)
				renderFunc(scaleform, ...)
			end

			break
		end

		renderFunc(scaleform, ...)
	end
end

function Scaleform.NewAsync(name)
	if _scaleformPool[name] then
		return _scaleformPool[name]
	end

	local self = { }
	setmetatable(self, Scaleform)

	self._name = name

	self._scaleform = RequestScaleformMovie(name)
	while not HasScaleformMovieLoaded(self._scaleform) do
		Citizen.Wait(0)
	end

	_scaleformPool[name] = self
	return self
end

function Scaleform.SetAsNoLongerNeeded(name)
	if _scaleformPool[name] then
		SetScaleformMovieAsNoLongerNeeded(_scaleformPool[name]._scaleform)
		_scaleformPool[name] = nil
	end
end

function Scaleform:call(func, ...)
	PushScaleformMovieFunction(self._scaleform, func)

	local params = { ... }
	for _, param in ipairs(params) do
		local paramType = type(param)

		if paramType == 'string' then
			PushScaleformMovieFunctionParameterString(param)
		elseif paramType == 'number' then
			if math.is_integer(param) then
				PushScaleformMovieFunctionParameterInt(param)
			else
				PushScaleformMovieFunctionParameterFloat(param)
			end
		elseif paramType == 'boolean' then
			PushScaleformMovieFunctionParameterBool(param)
		end
	end

	PopScaleformMovieFunctionVoid()
end

function Scaleform:render(x, y, w, h, r, g, b, a)
	DrawScaleformMovie(self._scaleform, x, y, w, h, r or 255, g or 255, b or 255, a or 255)
end

function Scaleform:renderFullscreen(r, g, b, a)
	DrawScaleformMovieFullscreen(self._scaleform, r or 255, g or 255, b or 255, a or 255)
end

function Scaleform:renderTimed(time, x, y, w, h, r, g, b, a)
	scaleform_render_timed(self, time, self.render, x, y, w, h, r, g, b, a)
end

function Scaleform:renderFullscreenTimed(time, r, g, b, a)
	scaleform_render_timed(self, time, self.renderFullscreen, r, g, b, a)
end
