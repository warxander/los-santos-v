--https://scaleform.devtesting.pizza/

Scaleform = { }
Scaleform.__index = Scaleform


local logger = Logger:CreateNamedLogger("Scaleform")

local function scaleform_is_valid(scaleform)
	if not scaleform or scaleform == 0 then
		logger:Error('Invalid scaleform parameter: '..logger:ToString(scaleform))
		return false
	end

	return true
end


local function scaleform_has_loaded(scaleform)
	if not scaleform or not HasScaleformMovieLoaded(scaleform) then
		logger:Error('Using not loaded scaleform: '..logger:ToString(scaleform))
		return false
	end

	return true
end


local function scaleform_is_int(number)
	return type(number) == "number" and not string.find(number, '%.')
end


local function scaleform_render_timed(scaleform, time, renderFunc, ...)
	if not scaleform_is_valid(scaleform.scaleform) then return end

	local startTime = GetGameTimer()
	local transOutTime = 500

	while Player.IsActive() and GetTimeDifference(GetGameTimer(), startTime) < time + transOutTime do
		Citizen.Wait(0)

		if GetGameTimer() - startTime > time then
			scaleform:Call('SHARD_ANIM_OUT', 1, 0.33)
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


function Scaleform:Request(id)
	if type(id) ~= "string" then
		logger:Error('Unable to request id: '..logger:ToString(id))
		return nil
	end

	local object = { }
	setmetatable(object, Scaleform)

	object.scaleform = RequestScaleformMovie(id)
	if not scaleform_is_valid(object.scaleform) then return nil end
	while not HasScaleformMovieLoaded(object.scaleform) do Citizen.Wait(0) end

	return object
end


function Scaleform:Delete()
	if not scaleform_is_valid(self.scaleform) then return end
	if not scaleform_has_loaded(self.scaleform) then return end

	SetScaleformMovieAsNoLongerNeeded(self.scaleform)

	self.scaleform = nil
end


function Scaleform:Call(func, ...)
	if not scaleform_is_valid(self.scaleform) then return end
	if type(func) ~= "string" then
		logger:Error('Unable to call scaleform func: '..logger:ToString(func))
		return
	end

	PushScaleformMovieFunction(self.scaleform, func)

	local params = { ... }
	for _, param in ipairs(params) do
		local paramType = type(param)
		if paramType == 'string' then
			PushScaleformMovieFunctionParameterString(param)
		elseif paramType == 'number' then
			if scaleform_is_int(param) then
				PushScaleformMovieFunctionParameterInt(param)
			else
				PushScaleformMovieFunctionParameterFloat(param)
			end
		elseif paramType == 'boolean' then
			PushScaleformMovieFunctionParameterBool(param)
		else
			logger:Error('Unknown parameter type for scaleform '..tostring(self.scaleform)..': '..tostring(paramType))
			return
		end
	end

	PopScaleformMovieFunctionVoid()
end


function Scaleform:Render(x, y, w, h, r, g, b, a)
	if not scaleform_is_valid(self.scaleform) then return end
	DrawScaleformMovie(self.scaleform, x, y, w, h, r or 255, g or 255, b or 255, a or 255)
end


function Scaleform:RenderFullscreen(r, g, b, a)
	if not scaleform_is_valid(self.scaleform) then return end
	DrawScaleformMovieFullscreen(self.scaleform, r or 255, g or 255, b or 255, a or 255)
end


function Scaleform:RenderTimed(time, x, y, w, h, r, g, b, a)
	scaleform_render_timed(self, time, self.Render, x, y, w, h, r, g, b, a)
end


function Scaleform:RenderFullscreenTimed(time, r, g, b, a)
	scaleform_render_timed(self, time, self.RenderFullscreen, r, g, b, a)
end