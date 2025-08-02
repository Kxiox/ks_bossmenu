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
    local reason = data.reason

    if not employees or #employees == 0 or not amount or amount <= 0 then
        cb(false, 'invalid_data')
        return
    end

    if IsPlayerAllowed(source) then
        local processedCount = 0
        local totalCost = amount * #employees
        
        -- Prüfe Firmenkontostand
        local societyAccount = 'society_' .. job.name
        local societyMoney = MySQL.single.await('SELECT money FROM addon_account_data WHERE account_name = ?', {
            societyAccount
        })
        
        if not societyMoney or societyMoney.money < totalCost then
            cb(false, 'not_enough_money')
            return
        end
        
        local targetsList = {}
        
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
            
            table.insert(targetsList, {
                name = employee.firstname .. ' ' .. employee.lastname,
                identifier = employee.identifier
            })
            processedCount = processedCount + 1
        end
        
        -- Discord Logging
        local newBalance = societyMoney.money - totalCost
        logBonusSpecificEmployees(source, job.name, amount, targetsList, newBalance, reason)
        
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
    local reason = data.reason

    if not ranks or #ranks == 0 or not amount or amount <= 0 then
        cb(false, 'invalid_data')
        return
    end
    
    if IsPlayerAllowed(source) then
        local selectedGrades = {}
        local gradesList = {}
        
        for _, rank in ipairs(ranks) do
            selectedGrades[rank.grade] = true
            table.insert(gradesList, {
                name = rank.label,
                level = rank.grade
            })
        end
        
        MySQL.query('SELECT identifier, job_grade FROM users WHERE job = ?', {
            job.name
        }, function(employees)
            local processedCount = 0
            
            if employees and #employees > 0 then
                -- Zähle erst wie viele Mitarbeiter betroffen sind
                for _, employee in ipairs(employees) do
                    if selectedGrades[employee.job_grade] then
                        processedCount = processedCount + 1
                    end
                end
                
                local totalCost = amount * processedCount
                
                -- Prüfe Firmenkontostand
                local societyAccount = 'society_' .. job.name
                local societyMoney = MySQL.single.await('SELECT money FROM addon_account_data WHERE account_name = ?', {
                    societyAccount
                })
                
                if not societyMoney or societyMoney.money < totalCost then
                    cb(false, 'not_enough_money')
                    return
                end
                
                -- Führe Bonus-Auszahlung durch
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
                    end
                end
                
                -- Discord Logging
                local newBalance = societyMoney.money - totalCost
                logBonusSpecificGrades(source, job.name, amount, gradesList, processedCount, newBalance, reason)
                
                cb(true, 'bonus_given')
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
    local reason = data.reason

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
                local totalCost = amount * #employees
                
                -- Prüfe Firmenkontostand
                local societyAccount = 'society_' .. job.name
                local societyMoney = MySQL.single.await('SELECT money FROM addon_account_data WHERE account_name = ?', {
                    societyAccount
                })
                
                if not societyMoney or societyMoney.money < totalCost then
                    cb(false, 'not_enough_money')
                    return
                end
                
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
                
                -- Discord Logging
                local newBalance = societyMoney.money - totalCost
                logBonusAllEmployees(source, job.name, amount, processedCount, newBalance, reason)
                
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
    local reason = data.reason

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
                local totalCost = amount * #employees
                
                -- Prüfe Firmenkontostand
                local societyAccount = 'society_' .. job.name
                local societyMoney = MySQL.single.await('SELECT money FROM addon_account_data WHERE account_name = ?', {
                    societyAccount
                })
                
                if not societyMoney or societyMoney.money < totalCost then
                    cb(false, 'not_enough_money')
                    return
                end
                
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
                
                -- Discord Logging
                local newBalance = societyMoney.money - totalCost
                logBonusAllGrades(source, job.name, amount, processedCount, newBalance, reason)
                
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
    local reason = data.reason

    if not amount or amount <= 0 then
        cb(false, 'invalid_data')
        return
    end
    
    if IsPlayerAllowed(source) then
        local processedCount = 0
        local xPlayers = ESX.GetExtendedPlayers()
        
        -- Zähle erst Online-Mitarbeiter
        for _, xTarget in pairs(xPlayers) do
            if xTarget.getJob().name == job.name then
                processedCount = processedCount + 1
            end
        end
        
        if processedCount == 0 then
            cb(false, 'no_online_employees')
            return
        end
        
        local totalCost = amount * processedCount
        
        -- Prüfe Firmenkontostand
        local societyAccount = 'society_' .. job.name
        local societyMoney = MySQL.single.await('SELECT money FROM addon_account_data WHERE account_name = ?', {
            societyAccount
        })
        
        if not societyMoney or societyMoney.money < totalCost then
            cb(false, 'not_enough_money')
            return
        end
        
        -- Führe Bonus-Auszahlung durch
        for _, xTarget in pairs(xPlayers) do
            if xTarget.getJob().name == job.name then
                removeMoney(source, job.name, amount)
                xTarget.addMoney(amount)
                TriggerClientEvent('ks_bossmenu:notify', xTarget.source, TranslateCap('receive_bonus', amount .. Config.Currency), 'info')
            end
        end
        
        -- Discord Logging
        local newBalance = societyMoney.money - totalCost
        logBonusOnlineEmployees(source, job.name, amount, processedCount, newBalance, reason)
        
        cb(true, 'bonus_given')
    else
        cb(false, 'not_allowed')
    end
end)