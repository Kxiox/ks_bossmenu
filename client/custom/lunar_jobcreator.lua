ESX = exports['es_extended']:getSharedObject()

Citizen.CreateThread(function()
    if Config.JobCreator ~= 'lunar' then return end

    local function ensureJobConfig(jobName)
        local jobConfig = Config.Jobs[jobName]

        if jobConfig then
            jobConfig.grades = jobConfig.grades or {}
            return jobConfig
        end

        return {
            color = Config.DefaultColor or 'blue',
            logo = Config.DefaultLogo or nil,
            grades = {}
        }
    end

    local function hasGradeAccess(jobConfig)
        if not jobConfig then
            return true
        end

        if not jobConfig.grades or #jobConfig.grades == 0 then
            return true
        end

        return TableContains(jobConfig.grades, ESX.PlayerData.job.grade)
    end

    RegisterNetEvent('ks_bossmenu:openMenuLunar')
    AddEventHandler('ks_bossmenu:openMenuLunar', function()
        local jobName = ESX.PlayerData.job.name
        local jobConfig = ensureJobConfig(jobName)

        if hasGradeAccess(jobConfig) then
            TriggerServerEvent('ks_bossmenu:lunar:checkSociety', jobName, function(exists)
            end)

            openNUI({
                color = jobConfig.color,
                logo = jobConfig.logo
            })
        end
    end)
end)
