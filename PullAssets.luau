local fs = require("@lune/fs")
local roblox = require("@lune/roblox")

function splitstring(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		table.insert(t, str)
	end
	return t
end

local function GetInstanceFromDatamodel(Datamodel, StringPath)
	local CurrentObjectReference = Datamodel

	for _, ObjectName in pairs(splitstring(StringPath, ".")) do
		if CurrentObjectReference:FindFirstChild(ObjectName) ~= nil then
			CurrentObjectReference = CurrentObjectReference[ObjectName]
		else
			error(ObjectName .. " was not found.")
			return nil
		end
	end

	return CurrentObjectReference
end

local function SaveAssetToFilesystem(Asset, Path)
	for _, Instance in pairs(Asset:GetChildren()) do
		if Instance.ClassName ~= "Folder" then
			local tempSerial = roblox.serializeModel({ Instance })
			fs.writeFile(Path .. "/" .. Instance.Name .. ".rbxm", tempSerial)
		else
			fs.writeDir(Path .. "/" .. Instance.Name)
			SaveAssetToFilesystem(Instance, Path .. "/" .. Instance.Name)
		end
	end
end

local Datamodel = roblox.deserializePlace(fs.readFile("WarpTrains.rbxlx"))
local Pullfrom = GetInstanceFromDatamodel(Datamodel, "ServerStorage.Assets.Maps")
local Saveto = "C:\\Users\\benja\\OneDrive\\Documents\\4 - Personal Projects\\src\\WarpTrains\\assets\\maps"

SaveAssetToFilesystem(Pullfrom, Saveto)
