HelpQueue = { }
HelpQueue.__index = HelpQueue


local helpHolders = { }

local function makeHelpHolder(text)
	local self = { }

	self._text = text
	self._cancelled = false

	self.Cancel = function() self._cancelled = true end

	return self
end


function HelpQueue.PushBack(text)
	local holder = makeHelpHolder(text)

	table.insert(helpHolders, holder)

	return holder
end


function HelpQueue.PushFront(text)
	local holder = makeHelpHolder(text)

	table.insert(helpHolders, 1, holder)

	return holder
end


AddEventHandler('lsv:init', function()
	while true do
		Citizen.Wait(5000)

		if not IsHudComponentActive(10) and not WarMenu.IsAnyMenuOpened() then
			if #helpHolders ~= 0 then
				local holder = helpHolders[1]
				table.remove(helpHolders, 1)
				if not holder._cancelled then Gui.DisplayHelpText(holder._text) end
			end
		end
	end
end)