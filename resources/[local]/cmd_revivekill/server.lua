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
    local target = args.id or source
    if target == 0 then return end -- Console cannot be revived
    TriggerClientEvent('qbx_medical:client:playerRevived', target)
    TriggerClientEvent('injury:client:revive', target)
    
    local adminName = (source > 0) and GetPlayerName(source) or "Console"
    TriggerClientEvent('ceria_bodycam:client:notify', target, 'success', {
        'ADMIN SYSTEM',
        'Kamu telah disembuhkan oleh Admin: ' .. adminName
    })

    if source > 0 then
        lib.notify(source, { title = 'Admin', description = 'Player revived successfully.', type = 'success' })
    end
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
