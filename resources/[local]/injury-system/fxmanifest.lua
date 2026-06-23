fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Custom Injury System'
description 'Advanced injury system with knock phase and bleeding effects'
version '1.0.1'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua',
    'client/radialmenu.lua'  -- Optional: untuk integrasi dengan radialmenu
}

server_scripts {
    'server/main.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}
