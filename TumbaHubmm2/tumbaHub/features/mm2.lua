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
    local currentRoundClient = Services.ReplicatedStorage:FindFirstChild("Modules") 
        and Services.ReplicatedStorage.Modules:FindFirstChild("CurrentRoundClient")
    
    if not currentRoundClient then return end
    
    -- In TumbaHub, we use the Metadata helper to get decoded dump data if possible
    -- However, real-time data is better. MM2 stores roles in a table inside this module.
    -- Since we can't easily read constants from a running ModuleScript (unless using a specific exploit function),
    -- we'll rely on our metadata dump for the structure and look for it in the environment.
    
    -- NOTE: Most MM2 scripts hook the 'SetRole' remotes or check 'Backpack' for Knife/Gun.
    -- We will do both for maximum reliability.
    
    for _, player in pairs(Services.Players:GetPlayers()) do
        local role = "Innocent"
        
        -- Check items
        if player:FindFirstChild("Backpack") then
            if player.Backpack:FindFirstChild("Knife") or (player.Character and player.Character:FindFirstChild("Knife")) then
                role = "Murderer"
            elseif player.Backpack:FindFirstChild("Gun") or (player.Character and player.Character:FindFirstChild("Gun")) then
                role = "Sheriff"
            end
        end
        
        -- Check Hero (Innocent with gun)
        if role == "Sheriff" and player.Name ~= MM2.GetSheriffName() then
            role = "Hero"
        end
        
        MM2.PlayerRoles[player.Name] = role
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
