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

ESX.RegisterServerCallback('ks_bossmenu:getEmployeesList', function(source, cb, jobName)
    MySQL.query('SELECT identifier, firstname, lastname, job_grade FROM users WHERE job = ?', {
        jobName
    }, function(result)
        local employees = {}

        for _, row in ipairs(result) do
            table.insert(employees, {
                identifier = row.identifier,
                firstname = row.firstname,
                lastname = row.lastname,
                jobgrade = getGradeLabel(row.job_grade, jobName),
                jobgradenr = row.job_grade,
                salary = getSalary(row.job_grade, jobName)
            })
        end

        cb(employees)
    end)
end)

ESX.RegisterServerCallback('ks_bossmenu:getSalaries', function(source, cb, jobName)
    
    local salaries = {}
    local results = MySQL.query.await('SELECT label, grade, salary FROM job_grades WHERE job_name = ?', {
        jobName
    })
    if results then
        for _, row in ipairs(results) do
            table.insert(salaries, {
                grade = row.grade,
                label = row.label,
                salary = row.salary,
            })
        end
    end
    local salary = salaries

    cb(salary)
end)

ESX.RegisterServerCallback('ks_bossmenu:getActionsList', function(source, cb, jobName)
    MySQL.query('SELECT * FROM ks_bossmenu_actions WHERE job = ?', {
        jobName
    }, function(result)
        local actions = {}

        for _, row in ipairs(result) do
            table.insert(actions, {
                id = row.id,
                action = row.action,
                employee = row.employee,
                time = row.time,
                data = row.data,
            })
        end

        cb(actions)
    end)
end)

ESX.RegisterServerCallback('ks_bossmenu:getTransactionsList', function(source, cb, jobName)
    MySQL.query('SELECT * FROM ks_bossmenu_transactions WHERE job = ?', {
        jobName
    }, function(result)
        local transactions = {}

        for _, row in ipairs(result) do
            table.insert(transactions, {
                id = row.id,
                action = row.action,
                employee = row.employee,
                amount = string.gsub(ESX.Math.GroupDigits(row.amount), ",", ".") .. Config.Currency,
                time = row.time,
            })
        end

        cb(transactions)
    end)
end)

ESX.RegisterServerCallback('ks_bossmenu:addEmployee', function(source, cb, data)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(data.message)

    if IsPlayerAllowed(source) then
        if xTarget and xTarget.getJob().name ~= xPlayer.getJob().name then
            xTarget.setJob(xPlayer.getJob().name, 0)
            addAction(source, {
                action = 'add_employee',
                data = {
                    target = xTarget.getName(),
                }
            })

            cb(true)
        else
            cb(false)
        end
    end
end)

ESX.RegisterServerCallback('ks_bossmenu:promoteEmployee', function(source, cb, data)
    local xPlayer = ESX.GetPlayerFromId(source)
    local targetFirstname = data['employee'].firstname
    local targetLastname = data['employee'].lastname
    local targetJobGrade = data['employee'].jobgradenr
    local targetIdentifier = data['employee'].identifier

    print(targetIdentifier)

    if IsPlayerAllowed(source) then
        if xPlayer.getIdentifier() == targetIdentifier then
            cb('self_promote')
            return
        end

        local highestGrade = MySQL.single.await('SELECT MAX(grade) as max_grade FROM job_grades WHERE job_name = ?', {
            xPlayer.getJob().name
        })

        if targetJobGrade == highestGrade.max_grade then
            cb('highest_grade')
            return
        end

        local targetJob = MySQL.single.await('SELECT job FROM users WHERE identifier = ?', {
            targetIdentifier
        })

        if targetJob.job ~= xPlayer.getJob().name then
            cb('not_same_job')
            return
        end

        MySQL.update('UPDATE users SET job_grade = job_grade + 1 WHERE identifier = ?', {
            targetIdentifier
        }, function(affectedRows)
            if affectedRows > 0 then
                local newGrade = MySQL.single.await('SELECT label FROM job_grades WHERE job_name = ? AND grade = ?', {
                    xPlayer.getJob().name, targetJobGrade + 1
                })

                addAction(source, {
                    action = 'promote_employee',
                    data = {
                        target = targetFirstname .. ' ' .. targetLastname,
                        new_grade = newGrade.label,
                    }
                })

                cb('success')
            else
                cb('error')
            end
        end)
    end
end)

