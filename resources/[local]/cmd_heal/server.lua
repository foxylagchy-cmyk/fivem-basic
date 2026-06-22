-- Server-side heal commands untuk administrator

-- Fungsi untuk check apakah player adalah admin
local function isAdmin(source)
    return IsPlayerAceAllowed(source, 'command.heal')
end

-- Server event untuk restore hunger & thirst
RegisterNetEvent('cmd_heal:restoreNeeds', function()
    local src = source
    
    -- QBX Core Player Status
    if GetResourceState('qbx_core') == 'started' then
        local Player = exports.qbx_core:GetPlayer(src)
        
        if Player then
            -- Set hunger dan thirst ke maximum (100%)
            Player.Functions.SetMetaData('hunger', 100)
            Player.Functions.SetMetaData('thirst', 100)
            
            -- Update status (fallback method)
            TriggerClientEvent('hud:client:UpdateNeeds', src, 100, 100)
        end
    end
end)

-- Command: /healme - Heal diri sendiri
lib.addCommand('healme', {
    help = 'Heal diri sendiri (Admin only)',
    restricted = 'group.admin'
}, function(source, args, raw)
    if not isAdmin(source) then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'Anda tidak memiliki akses ke command ini!',
            type = 'error'
        })
        return
    end

    -- Trigger heal untuk player yang menggunakan command
    TriggerClientEvent('cmd_heal:healPlayer', source)
    
    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Heal Complete',
        description = 'Health, Armor, Hunger & Thirst restored!',
        type = 'success'
    })
end)

-- Command: /heal [id/all] - Heal player lain atau semua player
lib.addCommand('heal', {
    help = 'Heal player lain atau semua player (Admin only)',
    params = {
        {
            name = 'target',
            type = 'string',
            help = 'ID player atau "all" untuk heal semua player',
        }
    },
    restricted = 'group.admin'
}, function(source, args, raw)
    if not isAdmin(source) then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'Anda tidak memiliki akses ke command ini!',
            type = 'error'
        })
        return
    end

    local target = args.target

    if not target then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'Gunakan: /heal [id] atau /heal all',
            type = 'error'
        })
        return
    end

    -- Heal semua player
    if target:lower() == 'all' then
        local players = GetPlayers()
        local healedCount = 0

        for _, playerId in ipairs(players) do
            local targetId = tonumber(playerId)
            if targetId then
                TriggerClientEvent('cmd_heal:healPlayer', targetId)
                healedCount = healedCount + 1
            end
        end

        -- Notify admin
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Heal All',
            description = 'Berhasil heal '..healedCount..' player!',
            type = 'success'
        })

        -- Notify semua player yang di-heal
        for _, playerId in ipairs(players) do
            local targetId = tonumber(playerId)
            if targetId then
                TriggerClientEvent('ox_lib:notify', targetId, {
                    title = 'Heal Complete',
                    description = 'You have been healed by Administrator! (Health + Hunger + Thirst)',
                    type = 'success'
                })
            end
        end

        -- Log ke console
        print(('[HEAL] Admin %s (%d) heal semua player (%d players)'):format(GetPlayerName(source), source, healedCount))
        return
    end

    -- Heal player tertentu berdasarkan ID
    local targetId = tonumber(target)
    
    if not targetId then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'ID player tidak valid!',
            type = 'error'
        })
        return
    end

    local targetPlayer = GetPlayerName(targetId)
    
    if not targetPlayer then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'Player dengan ID '..targetId..' tidak ditemukan!',
            type = 'error'
        })
        return
    end

    -- Trigger heal untuk target player
    TriggerClientEvent('cmd_heal:healPlayer', targetId)
    
    -- Notify admin
    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Heal',
        description = 'Berhasil heal '..targetPlayer..' (ID: '..targetId..')',
        type = 'success'
    })

    -- Notify target player
    TriggerClientEvent('ox_lib:notify', targetId, {
        title = 'Heal Complete',
        description = 'You have been healed by Administrator! (Health + Hunger + Thirst)',
        type = 'success'
    })

    -- Log ke console
    print(('[HEAL] Admin %s (%d) heal player %s (%d)'):format(GetPlayerName(source), source, targetPlayer, targetId))
end)
