-- gui/tabs/settings.lua
-- Content for the "SETTINGS" tab (MM2 Edition)

local tabKey = "tab_settings"
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

-- Localization Keys
local langKeys = { "language_english", "language_russian" }
local langMap = { ["language_english"] = "en", ["language_russian"] = "ru" }

-- Appearance Section
local AppearanceSection = UI.CreateSection(TabFrame, "section_settings_appearance")

UI.CreateDropdown(AppearanceSection, "dropdown_language", "Localization.CurrentLanguage", langKeys, function(val)
    local lang = langMap[val] or "en"
    if lang == Mega.Localization.CurrentLanguage then return end
    Mega.Localization.CurrentLanguage = lang
    if Mega.ReloadGUI then Mega.ReloadGUI() end
end, true)

UI.CreateKeybindButton(AppearanceSection, "keybind_menu", "Keybinds.Menu")

UI.CreateSlider(AppearanceSection, "slider_menu_transparency", "Settings.Menu.Transparency", 0, 100, function(v) 
    Mega.Settings.Menu.Transparency = v / 100
    if Mega.Objects.GUI and Mega.Objects.GUI:FindFirstChild("MainFrame") then
        Mega.Objects.GUI.MainFrame.BackgroundTransparency = v / 100
    end
end)

-- Config Section
local ConfigSection = UI.CreateSection(TabFrame, "section_settings_config")

UI.CreateButton(ConfigSection, "button_config_save", function()
    if Mega.ConfigSystem then Mega.ConfigSystem.Save("default") end
    ShowNotification(GetText("notify_config_saved"))
end)

UI.CreateButton(ConfigSection, "button_config_load", function()
    if Mega.ConfigSystem then Mega.ConfigSystem.Load("default") end
    ShowNotification(GetText("notify_config_loaded"))
    if Mega.ReloadGUI then Mega.ReloadGUI() end
end)

-- Cleanup Section
UI.CreateButton(TabFrame, "button_cleanup", function()
    Mega.Unloaded = true
    if Mega.Objects.GUI then Mega.Objects.GUI:Destroy() end
    for _, c in pairs(Mega.Objects.Connections) do pcall(function() c:Disconnect() end) end
end)

return TabFrame
