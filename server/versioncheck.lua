Citizen.CreateThread(function()
    updatePath = "/Kxiox/ks_bossmenu"
    resourceName = "ks_bossmenu ("..GetCurrentResourceName()..")"

    local RED = "^1"
    local GREEN = "^2"
    local YELLOW = "^3"
    local RESET = "^7"

    function checkVersion(err, responseText, headers)
        curVersion = LoadResourceFile(GetCurrentResourceName(), "version")

        if curVersion and string.find(curVersion, "dev") then
            print("\n"..YELLOW..resourceName.." is running a development version ("..curVersion.."). Version check skipped."..RESET)
            return
        end

        if curVersion ~= responseText and tonumber(curVersion) < tonumber(responseText) then
            print("\n"..RED.."###############################"..RESET)
            print("\n"..RED..resourceName.." is outdated, should be:\n"..responseText.."is:\n"..curVersion.."\nplease update it from https://github.com"..updatePath..""..RESET)
            print("\n"..RED.."###############################"..RESET)
        elseif tonumber(curVersion) > tonumber(responseText) then
            print(YELLOW.."You somehow skipped a few versions of "..resourceName.." or the git went offline, if it's still online i advise you to update ( or downgrade? )"..RESET)
        else
            print("\n"..GREEN..resourceName.." is up to date, have fun!"..RESET)
        end
    end

    PerformHttpRequest("https://raw.githubusercontent.com"..updatePath.."/master/version", checkVersion, "GET")
end)