-- gui/tabs/mm2.lua
-- Main MM2 feature tab

local parent = Mega.Objects.ContentContainer
local UI = Mega.UI
local GetText = Mega.GetText

local TabFrame = Instance.new("ScrollingFrame", parent)
TabFrame.Name = "tab_mm2_frame"
TabFrame.Size = UDim2.new(1, 0, 1, 0)
TabFrame.BackgroundTransparency = 1
TabFrame.BorderSizePixel = 0
TabFrame.ScrollBarThickness = 2
TabFrame.Visible = false
Mega.Objects.TabFrames["tab_mm2"] = TabFrame

local Layout = Instance.new("UIListLayout", TabFrame)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.Padding = UDim.new(0, 10)

-- Main Section
local MainSection = UI.CreateSection(TabFrame, "section_mm2_main")

UI.CreateToggle(MainSection, "toggle_role_reveal", "MM2.RoleReveal")
UI.CreateToggle(MainSection, "toggle_auto_grab_gun", "MM2.AutoGrabGun")

-- Aimbot Section
local AimbotSection = UI.CreateSection(TabFrame, "section_mm2_aimbot")

UI.CreateToggleWithSettings(AimbotSection, "toggle_aimbot", "Aimbot.Enabled", nil, {
    UI.CreateSlider(nil, "slider_aimbot_fov", "Aimbot.FOV", 10, 800),
    UI.CreateSlider(nil, "slider_aimbot_smoothness", "Aimbot.Smoothness", 1, 10),
    UI.CreateToggle(nil, "toggle_show_fov", "Aimbot.ShowFOV"),
    UI.CreateToggle(nil, "toggle_vis_check", "Aimbot.VisibilityCheck")
})

UI.CreateToggleWithSettings(AimbotSection, "toggle_silent_aim", "Aimbot.SilentAim", nil, {
    UI.CreateSlider(nil, "slider_silent_fov", "Aimbot.SilentFOV", 10, 800),
    UI.CreateSlider(nil, "slider_hit_chance", "Aimbot.HitChance", 1, 100)
})

-- Combat Section
local CombatSection = UI.CreateSection(TabFrame, "section_mm2_combat")

UI.CreateToggleWithSettings(CombatSection, "toggle_kill_aura", "MM2.KillAura.Enabled", nil, {
    UI.CreateSlider(nil, "slider_killaura_range", "MM2.KillAura.Range", 5, 50)
})

-- Footer Label
UI.CreateLabel(TabFrame, "loader_ready")

return TabFrame
