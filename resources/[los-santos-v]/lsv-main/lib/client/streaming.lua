Streaming = { }
Streaming.__index = Streaming

function Streaming.RequestAnimSetAsync(animSet)
	if not HasAnimSetLoaded(animSet) then
		RequestAnimSet(animSet)
		while not HasAnimSetLoaded(animSet) do
			Citizen.Wait(0)
		end
	end
end

function Streaming.RequestModelAsync(modelHash)
	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)
		while not HasModelLoaded(modelHash) do
			Citizen.Wait(0)
		end
	end
end

function Streaming.RequestEntityCollisionAsync(entity)
	local coords = GetEntityCoords(entity)
	if not HasCollisionLoadedAroundEntity(entity) then
		RequestCollisionAtCoord(coords.x, coords.y, coords.z)
		while not HasCollisionLoadedAroundEntity(entity) do
			Citizen.Wait(0)
		end
	end
end

function Streaming.RequestStreamedTextureDictAsync(textureDict)
	if not HasStreamedTextureDictLoaded(textureDict) then
		RequestStreamedTextureDict(textureDict)
		while not HasStreamedTextureDictLoaded(textureDict) do
			Citizen.Wait(0)
		end
	end
end

function Streaming.RequestNamedPtfxAssetAsync(assetName)
	if not HasNamedPtfxAssetLoaded(assetName) then
		RequestNamedPtfxAsset(assetName)
		while not HasNamedPtfxAssetLoaded(assetName) do
			Citizen.Wait(0)
		end
	end
end
