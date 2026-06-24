local hasNitro = false
local nitroLevel = 100.0
local isNitroActive = false
local vehicleParticles = {}

local function startNitroFlames(veh)
    if vehicleParticles[veh] then return end
    vehicleParticles[veh] = {}
    
    Citizen.CreateThread(function()
        local dict = "veh_xs_vehicle_mods"
        local name = "veh_nitrous"
        
        RequestNamedPtfxAsset(dict)
        while not HasNamedPtfxAssetLoaded(dict) do Citizen.Wait(0) end

        -- Validasi lagi apakah kendaraan masih ada setelah proses loading
        if not DoesEntityExist(veh) then return end

        local bones = {"exhaust", "exhaust_2", "exhaust_3", "exhaust_4", "exhaust_5", "exhaust_6"}
        local foundBone = false
        
        for _, boneName in ipairs(bones) do
            local boneIndex = GetEntityBoneIndexByName(veh, boneName)
            if boneIndex ~= -1 then
                foundBone = true
                UseParticleFxAssetNextCall(dict)
                local ptfx = StartParticleFxLoopedOnEntityBone(name, veh, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, boneIndex, 1.5, false, false, false)
                table.insert(vehicleParticles[veh], ptfx)
            end
        end
        
        if not foundBone then
            UseParticleFxAssetNextCall(dict)
            local ptfx = StartParticleFxLoopedOnEntity(name, veh, 0.0, -2.5, 0.2, 0.0, 0.0, 0.0, 1.5, false, false, false)
            table.insert(vehicleParticles[veh], ptfx)
        end
    end)
end

local function stopNitroFlames(veh)
    if vehicleParticles[veh] then
        for _, ptfx in ipairs(vehicleParticles[veh]) do
            StopParticleFxLooped(ptfx, false)
        end
        vehicleParticles[veh] = nil
    end
end

-- Listener untuk semua pemain agar melihat api dari mobil yang menyalakan NOS
AddStateBagChangeHandler('nitroFlames', nil, function(bagName, key, value, _reserved, replicated)
    local netId = tonumber(bagName:gsub('entity:', ''), 10)
    if not netId then return end
    
    local veh = NetToVeh(netId)
    if not DoesEntityExist(veh) then return end
    
    if value then
        startNitroFlames(veh)
    else
        stopNitroFlames(veh)
    end
end)

local lastSyncedState = false

RegisterCommand('pasangnos', function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    
    if veh ~= 0 then
        SetVehicleModKit(veh, 0)
        ToggleVehicleMod(veh, 18, true) -- Pasang Turbo
        hasNitro = true
        nitroLevel = 100.0
        isNitroActive = false
        lastSyncedState = false
        TriggerServerEvent('cmd_nitro:server:SyncFlames', VehToNet(veh), false)
        stopNitroFlames(veh)
        
        TriggerEvent('ox_lib:notify', {
            title = 'Mekanik Gaib',
            description = 'NOS terpasang! Tekan SHIFT KIRI sekali untuk ON/OFF. Bisa recharge otomatis.',
            type = 'success'
        })
    else
        TriggerEvent('ox_lib:notify', {
            title = 'Gagal',
            description = 'Kamu harus berada di dalam mobil!',
            type = 'error'
        })
    end
end, false)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)
        
        if veh ~= 0 and GetPedInVehicleSeat(veh, -1) == ped and hasNitro then
            
            if IsControlJustPressed(0, 21) then
                if isNitroActive then
                    isNitroActive = false
                elseif nitroLevel > 0.0 then
                    isNitroActive = true
                end
            end
            
            if isNitroActive then
                if nitroLevel > 0.0 then
                    nitroLevel = nitroLevel - 0.2
                    SetVehicleBoostActive(veh, 1)
                    SetVehicleEngineTorqueMultiplier(veh, 3.5)
                    SetVehicleEnginePowerMultiplier(veh, 3.5)
                    
                    startNitroFlames(veh) -- Panggil langsung secara lokal agar instan
                    
                    if not lastSyncedState then
                        lastSyncedState = true
                        TriggerServerEvent('cmd_nitro:server:SyncFlames', VehToNet(veh), true)
                    end
                else
                    isNitroActive = false
                end
            else
                if nitroLevel < 100.0 then
                    nitroLevel = nitroLevel + 0.05
                end
                
                SetVehicleBoostActive(veh, 0)
                SetVehicleEngineTorqueMultiplier(veh, 1.0)
                SetVehicleEnginePowerMultiplier(veh, 1.0)
                
                stopNitroFlames(veh) -- Panggil langsung secara lokal
                
                if lastSyncedState then
                    lastSyncedState = false
                    TriggerServerEvent('cmd_nitro:server:SyncFlames', VehToNet(veh), false)
                end
            end
            
            TriggerEvent('hud:client:UpdateNitrous', true, math.floor(nitroLevel), isNitroActive)
            
        else
            if veh == 0 then 
                if hasNitro then
                    TriggerEvent('hud:client:UpdateNitrous', false, 0, false)
                    stopNitroFlames(veh)
                end
                hasNitro = false
                isNitroActive = false
                lastSyncedState = false
            end
            Citizen.Wait(500)
        end
    end
end)
