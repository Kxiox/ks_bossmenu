--[[
    https://github.com/kxiox/ks_bossmenu

    This file is licensed under GPL-3.0 or higher <https://www.gnu.org/licenses/gpl-3.0.en.html>

    Copyright © 2025 Kxiox <https://github.com/kxiox>
]]

local isBeta = false

Citizen.CreateThread(function()
    local curVersion = GetResourceMetadata(GetCurrentResourceName(), 'version', 0)
    if curVersion and string.find(curVersion, "^beta%-") then
        isBeta = true
    end

    local updatePath = "/Kxiox/ks_versions"
    local resourceName = "ks_bossmenu ("..GetCurrentResourceName()..")"

    local RED = "^1"
    local GREEN = "^2"
    local YELLOW = "^3"
    local RESET = "^7"

    function checkVersion(err, responseText, headers)
        local curVersion = GetResourceMetadata(GetCurrentResourceName(), 'version', 0)

        if curVersion and string.find(curVersion, "dev") then
            print(YELLOW..resourceName.." is running a development version ("..curVersion.."). Skipping version check."..RESET)
            return
        end

        local function parseVersion(version)
            local isBeta = false
            local numbers = version
            if string.find(version, "^beta%-") then
                isBeta = true
                numbers = string.sub(version, 6)
            end
            local t = {}
            for num in string.gmatch(numbers or "", "%d+") do
                table.insert(t, tonumber(num))
            end
            return isBeta, t
        end

        local function compareVersions(v1, v2)
            local beta1, a = parseVersion(v1)
            local beta2, b = parseVersion(v2)
            
            if beta1 ~= beta2 then
                if beta1 then return -1 else return 1 end
            end
            for i = 1, math.max(#a, #b) do
                local n1, n2 = a[i] or 0, b[i] or 0
                if n1 < n2 then return -1 end
                if n1 > n2 then return 1 end
            end
            return 0
        end

        if isBeta then
            print(YELLOW..resourceName.." is running in BETA mode. You may encounter bugs or unfinished features."..RESET)
        end

        local cmp = compareVersions(curVersion, responseText)
        if cmp < 0 then
            print(RED.."###############################"..RESET)
            print("\n"..RED..resourceName.." is outdated. Latest version: "..responseText.."\nCurrent version: "..curVersion.."\nPlease update from: https://github.com/Kxiox/ks_bossmenu/releases"..RESET)
            print("\n"..RED.."###############################"..RESET)
        elseif cmp > 0 then
            print(YELLOW.."You are running a newer version of "..resourceName..". If the GitHub repository is still online, consider updating or downgrading as needed."..RESET)
        else
            print(GREEN..resourceName.." is up to date. Enjoy!"..RESET)
        end
    end

    local latestStableVersion = nil
    local latestBetaVersion = nil
    local requestsCompleted = 0

    local function checkBothVersions()
        requestsCompleted = requestsCompleted + 1
        
        if requestsCompleted < 2 then return end

        local curVersion = GetResourceMetadata(GetCurrentResourceName(), 'version', 0)
        local latestVersion = latestStableVersion

        if curVersion and string.find(curVersion, "^beta%-") then
            if latestBetaVersion then
                latestVersion = latestBetaVersion
            end
        else
            if not latestStableVersion and latestBetaVersion then
                latestVersion = latestBetaVersion
            end
        end

        if latestVersion then
            checkVersion(nil, latestVersion, nil)
        else
            print(RED.."[ERROR] No version information found from GitHub repositories."..RESET)
        end
    end

    local function checkStableVersion(httpCode, responseText, headers)
        if httpCode == 200 and responseText and responseText ~= "" then
            latestStableVersion = responseText:gsub("%s+", "") -- Entferne Whitespace
        end
        checkBothVersions()
    end

    local function checkBetaVersion(httpCode, responseText, headers)
        if httpCode == 200 and responseText and responseText ~= "" then
            latestBetaVersion = responseText:gsub("%s+", "") -- Entferne Whitespace
        end
        checkBothVersions()
    end

    PerformHttpRequest("https://raw.githubusercontent.com"..updatePath.."/master/ks_bossmenu", checkStableVersion, "GET")
    PerformHttpRequest("https://raw.githubusercontent.com"..updatePath.."/master/ks_bossmenu_beta", checkBetaVersion, "GET")
end)