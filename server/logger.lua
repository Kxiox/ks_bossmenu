ESX = exports['es_extended']:getSharedObject()

-- Job-spezifische Discord Webhook URLs
function getJobWebhook(job, webhookType)
    -- Prüfe zuerst job-spezifische Webhooks
    if Config.JobWebhooks and Config.JobWebhooks[job] and Config.JobWebhooks[job][webhookType] then
        return Config.JobWebhooks[job][webhookType]
    end
    
    -- Fallback auf allgemeine Webhooks
    if Config.Webhooks and Config.Webhooks[webhookType] then
        return Config.Webhooks[webhookType]
    end
    
    return ""
end

function hexToDecimal(hex)
    if not hex then return 255 end
    hex = hex:gsub("#", "")
    return tonumber(hex, 16) or 255
end

function getPlayerDiscordId(playerId)
    for _, identifier in ipairs(GetPlayerIdentifiers(playerId)) do
        if identifier:find("discord:") then
            return identifier:gsub("discord:", "")
        end
    end
    return "Unknown"
end

function getPlayerDiscord(playerId)
    local discordId = getPlayerDiscordId(playerId)
    return discordId ~= "Unknown" and ("<@" .. discordId .. ">") or "Not Found"
end

function getPlayerInfo(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if not xPlayer then return nil end
    return {
        identifier = xPlayer.getIdentifier(),
        name = xPlayer.getName(),
        discord = getPlayerDiscord(playerId),
        discordId = getPlayerDiscordId(playerId),
        status = TranslateCap('webhook_status_online')
    }
end

function getOfflinePlayerInfo(identifier, name)
    return {
        identifier = identifier,
        name = name or "Unknown",
        discord = "Unknown",
        discordId = "Unknown",
        status = TranslateCap('webhook_status_offline')
    }
end

function getLogo(jobname)
    local logo = Config.Jobs[jobname] and Config.Jobs[jobname].logo
    if logo and logo:find("http") then return logo end
    return "https://imgur.com/ICZpr7I.png"
end

-- Haupt Discord Log Funktion
function sendDiscordLog(webhookType, data)
    local webhook = getJobWebhook(data.job, webhookType)
    if not webhook or webhook == "" then return end
    
    local embed = createEmbed(webhookType, data)
    if not embed then return end
    
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
        username = "Boss Menu Logger • " .. data.job:upper(),
        avatar_url = getLogo(data.job),
        embeds = {embed}
    }), {['Content-Type'] = 'application/json'})
end

