--[[
    https://github.com/kxiox/ks_bossmenu

    This file is licensed under GPL-3.0 or higher <https://www.gnu.org/licenses/gpl-3.0.en.html>

    Copyright © 2025 Kxiox <https://github.com/kxiox>
]]

ESX = exports['es_extended']:getSharedObject()

RegisterNUICallback('giveBonusToSelectedEmployees', function (data, cb)
    ESX.TriggerServerCallback('ks_bossmenu:giveBonusToSelectedEmployees', function(success, message)
        if success then
            GetNewStats()
            cb('ok')
        elseif not success and message == 'exceeds_maximum' then
            cb('exceeds_maximum')
        else
            cb(message or 'error')
        end
    end, data)
end)

RegisterNUICallback('giveBonusToRanks', function (data, cb)
    ESX.TriggerServerCallback('ks_bossmenu:giveBonusToRanks', function(success, message)
        if success then
            GetNewStats()
            cb('ok')
        elseif not success and message == 'exceeds_maximum' then
            cb('exceeds_maximum')
        else
            cb(message or 'error')
        end
    end, data)
end)

RegisterNUICallback('giveBonusToAllEmployees', function (data, cb)
    ESX.TriggerServerCallback('ks_bossmenu:giveBonusToAllEmployees', function(success, message)
        if success then
            GetNewStats()
            cb('ok')
        elseif not success and message == 'exceeds_maximum' then
            cb('exceeds_maximum')
        else
            cb(message or 'error')
        end
    end, data)
end)

RegisterNUICallback('giveBonusToAllRanks', function (data, cb)
    ESX.TriggerServerCallback('ks_bossmenu:giveBonusToAllRanks', function(success, message)
        if success then
            GetNewStats()
            cb('ok')
        elseif not success and message == 'exceeds_maximum' then
            cb('exceeds_maximum')
        else
            cb(message or 'error')
        end
    end, data)
end)

RegisterNUICallback('giveBonusToOnlineEmployees', function (data, cb)
    ESX.TriggerServerCallback('ks_bossmenu:giveBonusToOnlineEmployees', function(success, message)
        if success then
            GetNewStats()
            cb('ok')
        elseif not success and message == 'exceeds_maximum' then
            cb('exceeds_maximum')
        else
            cb(message or 'error')
        end
    end, data)
end)