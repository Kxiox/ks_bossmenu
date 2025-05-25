ESX = exports['es_extended']:getSharedObject()

ESX.RegisterServerCallback('ks_bossmenu:getEmployees', function(source, cb, jobName)
    local xPlayers = ESX.GetExtendedPlayers('job', jobName)
    local employees = 0
    local onduty = 0

    MySQL.single('SELECT COUNT(*) as count FROM users WHERE job = ?', {
        jobName
    }, function(result)
        employees = result.count
    end)

    for _, xPlayer in ipairs(xPlayers) do
        if xPlayer.getJob().name == jobName then
            onduty = onduty + 1
        end
    end

    local factionmoney = 0
    local result = MySQL.single.await('SELECT money FROM addon_account_data WHERE account_name = ?', {
        'society_' .. jobName
    })

    if result then
        factionmoney = result.money or 0
    end

    cb(employees, onduty, factionmoney)
end)