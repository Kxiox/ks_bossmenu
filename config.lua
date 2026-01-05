--[[
    https://github.com/kxiox/ks_bossmenu

    This file is licensed under GPL-3.0 or higher <https://www.gnu.org/licenses/gpl-3.0.en.html>

    Copyright © 2025 Kxiox <https://github.com/kxiox>
]]

Config = {}

Config.Locale = 'en'

Config.Currency = '$'

Config.Timestamp = 'us'

Config.UnemployedJobName = 'unemployed'

Config.UseTarget = false -- only ox_target

Config.JobCreator = false -- 'jaksam', 'lunar', false | NEW -- Only Lunar supports marker by job creator. For the others, you need to set them in the Config.Jobs file.
Config.DefaultColor = 'green' -- Default color if you use jobcreator and not this config | NEW
Config.DefaultLogo = nil -- Default logo if you use jobcreator and not this config | NEW

Config.EnableCommand = false
Config.CommandName = 'bossmenu'

Config.Jobs = {
    ['police'] = {
        society = nil,
        logo = 'police.png',
        color = 'blue',
        grades = { 4 },
        marker = {
            type = 1,
            coords = vector3(441.0, -981.0, 30.0),
            scale = vector3(1.5, 1.5, 1.5),
            color = { r = 0, g = 0, b = 255, a = 200 },
        },
    }
}

Config.Menus = {
    employees = {
        enabled = true
    },

    salaries = {
        enabled = true,
        maximum = nil,
    },

    account = {
        enabled = true
    },

    bonus = {
        enabled = true,
        maximum = nil,
    }
}