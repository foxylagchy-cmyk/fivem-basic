local Config = {
    announcementMessage = "🔔 Server telah direstart! Semua sistem online kembali.",
    announcementDuration = 10000, -- 10 detik
    delayAfterStart = 5000, -- Delay 5 detik setelah resource start
}

-- Fungsi untuk mengirim announcement ke semua player
local function sendServerAnnouncement(message)
    local players = GetPlayers()
    
    for _, playerId in ipairs(players) do
        -- Kirim announcement via txAdmin jika tersedia
        TriggerClientEvent('chat:addMessage', playerId, {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background: linear-gradient(135deg, rgba(0, 255, 255, 0.2) 0%, rgba(0, 150, 255, 0.2) 100%); border-radius: 8px; border-left: 4px solid cyan; box-shadow: 0 0 10px rgba(0, 255, 255, 0.3);"><i class="fas fa-server"></i> <strong style="color: cyan; text-shadow: 0 0 5px cyan;">SERVER ANNOUNCEMENT</strong><br>{0}</div>',
            args = { message }
        })
        
        -- Kirim notifikasi tambahan jika menggunakan qbx_core
        TriggerClientEvent('qbx_core:Notify', playerId, message, 'inform', Config.announcementDuration)
    end
    
    -- Log ke console
    print('^2[SERVER ANNOUNCER]^7 ' .. message)
end

-- Event saat resource dimulai
AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        -- Tunggu beberapa detik agar server stabil
        Wait(Config.delayAfterStart)
        
        -- Kirim announcement
        sendServerAnnouncement(Config.announcementMessage)
    end
end)

-- Command untuk manual announcement (admin only)
RegisterCommand('announce', function(source, args, rawCommand)
    -- Cek apakah player adalah admin (via txAdmin atau ace permissions)
    if source == 0 or IsPlayerAceAllowed(source, "command.announce") then
        local message = table.concat(args, " ")
        
        if message == "" then
            if source > 0 then
                TriggerClientEvent('chat:addMessage', source, {
                    args = { "^1ERROR", "Gunakan: /announce <pesan>" }
                })
            else
                print("^1[ERROR]^7 Gunakan: announce <pesan>")
            end
            return
        end
        
        sendServerAnnouncement(message)
        
        if source > 0 then
            TriggerClientEvent('chat:addMessage', source, {
                args = { "^2SUCCESS", "Announcement telah dikirim!" }
            })
        else
            print("^2[SUCCESS]^7 Announcement telah dikirim!")
        end
    else
        TriggerClientEvent('chat:addMessage', source, {
            args = { "^1ERROR", "Kamu tidak memiliki permission untuk command ini!" }
        })
    end
end, false)

-- Command untuk scheduled announcement
RegisterCommand('scheduleannounce', function(source, args, rawCommand)
    if source == 0 or IsPlayerAceAllowed(source, "command.announce") then
        local interval = tonumber(args[1])
        
        if not interval or interval < 60 then
            if source > 0 then
                TriggerClientEvent('chat:addMessage', source, {
                    args = { "^1ERROR", "Gunakan: /scheduleannounce <detik> <pesan> (minimal 60 detik)" }
                })
            else
                print("^1[ERROR]^7 Minimal interval 60 detik")
            end
            return
        end
        
        table.remove(args, 1)
        local message = table.concat(args, " ")
        
        if message == "" then
            if source > 0 then
                TriggerClientEvent('chat:addMessage', source, {
                    args = { "^1ERROR", "Pesan tidak boleh kosong!" }
                })
            end
            return
        end
        
        -- Buat scheduled announcement
        CreateThread(function()
            while true do
                Wait(interval * 1000)
                sendServerAnnouncement(message)
            end
        end)
        
        if source > 0 then
            TriggerClientEvent('chat:addMessage', source, {
                args = { "^2SUCCESS", string.format("Scheduled announcement dibuat (setiap %d detik)", interval) }
            })
        else
            print(string.format("^2[SUCCESS]^7 Scheduled announcement dibuat (setiap %d detik)", interval))
        end
    else
        TriggerClientEvent('chat:addMessage', source, {
            args = { "^1ERROR", "Kamu tidak memiliki permission untuk command ini!" }
        })
    end
end, false)

-- Announcement saat server akan shutdown (jika menggunakan txAdmin)
AddEventHandler('txAdmin:events:serverShuttingDown', function()
    sendServerAnnouncement("⚠️ Server akan shutdown dalam beberapa saat. Simpan progress kalian!")
end)

-- Print info saat resource dimulai
print([[
^2========================================
^3    SERVER ANNOUNCER LOADED!
^2========================================
^7Commands:
^5  /announce <pesan>^7 - Kirim announcement manual
^5  /scheduleannounce <detik> <pesan>^7 - Scheduled announcement
^2========================================
]])
