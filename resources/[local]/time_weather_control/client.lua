-- Time & Weather Control - Client Side

local timeIsFrozen = false
local frozenHour = 12
local frozenMinute = 0
local weatherIsFrozen = false
local currentWeather = "CLEAR"

-- Disable default game weather and time changes
Citizen.CreateThread(function()
    -- Disable automatic weather changes
    SetRandomWeatherType()
    Wait(100)
    ClearOverrideWeather()
    ClearWeatherTypePersist()
    
    -- Set default weather
    SetWeatherTypePersist("CLEAR")
    SetWeatherTypeNow("CLEAR")
    SetWeatherTypeNowPersist("CLEAR")
end)

-- Event handler untuk set time
RegisterNetEvent('time_weather:setTime')
AddEventHandler('time_weather:setTime', function(hour, minute)
    frozenHour = hour
    frozenMinute = minute
    timeIsFrozen = true
    
    print(string.format("^2[Time Control] ^7Setting time to %02d:%02d", hour, minute))
end)

-- Event handler untuk set weather
RegisterNetEvent('time_weather:setWeather')
AddEventHandler('time_weather:setWeather', function(weatherType)
    currentWeather = weatherType
    weatherIsFrozen = true
    
    print(string.format("^2[Weather Control] ^7Forcing weather to %s", weatherType))
    
    -- Method 1: Clear everything first
    ClearOverrideWeather()
    ClearWeatherTypePersist()
    
    -- Method 2: Force set immediately multiple times
    for i = 1, 5 do
        SetWeatherTypeNow(weatherType)
        SetWeatherTypeNowPersist(weatherType)
        SetWeatherTypePersist(weatherType)
        Wait(10)
    end
    
    -- Method 3: Use transition
    SetWeatherTypeOvertimePersist(weatherType, 0.5)
    
    -- Set rain/snow levels based on weather type
    if weatherType == "RAIN" or weatherType == "THUNDER" then
        SetRainLevel(0.5) -- Medium rain
    elseif weatherType == "CLEARING" then
        SetRainLevel(0.3) -- Light rain
    elseif weatherType == "SNOWLIGHT" or weatherType == "XMAS" then
        SetRainLevel(0.3) -- Light snow
        SetSnowLevel(0.3)
    elseif weatherType == "BLIZZARD" then
        SetRainLevel(0.8) -- Heavy snow
        SetSnowLevel(0.8)
    else
        SetRainLevel(0.0) -- No rain
        SetSnowLevel(0.0) -- No snow
    end
    
    print(string.format("^2[Weather Control] ^7Weather should now be %s", weatherType))
end)

-- Main thread untuk maintain time
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        if timeIsFrozen then
            NetworkOverrideClockTime(frozenHour, frozenMinute, 0)
        end
    end
end)

-- Main thread untuk maintain weather - AGGRESSIVE MODE
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0) -- Run every frame for maximum control
        
        if weatherIsFrozen and currentWeather then
            -- FORCE weather every frame
            SetWeatherTypeNowPersist(currentWeather)
            SetWeatherTypePersist(currentWeather)
            
            -- Maintain rain/snow levels
            if currentWeather == "RAIN" or currentWeather == "THUNDER" then
                SetRainLevel(0.5)
            elseif currentWeather == "CLEARING" then
                SetRainLevel(0.3)
            elseif currentWeather == "SNOWLIGHT" or currentWeather == "XMAS" then
                SetRainLevel(0.3)
                SetSnowLevel(0.3)
            elseif currentWeather == "BLIZZARD" then
                SetRainLevel(0.8)
                SetSnowLevel(0.8)
            end
        end
    end
end)

print('^2[Time & Weather Control] ^7Client loaded!')
