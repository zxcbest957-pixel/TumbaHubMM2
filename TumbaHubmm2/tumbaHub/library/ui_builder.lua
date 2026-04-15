-- library/ui_builder.lua
-- GUI element factory functions (CreateToggle, CreateSlider, etc.)

Mega.UI = {}

local GetText = Mega.GetText
local ShowNotification = Mega.ShowNotification
local TweenService = Mega.Services.TweenService
local UserInputService = Mega.Services.UserInputService

-- Internal helper to handle nested state paths (e.g. "MM2.KillAura.Enabled")
local function getNestedValue(tbl, path)
    local value = tbl
    for part in path:gmatch("[^%.]+") do
        value = value and value[part]
    end
    return value
end

local function setNestedValue(tbl, path, newValue)
    local parts = {}
    for part in path:gmatch("[^%.]+") do table.insert(parts, part) end
    
    local current = tbl
    for i = 1, #parts - 1 do
        local part = parts[i]
        if current[part] == nil then current[part] = {} end
        current = current[part]
    end
    current[parts[#parts]] = newValue
end

function Mega.UI.CreateSection(parent, titleKey)
    local SectionFrame = Instance.new("Frame")
    SectionFrame.Name = titleKey .. "Section"
    SectionFrame.Size = UDim2.new(0.95, 0, 0, 30) -- Height will expand with AutomaticSize
    SectionFrame.BackgroundColor3 = Mega.Settings.Menu.ElementColor
    SectionFrame.BackgroundTransparency = 0.5 
    SectionFrame.BorderSizePixel = 0
    SectionFrame.AutomaticSize = Enum.AutomaticSize.Y

    local SectionCorner = Instance.new("UICorner", SectionFrame)
    SectionCorner.CornerRadius = UDim.new(0, 10)
    
    local SectionStroke = Instance.new("UIStroke", SectionFrame)
    SectionStroke.Color = Mega.Settings.Menu.AccentColor
    SectionStroke.Thickness = 1.2
    SectionStroke.Transparency = 0.7
    
    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Name = "SectionTitle"
    SectionTitle.Size = UDim2.new(1, -20, 0, 30)
    SectionTitle.Position = UDim2.new(0, 15, 0, 0)
    SectionTitle.BackgroundTransparency = 1
    SectionTitle.Text = GetText(titleKey)
    SectionTitle.TextColor3 = Mega.Settings.Menu.TextColor
    SectionTitle.TextSize = 13
    SectionTitle.Font = Enum.Font.GothamBold
    SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    SectionTitle.Parent = SectionFrame
    
    local Container = Instance.new("Frame", SectionFrame)
    Container.Name = "Container"
    Container.Size = UDim2.new(1, 0, 0, 0)
    Container.Position = UDim2.new(0, 0, 0, 30)
    Container.BackgroundTransparency = 1
    Container.AutomaticSize = Enum.AutomaticSize.Y
    
    local List = Instance.new("UIListLayout", Container)
    List.HorizontalAlignment = Enum.HorizontalAlignment.Center
    List.Padding = UDim.new(0, 5)
    
    SectionFrame.Parent = parent
    return Container -- Return the container where elements should go
end

function Mega.UI.CreateToggle(parent, textKey, statePath, callback)
    local translatedText = GetText(textKey)
    local initialState = getNestedValue(Mega.States, statePath) or false
    
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = textKey .. "Toggle"
    ToggleFrame.Size = UDim2.new(1, -20, 0, 32)
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.AutomaticSize = Enum.AutomaticSize.Y
    ToggleFrame.Parent = parent

    local MainContainer = Instance.new("Frame", ToggleFrame)
    MainContainer.Name = "MainContainer"
    MainContainer.Size = UDim2.new(1, 0, 0, 32)
    MainContainer.BackgroundTransparency = 1

    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Name = "Label"
    ToggleLabel.Size = UDim2.new(0.6, 0, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = translatedText
    ToggleLabel.TextColor3 = Mega.Settings.Menu.TextColor
    ToggleLabel.TextSize = 13
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = MainContainer

    local SettingsButton = Instance.new("ImageButton")
    SettingsButton.Name = "SettingsButton"
    SettingsButton.Size = UDim2.new(0, 18, 0, 18)
    SettingsButton.Position = UDim2.new(1, -85, 0.5, -9)
    SettingsButton.BackgroundTransparency = 1
    SettingsButton.Image = Mega.Settings.Menu.SettingsIcon
    SettingsButton.ImageColor3 = Mega.Settings.Menu.TextMutedColor
    SettingsButton.Parent = MainContainer

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "Toggle"
    ToggleButton.Size = UDim2.new(0, 40, 0, 20)
    ToggleButton.Position = UDim2.new(1, -50, 0.5, -10)
    ToggleButton.BackgroundColor3 = initialState and Mega.Settings.Menu.AccentColor or Mega.Settings.Menu.ToggleOffColor
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Text = ""
    ToggleButton.AutoButtonColor = false
    ToggleButton.Parent = MainContainer
    Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(1, 0)

    local ToggleCircle = Instance.new("Frame", ToggleButton)
    ToggleCircle.Name = "Circle"
    ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
    ToggleCircle.Position = initialState and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    ToggleCircle.BackgroundColor3 = Mega.Settings.Menu.TextColor
    Instance.new("UICorner", ToggleCircle).CornerRadius = UDim.new(1, 0)

    local SubSettings = Instance.new("Frame", ToggleFrame)
    SubSettings.Name = "SubSettings"
    SubSettings.Size = UDim2.new(1, -10, 0, 0)
    SubSettings.Position = UDim2.new(0, 10, 0, 32)
    SubSettings.BackgroundTransparency = 1
    SubSettings.ClipsDescendants = true
    SubSettings.Visible = false
    
    local SubList = Instance.new("UIListLayout", SubSettings)
    SubList.Padding = UDim.new(0, 5)
    SubList.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local function updateVisuals(state)
        TweenService:Create(ToggleButton, TweenInfo.new(0.2), { BackgroundColor3 = state and Mega.Settings.Menu.AccentColor or Mega.Settings.Menu.ToggleOffColor }):Play()
        TweenService:Create(ToggleCircle, TweenInfo.new(0.2), { Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8) }):Play()
    end

    ToggleButton.MouseButton1Click:Connect(function()
        local newState = not getNestedValue(Mega.States, statePath)
        setNestedValue(Mega.States, statePath, newState)
        updateVisuals(newState)
        if callback then pcall(callback, newState) end
        ShowNotification(translatedText .. ": " .. (newState and GetText("notify_enabled") or GetText("notify_disabled")), 2)
    end)

    local expanded = false
    SettingsButton.MouseButton1Click:Connect(function()
        expanded = not expanded
        TweenService:Create(SettingsButton, TweenInfo.new(0.3), { Rotation = expanded and 90 or 0, ImageColor3 = expanded and Mega.Settings.Menu.AccentColor or Mega.Settings.Menu.TextMutedColor }):Play()
        
        SubSettings.Visible = true
        local targetSize = expanded and SubList.AbsoluteContentSize.Y or 0
        local tween = TweenService:Create(SubSettings, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(1, -10, 0, targetSize) })
        tween:Play()
        tween.Completed:Connect(function() if not expanded then SubSettings.Visible = false end end)
    end)

    return ToggleFrame, SubSettings
end

function Mega.UI.CreateToggleWithSettings(parent, textKey, statePath, callback, settingsTable)
    local MainToggle, SubSettings = Mega.UI.CreateToggle(parent, textKey, statePath, callback)
    
    -- Populate SubSettings
    for _, element in ipairs(settingsTable) do
        element.Parent = SubSettings
        if element:FindFirstChild("Label") then
            element.Label.Position = UDim2.new(0, 20, 0, 0)
        end
    end
    
    return MainToggle
end

function Mega.UI.CreateSlider(parent, textKey, statePath, min, max, callback)
    local translatedText = GetText(textKey)
    local currentValue = getNestedValue(Mega.States, statePath) or min
    
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, -20, 0, 50)
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.AutomaticSize = Enum.AutomaticSize.Y
    SliderFrame.Parent = parent

    local MainContainer = Instance.new("Frame", SliderFrame)
    MainContainer.Size = UDim2.new(1, 0, 0, 50)
    MainContainer.BackgroundTransparency = 1

    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Size = UDim2.new(0.8, 0, 0, 20)
    SliderLabel.Position = UDim2.new(0, 5, 0, 0)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Text = translatedText .. ": " .. currentValue
    SliderLabel.TextColor3 = Mega.Settings.Menu.TextColor
    SliderLabel.TextSize = 12
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.Parent = MainContainer

    local SettingsButton = Instance.new("ImageButton")
    SettingsButton.Name = "SettingsButton"
    SettingsButton.Size = UDim2.new(0, 16, 0, 16)
    SettingsButton.Position = UDim2.new(1, -20, 0, 2)
    SettingsButton.BackgroundTransparency = 1
    SettingsButton.Image = Mega.Settings.Menu.SettingsIcon
    SettingsButton.ImageColor3 = Mega.Settings.Menu.TextMutedColor
    SettingsButton.Parent = MainContainer

    local SliderTrack = Instance.new("Frame", MainContainer)
    SliderTrack.Size = UDim2.new(1, -10, 0, 4)
    SliderTrack.Position = UDim2.new(0, 5, 0, 30)
    SliderTrack.BackgroundColor3 = Mega.Settings.Menu.ToggleOffColor
    SliderTrack.BorderSizePixel = 0

    local SliderFill = Instance.new("Frame", SliderTrack)
    SliderFill.Size = UDim2.new((currentValue - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Mega.Settings.Menu.AccentColor
    SliderFill.BorderSizePixel = 0

    local SliderButton = Instance.new("TextButton", SliderTrack)
    SliderButton.Size = UDim2.new(0, 14, 0, 14)
    SliderButton.Position = UDim2.new(SliderFill.Size.X.Scale, -7, 0.5, -7)
    SliderButton.BackgroundColor3 = Mega.Settings.Menu.TextColor
    SliderButton.Text = ""
    Instance.new("UICorner", SliderButton).CornerRadius = UDim.new(1, 0)

    local SubSettings = Instance.new("Frame", SliderFrame)
    SubSettings.Name = "SubSettings"
    SubSettings.Size = UDim2.new(1, -10, 0, 0)
    SubSettings.Position = UDim2.new(0, 10, 0, 50)
    SubSettings.BackgroundTransparency = 1
    SubSettings.ClipsDescendants = true
    SubSettings.Visible = false
    local SubList = Instance.new("UIListLayout", SubSettings)
    SubList.Padding = UDim.new(0, 5)

    local dragging = false
    SliderButton.MouseButton1Down:Connect(function() dragging = true end)
    UserInputService.InputEnded:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end 
    end)

    Mega.Services.RunService.RenderStepped:Connect(function()
        if dragging then
            local mousePos = UserInputService:GetMouseLocation()
            local framePos = SliderTrack.AbsolutePosition
            local frameSize = SliderTrack.AbsoluteSize
            local relativeX = math.clamp((mousePos.X - framePos.X) / frameSize.X, 0, 1)
            local newValue = math.floor(min + relativeX * (max - min) + 0.5)

            setNestedValue(Mega.States, statePath, newValue)
            SliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
            SliderButton.Position = UDim2.new(relativeX, -7, 0.5, -7)
            SliderLabel.Text = translatedText .. ": " .. newValue
            if callback then pcall(callback, newValue) end
        end
    end)

    local expanded = false
    SettingsButton.MouseButton1Click:Connect(function()
        expanded = not expanded
        TweenService:Create(SettingsButton, TweenInfo.new(0.3), { Rotation = expanded and 90 or 0, ImageColor3 = expanded and Mega.Settings.Menu.AccentColor or Mega.Settings.Menu.TextMutedColor }):Play()
        SubSettings.Visible = true
        local targetSize = expanded and SubList.AbsoluteContentSize.Y or 0
        local tween = TweenService:Create(SubSettings, TweenInfo.new(0.3), { Size = UDim2.new(1, -10, 0, targetSize) })
        tween:Play()
        tween.Completed:Connect(function() if not expanded then SubSettings.Visible = false end end)
    end)

    return SliderFrame, SubSettings
end

function Mega.UI.CreateButton(parent, textKey, callback)
    local ButtonFrame = Instance.new("Frame")
    ButtonFrame.Size = UDim2.new(0.9, 0, 0, 35)
    ButtonFrame.BackgroundTransparency = 1
    ButtonFrame.AutomaticSize = Enum.AutomaticSize.Y
    ButtonFrame.Parent = parent

    local MainContainer = Instance.new("Frame", ButtonFrame)
    MainContainer.Size = UDim2.new(1, 0, 0, 35)
    MainContainer.BackgroundTransparency = 1

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.85, 0, 1, 0)
    Button.BackgroundColor3 = Mega.Settings.Menu.ElementColor
    Button.Text = GetText(textKey)
    Button.TextColor3 = Mega.Settings.Menu.TextColor
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 13
    Button.AutoButtonColor = true
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 8)
    Button.Parent = MainContainer
    
    local SettingsButton = Instance.new("ImageButton")
    SettingsButton.Name = "SettingsButton"
    SettingsButton.Size = UDim2.new(0, 18, 0, 18)
    SettingsButton.Position = UDim2.new(1, -25, 0.5, -9)
    SettingsButton.BackgroundTransparency = 1
    SettingsButton.Image = Mega.Settings.Menu.SettingsIcon
    SettingsButton.ImageColor3 = Mega.Settings.Menu.TextMutedColor
    SettingsButton.Parent = MainContainer

    local SubSettings = Instance.new("Frame", ButtonFrame)
    SubSettings.Name = "SubSettings"
    SubSettings.Size = UDim2.new(1, -10, 0, 0)
    SubSettings.Position = UDim2.new(0, 10, 0, 35)
    SubSettings.BackgroundTransparency = 1
    SubSettings.ClipsDescendants = true
    SubSettings.Visible = false
    local SubList = Instance.new("UIListLayout", SubSettings)
    SubList.Padding = UDim.new(0, 5)

    Button.MouseButton1Click:Connect(function() if callback then pcall(callback) end end)

    local expanded = false
    SettingsButton.MouseButton1Click:Connect(function()
        expanded = not expanded
        TweenService:Create(SettingsButton, TweenInfo.new(0.3), { Rotation = expanded and 90 or 0, ImageColor3 = expanded and Mega.Settings.Menu.AccentColor or Mega.Settings.Menu.TextMutedColor }):Play()
        SubSettings.Visible = true
        local targetSize = expanded and SubList.AbsoluteContentSize.Y or 0
        local tween = TweenService:Create(SubSettings, TweenInfo.new(0.3), { Size = UDim2.new(1, -10, 0, targetSize) })
        tween:Play()
        tween.Completed:Connect(function() if not expanded then SubSettings.Visible = false end end)
    end)

    return ButtonFrame, SubSettings
