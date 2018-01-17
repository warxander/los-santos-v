Logger = { }
Logger.__index = Logger


local function printLogMessage(level, name, message)
	Citizen.Trace('['..os.date('%c')..'] ['..level..'] ['..name..'] '..tostring(message)..'\n')
end


function Logger:CreateNamedLogger(name)
	local logger = { }
	setmetatable(logger, Logger)
	logger.name = name
	return logger
end


function Logger:Info(message)
	printLogMessage("Info", self.name, message)
end


function Logger:Error(message)
	printLogMessage("Error", self.name, message)
end


function Logger:Warning(message)
	printLogMessage("Warning", self.name, message)
end


