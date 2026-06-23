-- CLIENT-SIDE CRASH PREVENTION
-- Mencegah crash dari memory overload dan streaming issues

local Config = {
    enableDebug = false,
    memoryCheckInterval = 30000, -- Check setiap 30 detik
    warningThreshold = 80, -- Warn jika memory usage > 80%
    clearCacheInterval = 300000, -- Clear cache setiap 5 menit
}

-- Memory monitoring
local lastMemoryCheck = 0
local memoryWarningShown = false

CreateThread(function()
    while true do
        Wait(Config.memoryCheckInterval)
        
        local memoryUsage = GetPerformanceMetrics()
        
        if memoryUsage and memoryUsage.memoryUsedMB then
            local usagePercent = (memoryUsage.memoryUsedMB / 4096) * 100
            
            if usagePercent > Config.warningThreshold and not memoryWarningShown then
                if Config.enableDebug then
                    print(string.format("^3[CRASH PREVENTION]^7 Memory usage high: %.1f%%", usagePercent))
                end
                memoryWarningShown = true
                
                -- Trigger cache cleanup
                TriggerEvent('crash-prevention:clearCache')
            elseif usagePercent < Config.warningThreshold then
                memoryWarningShown = false
            end
        end
    end
end)

-- Auto clear cache untuk mencegah memory leak
CreateThread(function()
    while true do
        Wait(Config.clearCacheInterval)
        TriggerEvent('crash-prevention:clearCache')
    end
end)

RegisterNetEvent('crash-prevention:clearCache', function()
    -- Clear weapon asset cache (REMOVED: ClearPedTasksImmediately interrupts player driving)
    -- Clear area around player
    local playerCoords = GetEntityCoords(PlayerPedId())
    ClearAreaOfVehicles(playerCoords.x, playerCoords.y, playerCoords.z, 50.0, false, false, false, false, false)
    
    -- Clear distant entities
    for vehicle in EnumerateVehicles() do
        local vehCoords = GetEntityCoords(vehicle)
        local distance = #(playerCoords - vehCoords)
        
        if distance > 300.0 and not IsPedInVehicle(PlayerPedId(), vehicle, false) then
            if NetworkGetEntityIsNetworked(vehicle) then
                SetEntityAsMissionEntity(vehicle, true, true)
            end
            DeleteEntity(vehicle)
        end
    end
    
    if Config.enableDebug then
        print("^2[CRASH PREVENTION]^7 Cache cleared successfully")
    end
end)

-- Prevent crash dari spawn explosions
local explosionBlacklist = {
    [2] = true,  -- GRENADE
    [4] = true,  -- MOLOTOV
    [5] = true,  -- ROCKET
    [13] = true, -- TANKER
    [32] = true, -- PLANE ROCKET
    [33] = true, -- VEHICLE BULLET
    [35] = true, -- GAS CANISTER
    [36] = true, -- EXTINGUISHER
    [37] = true, -- PROGRAMMABLE AR
    [82] = true, -- WATER HYDRANT
}

AddEventHandler('explosionEvent', function(sender, ev)
    if explosionBlacklist[ev.explosionType] then
        -- Allow legitimate explosions, prevent spam
        local playerCoords = GetEntityCoords(PlayerPedId())
        local explosionCoords = vec3(ev.posX, ev.posY, ev.posZ)
        local distance = #(playerCoords - explosionCoords)
        
        if distance > 500.0 then
            CancelEvent()
            return
        end
    end
end)

-- Prevent entity spam crashes
local entityCreateQueue = {}
local maxEntitiesPerSecond = 10
local entityCreateCount = 0

CreateThread(function()
    while true do
        Wait(1000)
        entityCreateCount = 0
    end
end)

AddEventHandler('entityCreating', function(entity)
    entityCreateCount = entityCreateCount + 1
    
    if entityCreateCount > maxEntitiesPerSecond then
        if Config.enableDebug then
            print("^3[CRASH PREVENTION]^7 Entity creation rate limited")
        end
        CancelEvent()
    end
end)

-- Helper function untuk enumerate vehicles
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

-- Detect and report crashes
CreateThread(function()
    local crashDetected = false
    
    while true do
        Wait(5000)
        
        -- Check if game is frozen
        local startTime = GetGameTimer()
        Wait(100)
        local endTime = GetGameTimer()
        
        if (endTime - startTime) > 500 then
            if not crashDetected then
                crashDetected = true
                print("^1[CRASH PREVENTION]^7 Potential freeze detected!")
                TriggerServerEvent('crash-prevention:reportFreeze')
                
                -- Emergency cleanup
                TriggerEvent('crash-prevention:clearCache')
            end
        else
            crashDetected = false
        end
    end
end)

-- Print info saat resource start
CreateThread(function()
    Wait(5000)
    if Config.enableDebug then
        print([[
^2========================================
^3  CRASH PREVENTION ACTIVE
^2========================================
^7Memory monitoring: ^2ENABLED
^7Cache clearing: ^2ENABLED
^7Entity spam protection: ^2ENABLED
^2========================================
]])
    end
end)
