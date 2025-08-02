--[[
    https://github.com/kxiox/ks_bossmenu

    This file is licensed under GPL-3.0 or higher <https://www.gnu.org/licenses/gpl-3.0.en.html>

    Copyright © 2025 Kxiox <https://github.com/kxiox>
]]

ESX = exports['es_extended']:getSharedObject()

function addAction(source, data)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not IsPlayerAllowed(source) then return false end
    
    MySQL.insert('INSERT INTO ks_bossmenu_actions (action, employee, data, time, job) VALUES (?, ?, ?, ?, ?)', {
        data.action,
        xPlayer.getName(),
        json.encode(data.data),
        os.time(os.date("!*t")),
        xPlayer.getJob().name
    })
end

function addTransaction(source, data)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not IsPlayerAllowed(source) then return false end

    MySQL.insert('INSERT INTO ks_bossmenu_transactions (action, employee, amount, time, job) VALUES (?, ?, ?, ?, ?)', {
        data.action,
        xPlayer.getName(),
        data.amount,
        os.time(os.date("!*t")),
        xPlayer.getJob().name,
    })
end

function removeMoney(source, jobname, amount)
    MySQL.update('UPDATE addon_account_data SET money = money - ? WHERE account_name = ?', {
        amount,
        Config.Jobs[jobname] and Config.Jobs[jobname].society or 'society_' .. jobname
    })
end 