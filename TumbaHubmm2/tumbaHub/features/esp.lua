-- features/esp.lua
-- Player ESP logic for MM2 Edition

if not Mega.Features then Mega.Features = {} end
Mega.Features.ESP = {}

local Services = Mega.Services
local States = Mega.States
local Settings = Mega.Settings

local espFolder = Instance.new("Folder", Services.CoreGui)
espFolder.Name = "TumbaESP_Container"

if not Mega.Objects.ESP then Mega.Objects.ESP = {} end

local function CreateESP(player)
    if player == Services.Players.LocalPlayer then return end

    local esp = {
        box = Drawing.new("Square"),
        name = Drawing.new("Text"),
        role = Drawing.new("Text"),
        distance = Drawing.new("Text"),
        tracer = Drawing.new("Line")
    }

    esp.box.Thickness = 1.5
    esp.box.Filled = false
    esp.box.Visible = false

    esp.name.Visible = false
    esp.name.Size = 14
    esp.name.Center = true
    esp.name.Outline = true

    esp.role.Visible = false
    esp.role.Size = 12
    esp.role.Center = true
    esp.role.Outline = true

    esp.distance.Visible = false
    esp.distance.Size = 12
    esp.distance.Center = true
    esp.distance.Outline = true

    esp.tracer.Visible = false
    esp.tracer.Thickness = 1

    Mega.Objects.ESP[player] = esp
end

local function RemoveESP(player)
    if Mega.Objects.ESP[player] then
        for _, drawing in pairs(Mega.Objects.ESP[player]) do drawing:Remove() end
        Mega.Objects.ESP[player] = nil
    end
end

local function GetRoleColor(role)
    if role == "Murderer" then return Settings.ESP.MurdererColor or Color3.fromRGB(255, 50, 50)
    elseif role == "Sheriff" then return Settings.ESP.SheriffColor or Color3.fromRGB(50, 100, 255)
    elseif role == "Hero" then return Settings.ESP.HeroColor or Color3.fromRGB(255, 255, 50)
    end
    return Settings.ESP.InnocentColor or Color3.fromRGB(200, 200, 200)
end

local function UpdateESP()
    local camera = Services.Workspace.CurrentCamera
    if not camera then return end
    
    local lp = Services.Players.LocalPlayer
    local localChar = lp and lp.Character
    local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")

    for player, esp in pairs(Mega.Objects.ESP) do
        local isVisible = false
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and localRoot then
            local root = player.Character.HumanoidRootPart
            local head = player.Character:FindFirstChild("Head")
            
            if root and head then
                local screenPos, onScreen = camera:WorldToViewportPoint(root.Position)
                local dist = (localRoot.Position - root.Position).Magnitude
                
                if onScreen and dist <= States.ESP.MaxDistance then
                    local roleData = { Role = "Innocent", IsDead = false }
                    if Mega.Features.MM2 and Mega.Features.MM2.PlayerRoles then
                        roleData = Mega.Features.MM2.PlayerRoles[player.Name] or roleData
                    end
                    
                    local role = roleData.Role
                    local isDead = roleData.IsDead
                    
                    -- Dead players ESP: show if enabled, but dim them
                    if isDead and not States.ESP.ShowDead then
                        isVisible = false
                    else
                        isVisible = true
                        local color = GetRoleColor(role)
                        if isDead then color = color:Lerp(Color3.new(0,0,0), 0.5) end -- Dim for dead
                        
                        local height = 1000 / dist * 3
                        local width = height * 0.6
                        
                        if States.ESP.Boxes then
                            esp.box.Visible = true
                            esp.box.Size = Vector2.new(width, height)
                            esp.box.Position = Vector2.new(screenPos.X - width/2, screenPos.Y - height/2)
                            esp.box.Color = color
                            esp.box.Transparency = isDead and 0.5 or 1
                        else esp.box.Visible = false end
                        
                        if States.ESP.Names then
                            esp.name.Visible = true
                            esp.name.Position = Vector2.new(screenPos.X, screenPos.Y - height/2 - 15)
                            esp.name.Text = player.DisplayName or player.Name
                            esp.name.Color = color
                            esp.name.Text = isDead and "[DEAD] " .. esp.name.Text or esp.name.Text
                        else esp.name.Visible = false end
                        
                        if States.ESP.ShowRoles and role ~= "Innocent" then
                            esp.role.Visible = true
                            esp.role.Position = Vector2.new(screenPos.X, screenPos.Y - height/2 - 28)
                            esp.role.Text = "[" .. role:upper() .. "]"
                            esp.role.Color = color
                        else esp.role.Visible = false end

                        if States.ESP.Distance then
                            esp.distance.Visible = true
                            esp.distance.Position = Vector2.new(screenPos.X, screenPos.Y + height/2 + 5)
                            esp.distance.Text = math.floor(dist) .. " studs"
                            esp.distance.Color = color
                        else esp.distance.Visible = false end

                        if States.ESP.Tracers then
                            esp.tracer.Visible = true
                            esp.tracer.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y)
                            esp.tracer.To = Vector2.new(screenPos.X, screenPos.Y + height/2)
                            esp.tracer.Color = color
                            esp.tracer.Transparency = isDead and 0.3 or 1
                        else esp.tracer.Visible = false end
                    end
                end
            end
        end
        
        if not isVisible then
            for _, d in pairs(esp) do d.Visible = false end
        end
    end
end

function Mega.Features.ESP.SetEnabled(state)
    States.ESP.Enabled = state
    if state then
        if not Mega.Objects.ESPRenderConnection then
            Mega.Objects.ESPRenderConnection = Services.RunService.RenderStepped:Connect(UpdateESP)
        end
    else
        if Mega.Objects.ESPRenderConnection then
            Mega.Objects.ESPRenderConnection:Disconnect()
            Mega.Objects.ESPRenderConnection = nil
        end
        for _, esp in pairs(Mega.Objects.ESP) do
            for _, d in pairs(esp) do d.Visible = false end
        end
    end
end

-- Init
for _, p in pairs(Services.Players:GetPlayers()) do CreateESP(p) end
Services.Players.PlayerAdded:Connect(CreateESP)
Services.Players.PlayerRemoving:Connect(RemoveESP)

print("🖼️ TumbaHub MM2: ESP logic loaded.")
return Mega.Features.ESP
