-- Event to open the custom admin menu GUI
RegisterNetEvent('kc_admin:client:openMenu', function()
    -- Register the menu using ox_lib context menu
    lib.registerContext({
        id = 'kc_admin_main',
        title = '🛡️ Kota Ceria Admin Panel',
        options = {
            {
                title = '🩺 Revive Player',
                description = 'Menyembuhkan player berdasarkan ID',
                icon = 'heart-pulse',
                onSelect = function()
                    local input = lib.inputDialog('Revive Player', {
                        {type = 'number', label = 'Player ID (Server ID)', required = true, min = 1}
                    })
                    if input and input[1] then
                        ExecuteCommand('revive ' .. input[1])
                    end
                end
            },
            {
                title = '🌟 Revive Semua (Revive All)',
                description = 'Menyembuhkan seluruh player di server',
                icon = 'users',
                onSelect = function()
                    local alert = lib.alertDialog({
                        header = 'Konfirmasi',
                        content = 'Apakah Anda yakin ingin melakukan Revive ke **SELURUH** player di kota?',
                        centered = true,
                        cancel = true
                    })
                    if alert == 'confirm' then
                        ExecuteCommand('reviveall')
                    end
                end
            },
            {
                title = '💀 Kill Player',
                description = 'Membunuh player berdasarkan ID',
                icon = 'skull',
                onSelect = function()
                    local input = lib.inputDialog('Kill Player', {
                        {type = 'number', label = 'Player ID (Server ID)', required = true, min = 1}
                    })
                    if input and input[1] then
                        ExecuteCommand('kill ' .. input[1])
                    end
                end
            },
            {
                title = '☠️ Kill Semua (Kill All)',
                description = 'Membunuh seluruh player di server (Kecuali Admin)',
                icon = 'bomb',
                onSelect = function()
                    local alert = lib.alertDialog({
                        header = 'Konfirmasi Kiamat',
                        content = 'Apakah Anda yakin ingin melakukan Kill ke **SELURUH** player di kota?',
                        centered = true,
                        cancel = true
                    })
                    if alert == 'confirm' then
                        ExecuteCommand('killall')
                    end
                end
            },
            {
                title = '🚗 Spawn Kendaraan',
                description = 'Memunculkan kendaraan dari daftar atau ketik manual',
                icon = 'car',
                onSelect = function()
                    local input = lib.inputDialog('Spawn Kendaraan', {
                        {
                            type = 'select', 
                            label = 'Pilih dari Daftar (Custom & Default)', 
                            options = {
                                { value = 'ninjah2', label = 'Kawasaki Ninja H2R (Custom)' },
                                { value = 'skyline', label = 'Nissan Skyline R34 (Custom)' },
                                { value = 'streetsupra', label = 'Toyota Supra (Custom)' },
                                { value = 'rs322', label = 'Audi RS3 2022 (Custom)' },
                                { value = 't20', label = 'T20 (Super)' },
                                { value = 'zentorno', label = 'Zentorno (Super)' },
                                { value = 'sultanrs', label = 'Sultan RS (Sport)' },
                                { value = 'sanchez', label = 'Sanchez (Off-Road Bike)' },
                                { value = 'police', label = 'Police Cruiser (Emergency)' },
                                { value = 'ambulance', label = 'Ambulance (Emergency)' }
                            },
                            searchable = true,
                            clearable = true
                        },
                        {type = 'input', label = 'ATAU Ketik Manual Nama Model', placeholder = 'kosongi jika pilih dari daftar'}
                    })
                    
                    if input then
                        local modelToSpawn = nil
                        if input[1] and input[1] ~= "" then
                            modelToSpawn = input[1]
                        elseif input[2] and input[2] ~= "" then
                            modelToSpawn = input[2]
                        end

                        if modelToSpawn then
                            ExecuteCommand('car ' .. modelToSpawn)
                        end
                    end
                end
            }
        }
    })

    -- Open the registered menu
    lib.showContext('kc_admin_main')
end)
