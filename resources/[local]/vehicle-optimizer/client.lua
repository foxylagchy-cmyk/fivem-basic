-- VEHICLE OPTIMIZER
-- Mencegah crash dari terlalu banyak vehicles spawn

local Config = {
    maxVehiclesNearby = 30, -- Maksimal vehicles dalam radius
    checkRadius = 150.0, -- Radius check (meter)
    cleanupInterval = 60000, -- Cleanup setiap 1 menit
    despawnDistance = 300.0, -- Despawn vehicle jika lebih jauh
    protectedVehicles = {}, -- Vehicle yang tidak boleh di-despawn
}

-- Track spawned vehicles
local spawnedVehicles = {}

-- Function untuk count vehicles nearby
local function countVehiclesNearby()
    local playerCoords = GetEntityCoords(PlayerPedId())
    local count = 0
    
    for vehicle in EnumerateVehicles() do
        local vehCoords = GetEntityCoords(vehicle)
        local distance = #(playerCoords - vehCoords)
        
        if distance <= Config.checkRadius then
            count = count + 1
        end
    end
    
    return count
end

-- Function untuk cleanup distant vehicles
local function cleanupDistantVehicles()
    local playerCoords = GetEntityCoords(PlayerPedId())
    local cleaned = 0
    
    for vehicle in EnumerateVehicles() do
        if DoesEntityExist(vehicle) then
            local vehCoords = GetEntityCoords(vehicle)
            local distance = #(playerCoords - vehCoords)
            
            -- Check jika vehicle jauh dan tidak ada player di dalamnya
            if distance > Config.despawnDistance then
                local hasPlayer = false
                
                -- Check semua seats
                for i = -1, GetVehicleMaxNumberOfPassengers(vehicle) do
                    local ped = GetPedInVehicleSeat(vehicle, i)
                    if ped ~= 0 and IsPedAPlayer(ped) then
                        hasPlayer = true
                        break
                    end
                end
                
                -- Jika tidak ada player dan bukan protected vehicle
                if not hasPlayer and not Config.protectedVehicles[vehicle] then
                    -- Check jika vehicle owned atau locked
                    local lockStatus = GetVehicleDoorLockStatus(vehicle)
                    
                    if lockStatus == 1 or lockStatus == 0 then -- Unlocked or no lock
                        if NetworkGetEntityIsNetworked(vehicle) then
                            SetEntityAsMissionEntity(vehicle, true, true)
                        end
                        DeleteEntity(vehicle)
                        cleaned = cleaned + 1
                    end
                end
            end
        end
    end
    
    return cleaned
end

-- Auto cleanup thread
CreateThread(function()
    while true do
        Wait(Config.cleanupInterval)
        
        local count = countVehiclesNearby()
        
        if count > Config.maxVehiclesNearby then
            local cleaned = cleanupDistantVehicles()
            
            if cleaned > 0 then
                print(string.format("^2[VEHICLE OPTIMIZER]^7 Cleaned %d distant vehicles (total nearby: %d)", cleaned, count))
            end
        end
    end
end)

-- Protect player's current vehicle
CreateThread(function()
    while true do
        Wait(5000)
        
        local playerPed = PlayerPedId()
        
        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            Config.protectedVehicles[vehicle] = true
        end
        
        -- Clean old protected vehicles
        for veh, _ in pairs(Config.protectedVehicles) do
            if not DoesEntityExist(veh) then
                Config.protectedVehicles[veh] = nil
            end
        end
    end
end)

-- Hook vehicle spawn
AddEventHandler('entityCreated', function(entity)
    if DoesEntityExist(entity) and IsEntityAVehicle(entity) then
        -- Track new vehicle
        table.insert(spawnedVehicles, entity)
        
        -- Check jika terlalu banyak vehicles
        local count = countVehiclesNearby()
        
        if count > Config.maxVehiclesNearby + 5 then
            print("^3[VEHICLE OPTIMIZER]^7 Warning: Too many vehicles nearby, triggering cleanup...")
            cleanupDistantVehicles()
        end
    end
end)

-- Command untuk manual cleanup (player bisa pake)
RegisterCommand('cleanvehicles', function()
    local playerCoords = GetEntityCoords(PlayerPedId())
    local currentVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    local cleaned = 0
    
    for vehicle in EnumerateVehicles() do
        if vehicle ~= currentVehicle and DoesEntityExist(vehicle) then
            local vehCoords = GetEntityCoords(vehicle)
            local distance = #(playerCoords - vehCoords)
            
            if distance > 100.0 then
                local hasPlayer = false
                
                for i = -1, GetVehicleMaxNumberOfPassengers(vehicle) do
                    local ped = GetPedInVehicleSeat(vehicle, i)
                    if ped ~= 0 and IsPedAPlayer(ped) then
                        hasPlayer = true
                        break
                    end
                end
                
                if not hasPlayer then
                    if NetworkGetEntityIsNetworked(vehicle) then
                        SetEntityAsMissionEntity(vehicle, true, true)
                    end
                    DeleteEntity(vehicle)
                    cleaned = cleaned + 1
                end
            end
        end
    end
    
    TriggerEvent('chat:addMessage', {
        args = { "^2VEHICLE OPTIMIZER", string.format("Cleaned %d vehicles", cleaned) }
    })
end, false)

-- Helper function
function EnumerateVehicles()
    return coroutine.wrap(function()
        local iter, id = FindFirstVehicle()
        if not id or id == 0 then
            EndFindVehicle(iter)
            return
        end
        
        local enum = {handle = iter, destructor = EndFindVehicle}
        setmetatable(enum, entityEnumerator)
        
        local next = true
        repeat
            coroutine.yield(id)
            next, id = FindNextVehicle(iter)
        until not next
        
        enum.destructor, enum.handle = nil, nil
        EndFindVehicle(iter)
    end)
end

entityEnumerator = {
    __gc = function(enum)
        if enum.destructor and enum.handle then
            enum.destructor(enum.handle)
        end
        enum.destructor, enum.handle = nil, nil
    end
}

print("^2[VEHICLE OPTIMIZER]^7 Loaded successfully")
