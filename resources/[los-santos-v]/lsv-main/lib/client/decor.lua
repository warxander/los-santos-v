Decor = { }
Decor.__index = Decor

local _decorTypes = {
	['float'] = 1,
	['boolean'] = 2,
	['integer'] = 3,
}

local _decorGetters = {
	function(entity, decorName) return DecorGetFloat(entity, decorName) end,
	function(entity, decorName) return DecorGetBool(entity, decorName) == 1 end,
	function(entity, decorName) return DecorGetInt(entity, decorName) end,
}

local _decorSetters = {
	function(entity, decorName, value) DecorSetFloat(entity, decorName, value) end,
	function(entity, decorName, value) DecorSetBool(entity, decorName, value) end,
	function(entity, decorName, value) DecorSetInt(entity, decorName, value) end,
}

local _vehicleHandlers = { }
local _pedHandlers = { }

local function getDecorTypeFromValue(value)
	local valueType = type(value)

	if valueType == 'number' then
		valueType = math.is_integer(value) and 'integer' or 'float'
	end

	return _decorTypes[valueType]
end

local function registerDecor(decorName, decorType)
	if not DecorIsRegisteredAsType(decorName, decorType) then
		DecorRegister(decorName, decorType)
	end
end

local function setDecorValue(entity, decorName, decorType, value)
	_decorSetters[decorType](entity, decorName, value)
end

function Decor.SetToVehicle(vehicle, decorName, value)
	local decorType = getDecorTypeFromValue(value)
	registerDecor(decorName, decorType)
	setDecorValue(vehicle, decorName, decorType, value)
end

function Decor.SetToPed(ped, decorName, value)
	local decorType = getDecorTypeFromValue(value)
	registerDecor(decorName, decorType)
	setDecorValue(ped, decorName, decorType, value)
end

function Decor.AddVehicleHandler(decorName, expectedValue, handlerFunc)
	local decorType = getDecorTypeFromValue(expectedValue)
	registerDecor(decorName, decorType)

	if not _vehicleHandlers[decorName] then
		_vehicleHandlers[decorName] = { decorType = decorType, expectedValue = expectedValue, handlers = { } }
	end

	table.insert(_vehicleHandlers[decorName].handlers, handlerFunc)
end

function Decor.AddPedHandler(decorName, expectedValue, handlerFunc)
	local decorType = getDecorTypeFromValue(expectedValue)
	registerDecor(decorName, decorType)

	if not _pedHandlers[decorName] then
		_pedHandlers[decorName] = { decorType = decorType, expectedValue = expectedValue, handlers = { } }
	end

	table.insert(_pedHandlers[decorName].handlers, handlerFunc)
end

AddEventHandler('lsv:init', function()
	World.AddVehicleHandler(function(vehicle)
		for decorName, handlerData in pairs(_vehicleHandlers) do
			if DecorExistOn(vehicle, decorName) then
				local value = _decorGetters[handlerData.decorType](vehicle, decorName)
				if value == handlerData.expectedValue then
					for _, handlerFunc in ipairs(handlerData.handlers) do
						handlerFunc(vehicle)
					end
				end
			end
		end
	end)

	World.AddPedHandler(function(ped)
		for decorName, handlerData in pairs(_pedHandlers) do
			if DecorExistOn(ped, decorName) then
				local value = _decorGetters[handlerData.decorType](ped, decorName)
				if value == handlerData.expectedValue then
					for _, handlerFunc in ipairs(handlerData.handlers) do
						handlerFunc(ped)
					end
				end
			end
		end
	end)
end)
