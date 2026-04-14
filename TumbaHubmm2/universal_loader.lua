-- TUMBA HUB MM2: PUBLIC LOADER
-- GitHub: https://github.com/zxcbest957-pixel/TumbaHubMM2

local function LoadTumbaHub()
    local success, content = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/zxcbest957-pixel/TumbaHubMM2/main/TumbaHubmm2/tumbaHub/tumbaHub.lua")
    end)
    
    if success and content then
        local chunk, err = loadstring(content)
        if chunk then
            print("🚀 TumbaHub MM2: Initializing...")
            task.spawn(chunk)
        else
            warn("❌ TumbaHub MM2: Loader syntax error:", err)
        end
    else
        warn("❌ TumbaHub MM2: Failed to fetch loader from GitHub.")
    end
end

LoadTumbaHub()
