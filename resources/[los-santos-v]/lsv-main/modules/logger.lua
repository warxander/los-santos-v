Logger = { }
Logger.__index = Logger


local function log(level, name, message)
	if IsDuplicityVersion() then
		Citizen.Trace('['..os.date('%c')..'] ['..level..'] ['..name..'] '..tostring(message)..'\n')
	else
		Citizen.Trace('['..level..'] ['..name..'] '..tostring(message))
	end
end


function Logger:CreateNamedLogger(name)
	local logger = { }
	setmetatable(logger, Logger)
	logger.name = name
	return logger
end


function Logger:Info(message)
	log('Info', self.name, message)
end


function Logger:Error(message)
	log('Error', self.name, message)
end


function Logger:Warning(message)
	log('Warning', self.name, message)
end


function Logger:Debug(message)
	if not Settings.debug then return end
	log('Debug', self.name, message)
end


function Logger:ToString(any)
	return '{ type: '..type(any)..', value: '..tostring(any)..' }'
end