end

function Mega.UI.CreateDropdown(parent, textKey, statePath, options, callback, optionsAreKeys)
    local DropdownOuterFrame = Instance.new("Frame")
    DropdownOuterFrame.Size = UDim2.new(0.9, 0, 0, 35)
    DropdownOuterFrame.BackgroundTransparency = 1
    DropdownOuterFrame.AutomaticSize = Enum.AutomaticSize.Y
    DropdownOuterFrame.Parent = parent

    local DropdownFrame = Instance.new("Frame", DropdownOuterFrame)
    DropdownFrame.Size = UDim2.new(1, 0, 0, 35)
    DropdownFrame.BackgroundTransparency = 1
    
    local Label = Instance.new("TextLabel", DropdownFrame)
    Label.Size = UDim2.new(0.45, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = GetText(textKey)
    Label.TextColor3 = Mega.Settings.Menu.TextColor
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Font = Enum.Font.Gotham
    
    local SettingsButton = Instance.new("ImageButton")
    SettingsButton.Name = "SettingsButton"
    SettingsButton.Size = UDim2.new(0, 16, 0, 16)
    SettingsButton.Position = UDim2.new(0.5, -10, 0.5, -8)
    SettingsButton.BackgroundTransparency = 1
    SettingsButton.Image = Mega.Settings.Menu.SettingsIcon
    SettingsButton.ImageColor3 = Mega.Settings.Menu.TextMutedColor
    SettingsButton.Parent = DropdownFrame

    local Button = Instance.new("TextButton", DropdownFrame)
    Button.Size = UDim2.new(0.4, 0, 0.8, 0)
    Button.Position = UDim2.new(0.6, -10, 0.1, 0)
    Button.BackgroundColor3 = Mega.Settings.Menu.SidebarColor
    Button.TextColor3 = Mega.Settings.Menu.TextColor
    local currentVal = getNestedValue(Mega.States, statePath)
    Button.Text = optionsAreKeys and GetText(currentVal) or tostring(currentVal or "Select")
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)
    
    local SubSettings = Instance.new("Frame", DropdownOuterFrame)
    SubSettings.Name = "SubSettings"
    SubSettings.Size = UDim2.new(1, -10, 0, 0)
    SubSettings.Position = UDim2.new(0, 10, 0, 35)
    SubSettings.BackgroundTransparency = 1
    SubSettings.ClipsDescendants = true
    SubSettings.Visible = false
    local SubList = Instance.new("UIListLayout", SubSettings)
    SubList.Padding = UDim.new(0, 5)

    Button.MouseButton1Click:Connect(function()
        if callback then pcall(callback, options[1]) end 
    end)
    
    local expanded = false
    SettingsButton.MouseButton1Click:Connect(function()
        expanded = not expanded
        TweenService:Create(SettingsButton, TweenInfo.new(0.3), { Rotation = expanded and 90 or 0, ImageColor3 = expanded and Mega.Settings.Menu.AccentColor or Mega.Settings.Menu.TextMutedColor }):Play()
        SubSettings.Visible = true
        local targetSize = expanded and SubList.AbsoluteContentSize.Y or 0
        local tween = TweenService:Create(SubSettings, TweenInfo.new(0.3), { Size = UDim2.new(1, -10, 0, targetSize) })
        tween:Play()
        tween.Completed:Connect(function() if not expanded then SubSettings.Visible = false end end)
    end)

    return DropdownOuterFrame, SubSettings
