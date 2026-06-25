ESX = exports['es_extended']:getSharedObject()

local function isTrackedJob(job)
    return Config.Jobs[job] ~= nil
end

local function formatDuration(seconds)
    seconds = tonumber(seconds) or 0
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)

    return string.format('%02dh %02dm', hours, minutes)
end

local function getFullName(firstname, lastname, fallback)
    local name = ('%s %s'):format(firstname or '', lastname or ''):gsub('^%s+', ''):gsub('%s+$', '')

    if name ~= '' then
        return name
    end

    return fallback
end

ESX.RegisterServerCallback('esx_time_tracking:startTime', function(source, cb, identifier, job)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not isTrackedJob(job) or xPlayer.getIdentifier() ~= identifier then
        cb(false)
        return
    end

    local openEntry = MySQL.single.await('SELECT 1 AS open FROM ks_bossmenu_time_tracking WHERE identifier = ? AND job = ? AND time_end = 0 LIMIT 1', {
        identifier,
        job
    })

    if openEntry then
        cb(true)
        return
    end

    MySQL.insert('INSERT INTO ks_bossmenu_time_tracking (identifier, job, time_start, time_end) VALUES (?, ?, ?, ?)', {
        identifier,
        job,
        os.time(),
        0
    }, function(rowsChanged)
        cb(rowsChanged > 0)
    end)
end)

ESX.RegisterServerCallback('esx_time_tracking:endTime', function(source, cb, identifier, job)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not isTrackedJob(job) or xPlayer.getIdentifier() ~= identifier then
        cb(false)
        return
    end

    MySQL.update('UPDATE ks_bossmenu_time_tracking SET time_end = ? WHERE identifier = ? AND job = ? AND time_end = 0', {
        os.time(),
        identifier,
        job
    }, function(rowsChanged)
        cb(rowsChanged > 0)
    end)
end)

