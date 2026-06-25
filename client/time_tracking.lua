ESX = exports['es_extended']:getSharedObject()

local function IsTrackedJob(job)
    return job and Config.Jobs[job] ~= nil
end

RegisterNetEvent('esx:playerLoaded', function (xPlayer, skin)
    local identifier = xPlayer.identifier
    local job = xPlayer.job.name

    if not IsTrackedJob(job) then return end

    ESX.TriggerServerCallback('esx_time_tracking:startTime', function() end, identifier, job)
end)

RegisterNetEvent("esx:setJob") 
AddEventHandler('esx:setJob', function(job, lastJob)
    local identifier = ESX.GetPlayerData().identifier

    if job and lastJob and job.name ~= lastJob.name then
        if IsTrackedJob(job.name) then
            if IsTrackedJob(lastJob.name) then
                ESX.TriggerServerCallback('esx_time_tracking:endTime', function() end, identifier, lastJob.name)
            end

            ESX.TriggerServerCallback('esx_time_tracking:startTime', function() end, identifier, job.name)
        elseif IsTrackedJob(lastJob.name) then
            ESX.TriggerServerCallback('esx_time_tracking:endTime', function() end, identifier, lastJob.name)
        end
    end
end)
