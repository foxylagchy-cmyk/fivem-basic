-- Client side vehicle spawning

RegisterNetEvent('better_car_spawn:spawnVehicle', function(model)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)
    
    -- Request model
    local modelHash = type(model) == 'string' and joaat(model) or model
    
    if not IsModelValid(modelHash) or not IsModelAVehicle(modelHash) then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            args = {"System", "Model kendaraan tidak valid: " .. tostring(model)}
        })
        return
    end

    RequestModel(modelHash)
    local timeout = 0
    while not HasModelLoaded(modelHash) and timeout < 5000 do
        Wait(10)
        timeout = timeout + 10
    end

    if not HasModelLoaded(modelHash) then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            args = {"System", "Gagal memuat model kendaraan"}
        })
        return
    end

    -- Spawn di depan player
    local spawnCoords = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 3.0, 0.5)
    local vehicle = CreateVehicle(modelHash, spawnCoords.x, spawnCoords.y, spawnCoords.z, heading, true, false)
    
    if not vehicle or vehicle == 0 then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            args = {"System", "Gagal spawn kendaraan"}
        })
        SetModelAsNoLongerNeeded(modelHash)
        return
    end

    -- Tunggu vehicle exist
    local existTimeout = 0
    while not DoesEntityExist(vehicle) and existTimeout < 2000 do
        Wait(10)
        existTimeout = existTimeout + 10
    end

    if not DoesEntityExist(vehicle) then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            args = {"System", "Kendaraan tidak muncul"}
        })
        SetModelAsNoLongerNeeded(modelHash)
        return
    end

    -- Set vehicle properties
    SetVehicleOnGroundProperly(vehicle)
    SetVehicleHasBeenOwnedByPlayer(vehicle, true)
    SetEntityAsMissionEntity(vehicle, true, true)
    SetVehicleNeedsToBeHotwired(vehicle, false)
    SetVehRadioStation(vehicle, 'OFF')
    SetPedIntoVehicle(playerPed, vehicle, -1)

    -- Tunggu network ID
    local netTimeout = 0
    while not NetworkGetEntityIsNetworked(vehicle) and netTimeout < 2000 do
        NetworkRegisterEntityAsNetworked(vehicle)
        Wait(10)
        netTimeout = netTimeout + 10
    end

    local netId = NetworkGetNetworkIdFromEntity(vehicle)
    
    -- Notify server
    TriggerServerEvent('better_car_spawn:vehicleSpawned', netId)

    -- Cleanup model
    SetModelAsNoLongerNeeded(modelHash)
end)

RegisterNetEvent('better_car_spawn:spawnVehicleNoWarp', function(model)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)
    
    -- Request model
    local modelHash = type(model) == 'string' and joaat(model) or model
    
    if not IsModelValid(modelHash) or not IsModelAVehicle(modelHash) then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            args = {"System", "Model kendaraan tidak valid: " .. tostring(model)}
        })
        return
    end

    RequestModel(modelHash)
    local timeout = 0
    while not HasModelLoaded(modelHash) and timeout < 5000 do
        Wait(10)
        timeout = timeout + 10
    end

    if not HasModelLoaded(modelHash) then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            args = {"System", "Gagal memuat model kendaraan"}
        })
        return
    end

    -- Spawn di depan player (sedikit lebih jauh agar tidak langsung naik)
    local spawnCoords = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 5.0, 0.5)
    local vehicle = CreateVehicle(modelHash, spawnCoords.x, spawnCoords.y, spawnCoords.z, heading, true, false)
    
    if not vehicle or vehicle == 0 then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            args = {"System", "Gagal spawn kendaraan"}
        })
        SetModelAsNoLongerNeeded(modelHash)
        return
    end

    -- Tunggu vehicle exist
    local existTimeout = 0
    while not DoesEntityExist(vehicle) and existTimeout < 2000 do
        Wait(10)
        existTimeout = existTimeout + 10
    end

    if not DoesEntityExist(vehicle) then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            args = {"System", "Kendaraan tidak muncul"}
        })
        SetModelAsNoLongerNeeded(modelHash)
        return
    end

    -- Set vehicle properties (TANPA warp player)
    SetVehicleOnGroundProperly(vehicle)
    SetVehicleHasBeenOwnedByPlayer(vehicle, true)
    SetEntityAsMissionEntity(vehicle, true, true)
    SetVehicleNeedsToBeHotwired(vehicle, false)
    SetVehRadioStation(vehicle, 'OFF')
    -- TIDAK ADA SetPedIntoVehicle - player tetap di luar

    -- Tunggu network ID
    local netTimeout = 0
    while not NetworkGetEntityIsNetworked(vehicle) and netTimeout < 2000 do
        NetworkRegisterEntityAsNetworked(vehicle)
        Wait(10)
        netTimeout = netTimeout + 10
    end

    local netId = NetworkGetNetworkIdFromEntity(vehicle)
    
    -- Notify server
    TriggerServerEvent('better_car_spawn:vehicleSpawned', netId)

    -- Cleanup model
    SetModelAsNoLongerNeeded(modelHash)
end)

-- Add suggestions
TriggerEvent('chat:addSuggestion', '/spawncar', 'Spawn kendaraan dan langsung naik (Admin Only)', {
    { name="model", help="Nama model kendaraan (contoh: skyline, adder, t20)" }
})

TriggerEvent('chat:addSuggestion', '/spawnveh', 'Spawn kendaraan tanpa langsung naik (Admin Only)', {
    { name="model", help="Nama model kendaraan (contoh: skyline, adder, t20)" }
})
