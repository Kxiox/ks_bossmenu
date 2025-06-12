Config = {}

Config.Debug = false -- set to true to enable debug messages in console

Config.Locale = GetConvar('esx:locale', 'en') -- en, de or create your own locale file in locales

Config.Currency = '$' -- currency symbol, e.g. $, €, £ etc.

Config.Timestamp = 'us' -- us or de

Config.UnemployedJobName = 'unemployed' -- job name of the unemployed job, used for employees wich get fired

Config.Jobs = {
    ['police'] = {
        logo = 'https://iili.io/Hg0h0Ux.png', -- url //TODO add files support
        color = 'blue', -- light, dark, blue, indigo, purple, pink, red, orange, yellow, green, teal, cyan, white, gray
        grades = { 4 },
        marker = {
            type = 1,
            coords = vector3(441.0, -981.0, 30.0),
            scale = vector3(1.5, 1.5, 1.5),
            color = { r = 0, g = 0, b = 255, a = 200 },
        },
    }
}