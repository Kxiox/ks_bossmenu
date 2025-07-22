ESX = exports['es_extended']:getSharedObject()

RegisterNetEvent('ks_bossmenu:notify')
AddEventHandler('ks_bossmenu:notify', function(message, type)
    SendNUIMessage({
        action = 'notify',
        message = message,
        type = type or 'info'
    })
end)
