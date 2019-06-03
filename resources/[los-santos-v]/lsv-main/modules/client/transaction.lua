RemoteTransaction = { }
RemoteTransaction.__index = RemoteTransaction


function RemoteTransaction.New()
	local self = { }
	setmetatable(self, RemoteTransaction)

	self._inProgress = false

	return self
end


function RemoteTransaction:WaitForEnding()
	if self._inProgress then return end
	self._inProgress = true
	BeginTextCommandBusyString('STRING')
	AddTextComponentSubstringPlayerName('Transaction pending')
	EndTextCommandBusyString(4)
	while self._inProgress do Citizen.Wait(0) end
end


function RemoteTransaction:InProgress()
	return self._inProgress
end


function RemoteTransaction:Finish()
	self._inProgress = false
	RemoveLoadingPrompt()
end