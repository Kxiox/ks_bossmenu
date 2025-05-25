ESX = exports['es_extended']:getSharedObject()

local display = false

function openNUI(data)
    setStats(data)

    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'openNUI',
    })
end


-- Callbacks

-- RegisterNUICallback('openNUI', function (data, cb)
--     SetNuiFocus(true, true)
--     SendNUIMessage({
--         action = 'openNUI',
--     })
--     cb('ok')
-- end)

RegisterNUICallback('closeNUI', function (data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)


-- Send NUI Messages

function setStats(data)
    ESX.TriggerServerCallback('ks_bossmenu:getEmployees', function(employees, onduty, factionmoney)
        SendNUIMessage({
            action = 'setStats',
            color = data.color,
            logo = data.logo,
            employeesamount = employees,
            ondutyamount = onduty,
            account = string.gsub(ESX.Math.GroupDigits(factionmoney), ",", "."),
            currency = Config.Currency,
        })

        print(onduty)
    end, ESX.PlayerData.job.name)
end