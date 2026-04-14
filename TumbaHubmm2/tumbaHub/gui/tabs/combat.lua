-- gui/tabs/combat.lua
-- Content for the "COMBAT" tab (MM2 Edition)

local tabKey = "tab_combat"
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

-- Kill Aura Section
UI.CreateSection(TabFrame, "section_mm2_combat")

UI.CreateToggleWithSettings(TabFrame, "toggle_kill_aura", "MM2.KillAura.Enabled", nil, {
    UI.CreateSlider(nil, "slider_killaura_range", "MM2.KillAura.Range", 5, 25),
    UI.CreateSlider(nil, "slider_killaura_delay", "MM2.KillAura.Delay", 0, 1000),
    UI.CreateToggle(nil, "toggle_killaura_target_esp", "MM2.KillAura.TargetESP")
})

-- Auto Shoot Section (Advanced)
UI.CreateSection(TabFrame, "section_combat_accuracy")

UI.CreateToggleWithSettings(TabFrame, "toggle_shoot_murderer", "MM2.AutoShootMurderer", nil, {
    UI.CreateToggle(nil, "toggle_autoshoot_silent", "MM2.SilentAim"),
    UI.CreateSlider(nil, "slider_autoshoot_fov", "MM2.AutoShootFOV", 10, 360)
})

return TabFrame
