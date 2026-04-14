-- TUMBA HUB MM2 EDITION
-- Main entry point & module loader for Murder Mystery 2
-- Adapted for TumbaHubmm2 structure

if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Global table initialization
Mega = {
    Game = "MM2",
    Objects = {
        Connections = {},
        GUI = nil,
        PlayerListItems = {},
        Toggles = {},
        TabFrames = {}
    },
    Features = {},
    LoadedModules = {}
}

-- Local baseURL for MM2 edition (if needed for remote assets)
local baseURL = "tumbaHub/" 

function Mega.GetImageFromURL(url, fileName)
    local folderPath = "tumbaHub/icons_v2/"
    local fullPath = folderPath .. fileName
    
    if isfile and writefile and makefolder and getcustomasset then
        if not isfolder("tumbaHub") then makefolder("tumbaHub") end
        if not isfolder(folderPath) then makefolder(folderPath) end

        if not isfile(fullPath) then
            if url and url ~= "" then
                local success, data = pcall(function() return game:HttpGet(url) end)
                if success and data and #data > 0 then
                    writefile(fullPath, data)
                end
            end
        end

        if isfile(fullPath) then
            local success, asset = pcall(function() return getcustomasset(fullPath) end)
            if success and asset then return asset end
        end
    end
    return "rbxassetid://13388222306"
end

-- Module Loader
function Mega.LoadModule(path)
    if Mega.LoadedModules[path] then return end

    local content = nil
    local success = false
    
    if isfile and readfile then
        local localPath = "tumbaHub/" .. path
        if isfile(localPath) then
            success, content = pcall(function() return readfile(localPath) end)
        end
    end

    if success and content then
        local chunk, err = loadstring("return function(Mega, game, script) " .. content .. " end")
        if chunk then
            local moduleFunc = chunk()
            local success, err = pcall(moduleFunc, Mega, game, script)
            if success then
                Mega.LoadedModules[path] = true
            else
                warn("Execution error in module:", path, "|", err)
            end
        else
            warn("Syntax error in module:", path, "|", err)
        end
    else
        warn("Failed to load module locally:", path)
    end
end

-- INITIALIZATION SEQUENCE
Mega.LoadModule("core/services.lua")
Mega.LoadModule("gui/loader_screen.lua")

local loaderUI = nil
if Mega.Loader then
    loaderUI = Mega.Loader.Create()
end

local function InitPhase(id, list)
    if loaderUI and loaderUI.SetStage then loaderUI.SetStage(id) end
    local count = #list
    for i, path in ipairs(list) do
        if loaderUI and loaderUI.Update then
            local overallPercent = (i / count) * 100
            loaderUI.Update(overallPercent, "Loading: " .. path)
        end
        Mega.LoadModule(path)
        task.wait(0.02)
    end
end

-- PHASE 1: DATA HANDSHAKE
InitPhase("network", {
    "core/metadata.lua"
})

-- PHASE 2: CORE SYSTEMS
InitPhase("core", {
    "core/settings.lua",
    "core/localization.lua",
    "core/config.lua"
})

-- PHASE 3: MM2 FEATURES
InitPhase("features", {
    "library/notifications.lua",
    "library/ui_builder.lua",
    "features/mm2.lua",
    "features/combat.lua",
    "features/player.lua",
    "features/esp.lua"
})

-- PHASE 4: UI
InitPhase("ui", {
    "gui/main_window.lua"
})

if loaderUI then
    loaderUI.Update(100, "READY")
    task.wait(0.5)
    loaderUI.Destroy()
end

print("🔥 TUMBA HUB: MM2 EDITION LOADED!")
