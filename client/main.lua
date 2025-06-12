ESX = exports['es_extended']:getSharedObject()

Citizen.CreateThread(function ()
    while not ESX.IsPlayerLoaded() do
        Citizen.Wait(100)
    end

    Wait(3000)

    setLocale()
    setTimestampFormat()

    while true do
        local sleep = 1000
        
        for k, v in pairs(Config.Jobs) do
            if ESX.PlayerData.job.name == k and tableContains(v.grades, ESX.PlayerData.job.grade) then
                local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.marker.coords.x, v.marker.coords.y, v.marker.coords.z, true)
                
                if distance < 20.0 then
                    sleep = 0
                    DrawMarker(v.marker.type, v.marker.coords.x, v.marker.coords.y, v.marker.coords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.marker.scale.x, v.marker.scale.y, v.marker.scale.z, v.marker.color.r, v.marker.color.g, v.marker.color.b, v.marker.color.a, false, true, 2, false, nil, nil, false)
                    
                    if distance < v.marker.scale.x then
                        ESX.ShowHelpNotification(TranslateCap('help_notification'))
                        if IsControlJustReleased(0, 38) then
                            openNUI({
                                color = v.color,
                                logo = v.logo
                            })
                        end
                    end
                end
            end
        end

        Wait(sleep)
    end
end)

function tableContains(tbl, val)
    for _, v in ipairs(tbl) do
        if v == val then
            return true
        end
    end

    return false
end