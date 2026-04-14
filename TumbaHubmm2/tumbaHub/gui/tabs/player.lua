-- gui/tabs/player.lua
-- Content for the "PLAYER" tab (MM2 Edition)

local tabKey = "tab_player"
local UI = Mega.UI
local GetText = Mega.GetText

local TabFrame = Instance.new("ScrollingFrame")
TabFrame.Name = tabKey
TabFrame.Size = UDim2.new(1, 0, 1, 0)
TabFrame.BackgroundTransparency = 1
TabFrame.BorderSizePixel = 0
TabFrame.ScrollBarThickness = 2
TabFrame.Visible = false
TabFrame.Parent = Mega.Objects.ContentContainer

local ContentLayout = Instance.new("UIListLayout", TabFrame)
ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ContentLayout.Padding = UDim.new(0, 8)

Mega.Objects.TabFrames[tabKey] = TabFrame

-- Movement Section
local MovementSection = UI.CreateSection(TabFrame, "section_player_movement")

UI.CreateToggleWithSettings(MovementSection, "toggle_speed", "Player.Speed", nil, {
    UI.CreateSlider(nil, "slider_speed", "Player.SpeedValue", 16, 200)
})

UI.CreateToggleWithSettings(MovementSection, "toggle_fly", "Player.Fly", nil, {
    UI.CreateSlider(nil, "slider_fly_speed", "Player.FlySpeed", 1, 100)
})

UI.CreateToggle(MovementSection, "toggle_inf_jump", "Player.InfiniteJump")
UI.CreateToggle(MovementSection, "toggle_noclip", "Player.NoClip")

return TabFrame
