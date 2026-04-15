-- features/silent_aim.lua
-- Pro-grade Silent Aim for MM2 (Stability Fix)

local Services = Mega.Services
local States = Mega.States
local lp = Services.Players.LocalPlayer
local Mouse = lp:GetMouse()

local CurrentTarget = nil

-- Separate loop for target selection to prevent recursion in hooks
task.spawn(function()
    while true do
        task.wait(0.1)
        if Mega.Unloaded then break end
        
        if States.Aimbot.SilentAim then
            CurrentTarget = Mega.Features.Aimbot and Mega.Features.Aimbot.GetTarget(States.Aimbot.SilentFOV)
        else
            CurrentTarget = nil
        end
    end
end)

-- Metatable hooking helper
local function Hook()
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    local oldIndex = mt.__index
    setreadonly(mt, false)

    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        
        if not checkcaller() and States.Aimbot.SilentAim and CurrentTarget then
            -- 1. Redirect Raycasts (Used for client-side visuals/checks)
            if method == "FindPartOnRayWithIgnoreList" then
                local hitPart = CurrentTarget.Character and (CurrentTarget.Character:FindFirstChild(States.Aimbot.TargetPart) or CurrentTarget.Character:FindFirstChild("HumanoidRootPart"))
                if hitPart and math.random(1, 100) <= States.Aimbot.HitChance then
                    local args = {...}
                    local origin = args[1].Origin
                    local direction = (hitPart.Position - origin).Unit * 1000
                    args[1] = Ray.new(origin, direction)
                    return oldNamecall(self, unpack(args))
                end
            end

            -- 2. Redirect Remote Call (The actual server-side hit registration)
            -- MM2 uses a remote named 'G' inside ReplicatedStorage for gun shots
            if method == "FireServer" and self.Name == "G" then
                local hitPart = CurrentTarget.Character and (CurrentTarget.Character:FindFirstChild(States.Aimbot.TargetPart) or CurrentTarget.Character:FindFirstChild("HumanoidRootPart"))
                if hitPart and math.random(1, 100) <= States.Aimbot.HitChance then
                    local args = {...}
                    -- Spoof the target position
                    args[1] = hitPart.Position
                    return oldNamecall(self, unpack(args))
                end
            end
        end
        
        return oldNamecall(self, ...)
    end)

    mt.__index = newcclosure(function(self, index)
        -- FAST PATH: Exit immediately if not a target property
        if index ~= "Hit" and index ~= "Target" then
            return oldIndex(self, index)
        end

        -- Verify we are indexing a Mouse object safely
        if not checkcaller() and States.Aimbot.SilentAim and CurrentTarget then
            local isMouse = false
            local s, res = pcall(function() return self:IsA("Mouse") end)
            if s and res then isMouse = true end

            if isMouse then
                local hitPart = CurrentTarget.Character and (CurrentTarget.Character:FindFirstChild(States.Aimbot.TargetPart) or CurrentTarget.Character:FindFirstChild("HumanoidRootPart"))
                if hitPart and math.random(1, 100) <= States.Aimbot.HitChance then
                    if index == "Hit" then
                        return hitPart.CFrame
                    elseif index == "Target" then
                        return hitPart
                    end
                end
            end
        end
        
        return oldIndex(self, index)
    end)

    setreadonly(mt, true)
end

-- Execute hook
local success, err = pcall(Hook)
if not success then
    warn("⚠️ TumbaHub MM2: Silent Aim hook failed:", err)
else
    print("🎯 TumbaHub MM2: Silent Aim stability fix applied.")
end

return {}
