version '1.0.0'
author 'KotaCeria Dev'
description 'Custom glassmorphism chat theme for Kota Ceria'

file 'style.css'
file 'shadow.js'

chat_theme 'kota_ceria_chat' {
    styleSheet = 'style.css',
    script = 'shadow.js',
    msgTemplates = {
        default = '<b>{0}</b><span>{1}</span>'
    }
}

game 'common'
fx_version 'adamant'
