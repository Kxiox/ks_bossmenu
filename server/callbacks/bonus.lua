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
        -- Erstelle eine Liste der ausgewählten Grade
        local selectedGrades = {}
        for _, rank in ipairs(ranks) do
            selectedGrades[rank.grade] = true
        end
        
        -- Hole alle Mitarbeiter des Jobs aus der Datenbank
        MySQL.query('SELECT identifier, job_grade FROM users WHERE job = ?', {
            job.name
        }, function(employees)
            local processedCount = 0
            
            if employees and #employees > 0 then
                for _, employee in ipairs(employees) do
                    -- Prüfe ob der Mitarbeiter einen ausgewählten Rang hat
                    if selectedGrades[employee.job_grade] then
                        local xTarget = ESX.GetPlayerFromIdentifier(employee.identifier)
                        
                        if xTarget then
                            -- Spieler ist online - Bonus direkt geben
                            xTarget.addMoney(amount)
                            TriggerClientEvent('ks_bossmenu:notify', xTarget.source, TranslateCap('receive_bonus', amount .. Config.Currency), 'info')
                        else
                            -- Spieler ist offline - zur Queue hinzufügen
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

-- Bonus für alle Mitarbeiter
ESX.RegisterServerCallback('ks_bossmenu:giveBonusToAllEmployees', function(source, cb, data)
    local xPlayer = ESX.GetPlayerFromId(source)
    local job = xPlayer.getJob()
    local amount = data.amount

    if not amount or amount <= 0 then
        cb(false, 'invalid_data')
        return
    end
    
    if IsPlayerAllowed(source) then
        -- Hole alle Mitarbeiter des Jobs aus der Datenbank
        MySQL.query('SELECT identifier FROM users WHERE job = ?', {
            job.name
        }, function(employees)
            local processedCount = 0
            
            if employees and #employees > 0 then
                for _, employee in ipairs(employees) do
                    local xTarget = ESX.GetPlayerFromIdentifier(employee.identifier)
                    
                    if xTarget then
                        -- Spieler ist online - Bonus direkt geben
                        xTarget.addMoney(amount)
                        TriggerClientEvent('ks_bossmenu:notify', xTarget.source, TranslateCap('receive_bonus', amount .. Config.Currency), 'info')
                    else
                        -- Spieler ist offline - zur Queue hinzufügen
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

-- Bonus für alle Ränge
ESX.RegisterServerCallback('ks_bossmenu:giveBonusToAllRanks', function(source, cb, data)
    local xPlayer = ESX.GetPlayerFromId(source)
    local job = xPlayer.getJob()
    local amount = data.amount

    if not amount or amount <= 0 then
        cb(false, 'invalid_data')
        return
    end
    
    if IsPlayerAllowed(source) then
        -- Hole alle Mitarbeiter des Jobs aus der Datenbank
        MySQL.query('SELECT identifier FROM users WHERE job = ?', {
            job.name
        }, function(employees)
            local processedCount = 0
            
            if employees and #employees > 0 then
                for _, employee in ipairs(employees) do
                    local xTarget = ESX.GetPlayerFromIdentifier(employee.identifier)
                    
                    if xTarget then
                        -- Spieler ist online - Bonus direkt geben
                        xTarget.addMoney(amount)
                        TriggerClientEvent('ks_bossmenu:notify', xTarget.source, TranslateCap('receive_bonus', amount .. Config.Currency), 'info')
                    else
                        -- Spieler ist offline - zur Queue hinzufügen
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

-- Bonus für online Mitarbeiter
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
        
        -- Hole alle online Spieler
        local xPlayers = ESX.GetExtendedPlayers()
        
        for _, xTarget in pairs(xPlayers) do
            -- Prüfe ob der Spieler den gleichen Job hat
            if xTarget.getJob().name == job.name then
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