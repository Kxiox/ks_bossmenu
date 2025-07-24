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

RegisterNUICallback('giveBonusToRanks', function (data, cb)
    ESX.TriggerServerCallback('ks_bossmenu:giveBonusToRanks', function(success, message)
        if success then
            cb('ok')
        else
            cb(message or 'error')
        end
    end, data)
end)

RegisterNUICallback('giveBonusToAllEmployees', function (data, cb)
    ESX.TriggerServerCallback('ks_bossmenu:giveBonusToAllEmployees', function(success, message)
        if success then
            cb('ok')
        else
            cb(message or 'error')
        end
    end, data)
end)

RegisterNUICallback('giveBonusToAllRanks', function (data, cb)
    ESX.TriggerServerCallback('ks_bossmenu:giveBonusToAllRanks', function(success, message)
        if success then
            cb('ok')
        else
            cb(message or 'error')
        end
    end, data)
end)

RegisterNUICallback('giveBonusToOnlineEmployees', function (data, cb)
    ESX.TriggerServerCallback('ks_bossmenu:giveBonusToOnlineEmployees', function(success, message)
        if success then
            cb('ok')
        else
            cb(message or 'error')
        end
    end, data)
end)