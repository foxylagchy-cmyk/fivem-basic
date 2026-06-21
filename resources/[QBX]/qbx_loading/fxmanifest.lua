fx_version 'cerulean'
game 'gta5'

name 'qbx_loading'
description 'Loading screen for Qbox'
repository 'https://github.com/Qbox-project/qbx_loading'
version '0.1.0'

files {
    'html/assets/**',
    'html/*',
}

loadscreen {
    'html/index.html'
}

loadscreen_cursor 'yes'
loadscreen_manual_shutdown 'yes'

lua54 'yes'
use_experimental_fxv2_oal 'yes'