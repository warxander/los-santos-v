SafeZone = { }
SafeZone.__index = SafeZone

SafeZone.Size = function() return GetSafeZoneSize() end

SafeZone.Left = function() return (1.0 - SafeZone.Size()) * 0.5 end
SafeZone.Right = function() return 1.0 - SafeZone.Left() end

SafeZone.Top = SafeZone.Left
SafeZone.Bottom = SafeZone.Right