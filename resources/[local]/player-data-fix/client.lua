-- Player Data Fix
-- Ensures player data is fully loaded before triggering events

local playerDataLoaded = false
local maxWaitTime = 30000 -- 30 seconds max wait
local checkInterval = 500 -- Check every 500ms

local function waitForPlayerData()
    local startTime = GetGameTimer()
    
    while not playerDataLoaded and (GetGameTimer() - startTime) < maxWaitTime do
        -- Check if QBX is available
        if not QBX then
            print('[PlayerDataFix] Waiting for QBX...')
            Wait(checkInterval)
            goto continue
        end
        
        -- Check if PlayerData exists
        if not QBX.PlayerData then
            print('[PlayerDataFix] Waiting for QBX.PlayerData...')
            Wait(checkInterval)
            goto continue
        end
        
        -- Check if critical data is loaded
        if not QBX.PlayerData.citizenid or not QBX.PlayerData.job or not QBX.PlayerData.gang then
            print('[PlayerDataFix] Waiting for complete player data...')
            Wait(checkInterval)
            goto continue
        end
        
        -- Check if metadata exists
        if not QBX.PlayerData.metadata then
            print('[PlayerDataFix] Waiting for player metadata...')
            Wait(checkInterval)
            goto continue
        end
        
        -- All checks passed
        playerDataLoaded = true
        print('[PlayerDataFix] ✅ Player data fully loaded!')
        print('[PlayerDataFix] Citizen ID:', QBX.PlayerData.citizenid)
        print('[PlayerDataFix] Job:', QBX.PlayerData.job.name)
        print('[PlayerDataFix] Gang:', QBX.PlayerData.gang.name)
        return true
        
        ::continue::
    end
    
    if not playerDataLoaded then
        print('[PlayerDataFix] ❌ Timeout waiting for player data!')
        return false
    end
end

-- Listen for player loaded event
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    print('[PlayerDataFix] OnPlayerLoaded event received')
    
    -- Wait a bit to ensure everything is set
    Wait(2000)
    
    -- Start waiting for player data
    CreateThread(function()
        local success = waitForPlayerData()
        
        if success then
            print('[PlayerDataFix] Player is now ready to spawn')
            -- Extra delay to be safe
            Wait(1000)
        else
            print('[PlayerDataFix] WARNING: Player data may be incomplete!')
        end
    end)
end)

-- Listen for player data updates
RegisterNetEvent('QBCore:Player:SetPlayerData', function(playerData)
    if playerData and playerData.citizenid then
        print('[PlayerDataFix] SetPlayerData event - Citizen ID:', playerData.citizenid)
        
        -- Check if this is first time loading
        if not playerDataLoaded then
            Wait(1000)
            waitForPlayerData()
        end
    end
end)

-- Check on resource start if player is already logged in
CreateThread(function()
    Wait(5000) -- Wait for QBX to initialize
    
    if LocalPlayer.state.isLoggedIn then
        print('[PlayerDataFix] Player already logged in on resource start')
        waitForPlayerData()
    end
end)

-- Export function for other resources to check if player data is ready
exports('IsPlayerDataLoaded', function()
    return playerDataLoaded
end)

-- Export function to wait for player data
exports('WaitForPlayerData', function()
    return waitForPlayerData()
end)
