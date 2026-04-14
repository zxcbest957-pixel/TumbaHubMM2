-- features/player.lua
-- Player movement features for MM2 Edition

if not Mega.Features then Mega.Features = {} end
local Player = {}
Mega.Features.Player = Player

local Services = Mega.Services
local States = Mega.States

-- Speed logic
local function onRenderStep()
    local char = Services.LocalPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    if States.Player.Speed then
        humanoid.WalkSpeed = States.Player.SpeedValue
    else
        -- Only reset if it was previously set by us
        if humanoid.WalkSpeed == States.Player.SpeedValue then
            humanoid.WalkSpeed = 16
        end
    end
end

-- Fly logic
local flyPart = nil
local function updateFly()
    if not States.Player.Fly then
        if flyPart then flyPart:Destroy(); flyPart = nil end
        return
    end
    
    local char = Services.LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if not flyPart then
        flyPart = Instance.new("BodyVelocity")
        flyPart.Velocity = Vector3.new(0,0,0)
        flyPart.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        flyPart.Parent = hrp
    end
    
    local cam = Services.Workspace.CurrentCamera
    local look = cam.CFrame.LookVector
    local right = cam.CFrame.RightVector
    local move = Vector3.new(0,0,0)
    
    if Services.UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + look end
    if Services.UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - look end
    if Services.UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + right end
    if Services.UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - right end
    if Services.UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
    if Services.UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0,1,0) end
    
    flyPart.Velocity = move.Unit * (States.Player.FlySpeed or 50)
    if move.Magnitude == 0 then flyPart.Velocity = Vector3.new(0,0,0) end
end

-- Infinite Jump
Services.UserInputService.JumpRequest:Connect(function()
    if States.Player.InfiniteJump then
        local char = Services.LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- NoClip
Services.RunService.Stepped:Connect(function()
    if States.Player.NoClip then
        local char = Services.LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

Services.RunService.RenderStepped:Connect(function()
    onRenderStep()
    updateFly()
end)

print("🏃 TumbaHub MM2: Player features loaded.")
return Player
