-- library/ui_builder.lua
-- GUI element factory functions (CreateToggle, CreateSlider, etc.)

Mega.UI = {}

local GetText = Mega.GetText
local ShowNotification = Mega.ShowNotification
local TweenService = Mega.Services.TweenService
local UserInputService = Mega.Services.UserInputService

function Mega.UI.CreateSection(parent, titleKey)
    local Section = Instance.new("Frame")
    Section.Name = titleKey .. "Section"
    Section.Size = UDim2.new(0.95, 0, 0, 45)
    Section.BackgroundColor3 = Mega.Settings.Menu.ElementColor
    Section.BackgroundTransparency = 0.5 
    Section.BorderSizePixel = 0

    local SectionCorner = Instance.new("UICorner")
    SectionCorner.CornerRadius = UDim.new(0, 10)
    SectionCorner.Parent = Section
    
    local SectionStroke = Instance.new("UIStroke", Section)
    SectionStroke.Color = Mega.Settings.Menu.AccentColor
    SectionStroke.Thickness = 1.2
    SectionStroke.Transparency = 0.7
    
    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Name = "SectionTitle"
    SectionTitle.Size = UDim2.new(1, -20, 1, 0)
    SectionTitle.Position = UDim2.new(0, 15, 0, 0)
    SectionTitle.BackgroundTransparency = 1
    SectionTitle.Text = GetText(titleKey)
    SectionTitle.TextColor3 = Mega.Settings.Menu.TextColor
    SectionTitle.TextSize = 14
    SectionTitle.Font = Enum.Font.GothamBold
    SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    SectionTitle.Parent = Section
    
    Section.Parent = parent
    return Section
end

function Mega.UI.CreateToggle(parent, textKey, statePath, callback)
    local translatedText = GetText(textKey)
    
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = textKey .. "Toggle"
    ToggleFrame.Size = UDim2.new(0.9, 0, 0, 35)
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Parent = parent

    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Name = "Label"
    ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = " " .. translatedText
    ToggleLabel.TextColor3 = Mega.Settings.Menu.TextColor
    ToggleLabel.TextSize = 13
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = ToggleFrame

    local function getState()
        local path = statePath
        local value = Mega.States
        for part in path:gmatch("[^%.]+") do
            value = value and value[part]
        end
        return value
    end

    local initialState = getState()

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "Toggle"
    ToggleButton.Size = UDim2.new(0, 44, 0, 22)
    ToggleButton.Position = UDim2.new(1, -54, 0.5, -11)
    ToggleButton.BackgroundColor3 = initialState and Mega.Settings.Menu.AccentColor or Mega.Settings.Menu.ToggleOffColor
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Text = ""
    ToggleButton.AutoButtonColor = false
    ToggleButton.Parent = ToggleFrame

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(1, 0)
    ToggleCorner.Parent = ToggleButton

    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Name = "Circle"
    ToggleCircle.Size = UDim2.new(0, 18, 0, 18)
    ToggleCircle.Position = initialState and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    ToggleCircle.BackgroundColor3 = Mega.Settings.Menu.BackgroundColor
    ToggleCircle.Parent = ToggleButton
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = ToggleCircle

    local function SetState(newState)
        local path = statePath
        local tbl = Mega.States
        local key
        for part in path:gmatch("[^%.]+") do
            key = part
            if part ~= path:match("([^%.]+)$") then
                if tbl[part] == nil then tbl[part] = {} end
                tbl = tbl[part]
            end
        end
        tbl[key] = newState

        TweenService:Create(ToggleButton, TweenInfo.new(0.2), { BackgroundColor3 = newState and Mega.Settings.Menu.AccentColor or Color3.fromRGB(60, 60, 80) }):Play()
        TweenService:Create(ToggleCircle, TweenInfo.new(0.2), { Position = newState and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9) }):Play()
        
        if callback then pcall(callback, newState) end
        
        local statusText = newState and GetText("notify_enabled") or GetText("notify_disabled")
        ShowNotification(translatedText .. ": " .. statusText, 2)
    end
    
    ToggleButton.MouseButton1Click:Connect(function() SetState(not getState()) end)

    if initialState and callback then
        task.spawn(callback, true)
    end

    return ToggleFrame
end

function Mega.UI.CreateButton(parent, textKey, callback)
    local Button = Instance.new("TextButton")
    Button.Name = textKey .. "Button"
    Button.Size = UDim2.new(0.9, 0, 0, 40)
    Button.BackgroundColor3 = Mega.Settings.Menu.ElementColor
    Button.BorderSizePixel = 0
    Button.Text = GetText(textKey)
    Button.TextColor3 = Mega.Settings.Menu.TextColor
    Button.TextSize = 13
    Button.Font = Enum.Font.GothamSemibold
    Button.AutoButtonColor = false
    Button.Parent = parent

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = Button

    local ButtonStroke = Instance.new("UIStroke", Button)
    ButtonStroke.Color = Mega.Settings.Menu.AccentColor
    ButtonStroke.Thickness = 1
    ButtonStroke.Transparency = 0.8

    Button.MouseEnter:Connect(function() 
        TweenService:Create(Button, TweenInfo.new(0.3), { 
            BackgroundColor3 = Mega.Settings.Menu.AccentColor,
            BackgroundTransparency = 0.2
        }):Play() 
    end)
    Button.MouseLeave:Connect(function() 
        TweenService:Create(Button, TweenInfo.new(0.3), { 
            BackgroundColor3 = Mega.Settings.Menu.ElementColor,
            BackgroundTransparency = 0
        }):Play() 
    end)
    Button.MouseButton1Click:Connect(function() 
        if callback then pcall(callback) end 
    end)

    return Button
end

