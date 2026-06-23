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
    
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            args = {"System", "Error: Kendaraan tidak ditemukan"}
        })
        return
    end

    -- Set vehicle owned
    SetEntityOrphanMode(vehicle, 2)
    
    -- Get plate using native function (no dependency on qbx global)
    local plate = GetVehicleNumberPlateText(vehicle)
    if plate then
        plate = plate:gsub("^%s*(.-)%s*$", "%1") -- trim whitespace
    end
    
    -- Give keys via QBX vehiclekeys export
    local success, err = pcall(function()
        exports.qbx_vehiclekeys:GiveKeys(source, vehicle)
    end)
    
    if success then
        print(string.format('[Better Car Spawn] Keys diberikan ke player %s untuk vehicle %s (plate: %s)', 
            source, vehicle, plate or "N/A"))
    else
        print(string.format('[Better Car Spawn] ERROR giving keys: %s', tostring(err)))
        -- Fallback: Try alternative method
        if plate then
            pcall(function()
                TriggerEvent('qb-vehiclekeys:server:AcquireVehicleKeys', source, plate)
            end)
        end
    end

    TriggerClientEvent('chat:addMessage', source, {
        color = {0, 255, 0},
        args = {"System", "Kendaraan berhasil di-spawn! Plate: " .. (plate or "N/A")}
    })
end)

print('^2[Better Car Spawn] ^7Resource loaded!')
