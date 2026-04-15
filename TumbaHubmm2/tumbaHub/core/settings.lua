-- core/settings.lua
-- Contains all default settings, states, and database structures.

Mega.VERSION = "5.0.2-MM2" -- Refactored version
Mega.BUILD_DATE = "2024.04.14"
Mega.DEVELOPER = "Antigravity/Tumba"

Mega.Themes = {
    Dark = {
        BackgroundColor = Color3.fromRGB(12, 12, 18),
        SidebarColor = Color3.fromRGB(15, 15, 22),
        ElementColor = Color3.fromRGB(20, 20, 30), 
        ElementHoverColor = Color3.fromRGB(35, 35, 45),
        ToggleOffColor = Color3.fromRGB(60, 60, 80),
        AccentColor = Color3.fromRGB(230, 50, 50), -- Red for MM2 Murderer vibe
        SecondaryColor = Color3.fromRGB(0, 255, 255),
        TextColor = Color3.fromRGB(255, 255, 255),
        TextMutedColor = Color3.fromRGB(150, 150, 170),
        IconColor = Color3.fromRGB(150, 150, 170),
        IconActiveColor = Color3.new(1, 1, 1),
        SectionGradient1 = Color3.fromRGB(15, 15, 25),
        SectionGradient2 = Color3.fromRGB(10, 10, 20)
    }
}

Mega.Settings = {
    Menu = {
        CurrentTheme = "Dark",
        Transparency = 0.1,
        CornerRadius = 12,
        AnimationSpeed = 0.25,
        ShowMenuIcon = true, -- Mobile menu toggle enabled by default for MM2 mobile players
        SettingsIcon = Mega.GetImageFromURL("https://raw.githubusercontent.com/zxcbest957-pixel/TumbaHubMM2/main/TumbaHubmm2/tumbaHub/icons/settings.png", "settings_gear.png")
    },
    System = {
        AntiAFK = true,
        AutoSave = true,
        PerformanceMode = false,
        DebugMode = false,
        ShowStatusIndicator = true
    }
}

Mega.States = {
    ESP = {
        Enabled = false,
        Boxes = true,
        Names = true,
        Distance = true,
        Health = false,
        Role = true,
        ShowRoles = true,
        ShowWeapons = true,
        ShowDead = false,
        Tracers = false,
        MaxDistance = 2000,
        MurdererColor = Color3.fromRGB(255, 50, 50),
        SheriffColor = Color3.fromRGB(50, 100, 255),
        HeroColor = Color3.fromRGB(255, 255, 50),
        InnocentColor = Color3.fromRGB(200, 200, 200)
    },
    MM2 = {
        RoleReveal = true,
        AutoGrabGun = false,
        AutoFarmCoins = false,
        AntiTrap = false,
        KillAura = {
            Enabled = false,
            Range = 25
        }
    },
    Aimbot = {
        Enabled = false,
        FOV = 150,
        Smoothness = 2, -- Lower is smoother, 1 is instant
        TargetPart = "Head",
        ShowFOV = true,
        VisibilityCheck = true,
        TargetMode = "FOV", -- "FOV" or "Distance"
        SilentAim = false,
        SilentFOV = 150,
        HitChance = 100
    },
    Player = {
        Speed = false,
        SpeedValue = 20,
        JumpPower = false,
        JumpPowerValue = 50,
        Fly = false,
        FlySpeed = 24,
        NoClip = false
    },
    Keybinds = {
        Menu = "RightShift"
    }
}

function Mega.SetTheme(themeName)
    local theme = Mega.Themes[themeName] or Mega.Themes.Dark
    Mega.Settings.Menu.CurrentTheme = themeName
    for k, v in pairs(theme) do
        Mega.Settings.Menu[k] = v
    end
end

Mega.SetTheme(Mega.Settings.Menu.CurrentTheme)
