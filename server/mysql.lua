--[[
    https://github.com/kxiox/ks_bossmenu

    This file is licensed under GPL-3.0 or higher <https://www.gnu.org/licenses/gpl-3.0.en.html>

    Copyright © 2025 Kxiox <https://github.com/kxiox>
]]

CreateThread(function()
    local queries = {
        [[CREATE TABLE IF NOT EXISTS `ks_bossmenu_actions` (
            `id` int(11) NOT NULL AUTO_INCREMENT,
            `action` text DEFAULT NULL,
            `employee` text DEFAULT NULL,
            `time` varchar(10) DEFAULT NULL,
            `data` longtext DEFAULT NULL,
            `job` text DEFAULT NULL,
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;]],
        [[CREATE TABLE IF NOT EXISTS `ks_bossmenu_bonus_queue` (
            `id` int(11) NOT NULL AUTO_INCREMENT,
            `identifier` varchar(46) NOT NULL,
            `amount` int(11) NOT NULL DEFAULT 0,
            `job` varchar(50) NOT NULL,
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;]],
        [[CREATE TABLE IF NOT EXISTS `ks_bossmenu_transactions` (
            `id` int(11) NOT NULL AUTO_INCREMENT,
            `action` text DEFAULT NULL,
            `employee` text DEFAULT NULL,
            `amount` int(11) DEFAULT NULL,
            `time` varchar(10) DEFAULT NULL,
            `job` text DEFAULT NULL,
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;]],
        [[CREATE TABLE IF NOT EXISTS `ks_bossmenu_time_tracking` (
            `id` int(11) NOT NULL AUTO_INCREMENT,
            `identifier` varchar(46) NOT NULL,
            `job` varchar(50) NOT NULL,
            `time_start` int(11) NOT NULL,
            `time_end` int(11) NOT NULL DEFAULT 0,
            PRIMARY KEY (`id`),
            KEY `idx_identifier_job_open` (`identifier`, `job`, `time_end`),
            KEY `idx_job_time_start` (`job`, `time_start`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;]]
    }
    for _, query in ipairs(queries) do
        MySQL.insert.await(query)
    end

    local columns = MySQL.query.await('SHOW COLUMNS FROM `ks_bossmenu_time_tracking`')
    local hasColumn = {}

    for _, column in ipairs(columns or {}) do
        hasColumn[column.Field] = true
    end

    if not hasColumn.id then
        pcall(function()
            MySQL.query.await('ALTER TABLE `ks_bossmenu_time_tracking` ADD COLUMN `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST')
        end)
    end

    if not hasColumn.identifier then
        MySQL.query.await('ALTER TABLE `ks_bossmenu_time_tracking` ADD COLUMN `identifier` varchar(46) NOT NULL')
    end

    if not hasColumn.job then
        MySQL.query.await('ALTER TABLE `ks_bossmenu_time_tracking` ADD COLUMN `job` varchar(50) NOT NULL')
    end

    if not hasColumn.time_start then
        MySQL.query.await('ALTER TABLE `ks_bossmenu_time_tracking` ADD COLUMN `time_start` int(11) NOT NULL')
    end

    if not hasColumn.time_end then
        MySQL.query.await('ALTER TABLE `ks_bossmenu_time_tracking` ADD COLUMN `time_end` int(11) NOT NULL DEFAULT 0')
    end

    pcall(function()
        MySQL.query.await('ALTER TABLE `ks_bossmenu_time_tracking` ADD INDEX `idx_identifier_job_open` (`identifier`, `job`, `time_end`)')
    end)

    pcall(function()
        MySQL.query.await('ALTER TABLE `ks_bossmenu_time_tracking` ADD INDEX `idx_job_time_start` (`job`, `time_start`)')
    end)

    Wait(1000)

    for k, v in pairs(Config.Jobs) do
        local societyName = v.society or ('society_' .. k)
        local result = MySQL.query.await('SELECT * FROM addon_account_data WHERE account_name = ?', { societyName })
        
        if #result == 0 then
            local success, err = pcall(function()
                MySQL.insert.await('INSERT INTO addon_account_data (account_name, money, owner) VALUES (?, ?, ?)', { societyName, 0, NULL })
            end)
            
            if not success then
                -- Try without owner column if it doesn't exist
                MySQL.insert.await('INSERT INTO addon_account_data (account_name, money) VALUES (?, ?)', { societyName, 0 })
            end
            
            print(('[ks_bossmenu] Society account for %s created.'):format(societyName))
        end
    end
end)

RegisterNetEvent('ks_bossmenu:lunar:checkSociety')
AddEventHandler('ks_bossmenu:lunar:checkSociety', function(jobName)
    local _source = source
    CreateThread(function()
        local societyName = Config.Jobs[jobName] and (Config.Jobs[jobName].society or 'society_' .. jobName) or 'society_' .. jobName
        local result = MySQL.query.await('SELECT * FROM addon_account_data WHERE account_name = ?', {societyName})
        
        if #result == 0 then
            AddSociety(societyName)
        end
        
        TriggerClientEvent('ks_bossmenu:lunar:societyChecked', _source, true)
    end)
end)

function AddSociety(societyName)
    local success, err = pcall(function()
        MySQL.insert.await('INSERT INTO addon_account_data (account_name, money, owner) VALUES (?, ?, ?)', { societyName, 0, NULL })
    end)
    
    if not success then
        -- Try without owner column if it doesn't exist
        MySQL.insert.await('INSERT INTO addon_account_data (account_name, money) VALUES (?, ?)', { societyName, 0 })
    end
    
    print(('[ks_bossmenu] Society account for %s created.'):format(societyName))
end
