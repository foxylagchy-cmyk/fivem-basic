-- SERVER-SIDE CRASH MONITORING & LOGGING

local crashLog = {}
local freezeLog = {}

RegisterNetEvent('crash-prevention:reportFreeze', function()
    local src = source
    local playerName = GetPlayerName(src)
    local identifiers = GetPlayerIdentifiers(src)
    
    table.insert(freezeLog, {
        player = playerName,
        source = src,
        identifiers = identifiers,
        time = os.date('%Y-%m-%d %H:%M:%S')
    })
    
    print(string.format("^3[CRASH PREVENTION]^7 Freeze reported by %s (ID: %d)", playerName, src))
    
    -- Notify admins
    for _, playerId in ipairs(GetPlayers()) do
        if IsPlayerAceAllowed(playerId, "command.announce") then
            TriggerClientEvent('chat:addMessage', playerId, {
                args = { "^3[CRASH WARN]", string.format("Player %s melaporkan freeze/lag", playerName) }
            })
        end
    end
end)

-- Command untuk melihat crash log (admin only)
RegisterCommand('crashlog', function(source, args, rawCommand)
    if source == 0 or IsPlayerAceAllowed(source, "command.announce") then
        if #freezeLog == 0 then
            if source > 0 then
                TriggerClientEvent('chat:addMessage', source, {
                    args = { "^2INFO", "Tidak ada freeze report" }
                })
            else
                print("^2[INFO]^7 Tidak ada freeze report")
            end
            return
        end
        
        print("^3========================================")
        print("^3  FREEZE/CRASH REPORTS")
        print("^3========================================")
        for i, log in ipairs(freezeLog) do
            print(string.format("^7[%d] %s - %s (ID: %d)", i, log.time, log.player, log.source))
        end
        print("^3========================================")
        
        if source > 0 then
            TriggerClientEvent('chat:addMessage', source, {
                args = { "^2INFO", string.format("Check console untuk %d freeze reports", #freezeLog) }
            })
        end
    end
end, false)

-- Command untuk clear crash log
RegisterCommand('clearcrashlogs', function(source, args, rawCommand)
    if source == 0 or IsPlayerAceAllowed(source, "command.announce") then
        freezeLog = {}
        print("^2[CRASH PREVENTION]^7 Crash logs cleared")
        
        if source > 0 then
            TriggerClientEvent('chat:addMessage', source, {
                args = { "^2SUCCESS", "Crash logs telah di-clear" }
            })
        end
    end
end, false)

-- Monitor server performance
CreateThread(function()
    while true do
        Wait(60000) -- Check every minute
        
        local memoryUsage = collectgarbage('count')
        local players = #GetPlayers()
        
        -- Log jika memory tinggi
        if memoryUsage > 500000 then -- 500MB
            print(string.format("^3[CRASH PREVENTION]^7 High server memory usage: %.2f MB", memoryUsage / 1024))
            
            -- Trigger garbage collection
            collectgarbage('collect')
        end
    end
end)

print([[
^2========================================
^3  CRASH PREVENTION SERVER LOADED
^2========================================
^7Commands:
^5  /crashlog^7 - View freeze reports
^5  /clearcrashlogs^7 - Clear logs
^2========================================
]])