end

function Mega.UI.CreateKeybindButton(parent, textKey, statePath)
    local outerFrame = Instance.new("Frame")
    outerFrame.Size = UDim2.new(0.9, 0, 0, 35)
    outerFrame.BackgroundTransparency = 1
    outerFrame.AutomaticSize = Enum.AutomaticSize.Y
    outerFrame.Parent = parent

    local Frame = Instance.new("Frame", outerFrame)
    Frame.Size = UDim2.new(1, 0, 0, 35)
    Frame.BackgroundTransparency = 1
    
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(0.5, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = GetText(textKey)
    Label.TextColor3 = Mega.Settings.Menu.TextColor
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Font = Enum.Font.Gotham
    
    local SettingsButton = Instance.new("ImageButton")
    SettingsButton.Name = "SettingsButton"
    SettingsButton.Size = UDim2.new(0, 16, 0, 16)
    SettingsButton.Position = UDim2.new(0.6, -20, 0.5, -8)
    SettingsButton.BackgroundTransparency = 1
    SettingsButton.Image = Mega.Settings.Menu.SettingsIcon
    SettingsButton.ImageColor3 = Mega.Settings.Menu.TextMutedColor
    SettingsButton.Parent = Frame

    local Button = Instance.new("TextButton", Frame)
    Button.Size = UDim2.new(0.3, 0, 0.8, 0)
    Button.Position = UDim2.new(0.7, -10, 0.1, 0)
    Button.BackgroundColor3 = Mega.Settings.Menu.SidebarColor
    Button.TextColor3 = Mega.Settings.Menu.AccentColor
    Button.Text = getNestedValue(Mega.States, statePath) or "None"
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)
    
    local SubSettings = Instance.new("Frame", outerFrame)
    SubSettings.Name = "SubSettings"
    SubSettings.Size = UDim2.new(1, -10, 0, 0)
    SubSettings.Position = UDim2.new(0, 10, 0, 35)
    SubSettings.BackgroundTransparency = 1
    SubSettings.ClipsDescendants = true
    SubSettings.Visible = false
    local SubList = Instance.new("UIListLayout", SubSettings)
    SubList.Padding = UDim.new(0, 5)

    local listening = false
    Button.MouseButton1Click:Connect(function()
        listening = true
        Button.Text = "..."
    end)
    
    UserInputService.InputBegan:Connect(function(input)
        if listening and input.UserInputType == Enum.UserInputType.Keyboard then
            listening = false
            local key = input.KeyCode.Name
            setNestedValue(Mega.States, statePath, key)
            Button.Text = key
        end
    end)

    local expanded = false
    SettingsButton.MouseButton1Click:Connect(function()
        expanded = not expanded
        TweenService:Create(SettingsButton, TweenInfo.new(0.3), { Rotation = expanded and 90 or 0, ImageColor3 = expanded and Mega.Settings.Menu.AccentColor or Mega.Settings.Menu.TextMutedColor }):Play()
        SubSettings.Visible = true
        local targetSize = expanded and SubList.AbsoluteContentSize.Y or 0
        local tween = TweenService:Create(SubSettings, TweenInfo.new(0.3), { Size = UDim2.new(1, -10, 0, targetSize) })
        tween:Play()
        tween.Completed:Connect(function() if not expanded then SubSettings.Visible = false end end)
    end)
    
    return outerFrame, SubSettings
end

function Mega.UI.CreateLabel(parent, textKey)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 25)
    Label.BackgroundTransparency = 1
    Label.Text = GetText(textKey)
    Label.TextColor3 = Mega.Settings.Menu.TextMutedColor
    Label.TextSize = 11
    Label.Font = Enum.Font.Gotham
    Label.Parent = parent
    return Label
end