-- Embed Creator
function createEmbed(type, data)
    local embeds = {
        hire = {
            title = "**" .. TranslateCap('webhook_hire_title') .. "**",
            color = 5763719, -- Grün
            fields = {
                {name = TranslateCap('webhook_hire_employee'), value = (data.target and (data.target.name .. "\n`" .. data.target.identifier .. "`")) or TranslateCap('webhook_unknown'), inline = true},
                {name = TranslateCap('webhook_hire_by'), value = (data.executor and (data.executor.name .. "\n" .. data.executor.discord)) or TranslateCap('webhook_unknown'), inline = true},
                {name = TranslateCap('webhook_hire_position'), value = (data.job or TranslateCap('webhook_unknown')) .. " - " .. (data.grade_name or TranslateCap('webhook_unknown')), inline = false},
                {name = TranslateCap('webhook_hire_salary'), value = "$" .. ESX.Math.GroupDigits(data.salary or 0), inline = true}
            }
        },
        
        fire = {
            title = "**" .. TranslateCap('webhook_fire_title') .. "**",
            color = 15158332, -- Rot
            fields = {
                {name = TranslateCap('webhook_fire_employee'), value = (data.target and (data.target.name .. "\n`" .. data.target.identifier .. "`")) or TranslateCap('webhook_unknown'), inline = true},
                {name = TranslateCap('webhook_fire_by'), value = (data.executor and (data.executor.name .. "\n" .. data.executor.discord)) or TranslateCap('webhook_unknown'), inline = true},
                {name = TranslateCap('webhook_fire_company'), value = data.job or TranslateCap('webhook_unknown'), inline = false}
            }
        },
        
        promote = {
            title = "**" .. TranslateCap('webhook_promote_title') .. "**",
            color = 3447003, -- Blau
            fields = {
                {name = TranslateCap('webhook_promote_employee'), value = (data.target and (data.target.name .. "\n`" .. data.target.identifier .. "`")) or TranslateCap('webhook_unknown'), inline = true},
                {name = TranslateCap('webhook_promote_by'), value = (data.executor and (data.executor.name .. "\n" .. data.executor.discord)) or TranslateCap('webhook_unknown'), inline = true},
                {name = TranslateCap('webhook_promote_company'), value = data.job or TranslateCap('webhook_unknown'), inline = false},
                {name = TranslateCap('webhook_promote_old_rank'), value = TranslateCap('webhook_level') .. " " .. (data.old_grade or "?") .. " - " .. (data.old_grade_name or TranslateCap('webhook_unknown')), inline = true},
                {name = TranslateCap('webhook_promote_new_rank'), value = TranslateCap('webhook_level') .. " " .. (data.new_grade or "?") .. " - " .. (data.new_grade_name or TranslateCap('webhook_unknown')), inline = true},
                {name = TranslateCap('webhook_promote_new_salary'), value = "$" .. ESX.Math.GroupDigits(data.new_salary or 0), inline = false}
            }
        },

        demote = {
            title = "**" .. TranslateCap('webhook_demote_title') .. "**",
            color = 15105570, -- Orange
            fields = {
                {name = TranslateCap('webhook_demote_employee'), value = (data.target and (data.target.name .. "\n`" .. data.target.identifier .. "`")) or TranslateCap('webhook_unknown'), inline = true},
                {name = TranslateCap('webhook_demote_by'), value = (data.executor and (data.executor.name .. "\n" .. data.executor.discord)) or TranslateCap('webhook_unknown'), inline = true},
                {name = TranslateCap('webhook_demote_company'), value = data.job or TranslateCap('webhook_unknown'), inline = false},
                {name = TranslateCap('webhook_demote_old_rank'), value = TranslateCap('webhook_level') .. " " .. (data.old_grade or "?") .. " - " .. (data.old_grade_name or TranslateCap('webhook_unknown')), inline = true},
                {name = TranslateCap('webhook_demote_new_rank'), value = TranslateCap('webhook_level') .. " " .. (data.new_grade or "?") .. " - " .. (data.new_grade_name or TranslateCap('webhook_unknown')), inline = true},
                {name = TranslateCap('webhook_demote_new_salary'), value = "$" .. ESX.Math.GroupDigits(data.new_salary or 0), inline = false}
            }
        },
        
        deposit = {
            title = "**" .. TranslateCap('webhook_deposit_title') .. "**",
            color = 5763719, -- Grün
            fields = {
                {name = TranslateCap('webhook_deposit_by'), value = (data.executor and (data.executor.name .. "\n" .. data.executor.discord)) or TranslateCap('webhook_unknown'), inline = true},
                {name = TranslateCap('webhook_deposit_company'), value = data.job or TranslateCap('webhook_unknown'), inline = true},
                {name = TranslateCap('webhook_deposit_amount'), value = "$" .. ESX.Math.GroupDigits(data.amount or 0), inline = false},
                {name = TranslateCap('webhook_deposit_balance'), value = "$" .. ESX.Math.GroupDigits(data.new_balance or 0), inline = false}
            }
        },
        
        withdraw = {
            title = "**" .. TranslateCap('webhook_withdraw_title') .. "**",
            color = 15105570, -- Orange
            fields = {
                {name = TranslateCap('webhook_withdraw_by'), value = (data.executor and (data.executor.name .. "\n" .. data.executor.discord)) or TranslateCap('webhook_unknown'), inline = true},
                {name = TranslateCap('webhook_withdraw_company'), value = data.job or TranslateCap('webhook_unknown'), inline = true},
                {name = TranslateCap('webhook_withdraw_amount'), value = "$" .. ESX.Math.GroupDigits(data.amount or 0), inline = false},
                {name = TranslateCap('webhook_withdraw_balance'), value = "$" .. ESX.Math.GroupDigits(data.new_balance or 0), inline = false}
            }
        },
        
        salary = {
            title = "**" .. TranslateCap('webhook_salary_title') .. "**",
            color = 10181046, -- Purple
            fields = {
                {name = TranslateCap('webhook_changed_by'), value = (data.executor and (data.executor.name .. "\n" .. data.executor.discord)) or TranslateCap('webhook_unknown'), inline = true},
                {name = TranslateCap('webhook_position'), value = (data.job or TranslateCap('webhook_unknown')) .. " - " .. (data.grade_name or TranslateCap('webhook_unknown')), inline = false},
                {name = TranslateCap('webhook_salary_previous'), value = "$" .. ESX.Math.GroupDigits(data.old_salary or 0), inline = true},
                {name = TranslateCap('webhook_salary_new'), value = "$" .. ESX.Math.GroupDigits(data.new_salary or 0), inline = true},
                {name = TranslateCap('webhook_salary_difference'), value = ((data.new_salary or 0) > (data.old_salary or 0) and "+" or "") .. "$" .. ESX.Math.GroupDigits((data.new_salary or 0) - (data.old_salary or 0)), inline = false}
            }
        },
        
        bonus = {
            title = "**" .. TranslateCap('webhook_bonus_title') .. "**",
            color = 15844367, -- Gold
            fields = {
                {name = TranslateCap('webhook_paid_by'), value = (data.executor and (data.executor.name .. "\n" .. data.executor.discord)) or TranslateCap('webhook_unknown'), inline = true},
                {name = TranslateCap('webhook_company'), value = data.job or TranslateCap('webhook_unknown'), inline = true},
                {name = TranslateCap('webhook_bonus_type'), value = data.bonus_type or TranslateCap('webhook_unknown'), inline = false},
                {name = TranslateCap('webhook_bonus_per_person'), value = "$" .. ESX.Math.GroupDigits(data.amount or 0), inline = true},
                {name = TranslateCap('webhook_recipients_count'), value = (data.recipients_count or 0) .. " " .. TranslateCap('webhook_employees'), inline = true},
                {name = TranslateCap('webhook_total_cost'), value = "$" .. ESX.Math.GroupDigits((data.amount or 0) * (data.recipients_count or 0)), inline = false},
                {name = TranslateCap('webhook_new_balance'), value = "$" .. ESX.Math.GroupDigits(data.new_balance or 0), inline = false},
            }
        }
    }
    
    local embed = embeds[type]
    if not embed then return nil end
    
    embed.thumbnail = {url = getLogo(data.job)}
    embed.footer = {
        text = TranslateCap('webhook_footer_text') .. " • " .. data.job:upper(),
        icon_url = "https://imgur.com/ICZpr7I.png"
    }
    embed.timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    
    return embed
