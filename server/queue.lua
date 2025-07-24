ESX = exports['es_extended']:getSharedObject()

AddEventHandler('esx:playerLoaded', function (playerId, xPlayer)
    print('triggered')

    if xPlayer then
        MySQL.Async.fetchAll('SELECT * FROM ks_bossmenu_bonus_queue WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.getIdentifier()
        }, function (result)
            for i=1, #result, 1 do
                print(json.encode(result[i]))
                xPlayer.addMoney(result[i].amount)
            end
        end)
    end
end)