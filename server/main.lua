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