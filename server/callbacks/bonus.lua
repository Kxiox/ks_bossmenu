--[[
    https://github.com/kxiox/ks_bossmenu

    This file is licensed under GPL-3.0 or higher <https://www.gnu.org/licenses/gpl-3.0.en.html>

    Copyright © 2025 Kxiox <https://github.com/kxiox>
]]

ESX = exports['es_extended']:getSharedObject()

ESX.RegisterServerCallback('ks_bossmenu:giveBonusToSelectedEmployees', function(source, cb, data)
    local xPlayer = ESX.GetPlayerFromId(source)
    local job = xPlayer.getJob()
    local employees = data.employees
    local amount = data.amount

    if not employees or #employees == 0 or not amount or amount <= 0 then
        cb(false, 'invalid_data')
        return
    end

    if IsPlayerAllowed(source) then
        for _, employee in ipairs(employees) do
            local xTarget = ESX.GetPlayerFromIdentifier(employee.identifier)
            if xTarget then
                removeMoney(source, job.name, amount)

                xTarget.addMoney(amount)

                TriggerClientEvent('ks_bossmenu:notify', xTarget.source, TranslateCap('receive_bonus', amount .. Config.Currency), 'info')
            else
                MySQL.insert('INSERT INTO ks_bossmenu_bonus_queue (identifier, amount, job) VALUES (?, ?, ?)', {
                    employee.identifier,
                    tonumber(amount),
                    job.name
                })
            end
        end
        cb(true, 'bonus_given')
    else
        cb(false, 'not_allowed')
    end
end)

ESX.RegisterServerCallback('ks_bossmenu:giveBonusToRanks', function(source, cb, data)
    local xPlayer = ESX.GetPlayerFromId(source)
    local job = xPlayer.getJob()
    local ranks = data.ranks
    local amount = data.amount

    if not ranks or #ranks == 0 or not amount or amount <= 0 then
        cb(false, 'invalid_data')
        return
    end
    
    if IsPlayerAllowed(source) then
        local selectedGrades = {}
        for _, rank in ipairs(ranks) do
            selectedGrades[rank.grade] = true
        end
        
        MySQL.query('SELECT identifier, job_grade FROM users WHERE job = ?', {
            job.name
        }, function(employees)
            local processedCount = 0
            
            if employees and #employees > 0 then
                for _, employee in ipairs(employees) do
                    if selectedGrades[employee.job_grade] then
                        local xTarget = ESX.GetPlayerFromIdentifier(employee.identifier)
                        
                        if xTarget then
                            removeMoney(source, job.name, amount)

                            xTarget.addMoney(amount)
                            TriggerClientEvent('ks_bossmenu:notify', xTarget.source, TranslateCap('receive_bonus', amount .. Config.Currency), 'info')
                        else
                            MySQL.insert('INSERT INTO ks_bossmenu_bonus_queue (identifier, amount, job) VALUES (?, ?, ?)', {
                                employee.identifier,
                                tonumber(amount),
                                job.name
                            })
                        end
                        processedCount = processedCount + 1
                    end
                end
                
                if processedCount > 0 then
                    cb(true, 'bonus_given')
                else
                    cb(false, 'no_employees_found')
                end
            else
                cb(false, 'no_employees_found')
            end
        end)
    else
        cb(false, 'not_allowed')
    end
end)

ESX.RegisterServerCallback('ks_bossmenu:giveBonusToAllEmployees', function(source, cb, data)
    local xPlayer = ESX.GetPlayerFromId(source)
    local job = xPlayer.getJob()
    local amount = data.amount

    if not amount or amount <= 0 then
        cb(false, 'invalid_data')
        return
    end
    
    if IsPlayerAllowed(source) then
        MySQL.query('SELECT identifier FROM users WHERE job = ?', {
            job.name
        }, function(employees)
            local processedCount = 0
            
            if employees and #employees > 0 then
                for _, employee in ipairs(employees) do
                    local xTarget = ESX.GetPlayerFromIdentifier(employee.identifier)
                    
                    if xTarget then
                        removeMoney(source, job.name, amount)

                        xTarget.addMoney(amount)
                        TriggerClientEvent('ks_bossmenu:notify', xTarget.source, TranslateCap('receive_bonus', amount .. Config.Currency), 'info')
                    else
                        MySQL.insert('INSERT INTO ks_bossmenu_bonus_queue (identifier, amount, job) VALUES (?, ?, ?)', {
                            employee.identifier,
                            tonumber(amount),
                            job.name
                        })
                    end
                    processedCount = processedCount + 1
                end
                
                cb(true, 'bonus_given')
            else
                cb(false, 'no_employees_found')
            end
        end)
    else
        cb(false, 'not_allowed')
    end
end)

ESX.RegisterServerCallback('ks_bossmenu:giveBonusToAllRanks', function(source, cb, data)
    local xPlayer = ESX.GetPlayerFromId(source)
    local job = xPlayer.getJob()
    local amount = data.amount

    if not amount or amount <= 0 then
        cb(false, 'invalid_data')
        return
    end
    
    if IsPlayerAllowed(source) then
        MySQL.query('SELECT identifier FROM users WHERE job = ?', {
            job.name
        }, function(employees)
            local processedCount = 0
            
            if employees and #employees > 0 then
                for _, employee in ipairs(employees) do
                    local xTarget = ESX.GetPlayerFromIdentifier(employee.identifier)
                    
                    if xTarget then
                        removeMoney(source, job.name, amount)

                        xTarget.addMoney(amount)
                        TriggerClientEvent('ks_bossmenu:notify', xTarget.source, TranslateCap('receive_bonus', amount .. Config.Currency), 'info')
                    else
                        MySQL.insert('INSERT INTO ks_bossmenu_bonus_queue (identifier, amount, job) VALUES (?, ?, ?)', {
                            employee.identifier,
                            tonumber(amount),
                            job.name
                        })
                    end
                    processedCount = processedCount + 1
                end
                
                cb(true, 'bonus_given')
            else
                cb(false, 'no_employees_found')
            end
        end)
    else
        cb(false, 'not_allowed')
    end
end)

ESX.RegisterServerCallback('ks_bossmenu:giveBonusToOnlineEmployees', function(source, cb, data)
    local xPlayer = ESX.GetPlayerFromId(source)
    local job = xPlayer.getJob()
    local amount = data.amount

    if not amount or amount <= 0 then
        cb(false, 'invalid_data')
        return
    end
    
    if IsPlayerAllowed(source) then
        local processedCount = 0
        
        local xPlayers = ESX.GetExtendedPlayers()
        
        for _, xTarget in pairs(xPlayers) do
            if xTarget.getJob().name == job.name then
                removeMoney(source, job.name, amount)

                xTarget.addMoney(amount)
                TriggerClientEvent('ks_bossmenu:notify', xTarget.source, TranslateCap('receive_bonus', amount .. Config.Currency), 'info')
                processedCount = processedCount + 1
            end
        end
        
        if processedCount > 0 then
            cb(true, 'bonus_given')
        else
            cb(false, 'no_online_employees')
        end
    else
        cb(false, 'not_allowed')
    end
end)