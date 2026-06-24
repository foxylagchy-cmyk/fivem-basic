-- Time & Weather Control - Server Side

-- Fungsi cek admin
local function isAdmin(source)
    return IsPlayerAceAllowed(source, "command")
end

-- Command /time
RegisterCommand('time', function(source, args, rawCommand)
    if source ~= 0 and not isAdmin(source) then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            args = {"System", "Anda tidak memiliki izin untuk command ini!"}
        })
        return
    end

    if #args == 0 then
        if source == 0 then
            print("^1[Time Control] ^7Gunakan: time [jam] [menit]")
        else
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 165, 0},
                args = {"System", "Gunakan: /time [jam] [menit] - Contoh: /time 13 atau /time 13 30"}
            })
        end
        return
    end

    local hour = tonumber(args[1])
    local minute = tonumber(args[2]) or 0

    if not hour or hour < 0 or hour > 23 then
        if source == 0 then
            print("^1[Time Control] ^7Jam harus antara 0-23!")
        else
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                args = {"System", "Jam harus antara 0-23!"}
            })
        end
        return
    end

    if minute < 0 or minute > 59 then
        if source == 0 then
            print("^1[Time Control] ^7Menit harus antara 0-59!")
        else
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                args = {"System", "Menit harus antara 0-59!"}
            })
        end
        return
    end

    -- Trigger ke semua clients
    TriggerClientEvent('time_weather:setTime', -1, hour, minute)

    -- Notifikasi
    local adminName = source == 0 and "Console" or GetPlayerName(source)
    local message = string.format("Waktu diubah menjadi %02d:%02d oleh %s", hour, minute, adminName)
    
    print(string.format("^2[Time Control] ^7%s", message))
    
    if source ~= 0 then
        TriggerClientEvent('chat:addMessage', -1, {
            color = {0, 255, 255},
            args = {"System", message}
        })
    end
end, false)

-- Command /weather
RegisterCommand('weather', function(source, args, rawCommand)
    if source ~= 0 and not isAdmin(source) then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            args = {"System", "Anda tidak memiliki izin untuk command ini!"}
        })
        return
    end

    if #args == 0 then
        local helpText = "Gunakan: weather [tipe]\nTipe: clear, extrasunny, clouds, overcast, rain, clearing, thunder, smog, foggy, xmas, snowlight, blizzard"
        if source == 0 then
            print("^1[Weather Control] ^7" .. helpText)
        else
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 165, 0},
                args = {"System", helpText}
            })
        end
        return
    end

    local weatherType = string.upper(args[1])
    local validWeathers = {
        "CLEAR", "EXTRASUNNY", "CLOUDS", "OVERCAST", "RAIN", 
        "CLEARING", "THUNDER", "SMOG", "FOGGY", "XMAS", 
        "SNOWLIGHT", "BLIZZARD"
    }

    local isValid = false
    for _, weather in ipairs(validWeathers) do
        if weatherType == weather then
            isValid = true
            break
        end
    end

    if not isValid then
        if source == 0 then
            print("^1[Weather Control] ^7Tipe cuaca tidak valid!")
        else
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                args = {"System", "Tipe cuaca tidak valid!"}
            })
        end
        return
    end

    -- Trigger ke semua clients
    TriggerClientEvent('time_weather:setWeather', -1, weatherType)

    -- Notifikasi
    local adminName = source == 0 and "Console" or GetPlayerName(source)
    local message = string.format("Cuaca diubah menjadi %s oleh %s", weatherType, adminName)
    
    print(string.format("^2[Weather Control] ^7%s", message))
    
    if source ~= 0 then
        TriggerClientEvent('chat:addMessage', -1, {
            color = {0, 255, 255},
            args = {"System", message}
        })
    end
end, false)

print('^2[Time & Weather Control] ^7Server loaded!')
