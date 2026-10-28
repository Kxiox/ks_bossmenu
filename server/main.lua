--[[
    https://github.com/kxiox/ks_bossmenu

    This file is licensed under GPL-3.0 or higher <https://www.gnu.org/licenses/gpl-3.0.en.html>

    Copyright © 2025 Kxiox <https://github.com/kxiox>
]]

ESX = exports['es_extended']:getSharedObject()

function AddAction(source, data)
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

function AddTransaction(source, data)
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

function GetMoney(jobname)
    if Config.JobCreator == 'jaksam' then
        exports["jobs_creator"]:getSocietyMoney(jobname, amount)
        return
    end

    return exports['esx_addonaccount']:GetSharedAccount('society_' .. jobname).getMoney()
end

function RemoveMoney(source, jobname, amount)
    if Config.UseJobsCreator then
        exports["jobs_creator"]:removeSocietyMoney(jobname, amount)
        return
    end

    -- MySQL.update('UPDATE addon_account_data SET money = money - ? WHERE account_name = ?', {
    --     amount,
    --     Config.Jobs[jobname] and Config.Jobs[jobname].society or 'society_' .. jobname
    -- })

    local account = exports['esx_addonaccount']:GetSharedAccount('society_' .. jobname)
    account.removeMoney(amount)
end