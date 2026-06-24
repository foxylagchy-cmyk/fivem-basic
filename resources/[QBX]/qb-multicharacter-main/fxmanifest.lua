fx_version 'cerulean'
game 'gta5'

-- ==========================================
-- RESOURCE DISABLED
-- ==========================================
-- This is QB-Core's multicharacter system (legacy)
-- QBX Framework has built-in multicharacter in qbx_core
-- Running both causes spawn selector conflicts
--
-- Use qbx_core's built-in multicharacter instead
-- Disabled on: 2026-06-22
-- ==========================================

--[[ ORIGINAL MANIFEST
lua54 'yes'
author 'Kakarot'
description 'Allows players to create multiple characters'
version '1.5.0'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua',
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    '@qb-apartments/config.lua',
    'server.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/reset.css',
    'html/vue.js',
    'html/swal2.js',
    'html/profanity.js',
    'html/translations.js',
    'html/validation.js',
    'html/app.js'
}

dependencies {
    'qb-core',
    'qb-spawn'
}
--]]
