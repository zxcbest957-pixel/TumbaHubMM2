-- features/combat.lua
-- Combat features for MM2 Edition (KillAura, etc.)

if not Mega.Features then Mega.Features = {} end
local Combat = {}
Mega.Features.Combat = Combat

local Services = Mega.Services
local States = Mega.States

-- Kill Aura logic (Refined)
function Combat.RunKillAura()
    local kStates = States.MM2.KillAura
    if not kStates.Enabled then return end
    
    local lp = Services.Players.LocalPlayer
    local char = lp.Character
    if not char then return end
    
    -- In MM2, KillAura is only useful for the Murderer
    local isMurderer = false
    if Mega.Features.MM2 and Mega.Features.MM2.PlayerRoles then
        isMurderer = (Mega.Features.MM2.PlayerRoles[lp.Name] == "Murderer")
    end
    
    if not isMurderer then return end
    
    local knife = char:FindFirstChild("Knife")
    if not knife then 
        knife = lp.Backpack:FindFirstChild("Knife")
        if knife then knife.Parent = char end
    end
    if not knife then return end

    local range = kStates.Range or 15
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for _, player in pairs(Services.Players:GetPlayers()) do
        if player ~= lp and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local targetHrp = player.Character.HumanoidRootPart
            local dist = (hrp.Position - targetHrp.Position).Magnitude
            
            if dist <= range then
                local remote = Mega.GetRemote("MurderDaggerKill")
                if remote then
                    -- Simple Kill Aura: Trigger remote
                    remote:FireServer(player.Character)
                    -- Visual feedback (optional)
                    if kStates.TargetESP then
                        -- Highlighting logic could go here
                    end
                end
            end
        end
    end
end

-- Auto Shoot (Sheriff)
function Combat.RunAutoShoot()
    if not States.MM2.AutoShootMurderer then return end
    
    local lp = Services.Players.LocalPlayer
    local isSheriff = false
    if Mega.Features.MM2 and Mega.Features.MM2.PlayerRoles then
        local role = Mega.Features.MM2.PlayerRoles[lp.Name]
        isSheriff = (role == "Sheriff" or role == "Hero")
    end
    if not isSheriff then return end

    local gun = lp.Character and lp.Character:FindFirstChild("Gun")
    if not gun then 
        gun = lp.Backpack:FindFirstChild("Gun")
        if gun then gun.Parent = lp.Character end
    end
    if not gun then return end

    -- Find Murderer
    local murderer = nil
    for name, role in pairs(Mega.Features.MM2.PlayerRoles) do
        if role == "Murderer" then
            murderer = Services.Players:FindFirstChild(name)
            break
        end
    end

    if murderer and murderer.Character and murderer.Character:FindFirstChild("HumanoidRootPart") then
        local targetPos = murderer.Character.HumanoidRootPart.Position
        local hrp = lp.Character.HumanoidRootPart
        local cam = Services.Workspace.CurrentCamera
        
        -- Check if in FOV or Silent Aim
        if (hrp.Position - targetPos).Magnitude < 100 then
            -- Triggering ShootGun remote
            -- Note: MM2 gun shooting is often handled by a remote inside the Gun tool or a global one
            local shootRemote = Mega.GetRemote("ShootGun") -- Check mapping
            if shootRemote then
                shootRemote:InvokeServer(targetPos)
            end
        end
    end
end

-- Main Loop
task.spawn(function()
    while true do
        task.wait(0.1) -- Faster loop for combat
        if Mega.Unloaded then break end
        
        Combat.RunKillAura()
        -- Combat.RunAutoShoot() -- Disabled for now until remote is confirmed
    end
end)

print("⚔️ TumbaHub MM2: Combat logic loaded.")
return Combat
