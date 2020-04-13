# Los Santos V Documentation

## Table of Contents
1. [Project Structure](#project-structure)
2. [Player Initialization](#player-initialization)
3. [Signals](#signals)
4. [Code Style](#code-style)
	1. [Module](#module)
	2. [Class](#class)
	3. [Script](#script)

## Project Structure
* `client/` contains client **scripts**
* `server/` contains server **scripts**
* `lib/` contains shared **modules** and **classes**
* `lib/client/` contains client **modules** and **classes**
* `lib/server/` contains server **modules** and **classes**

## Player Initialization
`lsv:loadPlayer` -> `lsv:playerLoaded` -> `lsv:playerInitialized` -> `lsv:playerConnected` -> `lsv:init`

## Signals
Signals are the same thing as FiveM resource events except their handlers will be executed in synchronous mode.

```lua
TriggerSignal(signalName, signalParam1, signalParam2, ...)
AddSignalHandler(signalName, signalHandlerFunc)
```

## Code Style
### Module
Module is a singleton object with public interface

```lua
-- Module declaration
Module = { }
Module.__index = Module

-- Module constants
Module.GLOBAL_CONST = 1

-- Module variables
Module.Token = nil

-- Logger
local logger = Logger.New('Module')

-- Local variables
local _wasInitialized = false

-- Local functions
local function generateToken()
	return '12345'
end

-- Module functions
function Module.Init()
	if _wasInitialized then
		return
	end

	local token = generateToken()
	Module.Token = token

	_wasInitialized = true
end

-- Threads
-- Event handlers
-- Signal handlers
```

### Class
Class is a [class](https://en.wikipedia.org/wiki/Class_(computer_programming))

```lua
-- Class declaration
Class = { }
Class.__index = Class

-- Logger
-- Local variables
-- Local functions

-- Constructors
function Class.New(func)
	local self = { }
	setmetatable(self, Class)

	self._func = func

	return self
end

-- Class methods
function Class:foo(params)
	self._func(table.unpack({ params }))
end
```

### Script
Script is a file, which defines game event handling (`game mode` itself)

```lua
-- Logger
-- Local variables
local _isPlayerLoaded = false

-- Local functions
local function loadPlayer()
	_isPlayerLoaded = true
end

-- Net event handlers
RegisterNetEvent('resource:playerLoaded')
AddEventHandler('resource:playerLoaded', function()
	if not _isPlayerLoaded then
		TriggerEvent('resource:loadPlayer')
	end
end)

-- Threads

-- Event handlers
AddEventHandler('resource:loadPlayer', function()
	loadPlayer()
end)

-- Signal handlers
```
