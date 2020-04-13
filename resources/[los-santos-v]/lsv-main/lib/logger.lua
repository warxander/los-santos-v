Logger = { }
Logger.__index = Logger

local _logColors = {
	['Info'] = '7',
	['Error'] = '1',
	['Warning'] = '3',
}

local log = nil
if IsDuplicityVersion() then
	log = function(level, name, message)
		Citizen.Trace('^4['..os.date('%c')..'] ^2['..name..'] ^'.._logColors[level]..'['..level..'] '..tostring(message)..'\n')
	end
else
	log = function(level, name, message)
		Citizen.Trace('['..name..'] ['..level..'] '..tostring(message)..'\n')
	end
end

function Logger.New(name)
	local self = { }
	setmetatable(self, Logger)

	self._name = name

	return self
end

function Logger:info(message)
	log('Info', self._name, message)
end

function Logger:err(message)
	log('Error', self._name, message)
end

function Logger:warn(message)
	log('Warning', self._name, message)
end
