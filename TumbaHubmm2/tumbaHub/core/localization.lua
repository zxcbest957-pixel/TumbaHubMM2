-- core/localization.lua
-- Mega.Localization table and GetText function

Mega.Localization = {
    CurrentLanguage = "en",
    Strings = {
        ["phase_network"] = { ru = "РУКОПОЖАТИЕ (СЕТЬ)", en = "HANDSHAKE (NETWORK)" },
        ["phase_core"] = { ru = "СБОРКА ОКРУЖЕНИЯ", en = "BUILDING CORE" },
        ["phase_features"] = { ru = "СИНХРОНИЗАЦИЯ ФУНКЦИЙ", en = "SYNCING FEATURES" },
        ["phase_ui"] = { ru = "ФИНАЛИЗАЦИЯ ИНТЕРФЕЙСА", en = "FINALIZING INTERFACE" },
        ["loader_ready"] = { ru = "СИСТЕМА ГОТОВА к ЗАПУСКУ", en = "SYSTEM READY FOR LAUNCH" },
        
        -- MM2 Roles
        ["role_innocent"] = { ru = "Мирный", en = "Innocent" },
        ["role_sheriff"] = { ru = "Шериф", en = "Sheriff" },
        ["role_murderer"] = { ru = "Мардер", en = "Murderer" },
        ["role_hero"] = { ru = "Герой", en = "Hero" },
        ["role_hidden"] = { ru = "???", en = "???" },

        -- MM2 Specific Tabs/Sections
        ["tab_mm2"] = { ru = "MM2", en = "MM2" },
        ["section_mm2_main"] = { ru = "ОСНОВНОЕ (MM2)", en = "MAIN (MM2)" },
        ["toggle_role_reveal"] = { ru = "Раскрытие ролей", en = "Role Reveal" },
        ["toggle_auto_grab_gun"] = { ru = "Авто-подбор оружия", en = "Auto Grab Gun" },
        ["toggle_shoot_murderer"] = { ru = "Авто-выстрел в мардера", en = "Auto Shoot Murderer" },
        ["section_mm2_combat"] = { ru = "БОЙ (MM2)", en = "COMBAT (MM2)" },
        ["toggle_kill_aura"] = { ru = "Килл-аура (Dagger)", en = "Kill Aura (Dagger)" },

        -- ESP
        ["tab_esp"] = { ru = "ESP", en = "ESP" },
        ["toggle_esp"] = { ru = "Включить ESP", en = "Enable ESP" },
        ["toggle_esp_names"] = { ru = "Имена", en = "Names" },
        ["toggle_esp_boxes"] = { ru = "Боксы", en = "Boxes" },
        ["toggle_esp_role"] = { ru = "Показывать роли", en = "Show Roles" },

        -- Player
        ["tab_player"] = { ru = "ИГРОК", en = "PLAYER" },
        ["toggle_speed"] = { ru = "Спидхак", en = "Speedhack" },
        ["slider_speed"] = { ru = "Скорость", en = "Speed" },

        -- Settings
        ["tab_settings"] = { ru = "НАСТРОЙКИ", en = "SETTINGS" },
        ["button_reload_script"] = { ru = "Перезагрузить", en = "Reload" },
        ["dropdown_language"] = { ru = "Язык", en = "Language" },
        ["language_english"] = { ru = "English", en = "English" },
        ["language_russian"] = { ru = "Русский", en = "Russian" },

        -- UI Strings
        ["title_bar"] = { ru = "💎 TUMBA HUB: MM2 v%s 💎", en = "💎 TUMBA HUB: MM2 v%s 💎" },
        ["notify_enabled"] = { ru = "ВКЛЮЧЕНО", en = "ENABLED" },
        ["notify_disabled"] = { ru = "ВЫКЛЮЧЕНО", en = "DISABLED" }
    }
}

function Mega.GetText(key, ...)
    local lang = Mega.Localization.CurrentLanguage
    local str = Mega.Localization.Strings[key]
    if str and str[lang] then
        local text = str[lang]
        local success, result = pcall(string.format, text, ...)
        return success and result or text
    end
    return key
end

function Mega.LoadLanguage()
    return "ru" -- For now, default to RU as per user's greeting
end

Mega.Localization.CurrentLanguage = Mega.LoadLanguage()
