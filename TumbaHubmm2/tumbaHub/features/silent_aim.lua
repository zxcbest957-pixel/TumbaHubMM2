-- features/silent_aim.lua
-- Pro-grade Silent Aim for MM2

local Services = Mega.Services
local States = Mega.States
local lp = Services.Players.LocalPlayer
local Mouse = lp:GetMouse()

-- Metatable hooking helper
local function Hook()
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    local oldIndex = mt.__index
    setreadonly(mt, false)

    mt.__namecall = newcclosure(function(self, ...)
        local args = {...}
        local method = getnamecallmethod()
        
        if not checkcaller() and States.Aimbot.SilentAim then
            -- Only redirect if we are holding the Gun
            local gun = lp.Character and lp.Character:FindFirstChild("Gun")
            if gun then
                if method == "FindPartOnRayWithIgnoreList" then
                    local target = Mega.Features.Aimbot and Mega.Features.Aimbot.GetTarget(States.Aimbot.SilentFOV)
                    if target and target.Character then
                        local hitPart = target.Character:FindFirstChild(States.Aimbot.TargetPart) or target.Character:FindFirstChild("HumanoidRootPart")
                        if hitPart then
                            -- Random chance check
                            if math.random(1, 100) <= States.Aimbot.HitChance then
                                local origin = args[1].Origin
                                local direction = (hitPart.Position - origin).Unit * 1000
                                args[1] = Ray.new(origin, direction)
                                return oldNamecall(self, unpack(args))
                            end
                        end
                    end
                end
            end
        end
        
        return oldNamecall(self, ...)
    end)

    mt.__index = newcclosure(function(self, index)
        if not checkcaller() and States.Aimbot.SilentAim then
            local gun = lp.Character and lp.Character:FindFirstChild("Gun")
            if gun then
                if self == Mouse and (index == "Hit" or index == "Target") then
                    local target = Mega.Features.Aimbot and Mega.Features.Aimbot.GetTarget(States.Aimbot.SilentFOV)
                    if target and target.Character then
                        local hitPart = target.Character:FindFirstChild(States.Aimbot.TargetPart) or target.Character:FindFirstChild("HumanoidRootPart")
                        if hitPart then
                             -- Random chance check
                            if math.random(1, 100) <= States.Aimbot.HitChance then
                                if index == "Hit" then
                                    return hitPart.CFrame
                                elseif index == "Target" then
                                    return hitPart
                                end
                            end
                        end
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
    warn("⚠️ TumbaHub MM2: Silent Aim hook failed (Executor may not support metatable hooking):", err)
else
    print("🎯 TumbaHub MM2: Silent Aim module loaded.")
end

return {}
