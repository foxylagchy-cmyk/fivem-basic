lib.addCommand('revive', {
    help = 'Revive a player (Admin Only)',
    params = {
        {
            name = 'id',
            type = 'playerId',
            help = 'Player ID to revive',
            optional = true,
        }
    },
    restricted = 'group.admin'
}, function(source, args)
    -- Debug logging
    print('[cmd_revivekill] Revive command called')
    print('[cmd_revivekill] Source:', source)
    print('[cmd_revivekill] Args:', json.encode(args))
    
    -- args.id is the player ID from ox_lib
    local target = args.id or source
    
    print('[cmd_revivekill] Target resolved:', target)
    
    -- Validate target
    if not target or target == 0 then
        print('[cmd_revivekill] Invalid target ID')
        if source > 0 then
            lib.notify(source, { 
                title = 'Error', 
                description = 'Invalid player ID', 
                type = 'error' 
            })
        end
        return
    end
    
    -- Check if player exists
    local targetPlayer = GetPlayerName(target)
    print('[cmd_revivekill] Target player name:', targetPlayer or 'NOT FOUND')
    
    if not targetPlayer then
        print('[cmd_revivekill] Player not found or offline')
        if source > 0 then
            lib.notify(source, { 
                title = 'Error', 
                description = 'Player not found or offline (ID: ' .. target .. ')', 
                type = 'error' 
            })
        end
        return
    end
    
    print('[cmd_revivekill] Triggering revive events for player:', target)
    
    -- Trigger revive events
    TriggerClientEvent('qbx_medical:client:playerRevived', target)
    print('[cmd_revivekill] Sent qbx_medical:client:playerRevived')
    
    TriggerClientEvent('injury:client:revive', target)
    print('[cmd_revivekill] Sent injury:client:revive')
    
    -- Notify target player
    local adminName = (source > 0) and GetPlayerName(source) or "Console"
    
    -- Try ceria_bodycam notification
    local notifySuccess = pcall(function()
        TriggerClientEvent('ceria_bodycam:client:notify', target, 'success', {
            'ADMIN SYSTEM',
            'Kamu telah disembuhkan oleh Admin: ' .. adminName
        })
    end)
    
    -- Fallback notification if ceria_bodycam not available
    if not notifySuccess then
        TriggerClientEvent('QBCore:Notify', target, 'You have been revived by Admin: ' .. adminName, 'success')
    end

    -- Notify admin
    if source > 0 then
        lib.notify(source, { 
            title = 'Admin', 
            description = 'Player ' .. targetPlayer .. ' (ID: ' .. target .. ') revived successfully.', 
            type = 'success' 
        })
    end
    
    -- Log for debugging
    print(string.format('[cmd_revivekill] SUCCESS: Admin %s revived player %s (ID: %s)', 
        adminName, targetPlayer, target))
end)

lib.addCommand('reviveall', {
    help = 'Revive all players (Admin Only)',
    restricted = 'group.admin'
}, function(source, args)
    local players = GetPlayers()
    local adminName = (source > 0) and GetPlayerName(source) or "Console"
    
    for _, playerId in ipairs(players) do
        local target = tonumber(playerId)
        TriggerClientEvent('qbx_medical:client:playerRevived', target)
        TriggerClientEvent('injury:client:revive', target)
        TriggerClientEvent('ceria_bodycam:client:notify', target, 'success', {
            'ADMIN SYSTEM',
            'Kamu telah disembuhkan oleh Admin: ' .. adminName
        })
    end
    if source > 0 then
        lib.notify(source, { title = 'Admin', description = 'All players revived successfully.', type = 'success' })
    end
end)

lib.addCommand('kill', {
    help = 'Kill a player (Admin Only)',
    params = {
        {
            name = 'id',
            type = 'playerId',
            help = 'Player ID to kill',
            optional = true,
        }
    },
    restricted = 'group.admin'
}, function(source, args)
    local target = args.id or source
    if target == 0 then return end -- Console cannot be killed
    TriggerClientEvent('cmd_revivekill:client:killPlayer', target)
    if source > 0 then
        lib.notify(source, { title = 'Admin', description = 'Kill command executed.', type = 'info' })
    end
end)

lib.addCommand('killall', {
    help = 'Kill all players (Admin Only)',
    restricted = 'group.admin'
}, function(source, args)
    local players = GetPlayers()
    for _, playerId in ipairs(players) do
        TriggerClientEvent('cmd_revivekill:client:killPlayer', tonumber(playerId))
    end
    if source > 0 then
        lib.notify(source, { title = 'Admin', description = 'Kill all command executed.', type = 'info' })
    end
end)
