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

-- Main Loop
Services.RunService.Heartbeat:Connect(function()
    Combat.RunKillAura()
end)

print("⚔️ TumbaHub MM2: Combat logic loaded.")
return Combat