function Mega.UI.CreateSlider(parent, textKey, statePath, min, max, callback)
    local translatedText = GetText(textKey)
    
    local function getState()
        local path = statePath
        local value = Mega.States
        for part in path:gmatch("[^%.]+") do
            value = value and value[part]
        end
        return value or min
    end

    local currentValue = getState()

    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(0.9, 0, 0, 60)
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Parent = parent

    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Size = UDim2.new(1, 0, 0, 20)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Text = GetText("slider_label", translatedText, currentValue)
    SliderLabel.TextColor3 = Mega.Settings.Menu.TextColor
    SliderLabel.TextSize = 12
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.Parent = SliderFrame

    local SliderTrack = Instance.new("Frame")
    SliderTrack.Name = "Track"
    SliderTrack.Size = UDim2.new(1, 0, 0, 6)
    SliderTrack.Position = UDim2.new(0, 0, 0, 35)
    SliderTrack.BackgroundColor3 = Mega.Settings.Menu.ToggleOffColor
    SliderTrack.BorderSizePixel = 0
    SliderTrack.Parent = SliderFrame

    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((currentValue - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Mega.Settings.Menu.AccentColor
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderTrack

    local SliderButton = Instance.new("TextButton")
    SliderButton.Size = UDim2.new(0, 16, 0, 16)
    SliderButton.Position = UDim2.new(SliderFill.Size.X.Scale, -8, 0.5, -8)
    SliderButton.BackgroundColor3 = Mega.Settings.Menu.AccentColor
    SliderButton.BorderSizePixel = 0
    SliderButton.Text = ""
    SliderButton.Parent = SliderTrack
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

            local path = statePath
            local tbl = Mega.States
            local key
            for part in path:gmatch("[^%.]+") do
                key = part
                if part ~= path:match("([^%.]+)$") then tbl = tbl[part] end
            end
            tbl[key] = newValue

            SliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
            SliderButton.Position = UDim2.new(relativeX, -8, 0.5, -8)
            SliderLabel.Text = GetText("slider_label", translatedText, newValue)
            if callback then pcall(callback, newValue) end
        end
    end)

    return SliderFrame
end

function Mega.UI.CreateDropdown(parent, textKey, statePath, options, callback, optionsAreKeys)
    local function getState()
        local path = statePath
        local value = Mega.States
        for part in path:gmatch("[^%.]+") do value = value and value[part] end
        return value
    end
    
    local initialValue = getState()

    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Size = UDim2.new(0.9, 0, 0, 35)
    DropdownFrame.BackgroundTransparency = 1
    DropdownFrame.Parent = parent

    local DropdownLabel = Instance.new("TextLabel")
    DropdownLabel.Size = UDim2.new(0.5, 0, 1, 0)
    DropdownLabel.BackgroundTransparency = 1
    DropdownLabel.Text = " " .. GetText(textKey)
    DropdownLabel.TextColor3 = Mega.Settings.Menu.TextColor
    DropdownLabel.TextSize = 13
    DropdownLabel.Font = Enum.Font.Gotham
    DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
    DropdownLabel.Parent = DropdownFrame

    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Size = UDim2.new(0, 150, 0, 25)
    DropdownButton.Position = UDim2.new(1, -155, 0.5, -12.5)
    DropdownButton.BackgroundColor3 = Mega.Settings.Menu.ElementColor
    local displayText = (optionsAreKeys and GetText(initialValue)) or initialValue
    DropdownButton.Text = tostring(displayText or "Select")
    DropdownButton.TextColor3 = Mega.Settings.Menu.TextColor
    DropdownButton.TextSize = 11
    DropdownButton.Font = Enum.Font.GothamBold
    DropdownButton.Parent = DropdownFrame
    Instance.new("UICorner", DropdownButton).CornerRadius = UDim.new(0, 6)

    local DropdownList = Instance.new("Frame")
    DropdownList.Size = UDim2.new(0, 150, 0, #options * 30)
    DropdownList.Position = UDim2.new(1, -155, 1, 5)
    DropdownList.BackgroundColor3 = Mega.Settings.Menu.SidebarColor
    DropdownList.Visible = false
    DropdownList.ZIndex = 100
    DropdownList.Parent = DropdownFrame
    Instance.new("UICorner", DropdownList).CornerRadius = UDim.new(0, 6)

    local ListLayout = Instance.new("UIListLayout", DropdownList)

    for _, optionKey in ipairs(options) do
        local ListItem = Instance.new("TextButton")
        ListItem.Size = UDim2.new(1, 0, 0, 30)
        ListItem.BackgroundTransparency = 1
        ListItem.Text = (optionsAreKeys and GetText(optionKey)) or optionKey
        ListItem.TextColor3 = Color3.new(1, 1, 1)
        ListItem.TextSize = 11
        ListItem.Font = Enum.Font.Gotham
        ListItem.Parent = DropdownList
        
        ListItem.MouseButton1Click:Connect(function()
            DropdownButton.Text = ListItem.Text
            DropdownList.Visible = false
            
            local path = statePath
            local tbl = Mega.States
            local key
            for part in path:gmatch("[^%.]+") do
                key = part
                if part ~= path:match("([^%.]+)$") then tbl = tbl[part] end
            end
            tbl[key] = optionKey
            if callback then pcall(callback, optionKey) end
        end)
    end

    DropdownButton.MouseButton1Click:Connect(function()
        DropdownList.Visible = not DropdownList.Visible
    end)

    return DropdownFrame
end

function Mega.UI.CreateLabel(parent, textKey)
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(0.9, 0, 0, 30)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = GetText(textKey)
    TextLabel.TextColor3 = Mega.Settings.Menu.TextColor
    TextLabel.TextSize = 14
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.Parent = parent
    return TextLabel
end
