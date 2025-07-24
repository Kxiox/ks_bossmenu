--[[
    https://github.com/kxiox/ks_bossmenu

    This file is licensed under GPL-3.0 or higher <https://www.gnu.org/licenses/gpl-3.0.en.html>

    Copyright © 2025 Kxiox <https://github.com/kxiox>
]]

ESX = exports['es_extended']:getSharedObject()

RegisterNetEvent('ks_bossmenu:notify')
AddEventHandler('ks_bossmenu:notify', function(message, type)
    SendNUIMessage({
        action = 'notify',
        message = message,
        type = type or 'info'
    })
end)
