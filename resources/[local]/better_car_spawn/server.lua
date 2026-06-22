-- Better car spawn command dengan improved stability

lib.addCommand('spawncar', {
    help = 'Spawn kendaraan dengan stability yang lebih baik (Admin Only)',
    params = {
        { name = 'model', help = 'Nama/model kendaraan' },
    },
    restricted = 'group.admin'
}, function(source, args)
    if not args or not args.model then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            args = {"System", "Gunakan: /spawncar [model]"}
        })
        return
    end

    local model = args.model
    local playerPed = GetPlayerPed(source)
    
    if not playerPed or playerPed == 0 then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            args = {"System", "Error: Tidak dapat menemukan player ped"}
        })
        return
    end

    -- Hapus kendaraan lama jika ada
    local currentVeh = GetVehiclePedIsIn(playerPed, false)
    if currentVeh and currentVeh ~= 0 then
        DeleteEntity(currentVeh)
        Wait(500) -- Tunggu lebih lama untuk ensure deletion
    end

    -- Trigger client untuk spawn
    TriggerClientEvent('better_car_spawn:spawnVehicle', source, model)
end)

lib.addCommand('spawnveh', {
    help = 'Spawn kendaraan tanpa langsung naik (Admin Only)',
    params = {
        { name = 'model', help = 'Nama/model kendaraan' },
    },
    restricted = 'group.admin'
}, function(source, args)
    if not args or not args.model then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            args = {"System", "Gunakan: /spawnveh [model]"}
        })
        return
    end

    local model = args.model
    local playerPed = GetPlayerPed(source)
    
    if not playerPed or playerPed == 0 then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            args = {"System", "Error: Tidak dapat menemukan player ped"}
        })
        return
    end

    -- Trigger client untuk spawn tanpa warp
    TriggerClientEvent('better_car_spawn:spawnVehicleNoWarp', source, model)
end)

-- Callback untuk set owner dan keys
RegisterNetEvent('better_car_spawn:vehicleSpawned', function(netId)
    local source = source
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    
    if not vehicle or vehicle == 0 then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            args = {"System", "Error: Kendaraan tidak ditemukan"}
        })
        return
    end

    -- Set vehicle owned
    SetEntityOrphanMode(vehicle, 2)
    
    -- Give keys via QBX
    Wait(100)
    local plate = qbx.getVehiclePlate(vehicle)
    if plate then
        pcall(function()
            config.giveVehicleKeys(source, plate, vehicle)
        end)
    end

    TriggerClientEvent('chat:addMessage', source, {
        color = {0, 255, 0},
        args = {"System", "Kendaraan berhasil di-spawn! Model: " .. GetEntityModel(vehicle)}
    })
end)

print('^2[Better Car Spawn] ^7Resource loaded!')
