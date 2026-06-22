fx_version 'cerulean'
game 'gta5'

-- ==========================================
-- RESOURCE DISABLED
-- ==========================================
-- This resource requires main NPWD resource which is not installed
-- NPWD requires Node.js and pnpm to build
-- Use qbx_phone instead (simpler alternative)
-- Disabled on: 2026-06-22
-- ==========================================

-- Original manifest commented out to prevent loading

--[[ ORIGINAL MANIFEST
description 'A simple bridge resource for Qbox Compatibility for NPWD'
version '1.0.0'
repository 'https://github.com/Qbox-Project/qbx_npwd'

client_script 'client.lua'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

shared_script 'config.lua'

lua54 'yes'
use_experimental_fxv2_oal 'yes'
provide 'qb-npwd'
--]]
