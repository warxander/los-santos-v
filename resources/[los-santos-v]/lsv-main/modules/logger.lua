Logger = { }
Logger.__index = Logger


local function log(level, name, message)
	Citizen.Trace('['..os.date('%c')..'] ['..level..'] ['..name..'] '..tostring(message)..'\n')
end


function Logger:CreateNamedLogger(name)
	local logger = { }
	setmetatable(logger, Logger)
	logger.name = name
	return logger
end


function Logger:Info(message)
	log("Info", self.name, message)
end


function Logger:Error(message)
	log("Error", self.name, message)
end


function Logger:Warning(message)
	log("Warning", self.name, message)
end