ESX.RegisterServerCallback('ks_bossmenu:getTimeTrackingList', function(source, cb, jobName)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or xPlayer.getJob().name ~= jobName then
        cb({}, {})
        return
    end

    if not Config.JobCreator and not IsPlayerAllowed(source) then
        cb({}, {})
        return
    end

    local now = os.time()
    local employeeRows = MySQL.query.await([[
        SELECT identifier, firstname, lastname, job_grade
        FROM users
        WHERE job = ?
    ]], {
        jobName
    }) or {}

    local sessionRows = MySQL.query.await([[
        SELECT identifier, time_start, time_end
        FROM ks_bossmenu_time_tracking
        WHERE job = ?
        ORDER BY time_start DESC
        LIMIT 1000
    ]], {
        jobName
    }) or {}

    local employees = {}
    local employeeByIdentifier = {}
    local totalSeconds = 0
    local activeCount = 0
    local trackedCount = 0
    local sessionCount = 0
    local activeDayKeys = {}

    for _, row in ipairs(employeeRows) do
        local employee = {
            identifier = row.identifier,
            name = getFullName(row.firstname, row.lastname, row.identifier),
            jobgrade = getGradeLabel(row.job_grade, jobName),
            jobgradenr = row.job_grade,
            totalSeconds = 0,
            totalLabel = formatDuration(0),
            sessionCount = 0,
            dayCount = 0,
            avgSessionSeconds = 0,
            avgSessionLabel = formatDuration(0),
            avgDaySeconds = 0,
            avgDayLabel = formatDuration(0),
            firstActivity = 0,
            lastActivity = 0,
            lastStart = 0,
            active = false,
            sessions = {},
            days = {},
        }

        employeeByIdentifier[row.identifier] = employee
        table.insert(employees, employee)
    end

    for _, row in ipairs(sessionRows) do
        local employee = employeeByIdentifier[row.identifier]

        if employee then
            local startTime = tonumber(row.time_start) or 0
            local endTime = tonumber(row.time_end) or 0
            local isActive = endTime == 0
            local effectiveEnd = isActive and now or endTime
            local duration = math.max(effectiveEnd - startTime, 0)
            local dayKey = os.date('%Y-%m-%d', startTime)

            employee.totalSeconds = employee.totalSeconds + duration
            employee.sessionCount = employee.sessionCount + 1
            employee.lastStart = math.max(employee.lastStart, startTime)
            employee.lastActivity = math.max(employee.lastActivity, effectiveEnd)

            if employee.firstActivity == 0 or startTime < employee.firstActivity then
                employee.firstActivity = startTime
            end

            if isActive then
                employee.active = true
            end

            if not employee._daysByKey then
                employee._daysByKey = {}
            end

            if not employee._daysByKey[dayKey] then
                employee._daysByKey[dayKey] = {
                    date = dayKey,
                    totalSeconds = 0,
                    totalLabel = formatDuration(0),
                    sessionCount = 0,
                    firstStart = startTime,
                    lastEnd = effectiveEnd,
                    active = false,
                }
            end

            local day = employee._daysByKey[dayKey]
            day.totalSeconds = day.totalSeconds + duration
            day.sessionCount = day.sessionCount + 1
            day.firstStart = math.min(day.firstStart, startTime)
            day.lastEnd = math.max(day.lastEnd, effectiveEnd)
            day.active = day.active or isActive

            if employee.sessionCount <= 50 then
                table.insert(employee.sessions, {
                    time_start = startTime,
                    time_end = endTime,
                    duration = duration,
                    durationLabel = formatDuration(duration),
                    day = dayKey,
                    active = isActive,
                })
            end

            totalSeconds = totalSeconds + duration
            sessionCount = sessionCount + 1
            activeDayKeys[dayKey] = true
        end
    end

    for _, employee in ipairs(employees) do
        if employee.sessionCount > 0 then
            trackedCount = trackedCount + 1
            employee.avgSessionSeconds = math.floor(employee.totalSeconds / employee.sessionCount)
            employee.avgSessionLabel = formatDuration(employee.avgSessionSeconds)
        end

        if employee.active then
            activeCount = activeCount + 1
        end

        if employee._daysByKey then
            for _, day in pairs(employee._daysByKey) do
                day.totalLabel = formatDuration(day.totalSeconds)
                table.insert(employee.days, day)
            end
        end

        table.sort(employee.days, function(a, b)
            return a.date > b.date
        end)

        table.sort(employee.sessions, function(a, b)
            return a.time_start > b.time_start
        end)

        employee.dayCount = #employee.days
        if employee.dayCount > 0 then
            employee.avgDaySeconds = math.floor(employee.totalSeconds / employee.dayCount)
            employee.avgDayLabel = formatDuration(employee.avgDaySeconds)
        end

        employee.totalLabel = formatDuration(employee.totalSeconds)
        employee._daysByKey = nil
    end

    table.sort(employees, function(a, b)
        if a.totalSeconds == b.totalSeconds then
            return a.lastActivity > b.lastActivity
        end

        return a.totalSeconds > b.totalSeconds
    end)

    local activeDayCount = 0
    for _ in pairs(activeDayKeys) do
        activeDayCount = activeDayCount + 1
    end

    cb(employees, {
        totalSeconds = totalSeconds,
        totalLabel = formatDuration(totalSeconds),
        averageSessionLabel = formatDuration(sessionCount > 0 and math.floor(totalSeconds / sessionCount) or 0),
        averageDayLabel = formatDuration(activeDayCount > 0 and math.floor(totalSeconds / activeDayCount) or 0),
        activeCount = activeCount,
        employeeCount = #employees,
        trackedCount = trackedCount,
        sessionCount = sessionCount,
        activeDayCount = activeDayCount,
    })
end)

AddEventHandler('playerDropped', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local job = xPlayer.getJob().name
    if not isTrackedJob(job) then return end

    MySQL.update('UPDATE ks_bossmenu_time_tracking SET time_end = ? WHERE identifier = ? AND job = ? AND time_end = 0', {
        os.time(),
        xPlayer.getIdentifier(),
        job
    })
end)

RegisterCommand('ks_bossmenu_seed_time_tracking', function(source, args)
    if source ~= 0 then
        print('[ks_bossmenu] This command can only be used from the server console.')
        return
    end

    local jobName = args[1] or 'police'
    if not isTrackedJob(jobName) then
        print(('[ks_bossmenu] Cannot seed time tracking: job "%s" is not configured.'):format(jobName))
        return
    end

    local employees = MySQL.query.await('SELECT identifier FROM users WHERE job = ? LIMIT 10', {
        jobName
    }) or {}

    if #employees == 0 then
        print(('[ks_bossmenu] Cannot seed time tracking: no users found for job "%s".'):format(jobName))
        return
    end

    local now = os.time()
    local inserted = 0

    for index, employee in ipairs(employees) do
        for day = 1, 6 do
            local startTime = now - (day * 86400) - (index * 900)
            local duration = (3600 + (day * 900) + (index * 600))
            local endTime = startTime + duration

            MySQL.insert.await('INSERT INTO ks_bossmenu_time_tracking (identifier, job, time_start, time_end) VALUES (?, ?, ?, ?)', {
                employee.identifier,
                jobName,
                startTime,
                endTime
            })

            inserted = inserted + 1
        end
    end

    print(('[ks_bossmenu] Seeded %s time tracking test entries for job "%s".'):format(inserted, jobName))
end, true)