end

-- Einfache Verwendungs-Funktionen
function logHire(executorId, targetData, job, grade, gradeName, salary)
    local executor = getPlayerInfo(executorId)
    if not executor then return end
    
    sendDiscordLog("hire", {
        executor = executor,
        target = targetData,
        job = job,
        grade = grade,
        grade_name = gradeName,
        salary = salary
    })
end

function logFire(executorId, targetData, job, reason)
    local executor = getPlayerInfo(executorId)
    if not executor then return end
    
    sendDiscordLog("fire", {
        executor = executor,
        target = targetData,
        job = job,
        reason = reason
    })
end

function logPromotion(executorId, targetData, job, oldGrade, oldGradeName, newGrade, newGradeName, oldSalary, newSalary)
    local executor = getPlayerInfo(executorId)
    if not executor then return end
    
    sendDiscordLog("promote", {
        executor = executor,
        target = targetData,
        job = job,
        old_grade = oldGrade,
        old_grade_name = oldGradeName,
        new_grade = newGrade,
        new_grade_name = newGradeName,
        old_salary = oldSalary,
        new_salary = newSalary
    })
end

function logDemotion(executorId, targetData, job, oldGrade, oldGradeName, newGrade, newGradeName, oldSalary, newSalary)
    local executor = getPlayerInfo(executorId)
    if not executor then return end

    sendDiscordLog("demote", {
        executor = executor,
        target = targetData,
        job = job,
        old_grade = oldGrade,
        old_grade_name = oldGradeName,
        new_grade = newGrade,
        new_grade_name = newGradeName,
        old_salary = oldSalary,
        new_salary = newSalary
    })
