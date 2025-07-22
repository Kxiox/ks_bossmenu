ESX = exports['es_extended']:getSharedObject()

ESX.RegisterServerCallback('ks_bossmenu:giveBonusToSelectedEmployees', function(source, cb, data)
    local job = ESX.GetPlayerFromId(source).getJob()
    local employees = data.employees
    local amount = data.amount

    if not employees or #employees == 0 or not amount or amount <= 0 then
        cb(false, 'invalid_data')
        return
    end

    if IsPlayerAllowed(source) then
        for _, employee in ipairs(employees) do
            local xPlayer = ESX.GetPlayerFromIdentifier(employee.identifier)
            if xPlayer then
                xPlayer.addMoney(amount)

                TriggerClientEvent('ks_bossmenu:notify', xPlayer.source, TranslateCap('receive_bonus', amount .. Config.Currency), 'info')
            else
                MySQL.insert('INSERT INTO ks_bossmenu_bonus_queue (identifier, amount, job) VALUES (?, ?, ?)', {
                    employee.identifier,
                    tonumber(amount),
                    job
                })
            end
        end
        cb(true, 'bonus_given')
    else
        cb(false, 'not_allowed')
    end
end)
