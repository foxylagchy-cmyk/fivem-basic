-- Client-side heal script

-- Event untuk heal player
RegisterNetEvent('cmd_heal:healPlayer', function()
    local ped = PlayerPedId()
    
    -- Set health penuh (200 = max health)
    SetEntityHealth(ped, 200)
    
    -- Hapus semua damage visual (blood, etc)
    ClearPedBloodDamage(ped)
    ResetPedVisibleDamage(ped)
    
    -- Clear ped tasks (jika sedang jatuh/terluka)
    ClearPedTasksImmediately(ped)
    
    -- Revive jika player mati (untuk QBX)
    if GetEntityHealth(ped) <= 0 then
        local coords = GetEntityCoords(ped)
        NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, GetEntityHeading(ped), true, false)
        SetEntityHealth(ped, 200)
    end
    
    -- Set armor penuh (optional, bisa dikomentari jika tidak mau full armor)
    SetPedArmour(ped, 100)
    
    -- Restore Hunger & Thirst (QBX Status System)
    if GetResourceState('qbx_core') == 'started' then
        -- QBX menggunakan status system
        TriggerServerEvent('cmd_heal:restoreNeeds')
    end
    
    -- Hapus efek bleeding jika ada (QBX/QB compatibility)
    if GetResourceState('qbx_ambulancejob') == 'started' then
        TriggerEvent('hospital:client:RemoveBleed')
        TriggerEvent('hospital:client:ResetLimbs')
    end
    
    -- Play heal effect - Pilih salah satu atau nonaktifkan semua
    -- OPSI 1: Efek mabuk/alien (TIDAK DIREKOMENDASIKAN)
    -- AnimpostfxPlay("DrugsMichaelAliensFight", 3000, true)
    
    -- OPSI 2: Efek celebration halus (DEFAULT - AKTIF)
    AnimpostfxPlay("HeistCelebPass", 2000, false)
    
    -- OPSI 3: Efek rampage (action movie style)
    -- AnimpostfxPlay("RaceTurbo", 1000, false)
    
    -- OPSI 4: Tanpa efek visual (komentari semua baris AnimpostfxPlay)
    
    print('[HEAL] Player healed successfully (Health + Armor + Hunger + Thirst)')
end)
