-- features/aimbot.lua
-- Pro-grade Aimbot for MM2 (Camera Lock)

if not Mega.Features then Mega.Features = {} end
local Aimbot = {}
Mega.Features.Aimbot = Aimbot

local Services = Mega.Services
local States = Mega.States
local lp = Services.Players.LocalPlayer
local Camera = Services.Workspace.CurrentCamera
local Mouse = lp:GetMouse()

-- FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.NumSides = 64
FOVCircle.Color = Color3.new(1, 1, 1)
FOVCircle.Filled = false
FOVCircle.Visible = false

local function UpdateFOV()
    if not States.Aimbot.Enabled or not States.Aimbot.ShowFOV then
        FOVCircle.Visible = false
        return
    end

    FOVCircle.Visible = true
    FOVCircle.Radius = States.Aimbot.FOV
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end

local function IsVisible(targetChar)
    if not States.Aimbot.VisibilityCheck then return true end
    
    local hrp = targetChar:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local ray = Ray.new(Camera.CFrame.Position, (hrp.Position - Camera.CFrame.Position).Unit * (hrp.Position - Camera.CFrame.Position).Magnitude)
    local hit = Services.Workspace:FindPartOnRayWithIgnoreList(ray, {lp.Character, targetChar})
    
    return hit == nil
end

local function GetTarget()
    local bestTarget = nil
    local maxDist = math.huge
    local myRole = Mega.Features.MM2 and Mega.Features.MM2.PlayerRoles[lp.Name] or "Innocent"

    for _, player in pairs(Services.Players:GetPlayers()) do
        if player ~= lp and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local role = Mega.Features.MM2 and Mega.Features.MM2.PlayerRoles[player.Name] or "Unknown"
            local isDead = Mega.Features.MM2 and Mega.Features.MM2.DeadPlayers[player.Name]
            
            -- Filter logic
            local isTarget = false
            if (myRole == "Sheriff" or myRole == "Hero") and role == "Murderer" then
                isTarget = true
            elseif myRole == "Murderer" and (role == "Sheriff" or role == "Hero") then
                isTarget = true
            end

            if isTarget and not isDead then
                local head = player.Character:FindFirstChild(States.Aimbot.TargetPart) or player.Character:FindFirstChild("HumanoidRootPart")
                if head then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local mousePos = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        
                        if dist <= States.Aimbot.FOV and dist < maxDist then
                            if IsVisible(player.Character) then
                                maxDist = dist
                                bestTarget = player
                            end
                        end
                    end
                end
            end
        end
    end
    return bestTarget
end

-- Main Loop
Services.RunService.RenderStepped:Connect(function()
    UpdateFOV()
    
    if not States.Aimbot.Enabled then return end
    
    local target = GetTarget()
    if target and target.Character then
        local targetPart = target.Character:FindFirstChild(States.Aimbot.TargetPart) or target.Character:FindFirstChild("HumanoidRootPart")
        if targetPart then
            local goal = CFrame.new(Camera.CFrame.Position, targetPart.Position)
            -- Apply smoothing
            local smooth = math.clamp(States.Aimbot.Smoothness, 1, 20)
            Camera.CFrame = Camera.CFrame:Lerp(goal, 1 / smooth)
        end
    end
end)

print("🎯 TumbaHub MM2: Aimbot module loaded.")
return Aimbot
