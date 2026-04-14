-- gui/tabs/esp.lua
-- Content for the "ESP" tab (MM2 Edition)

local tabKey = "tab_esp"
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

-- Main ESP Section
local MainSection = UI.CreateSection(TabFrame, "section_esp_main")

UI.CreateToggleWithSettings(MainSection, "toggle_esp", "ESP.Enabled", function(v)
    if Mega.Features.ESP then Mega.Features.ESP.SetEnabled(v) end
end, {
    UI.CreateToggle(nil, "toggle_esp_boxes", "ESP.Boxes"),
    UI.CreateToggle(nil, "toggle_esp_names", "ESP.Names"),
    UI.CreateToggle(nil, "toggle_esp_role", "ESP.ShowRole"),
    UI.CreateToggle(nil, "toggle_esp_distance", "ESP.Distance"),
    UI.CreateToggle(nil, "toggle_esp_tracers", "ESP.Tracers"),
    UI.CreateSlider(nil, "slider_esp_max_dist", "ESP.MaxDistance", 50, 5000)
})

-- Detailed ESP Section
local DetailSection = UI.CreateSection(TabFrame, "section_esp_details")

UI.CreateToggle(DetailSection, "toggle_esp_skeleton", "ESP.Skeleton")
UI.CreateToggle(DetailSection, "toggle_esp_health", "ESP.HealthBar")
UI.CreateToggle(DetailSection, "toggle_esp_items", "ESP.ShowItems")
UI.CreateToggle(DetailSection, "toggle_esp_dead", "ESP.ShowDead")
UI.CreateToggle(DetailSection, "toggle_esp_icons", "ESP.UseIcons")
UI.CreateToggle(DetailSection, "toggle_esp_gundrop", "ESP.GunDrop")

return TabFrame
