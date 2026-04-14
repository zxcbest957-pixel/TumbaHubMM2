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
    ToggleFrame.Parent = parent

    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Name = "Label"
    ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = translatedText
    ToggleLabel.TextColor3 = Mega.Settings.Menu.TextColor
    ToggleLabel.TextSize = 13
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = ToggleFrame

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "Toggle"
    ToggleButton.Size = UDim2.new(0, 40, 0, 20)
    ToggleButton.Position = UDim2.new(1, -50, 0.5, -10)
    ToggleButton.BackgroundColor3 = initialState and Mega.Settings.Menu.AccentColor or Mega.Settings.Menu.ToggleOffColor
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Text = ""
    ToggleButton.AutoButtonColor = false
    ToggleButton.Parent = ToggleFrame
    Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(1, 0)

    local ToggleCircle = Instance.new("Frame", ToggleButton)
    ToggleCircle.Name = "Circle"
    ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
    ToggleCircle.Position = initialState and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    ToggleCircle.BackgroundColor3 = Mega.Settings.Menu.TextColor
    Instance.new("UICorner", ToggleCircle).CornerRadius = UDim.new(1, 0)

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

    return ToggleFrame
end

function Mega.UI.CreateToggleWithSettings(parent, textKey, statePath, callback, settingsTable)
    local MainToggle = Mega.UI.CreateToggle(parent, textKey, statePath, callback)
    
    local SettingsFrame = Instance.new("Frame", parent)
    SettingsFrame.Name = textKey .. "_SubSettings"
    SettingsFrame.Size = UDim2.new(0.9, 0, 0, 0)
    SettingsFrame.BackgroundTransparency = 1
    SettingsFrame.ClipsDescendants = true
    SettingsFrame.AutomaticSize = Enum.AutomaticSize.Y
    SettingsFrame.Visible = getNestedValue(Mega.States, statePath) or false
    
    local List = Instance.new("UIListLayout", SettingsFrame)
    List.Padding = UDim.new(0, 4)
    List.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- Indent sub-elements
    for _, element in ipairs(settingsTable) do
        element.Parent = SettingsFrame
        -- Small indent if it has a label
        if element:FindFirstChild("Label") then
            element.Label.Position = UDim2.new(0, 20, 0, 0)
        end
    end
    
    -- Sync visibility with main toggle
    local oldCallback = callback
    if MainToggle:FindFirstChild("Toggle") then
        MainToggle.Toggle.MouseButton1Click:Connect(function()
            local newState = getNestedValue(Mega.States, statePath)
            SettingsFrame.Visible = newState
        end)
    end

    return MainToggle
end

function Mega.UI.CreateSlider(parent, textKey, statePath, min, max, callback)
    local translatedText = GetText(textKey)
    local currentValue = getNestedValue(Mega.States, statePath) or min
    
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, -20, 0, 50)
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Parent = parent

    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Size = UDim2.new(1, 0, 0, 20)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Text = translatedText .. ": " .. currentValue
    SliderLabel.TextColor3 = Mega.Settings.Menu.TextColor
    SliderLabel.TextSize = 12
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.Parent = SliderFrame

    local SliderTrack = Instance.new("Frame", SliderFrame)
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

    return SliderFrame
end

function Mega.UI.CreateButton(parent, textKey, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.9, 0, 0, 35)
    Button.BackgroundColor3 = Mega.Settings.Menu.ElementColor
    Button.Text = GetText(textKey)
    Button.TextColor3 = Mega.Settings.Menu.TextColor
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 13
    Button.AutoButtonColor = true
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 8)
    Button.Parent = parent
    Button.MouseButton1Click:Connect(function() if callback then pcall(callback) end end)
    return Button
end

function Mega.UI.CreateDropdown(parent, textKey, statePath, options, callback, optionsAreKeys)
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Size = UDim2.new(0.9, 0, 0, 35)
    DropdownFrame.BackgroundTransparency = 1
    DropdownFrame.Parent = parent
    
    local Label = Instance.new("TextLabel", DropdownFrame)
    Label.Size = UDim2.new(0.5, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = GetText(textKey)
    Label.TextColor3 = Mega.Settings.Menu.TextColor
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Font = Enum.Font.Gotham
    
    local Button = Instance.new("TextButton", DropdownFrame)
    Button.Size = UDim2.new(0.4, 0, 0.8, 0)
    Button.Position = UDim2.new(0.6, -10, 0.1, 0)
    Button.BackgroundColor3 = Mega.Settings.Menu.SidebarColor
    Button.TextColor3 = Mega.Settings.Menu.TextColor
    local currentVal = getNestedValue(Mega.States, statePath)
    Button.Text = optionsAreKeys and GetText(currentVal) or tostring(currentVal or "Select")
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)
    
    -- Dropdown list logic simplified for now
    Button.MouseButton1Click:Connect(function()
        -- Normally opens a list...
        if callback then pcall(callback, options[1]) end -- Cycle thru options for simplicity?
    end)
    
    return DropdownFrame
end

function Mega.UI.CreateKeybindButton(parent, textKey, statePath)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0.9, 0, 0, 35)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parent
    
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = GetText(textKey)
    Label.TextColor3 = Mega.Settings.Menu.TextColor
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Font = Enum.Font.Gotham
    
    local Button = Instance.new("TextButton", Frame)
    Button.Size = UDim2.new(0.3, 0, 0.8, 0)
    Button.Position = UDim2.new(0.7, -10, 0.1, 0)
    Button.BackgroundColor3 = Mega.Settings.Menu.SidebarColor
    Button.TextColor3 = Mega.Settings.Menu.AccentColor
    Button.Text = getNestedValue(Mega.States, statePath) or "None"
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)
    
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
    
    return Frame
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
