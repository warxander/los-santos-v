--https://scaleform.devtesting.pizza/

Scaleform = { }
Scaleform.__index = Scaleform


local logger = Logger:CreateNamedLogger("Scaleform")

local function scaleform_is_valid(scaleform)
	if not scaleform or scaleform == 0 then
		logger:Error('Scaleform: invalid scaleform '..tostring(scaleform))
		return false
	end

	return true
end


local function scaleform_has_loaded(scaleform)
	if not scaleform or not HasScaleformMovieLoaded(scaleform) then
		logger:Error('Scaleform: using not loaded scaleform '..tostring(scaleform))
		return false
	end

	return true
end


local function scaleform_is_int(number)
	return type(number) == "number" and not string.find(tostring(number), '%.')
end


function Scaleform:Request(id)
	if type(id) ~= "string" then
		logger:Error('Scaleform: unable to request '..tostring(id))
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
		logger:Error('Scaleform: unable to call '..tostring(func)..' func')
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
			logger:Error('Scaleform: invalid parameter type ['..tostring(paramType)..'] for scaleform '..tostring(self.scaleform))
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