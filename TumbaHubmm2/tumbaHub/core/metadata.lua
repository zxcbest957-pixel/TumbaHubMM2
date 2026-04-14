-- core/metadata.lua
-- Dynamic Remote Mapping and Game Metadata System for MM2

if not Mega.Metadata then Mega.Metadata = {} end

local HttpService = game:GetService("HttpService")
local MetadataManager = {}
Mega.MetadataManager = MetadataManager

local jsonContent = nil

-- Function to load metadata
function MetadataManager.Init()
    local localPath = "packages.json"
    
    -- In MM2 edition, we favor the local packages.json provided in the workspace
    if isfile and readfile then
        if isfile(localPath) then
            print("📦 TumbaHub MM2: Loading metadata from local packages.json...")
            local success, data = pcall(function() return readfile(localPath) end)
            if success then jsonContent = data end
        end
    end
    
    if jsonContent then
        local success, decoded = pcall(function() return HttpService:JSONDecode(jsonContent) end)
        if success then
            Mega.Metadata = decoded
            print("✅ TumbaHub MM2: Metadata loaded successfully!")
        else
            warn("❌ TumbaHub MM2: Failed to parse packages.json")
        end
    end
end

-- Function to get a remote by internal name
function Mega.GetRemote(name)
    local actualName = name
    
    -- Check mapping in metadata
    if Mega.Metadata and Mega.Metadata.remotes then
        actualName = Mega.Metadata.remotes[name] or name
    end
    
    -- MM2 remotes are usually in ReplicatedStorage or children of it
    -- We'll do a recursive search since MM2 structure can vary between services
    local remote = game:GetService("ReplicatedStorage"):FindFirstChild(actualName, true)
    
    if remote then
        return remote
    end
    
    -- Second chance: Check for game.ReplicatedStorage:FindFirstChild("Remotes") or similar
    local remotesFolder = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
    if remotesFolder then
        remote = remotesFolder:FindFirstChild(actualName)
    end

    return remote
end

-- Function to get structured data from the dump (e.g., role information)
function Mega.GetDumpData(key)
    if not Mega.Metadata then return nil end
    local data = Mega.Metadata[key]
    if type(data) == "string" then
        local s, d = pcall(HttpService.JSONDecode, HttpService, data)
        return s and d or nil
    end
    return data
end

-- Initialize immediately
MetadataManager.Init()

return MetadataManager
