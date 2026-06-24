-- Test ESC Key Detection

local debugMode = false -- Set false untuk disable semua log
local escPressTime = 0
local mapOpenCooldown = 0

local function debugPrint(...)
    if debugMode then
        print('[TEST_ESC]', ...)
    end
end

debugPrint('Script loaded - monitoring ESC key...')

-- Auto-bind ESC to open pause menu (instant response)
CreateThread(function()
    while true do
        Wait(0) -- Run every frame for instant detection
        
        local currentTime = GetGameTimer()
        
        -- Check if ESC is being pressed (not just released)
        if IsControlPressed(0, 200) or IsDisabledControlPressed(0, 200) then
            -- Prevent spam (cooldown 500ms)
            if currentTime - mapOpenCooldown > 500 then
                if not IsPauseMenuActive() then
                    debugPrint('✅ ESC HELD! Opening map instantly...')
                    
                    -- Force open pause menu immediately
                    ActivateFrontendMenu(GetHashKey('FE_MENU_VERSION_MP_PAUSE'), false, -1)
                    
                    mapOpenCooldown = currentTime
                end
            end
        end
    end
end)

-- Command to manually test pause menu
RegisterCommand('testpause', function()
    local isPauseActive = IsPauseMenuActive()
    debugPrint('Pause Menu Active: ' .. tostring(isPauseActive))
    
    SetNotificationTextEntry("STRING")
    if isPauseActive then
        AddTextComponentString("~g~Pause Menu~w~ is OPEN")
    else
        AddTextComponentString("~r~Pause Menu~w~ is CLOSED")
    end
    DrawNotification(false, true)
end, false)

-- Command to check which controls are disabled
RegisterCommand('checkcontrols', function()
    local control200Enabled = IsControlEnabled(0, 200) -- ESC
    local control199Enabled = IsControlEnabled(2, 199) -- Pause Menu
    
    -- Check if they can be pressed
    local control200Pressed = IsControlPressed(0, 200)
    local control199Pressed = IsControlPressed(2, 199)
    
    -- Check disabled control
    local control200DisabledPressed = IsDisabledControlPressed(0, 200)
    local control199DisabledPressed = IsDisabledControlPressed(2, 199)
    
    debugPrint('======================')
    debugPrint('Control 200 (ESC):')
    debugPrint('  - Enabled: ' .. tostring(control200Enabled))
    debugPrint('  - Pressed: ' .. tostring(control200Pressed))
    debugPrint('  - DisabledPressed: ' .. tostring(control200DisabledPressed))
    debugPrint('Control 199 (Pause):')
    debugPrint('  - Enabled: ' .. tostring(control199Enabled))
    debugPrint('  - Pressed: ' .. tostring(control199Pressed))
    debugPrint('  - DisabledPressed: ' .. tostring(control199DisabledPressed))
    debugPrint('======================')
    
    SetNotificationTextEntry("STRING")
    AddTextComponentString(string.format(
        "ESC: %s | Pause: %s",
        control200Enabled and "~g~OK" or "~r~BLOCKED",
        control199Enabled and "~g~OK" or "~r~BLOCKED"
    ))
    DrawNotification(false, true)
end, false)

-- Command to try forcing the map open
RegisterCommand('forcemap', function()
    debugPrint('Attempting to force pause menu open...')
    
    -- Try activating the frontend
    ActivateFrontendMenu(GetHashKey('FE_MENU_VERSION_MP_PAUSE'), false, -1)
    
    Wait(500)
    
    local isPauseActive = IsPauseMenuActive()
    debugPrint('Pause Menu Active after force: ' .. tostring(isPauseActive))
    
    SetNotificationTextEntry("STRING")
    if isPauseActive then
        AddTextComponentString("~g~Map opened successfully!")
    else
        AddTextComponentString("~r~Failed to open map")
    end
    DrawNotification(false, true)
end, false)

-- Command to toggle debug mode
RegisterCommand('toggledebug', function()
    debugMode = not debugMode
    print('[TEST_ESC] Debug mode: ' .. (debugMode and 'ON' or 'OFF'))
    
    SetNotificationTextEntry("STRING")
    AddTextComponentString(debugMode and "~g~Debug ON" or "~r~Debug OFF")
    DrawNotification(false, true)
end, false)

if debugMode then
    TriggerEvent('chat:addSuggestion', '/testpause', 'Check if pause menu is active')
    TriggerEvent('chat:addSuggestion', '/checkcontrols', 'Check if ESC/Pause controls are blocked')
    TriggerEvent('chat:addSuggestion', '/forcemap', 'Try to force open pause menu map')
    TriggerEvent('chat:addSuggestion', '/toggledebug', 'Toggle debug logs on/off')
    
    debugPrint('Commands available: /testpause, /checkcontrols, /forcemap, /toggledebug')
    debugPrint('Press ESC to see if it\'s detected!')
end
