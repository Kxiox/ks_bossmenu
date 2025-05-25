Config = {}

Config.Debug = false

Config.Locale = GetConvar('esx:locale', 'en')

Config.Currency = '$'

Config.Jobs = {
    ['police'] = {
        logo = 'https://iili.io/Hg0h0Ux.png', -- image.png or url
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