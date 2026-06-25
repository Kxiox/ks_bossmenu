--[[
    https://github.com/kxiox/ks_bossmenu

    This file is licensed under GPL-3.0 or higher <https://www.gnu.org/licenses/gpl-3.0.en.html>

    Copyright © 2025 Kxiox <https://github.com/kxiox>
]]

ESX = exports['es_extended']:getSharedObject()

local targetZones = {}

Citizen.CreateThread(function()
    while not ESX.PlayerLoaded do
        Citizen.Wait(100)
    end

    Wait(3000)

    setLocale()
    setTimestampFormat()

    if Config.UseTarget and GetResourceState('ox_target') == 'started' then
        for jobName, jobConfig in pairs(Config.Jobs) do
            targetZones[jobName] = exports.ox_target:addBoxZone({
                coords = vec3(jobConfig.marker.coords.x, jobConfig.marker.coords.y, jobConfig.marker.coords.z),
                size = vec3(2, 2, 2),
                rotation = 0,
                debug = false,
                options = {
                    {
                        name = 'bossmenu:' .. jobName,
                        event = 'ks_bossmenu:openMenu',
                        icon = 'fa-solid fa-briefcase', 
                        label = TranslateCap('ox_target'),
                        canInteract = function()
                            return ESX.PlayerData.job.name == jobName and TableContains(jobConfig.grades, ESX.PlayerData.job.grade)
                        end,
                        distance = 2
                    }
                }
            })
        end
    else
        while true do
            local sleep = 3000
            
            for k, v in pairs(Config.Jobs) do
                if ESX.PlayerData.job.name == k and TableContains(v.grades, ESX.PlayerData.job.grade) then
                    local coords = GetEntityCoords(PlayerPedId())
                    local distance = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.marker.coords.x, v.marker.coords.y, v.marker.coords.z, true)

                    if distance < 20.0 then
                        sleep = 0
                        DrawMarker(v.marker.type, v.marker.coords.x, v.marker.coords.y, v.marker.coords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.marker.scale.x, v.marker.scale.y, v.marker.scale.z, v.marker.color.r, v.marker.color.g, v.marker.color.b, v.marker.color.a, false, true, 2, false, nil, nil, false)
                        
                        if distance < v.marker.scale.x then
                            ESX.ShowHelpNotification(TranslateCap('help_notification'))
                            if IsControlJustReleased(0, 38) then
                                TriggerEvent('ks_bossmenu:openMenu')
                            end
                        end
                    end
                end
            end

            Wait(sleep)
        end
    end
end)

RegisterNetEvent('ks_bossmenu:openMenu', function()
    local jobName = ESX.PlayerData.job.name
    local jobConfig = Config.Jobs[jobName]
    
    if jobConfig and TableContains(jobConfig.grades, ESX.PlayerData.job.grade) then
        openNUI({
            color = jobConfig.color,
            logo = jobConfig.logo
        })
    end
end)

-- This section checks the player's grade.
function TableContains(tbl, val)
    for _, v in ipairs(tbl) do
        if v == val then
            return true
        end
    end
    return false
end

if Config.EnableCommand then
    RegisterCommand(Config.CommandName, function()
        local jobName = ESX.PlayerData.job.name
        local jobConfig = Config.Jobs[jobName]

        if jobConfig and TableContains(jobConfig.grades, ESX.PlayerData.job.grade) then
            TriggerEvent('ks_bossmenu:openMenu')
        end
    end, false)
end

function TableContains(tbl, val)
    for _, v in ipairs(tbl) do
        if v == val then
            return true
        end
    end

    return false
end