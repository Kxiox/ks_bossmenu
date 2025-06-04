ESX = exports['es_extended']:getSharedObject()

local display = false
local stats = {}

function openNUI(data)
    getStats(data)
    getEmployees()
    getSalaries()
    getActions()
    getTransactions()
    getCurrency()

    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'openNUI',
    })

    stats = data
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

RegisterNUICallback('addEmployee', function (data, cb)
    ESX.TriggerServerCallback('ks_bossmenu:addEmployee', function(success)
        if success then
            getEmployees()
            getActions()
            cb('ok')
        else
            cb('error')
        end
    end, data)
end)

RegisterNUICallback('changeSalary', function (data, cb)
    ESX.TriggerServerCallback('ks_bossmenu:changeSalary', function(success)
        if success then
            getSalaries()
            getActions()
            cb('ok')
        else
            cb('error')
        end
    end, data)
end)

RegisterNUICallback('deposit', function (data, cb)
    ESX.TriggerServerCallback('ks_bossmenu:depositMoney', function(success)
        if success then
            getStats(stats)
            getActions()
            cb('ok')
        else
            cb('error')
        end
    end, data)
end)

-- Send NUI Messages

function getStats(data)
    ESX.TriggerServerCallback('ks_bossmenu:getEmployees', function(employees, onduty, factionmoney)
        SendNUIMessage({
            action = 'getStats',
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

function getEmployees()
    ESX.TriggerServerCallback('ks_bossmenu:getEmployeesList', function(employeeslist)
        local args = {}

        for _, employee in ipairs(employeeslist) do
            print(employee.grade)
            table.insert(args, {
                firstname = employee.firstname,
                lastname = employee.lastname,
                jobgrade = employee.jobgrade,
                jobgradenr = employee.jobgradenr,
                salary = string.gsub(ESX.Math.GroupDigits(employee.salary), ",", ".") .. Config.Currency,
            })
        end

        SendNUIMessage({
            action = 'getEmployeesList',
            employees = args,
        })
        
    end, ESX.PlayerData.job.name)
end

function getSalaries()
    ESX.TriggerServerCallback('ks_bossmenu:getSalaries', function(salaries)
        local args = {}

        for _, salary in ipairs(salaries) do
            table.insert(args, {
                grade = salary.grade,
                grade_label = salary.label,
                salary = string.gsub(ESX.Math.GroupDigits(salary.salary), ",", ".") .. Config.Currency,
            })
        end

        SendNUIMessage({
            action = 'getSalaries',
            salaries = args,
        })
        
    end, ESX.PlayerData.job.name)
end

function getActions()
    ESX.TriggerServerCallback('ks_bossmenu:getActionsList', function(actions)
        SendNUIMessage({
            action = 'getActions',
            actions = actions,
        })
    end, ESX.PlayerData.job.name)
end

function getTransactions()
    ESX.TriggerServerCallback('ks_bossmenu:getTransactionsList', function(transactions)
        SendNUIMessage({
            action = 'getTransactions',
            transactions = transactions,
        })
    end, ESX.PlayerData.job.name)
end

function getCurrency()
    SendNUIMessage({
        action = 'getCurrency',
        currency = Config.Currency,
    })
end