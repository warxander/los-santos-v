Logger = { }
Logger.__index = Logger


local function log(level, name, message)
	if IsDuplicityVersion() then
		Citizen.Trace('['..os.date('%c')..'] ['..level..'] ['..name..'] '..tostring(message)..'\n')
	else
		Citizen.Trace('['..level..'] ['..name..'] '..tostring(message)..'\n')
	end
end


function Logger.New(name)
	local self = { }

	setmetatable(self, Logger)
	self._name = name

	return self
end


function Logger:Info(message)
	log('Info', self._name, message)
end


function Logger:Error(message)
	log('Error', self._name, message)
end


function Logger:Warning(message)
	log('Warning', self._name, message)
end


function Logger:ToString(any)
	return '{ type: '..type(any)..', value: '..tostring(any)..' }'
end
