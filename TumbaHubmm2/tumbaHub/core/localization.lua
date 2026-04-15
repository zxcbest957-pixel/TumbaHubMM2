-- core/localization.lua
-- Mega.Localization table and GetText function

Mega.Localization = {
    CurrentLanguage = "ru",
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

        -- Sections
        ["section_mm2_main"] = { ru = "ОСНОВНОЕ (MM2)", en = "MAIN (MM2)" },
        ["section_mm2_combat"] = { ru = "БОЙ (MM2)", en = "COMBAT (MM2)" },
        ["section_mm2_aimbot"] = { ru = "АИМБОТ (MM2)", en = "AIMBOT (MM2)" },
        ["section_esp_main"] = { ru = "ИГРОКИ (ESP)", en = "PLAYERS (ESP)" },
        ["section_combat_accuracy"] = { ru = "ТОЧНОСТЬ", en = "ACCURACY" },
        ["section_player_movement"] = { ru = "ПЕРЕДВИЖЕНИЕ", en = "MOVEMENT" },
        ["section_settings_appearance"] = { ru = "ВНЕШНИЙ ВИД", en = "APPEARANCE" },
        ["section_settings_config"] = { ru = "КОНФИГУРАЦИИ", en = "CONFIGURATIONS" },

        -- Tabs
        ["tab_mm2"] = { ru = "MM2", en = "MM2" },
        ["tab_esp"] = { ru = "ESP", en = "ESP" },
        ["tab_combat"] = { ru = "БОЙ", en = "COMBAT" },
        ["tab_player"] = { ru = "ИГРОК", en = "PLAYER" },
        ["tab_settings"] = { ru = "НАСТРОЙКИ", en = "SETTINGS" },

        -- Toggles
        ["toggle_role_reveal"] = { ru = "Раскрытие ролей", en = "Role Reveal" },
        ["toggle_auto_grab_gun"] = { ru = "Авто-подбор оружия", en = "Auto Grab Gun" },
        ["toggle_shoot_murderer"] = { ru = "Авто-выстрел в мардера", en = "Auto Shoot Murderer" },
        ["toggle_kill_aura"] = { ru = "Килл-аура (Dagger)", en = "Kill Aura (Dagger)" },
        ["toggle_aimbot"] = { ru = "Аимбот (Camera)", en = "Aimbot (Camera)" },
        ["toggle_show_fov"] = { ru = "Показывать FOV", en = "Show FOV" },
        ["toggle_vis_check"] = { ru = "Проверка видимости", en = "Visibility Check" },
        ["toggle_silent_aim"] = { ru = "Сайлент Аим (Silent)", en = "Silent Aim" },
        ["toggle_esp"] = { ru = "Включить ESP", en = "Enable ESP" },
        ["toggle_esp_names"] = { ru = "Имена", en = "Names" },
        ["toggle_esp_boxes"] = { ru = "Боксы", en = "Boxes" },
        ["toggle_esp_role"] = { ru = "Роли", en = "Roles" },
        ["toggle_esp_distance"] = { ru = "Дистанция", en = "Distance" },
        ["toggle_esp_tracers"] = { ru = "Трейсеры", en = "Tracers" },
        ["toggle_killaura_target_esp"] = { ru = "ESP на цель", en = "Target ESP" },
        ["toggle_autoshoot_silent"] = { ru = "Сайлент аим", en = "Silent Aim" },
        ["toggle_speed"] = { ru = "Спидхак", en = "Speedhack" },
        ["toggle_fly"] = { ru = "Полет", en = "Fly" },
        ["toggle_inf_jump"] = { ru = "Бесконечный прыжок", en = "Infinite Jump" },
        ["toggle_noclip"] = { ru = "Ноуклип", en = "NoClip" },

        -- Sliders
        ["slider_speed"] = { ru = "Скорость", en = "Speed" },
        ["slider_fly_speed"] = { ru = "Скорость полета", en = "Fly Speed" },
        ["slider_esp_max_dist"] = { ru = "Макс. дистанция", en = "Max Distance" },
        ["slider_killaura_range"] = { ru = "Радиус ауры", en = "Aura Range" },
        ["slider_killaura_delay"] = { ru = "Задержка (мс)", en = "Delay (ms)" },
        ["slider_autoshoot_fov"] = { ru = "Угол обзора (FOV)", en = "FOV" },
        ["slider_aimbot_fov"] = { ru = "Радиус аима (FOV)", en = "Aimbot FOV" },
        ["slider_aimbot_smoothness"] = { ru = "Сглаживание", en = "Smoothness" },
        ["slider_silent_fov"] = { ru = "Радиус Сайлента (FOV)", en = "Silent Aim FOV" },
        ["slider_hit_chance"] = { ru = "Шанс попадания", en = "Hit Chance" },
        ["slider_menu_transparency"] = { ru = "Прозрачность меню", en = "Menu Transparency" },

        -- Buttons
        ["keybind_menu"] = { ru = "Клавиша меню", en = "Menu Keybind" },
        ["button_config_save"] = { ru = "Сохранить конфиг", en = "Save Config" },
        ["button_config_load"] = { ru = "Загрузить конфиг", en = "Load Config" },
        ["button_cleanup"] = { ru = "Выгрузить чит", en = "Unload Cheat" },
        ["button_reload_script"] = { ru = "Перезагрузить GUI", en = "Reload GUI" },
        ["dropdown_language"] = { ru = "Язык интерфейса", en = "Interface Language" },

        -- Notifications
        ["notify_enabled"] = { ru = "ВКЛЮЧЕНО", en = "ENABLED" },
        ["notify_disabled"] = { ru = "ВЫКЛЮЧЕНО", en = "DISABLED" },
        ["notify_config_saved"] = { ru = "Конфигурация сохранена!", en = "Configuration saved!" },
        ["notify_config_loaded"] = { ru = "Конфигурация загружена!", en = "Configuration loaded!" }
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
    return "ru"
end

Mega.Localization.CurrentLanguage = Mega.LoadLanguage()
return Mega.Localization
