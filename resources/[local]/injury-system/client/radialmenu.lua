-- Integrasi dengan RadialMenu atau Target System
-- File ini optional, hanya jika ingin integrasi dengan radialmenu

-- Function untuk revive player terdekat
RegisterNetEvent('injury:client:medicReviveNearby', function()
    local PlayerData = QBX.PlayerData
    
    -- Cek apakah player adalah medis
    local isMedic = false
    for _, job in ipairs(Config.MedicJobs) do
        if PlayerData.job.name == job or PlayerData.job.type == job then
            isMedic = true
            break
        end
    end
    
    if not isMedic then
        exports.qbx_core:Notify(Config.Messages.NotMedic, 'error', 3000)
        return
    end
    
    -- Cari player terdekat
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local closestPlayer = nil
    local closestDistance = Config.ReviveDistance
    
    for _, player in ipairs(GetActivePlayers()) do
        local targetPed = GetPlayerPed(player)
        if targetPed ~= playerPed then
            local targetCoords = GetEntityCoords(targetPed)
            local distance = #(playerCoords - targetCoords)
            
            if distance < closestDistance then
                closestPlayer = GetPlayerServerId(player)
                closestDistance = distance
            end
        end
    end
    
    if closestPlayer then
        -- Callback untuk cek status target
        lib.callback('injury:server:getPlayerStatus', false, function(status)
            if status and (status.isDead or status.isKnocked) then
                -- Mulai proses revive
                StartReviveProcess(closestPlayer)
            else
                exports.qbx_core:Notify('Player tidak memerlukan bantuan medis', 'error', 3000)
            end
        end, closestPlayer)
    else
        exports.qbx_core:Notify('Tidak ada player terluka di dekatmu', 'error', 3000)
    end
end)

-- Function untuk proses revive dengan progress bar
function StartReviveProcess(targetPlayerId)
    local playerPed = PlayerPedId()
    
    -- Load animation
    local dict = "amb@medic@standing@kneel@base"
    local anim = "base"
    
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
    
    TaskPlayAnim(playerPed, dict, anim, 8.0, -8.0, -1, 1, 0, false, false, false)
    
    -- Progress bar menggunakan lib.progressBar (ox_lib)
    if lib.progressBar({
        duration = 10000,
        label = 'Merevive player...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            combat = true,
        },
        anim = {
            dict = dict,
            clip = anim
        },
    }) then
        -- Done
        ClearPedTasks(playerPed)
        TriggerServerEvent('injury:server:medicRevive', targetPlayerId)
    else
        -- Cancelled
        ClearPedTasks(playerPed)
        exports.qbx_core:Notify('Revive dibatalkan', 'error', 3000)
    end
end

-- Event untuk check nearby injured players (untuk indicator)
RegisterNetEvent('injury:client:checkNearbyInjured', function()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local injuredNearby = false
    
    for _, player in ipairs(GetActivePlayers()) do
        local targetPed = GetPlayerPed(player)
        if targetPed ~= playerPed then
            local targetCoords = GetEntityCoords(targetPed)
            local distance = #(playerCoords - targetCoords)
            
            if distance < Config.ReviveDistance then
                local targetId = GetPlayerServerId(player)
                lib.callback('injury:server:getPlayerStatus', false, function(status)
                    if status and (status.isDead or status.isKnocked) then
                        injuredNearby = true
                    end
                end, targetId)
            end
        end
    end
    
    return injuredNearby
end)

-- Command untuk revive (alternative)
RegisterCommand('revive', function(source, args)
    TriggerEvent('injury:client:medicReviveNearby')
end, false)
