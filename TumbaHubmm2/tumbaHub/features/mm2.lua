-- features/mm2.lua
-- Core logic for Murder Mystery 2 features

if not Mega.Features then Mega.Features = {} end
local MM2 = {}
Mega.Features.MM2 = MM2

local Services = Mega.Services
local States = Mega.States
local GetRemote = Mega.GetRemote

MM2.PlayerRoles = {} -- Cache for player roles

-- Function to update roles from game data
function MM2.UpdateRoles()
    local module = Services.ReplicatedStorage:FindFirstChild("Modules") 
        and Services.ReplicatedStorage.Modules:FindFirstChild("CurrentRoundClient")
    
    local gameData = nil
    if module then
        -- We try to get the data from the module's environment or by calling its internal functions
        -- MM2 usually stores this in a table named 'PlayerData' or similar.
        -- We'll use a safer approach: checking backpack but with a helper for Hero detection.
        pcall(function()
            -- Some executors support getting the return value of a module via require
            local data = require(module)
            if type(data) == "table" and data.PlayerData then
                gameData = data.PlayerData
            end
        end)
    end
    
    for _, player in pairs(Services.Players:GetPlayers()) do
        local role = "Innocent"
        local isDead = false
        
        if gameData and gameData[player.Name] then
            role = gameData[player.Name].Role or "Innocent"
            isDead = gameData[player.Name].Dead
        else
            -- Fallback: Scanning weapons
            local char = player.Character
            local backpack = player:FindFirstChild("Backpack")
            
            if (char and char:FindFirstChild("Knife")) or (backpack and backpack:FindFirstChild("Knife")) then
                role = "Murderer"
            elseif (char and char:FindFirstChild("Gun")) or (backpack and backpack:FindFirstChild("Gun")) then
                role = "Sheriff"
            end

            -- Hero logic: If they have a gun but aren't the original sheriff
            if role == "Sheriff" then
                -- In MM2, the Sheriff always has a 'Gun' at start. 
                -- If someone else gets it later, they are the Hero.
                -- We'll refine this if we find a better way to track the original sheriff.
            end
        end
        
        MM2.PlayerRoles[player.Name] = {
            Role = role,
            IsDead = isDead
        }
    end
end

function MM2.GetSheriffName()
    -- Logic to find the real sheriff if possible
    return "" 
end

-- Kill Aura logic
function MM2.RunKillAura()
    if not States.MM2.KillAura.Enabled then return end
    if MM2.PlayerRoles[Services.LocalPlayer.Name] ~= "Murderer" then return end
    
    local knife = Services.LocalPlayer.Character and Services.LocalPlayer.Character:FindFirstChild("Knife")
    if not knife then 
        knife = Services.LocalPlayer.Backpack:FindFirstChild("Knife")
        if knife then knife.Parent = Services.LocalPlayer.Character end
    end
    
    if not knife then return end
    
    local range = States.MM2.KillAura.Range or 15
    for _, player in pairs(Services.Players:GetPlayers()) do
        if player ~= Services.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (Services.LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if dist <= range then
                local remote = GetRemote("MurderDaggerKill")
                if remote then
                    remote:FireServer(player.Character)
                end
            end
        end
    end
end

-- Auto Grab Gun logic
function MM2.RunAutoGrabGun()
    if not States.MM2.AutoGrabGun then return end
    
    local gunDrop = Services.Workspace:FindFirstChild("GunDrop")
    if gunDrop and gunDrop:IsA("BasePart") then
        local hrp = Services.LocalPlayer.Character and Services.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            -- Safe approach: move towards it, or teleport if possible
            -- For now, we'll just show a notification or do a small leap
            if (hrp.Position - gunDrop.Position).Magnitude < 10 then
                firetouchinterest(hrp, gunDrop, 0)
                firetouchinterest(hrp, gunDrop, 1)
            end
        end
    end
end

-- Main Loop
task.spawn(function()
    while true do
        task.wait(0.5)
        if Mega.Unloaded then break end
        
        MM2.UpdateRoles()
        MM2.RunKillAura()
        MM2.RunAutoGrabGun()
    end
end)

print("🎯 TumbaHub MM2: Features logic loaded.")
return MM2
