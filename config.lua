--[[
    https://github.com/kxiox/ks_bossmenu

    This file is licensed under GPL-3.0 or higher <https://www.gnu.org/licenses/gpl-3.0.en.html>

    Copyright © 2025 Kxiox <https://github.com/kxiox>
]]

Config = {}

Config.Locale = 'en' -- en, de or create your own locale file in locales and html/locales

Config.Currency = '$' -- currency symbol, e.g. $, €, £ etc.

Config.Timestamp = 'us' -- us, de, iso, uk or fr

Config.UnemployedJobName = 'unemployed' -- job name of the unemployed job, used for employees wich get fired

Config.Jobs = {
    ['police'] = {
        society = nil, -- nil for society_yourjobname, or set a custom society name
        logo = 'police.png', -- url or file in html/img/
        color = 'blue', -- light, dark, blue, indigo, purple, pink, red, orange, yellow, green, teal, cyan
        grades = { 4 },
        marker = {
            type = 1,
            coords = vector3(441.0, -981.0, 30.0),
            scale = vector3(1.5, 1.5, 1.5),
            color = { r = 0, g = 0, b = 255, a = 200 },
        },
    }
}