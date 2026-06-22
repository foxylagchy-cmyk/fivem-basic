-- Fungsi untuk mengecek apakah player adalah admin menggunakan ACE permissions
local function isAdmin(source)
    -- Cek apakah player punya permission admin dari txAdmin atau server.cfg
    return IsPlayerAceAllowed(source, "command")
end

-- Command /report - User melaporkan ke Admin
RegisterCommand('report', function(source, args, rawCommand)
    if #args == 0 then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = true,
            args = {"System", "Gunakan: /report [pesan]"}
        })
        return
    end

    local message = table.concat(args, " ")
    local playerName = GetPlayerName(source)
    
    -- Kirim ke semua admin yang online
    for _, playerId in ipairs(GetPlayers()) do
        if isAdmin(tonumber(playerId)) then
            TriggerClientEvent('chat:addMessage', tonumber(playerId), {
                color = {255, 165, 0},
                multiline = true,
                args = {"[REPORT dari " .. playerName .. " (ID: " .. source .. ")]", message}
            })
        end
    end
    
    -- Konfirmasi ke player
    TriggerClientEvent('chat:addMessage', source, {
        color = {0, 255, 0},
        multiline = true,
        args = {"System", "Report Anda telah dikirim ke admin!"}
    })
end, false)

-- Command /staff - Admin memberikan informasi ke semua pemain
RegisterCommand('staff', function(source, args, rawCommand)
    if not isAdmin(source) then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = true,
            args = {"System", "Anda tidak memiliki izin untuk menggunakan command ini!"}
        })
        return
    end

    if #args == 0 then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = true,
            args = {"System", "Gunakan: /staff [pesan]"}
        })
        return
    end

    local message = table.concat(args, " ")
    local adminName = GetPlayerName(source)
    
    -- Kirim ke semua player
    TriggerClientEvent('chat:addMessage', -1, {
        color = {255, 0, 0},
        multiline = true,
        args = {"[STAFF - " .. adminName .. "]", message}
    })
end, false)

-- Command /staffo - Admin chat hanya untuk sesama admin
RegisterCommand('staffo', function(source, args, rawCommand)
    if not isAdmin(source) then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = true,
            args = {"System", "Anda tidak memiliki izin untuk menggunakan command ini!"}
        })
        return
    end

    if #args == 0 then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = true,
            args = {"System", "Gunakan: /staffo [pesan]"}
        })
        return
    end

    local message = table.concat(args, " ")
    local adminName = GetPlayerName(source)
    
    -- Kirim hanya ke admin yang online
    for _, playerId in ipairs(GetPlayers()) do
        if isAdmin(tonumber(playerId)) then
            TriggerClientEvent('chat:addMessage', tonumber(playerId), {
                color = {0, 200, 255},
                multiline = true,
                args = {"[STAFF ONLY - " .. adminName .. "]", message}
            })
        end
    end
end, false)

-- Command /ooc - Out of Character chat untuk semua
RegisterCommand('ooc', function(source, args, rawCommand)
    if #args == 0 then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = true,
            args = {"System", "Gunakan: /ooc [pesan]"}
        })
        return
    end

    local message = table.concat(args, " ")
    local playerName = GetPlayerName(source)
    
    -- Kirim ke semua player dengan format OOC
    TriggerClientEvent('chat:addMessage', -1, {
        color = {150, 150, 150},
        multiline = true,
        args = {"[OOC] " .. playerName, message}
    })
end, false)

-- Command /godcar - Admin membuat kendaraan kebal
RegisterCommand('godcar', function(source, args, rawCommand)
    if not isAdmin(source) then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = true,
            args = {"System", "Anda tidak memiliki izin untuk menggunakan command ini!"}
        })
        return
    end

    -- Trigger ke client untuk toggle godcar
    TriggerClientEvent('chat_commands:toggleGodCar', source)
end, false)

print('^2[Chat Commands] ^7Resource telah dimuat!')
print('^2[Chat Commands] ^7Commands tersedia: /report, /staff, /staffo, /ooc, /godcar')
