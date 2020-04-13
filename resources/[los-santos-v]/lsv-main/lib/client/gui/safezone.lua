SafeZone = { }
SafeZone.__index = SafeZone

function SafeZone.Size()
	return GetSafeZoneSize()
end

function SafeZone.Left()
	return (1.0 - SafeZone.Size()) * 0.5
end

function SafeZone.Right()
	return 1.0 - SafeZone.Left()
end

SafeZone.Top = SafeZone.Left
SafeZone.Bottom = SafeZone.Right
