RegisterNetEvent('cmd_revivekill:client:killPlayer', function()
    local ped = cache.ped
    local playerId = cache.playerId
    
    -- Check if the player is in God Mode
    if not GetPlayerInvincible(playerId) then
        SetEntityHealth(ped, 0)
    else
        lib.notify({
            title = 'God Mode Active',
            description = 'Kamu selamat dari command /kill karena God Mode sedang aktif!',
            type = 'info'
        })
    end
end)
