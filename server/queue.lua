--[[
    https://github.com/kxiox/ks_bossmenu

    This file is licensed under GPL-3.0 or higher <https://www.gnu.org/licenses/gpl-3.0.en.html>

    Copyright © 2025 Kxiox <https://github.com/kxiox>
]]

ESX = exports['es_extended']:getSharedObject()

AddEventHandler('esx:playerLoaded', function (source, xPlayer)
    Wait(5000)

    if xPlayer then
        MySQL.Async.fetchAll('SELECT * FROM ks_bossmenu_bonus_queue WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.getIdentifier()
        }, function (result)
            for i=1, #result, 1 do
                MySQL.Async.execute('DELETE FROM ks_bossmenu_bonus_queue WHERE identifier = @identifier AND id = @id', {
                    ['@identifier'] = xPlayer.getIdentifier(),
                    ['@id'] = result[i].id
                })

                removeMoney(source, result[i].job, result[i].amount)

                xPlayer.addMoney(result[i].amount)

                TriggerClientEvent('ks_bossmenu:notify', source, TranslateCap('receive_bonus', result[i].amount .. Config.Currency), 'info')

                Wait(5500)
            end
        end)
    end
end)