end

function logDeposit(executorId, job, amount, newBalance)
    local executor = getPlayerInfo(executorId)
    if not executor then return end
    
    sendDiscordLog("deposit", {
        executor = executor,
        job = job,
        amount = amount,
        new_balance = newBalance
    })
end

function logWithdraw(executorId, job, amount, newBalance)
    local executor = getPlayerInfo(executorId)
    if not executor then return end
    
    sendDiscordLog("withdraw", {
        executor = executor,
        job = job,
        amount = amount,
        new_balance = newBalance
    })
end

function logSalaryChange(executorId, targetData, job, gradeName, oldSalary, newSalary)
    local executor = getPlayerInfo(executorId)
    if not executor then return end
    
    sendDiscordLog("salary", {
        executor = executor,
        target = targetData,
        job = job,
        grade_name = gradeName,
        old_salary = oldSalary,
        new_salary = newSalary
    })
end

-- Bonus Logging Funktionen
function logBonus(executorId, job, bonusType, amount, recipientsCount, newBalance, details, specificTargets)
    local executor = getPlayerInfo(executorId)
    if not executor then return end
    
    local bonusTypeNames = {
        all_employees = TranslateCap('webhook_bonus_all_employees'),
        specific_employees = TranslateCap('webhook_bonus_specific_employees'),
        all_grades = TranslateCap('webhook_bonus_all_grades'),
        specific_grades = TranslateCap('webhook_bonus_specific_grades'),
        online_employees = TranslateCap('webhook_bonus_online_employees')
    }
    
    local bonusData = {
        executor = executor,
        job = job,
        bonus_type = bonusTypeNames[bonusType] or bonusType,
        amount = amount,
        recipients_count = recipientsCount,
        new_balance = newBalance,
        details = details
    }
    
    -- Wenn spezifische Ziele vorhanden sind, füge sie zu den Details hinzu
    if specificTargets and #specificTargets > 0 then
        local targetNames = {}
        for _, target in ipairs(specificTargets) do
            table.insert(targetNames, target.name or target.identifier)
        end
        bonusData.details = (details or "") .. "\n**" .. TranslateCap('webhook_recipients') .. ":** " .. table.concat(targetNames, ", ")
    end
    
    sendDiscordLog("bonus", bonusData)
end

-- Spezifische Bonus Funktionen für jeden Typ
function logBonusAllEmployees(executorId, job, amount, recipientsCount, newBalance, reason)
    logBonus(executorId, job, "all_employees", amount, recipientsCount, newBalance, 
             reason or TranslateCap('webhook_bonus_default_all'))
end

function logBonusSpecificEmployees(executorId, job, amount, targets, newBalance, reason)
    logBonus(executorId, job, "specific_employees", amount, #targets, newBalance, 
             reason or TranslateCap('webhook_bonus_default_specific'), targets)
end

function logBonusAllGrades(executorId, job, amount, recipientsCount, newBalance, reason)
    logBonus(executorId, job, "all_grades", amount, recipientsCount, newBalance, 
             reason or TranslateCap('webhook_bonus_default_grades'))
end

function logBonusSpecificGrades(executorId, job, amount, grades, recipientsCount, newBalance, reason)
    local gradeNames = {}
    for _, grade in ipairs(grades) do
        table.insert(gradeNames, grade.name)
    end
    
    local executor = getPlayerInfo(executorId)
    if not executor then return end
    
    local bonusData = {
        executor = executor,
        job = job,
        bonus_type = TranslateCap('webhook_bonus_specific_grades'),
        amount = amount,
        recipients_count = recipientsCount,
        new_balance = newBalance,
        details = reason or TranslateCap('webhook_bonus_default_grades')
    }
    
    sendDiscordLog("bonus", bonusData)
end

function logBonusOnlineEmployees(executorId, job, amount, recipientsCount, newBalance, reason)
    logBonus(executorId, job, "online_employees", amount, recipientsCount, newBalance, 
             reason or TranslateCap('webhook_bonus_default_online'))
end
