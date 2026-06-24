fx_version 'cerulean'
game 'gta5'

author 'Your Name'
description 'Better Car Spawn dengan improved stability'
version '1.0.0'

shared_script '@ox_lib/init.lua'

server_scripts {
    'server.lua'
}

client_scripts {
    'client.lua'
}

dependency 'qbx_core'
