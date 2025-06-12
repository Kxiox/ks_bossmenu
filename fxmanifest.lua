fx_version 'cerulean'
game 'gta5'

author 'Kxiox Scripts'
description 'Bossmenu for ESX'
lua_54 'yes'
version '1.0.0'

shared_scripts {
    '@es_extended/imports.lua',
    '@es_extended/locale.lua',
    'config.lua',
}

client_scripts {
    'client/*.lua',
    'locales/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    '@es_extended/locale.lua',
    'server/*.lua',
    'locales/*.lua'
}

ui_page 'html/index.html'
-- ui_page 'http://localhost:5173/'

files {
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

-- // TODO version checker erstellen