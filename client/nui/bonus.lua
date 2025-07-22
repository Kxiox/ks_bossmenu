ESX = exports['es_extended']:getSharedObject()

RegisterNUICallback('giveBonusToSelectedEmployees', function (data, cb)
    ESX.TriggerServerCallback('ks_bossmenu:giveBonusToSelectedEmployees', function(success, message)
        if success then
            cb('ok')
        else
            cb(message or 'error')
        end
    end, data)
end)