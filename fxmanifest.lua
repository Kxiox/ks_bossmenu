--[[
    https://github.com/kxiox/ks_bossmenu

    This file is licensed under GPL-3.0 or higher <https://www.gnu.org/licenses/gpl-3.0.en.html>

    Copyright © 2025 Kxiox <https://github.com/kxiox>
]]

fx_version 'cerulean'
game 'gta5'

author 'Kxiox Scripts'
description 'Bossmenu for ESX'
lua_54 'yes'
version 'dev-1.1.0'

shared_scripts {
    '@es_extended/imports.lua',
    '@es_extended/locale.lua',
    'config.lua',
    'locales/*.lua'
}

client_scripts {
    'client/nui/bonus.lua',
    'client/nui/notify.lua',
    'client/nui/nui.lua',
    'client/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    '@es_extended/locale.lua',
    'webhooks.lua',
    'server/callbacks/bonus.lua',
    'server/callbacks/callbacks.lua',
    'server/main.lua',
    'server/queue.lua',
    'server/versioncheck.lua'
}

-- ui_page 'html/index.html'
ui_page 'http://localhost:5173/'

files {
    'html/locales/*.json',
    'html/index.html',
    'html/assets/*.css',
    'html/assets/*.js',
    'html/assets/*.png',
    'html/img/*.png',
}

dependencies {
    'es_extended',
    'oxmysql',
}
