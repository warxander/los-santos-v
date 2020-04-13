Prompt = { }
Prompt.__index = Prompt

local _isDisplaying = false

function Prompt.ShowAsync(message, type)
	if _isDisplaying then
		return
	end

	BeginTextCommandBusyString('STRING')
	Gui.AddText(message or 'Transaction pending')
	EndTextCommandBusyString(type or 4)

	_isDisplaying = true
	while _isDisplaying do
		Citizen.Wait(0)
	end
end

function Prompt.Hide()
	_isDisplaying = false
	RemoveLoadingPrompt()
end
