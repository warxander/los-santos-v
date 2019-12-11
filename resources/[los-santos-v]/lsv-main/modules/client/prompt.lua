Prompt = { }
Prompt.__index = Prompt


local isDisplaying = false


function Prompt.ShowAsync(message, type)
	if isDisplaying then return end

	BeginTextCommandBusyString('STRING')
	Gui.AddText(message or 'Transaction pending')
	EndTextCommandBusyString(type or 4)

	isDisplaying = true
	while isDisplaying do Citizen.Wait(0) end
end


function Prompt.Hide()
	isDisplaying = false
	RemoveLoadingPrompt()
end
