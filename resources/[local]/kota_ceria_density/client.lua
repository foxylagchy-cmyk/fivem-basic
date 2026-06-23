-- Kota Ceria Density Control
-- Optimized version dengan config mudah

local Config = {
    -- Density settings (0.0 = hilang total, 1.0 = default GTA)
    -- Turunkan angka ini untuk performa lebih baik
    vehicleDensity = 0.3,        -- Mobil yang jalan (default: 0.4)
    pedDensity = 0.3,            -- Orang jalan kaki (default: 0.4)
    parkedVehicleDensity = 0.2,  -- Mobil parkir (default: 0.4)
    scenarioPedDensity = 0.2,    -- Orang nongkrong (default: 0.4)
    
    -- Performance settings
    disablePoliceNPC = true,     -- Nonaktifkan polisi NPC
    disableAmbulanceNPC = true,  -- Nonaktifkan ambulans NPC
    disableTraffic = false,      -- Set true untuk hilangkan traffic total (extreme)
    
    -- Extra optimizations
    disableTrains = true,        -- Nonaktifkan kereta
    disableBoats = true,         -- Nonaktifkan kapal
    disableHelicopters = true,   -- Nonaktifkan helikopter
    disablePlanes = true,        -- Nonaktifkan pesawat
    disableGarbageTrucks = true, -- Nonaktifkan truk sampah
    
    -- Anti spawn di depan player
    clearRadius = 50.0,          -- Radius untuk clear vehicle (meter)
    clearCheckInterval = 1000,   -- Check setiap 1 detik
    preventSpawnNearby = true,   -- Prevent spawn di dekat player
}

-- Main thread dengan optimasi
CreateThread(function()
    -- Disable static entities once (tidak perlu loop)
    if Config.disableTrains then
        SwitchTrainTrack(0, false)
        SwitchTrainTrack(3, false)
        SetRandomTrains(false)
    end
    
    -- Loop untuk dynamic density control
    while true do
        Wait(0) -- Harus 0 untuk apply setiap frame
        
        -- Apply density multipliers
        if Config.disableTraffic then
            -- Mode extreme - hilangkan semua traffic
            SetVehicleDensityMultiplierThisFrame(0.0)
            SetPedDensityMultiplierThisFrame(0.0)
            SetRandomVehicleDensityMultiplierThisFrame(0.0)
            SetParkedVehicleDensityMultiplierThisFrame(0.0)
            SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
        else
            -- Mode normal - density dikurangi
            SetVehicleDensityMultiplierThisFrame(Config.vehicleDensity)
            SetPedDensityMultiplierThisFrame(Config.pedDensity)
            SetRandomVehicleDensityMultiplierThisFrame(Config.vehicleDensity)
            SetParkedVehicleDensityMultiplierThisFrame(Config.parkedVehicleDensity)
            SetScenarioPedDensityMultiplierThisFrame(Config.scenarioPedDensity, Config.scenarioPedDensity)
        end
        
        -- Disable dispatch services (polisi, ambulans, etc)
        if Config.disablePoliceNPC or Config.disableAmbulanceNPC then
            for i = 1, 15 do
                EnableDispatchService(i, false)
            end
        end
        
        -- Disable ambient vehicles
        SetAmbientVehicleRangeMultiplierThisFrame(Config.vehicleDensity)
        
        -- Extra performance tweaks
        if Config.disableGarbageTrucks then
            SetGarbageTrucks(false)
        end
        
        if Config.disableBoats then
            SetRandomBoats(false)
        end
    end
end)

-- Thread untuk clear vehicle yang spawn terlalu dekat dengan player
if Config.preventSpawnNearby then
    CreateThread(function()
        while true do
            Wait(Config.clearCheckInterval)
            
            local ped = PlayerPedId()
            local playerCoords = GetEntityCoords(ped)
            local playerVehicle = GetVehiclePedIsIn(ped, false)
            
            -- Get all vehicles di sekitar player
            local vehicles = GetGamePool('CVehicle')
            
            for _, vehicle in ipairs(vehicles) do
                -- Skip kalau ini kendaraan player sendiri
                if vehicle ~= playerVehicle then
                    local vehCoords = GetEntityCoords(vehicle)
                    local distance = #(playerCoords - vehCoords)
                    
                    -- Kalau vehicle terlalu dekat DAN tidak ada player di dalamnya
                    if distance < Config.clearRadius then
                        local driver = GetPedInVehicleSeat(vehicle, -1)
                        
                        -- Check kalau driver adalah NPC (bukan player)
                        if driver ~= 0 and not IsPedAPlayer(driver) then
                            -- Check kalau vehicle sedang spawn (velocity rendah, baru muncul)
                            local velocity = GetEntityVelocity(vehicle)
                            local speed = math.sqrt(velocity.x^2 + velocity.y^2 + velocity.z^2)
                            
                            -- Kalau kendaraan baru spawn atau tidak bergerak, delete
                            if speed < 5.0 then -- Speed < 5 m/s (18 km/h)
                                SetEntityAsNoLongerNeeded(vehicle)
                                DeleteEntity(vehicle)
                            end
                        end
                    end
                end
            end
        end
    end)
end

-- Command untuk adjust density on-the-fly (admin only)
RegisterCommand('density', function(source, args)
    if not args[1] then
        print('[Density] Current settings:')
        print('Vehicle: ' .. Config.vehicleDensity)
        print('Ped: ' .. Config.pedDensity)
        print('Parked: ' .. Config.parkedVehicleDensity)
        print('Clear Radius: ' .. Config.clearRadius .. 'm')
        return
    end
    
    local value = tonumber(args[1])
    if value and value >= 0.0 and value <= 1.0 then
        Config.vehicleDensity = value
        Config.pedDensity = value
        Config.parkedVehicleDensity = value
        Config.scenarioPedDensity = value
        print('[Density] Set to: ' .. value)
    else
        print('[Density] Usage: /density [0.0-1.0]')
        print('[Density] Example: /density 0.2 (lebih ringan) atau /density 0.5 (lebih ramai)')
    end
end)

-- Command untuk adjust clear radius
RegisterCommand('clearradius', function(source, args)
    if not args[1] then
        print('[Density] Current clear radius: ' .. Config.clearRadius .. 'm')
        return
    end
    
    local value = tonumber(args[1])
    if value and value >= 10.0 and value <= 200.0 then
        Config.clearRadius = value
        print('[Density] Clear radius set to: ' .. value .. 'm')
    else
        print('[Density] Usage: /clearradius [10-200]')
        print('[Density] Example: /clearradius 50 (clear 50 meter di sekitar)')
    end
end)

-- Info saat resource start
AddEventHandler('onClientResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    print('========================================')
    print('Kota Ceria Density Control - Loaded')
    print('Vehicle Density: ' .. (Config.vehicleDensity * 100) .. '%')
    print('Ped Density: ' .. (Config.pedDensity * 100) .. '%')
    print('Parked Vehicle: ' .. (Config.parkedVehicleDensity * 100) .. '%')
    print('Clear Radius: ' .. Config.clearRadius .. 'm')
    print('Anti-Spawn Nearby: ' .. (Config.preventSpawnNearby and 'ENABLED' or 'DISABLED'))
    print('Use /density [value] to adjust')
    print('Use /clearradius [value] to adjust clear radius')
    print('========================================')
end)