ESX.RegisterServerCallback('ks_bossmenu:demoteEmployee', function(source, cb, data)
    local xPlayer = ESX.GetPlayerFromId(source)
    local targetFirstname = data['employee'].firstname
    local targetLastname = data['employee'].lastname
    local targetJobGrade = data['employee'].jobgradenr
    local targetIdentifier = data['employee'].identifier

    if IsPlayerAllowed(source) then
        if xPlayer.getIdentifier() == targetIdentifier then
            cb('self_demote')
            return
        end

        local lowestGrade = MySQL.single.await('SELECT MIN(grade) as min_grade FROM job_grades WHERE job_name = ?', {
            xPlayer.getJob().name
        })

        if targetJobGrade == lowestGrade.min_grade then
            cb('lowest_grade')
            return
        end

        local targetJob = MySQL.single.await('SELECT job FROM users WHERE identifier = ?', {
            targetIdentifier
        })

        if targetJob.job ~= xPlayer.getJob().name then
            cb('not_same_job')
            return
        end

        MySQL.update('UPDATE users SET job_grade = job_grade - 1 WHERE identifier = ?', {
            targetIdentifier
        }, function(affectedRows)
            if affectedRows > 0 then
                local newGrade = MySQL.single.await('SELECT label FROM job_grades WHERE job_name = ? AND grade = ?', {
                    xPlayer.getJob().name, targetJobGrade - 1
                })

                addAction(source, {
                    action = 'demote_employee',
                    data = {
                        target = targetFirstname .. ' ' .. targetLastname,
                        new_grade = newGrade.label,
                    }
                })

                cb('success')
            else
                cb('error')
            end
        end)
    end
end)

ESX.RegisterServerCallback('ks_bossmenu:fireEmployee', function(source, cb, data)
    local xPlayer = ESX.GetPlayerFromId(source)
    local targetFirstname = data['employee'].firstname
    local targetLastname = data['employee'].lastname
    local targetIdentifier = data['employee'].identifier

    if IsPlayerAllowed(source) then
        if xPlayer.getIdentifier() == targetIdentifier then
            cb('self_fire')
            return
        end

        local targetJob = MySQL.single.await('SELECT job FROM users WHERE identifier = ?', {
            targetIdentifier
        })

        if targetJob.job ~= xPlayer.getJob().name then
            cb('not_same_job')
            return
        end

        MySQL.update('UPDATE users SET job = ?, job_grade = ? WHERE identifier = ?', {
            Config.UnemployedJobName, 0, targetIdentifier
        }, function(affectedRows)
            if affectedRows > 0 then
                addAction(source, {
                    action = 'fire_employee',
                    data = {
                        target = targetFirstname .. ' ' .. targetLastname,
                    }
                })
                cb('success')
            else
                cb('error')
            end
        end)
    end
end)

ESX.RegisterServerCallback('ks_bossmenu:changeSalary', function(source, cb, data)
    local xPlayer = ESX.GetPlayerFromId(source)

    if IsPlayerAllowed(source) then
        local grade = tonumber(data.grade)
        local salary = tonumber(data.salary)

        if grade and salary then
            MySQL.update('UPDATE job_grades SET salary = ? WHERE job_name = ? AND grade = ?', {
                salary, xPlayer.getJob().name, grade
            }, function(affectedRows)
                if affectedRows > 0 then
                    addAction(source, {
                        action = 'change_salary',
                        data = {
                            grade = getGradeLabel(grade, xPlayer.getJob().name),
                            salary = salary,
                        }
                    })
                    cb(true)
                else
                    cb(false)
                end
            end)
        else
            cb(false)
        end
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('ks_bossmenu:depositMoney', function(source, cb, data)
    
end)

function getSalary(grade, jobName)
    local result = MySQL.single.await('SELECT salary FROM job_grades WHERE job_name = ? AND grade = ?', {
        jobName, grade
    })

    if result then
        return result.salary or 0
    else
        return 0
    end
end

function getGradeLabel(grade, jobName)
    local result = MySQL.single.await('SELECT label FROM job_grades WHERE job_name = ? AND grade = ?', {
        jobName, grade
    })

    if result then
        return result.label or ''
    else
        return ''
    end
    
end

function IsPlayerAllowed(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    for k, v in pairs(Config.Jobs) do
        if xPlayer.getJob().name == k then
            if tableContains(v.grades, xPlayer.getJob().grade) then
                return true
            end
        end
    end

    return false
end

function tableContains(tbl, val)
    for _, v in ipairs(tbl) do
        if v == val then
            return true
        end
    end

    return false
end