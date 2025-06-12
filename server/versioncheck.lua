Citizen.CreateThread(function()
    updatePath = "/Kxiox/ks_bossmenu_testv"
    resourceName = "ks_bossmenu ("..GetCurrentResourceName()..")"

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

        local function splitVersion(version)
            local t = {}
            for num in string.gmatch(version or "", "%d+") do
                table.insert(t, tonumber(num))
            end
            return t
        end

        local function compareVersions(v1, v2)
            local a, b = splitVersion(v1), splitVersion(v2)
            for i = 1, math.max(#a, #b) do
                local n1, n2 = a[i] or 0, b[i] or 0
                if n1 < n2 then return -1 end
                if n1 > n2 then return 1 end
            end
            return 0
        end

        local cmp = compareVersions(curVersion, responseText)
        if cmp < 0 then
            print(RED.."###############################"..RESET)
            print("\n"..RED..resourceName.." is outdated. Latest version: "..responseText.."\nCurrent version: "..curVersion.."\nPlease update from: https://github.com"..updatePath..RESET)
            print("\n"..RED.."###############################"..RESET)
        elseif cmp > 0 then
            print(YELLOW.."You are running a newer version of "..resourceName..". If the GitHub repository is still online, consider updating or downgrading as needed."..RESET)
        else
            print(GREEN..resourceName.." is up to date. Enjoy!"..RESET)
        end
    end

    PerformHttpRequest("https://raw.githubusercontent.com"..updatePath.."/master/version", checkVersion, "GET")
end)