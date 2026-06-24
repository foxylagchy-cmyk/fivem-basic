-- Event untuk set knock status
RegisterNetEvent('injury:server:setKnockStatus', function(status)
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player then return end
    
    -- Set custom metadata untuk knock
    Player.Functions.SetMetaData('inknock', status)
    
    -- Trigger untuk client lain (untuk interaction dengan player yang knock)
    TriggerClientEvent('injury:client:syncKnockStatus', -1, src, status)
end)

-- Event untuk set death status
RegisterNetEvent('injury:server:setDeathStatus', function(status)
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player then return end
    
    -- Update metadata isdead dan inlaststand
    Player.Functions.SetMetaData('isdead', status)
    Player.Functions.SetMetaData('inlaststand', status)
end)

-- Event untuk medic revive
RegisterNetEvent('injury:server:medicRevive', function(targetId)
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    local Target = exports.qbx_core:GetPlayer(targetId)
    
    if not Player or not Target then return end
    
    -- Cek apakah player adalah medic dari config
    local isMedic = false
    for _, job in ipairs(Config.MedicJobs) do
        if Player.PlayerData.job.name == job or Player.PlayerData.job.type == job then
            isMedic = true
            break
        end
    end
    
    if isMedic then
        -- Reset metadata target
        Target.Functions.SetMetaData('isdead', false)
        Target.Functions.SetMetaData('inlaststand', false)
        Target.Functions.SetMetaData('inknock', false)
        
        -- Trigger client untuk revive
        TriggerClientEvent('injury:client:medicRevive', targetId)
        
        -- Berikan reward jika diaktifkan
        if Config.ReviveReward > 0 then
            Player.Functions.AddMoney('cash', Config.ReviveReward)
            exports.qbx_core:Notify(src, Config.Messages.PatientSaved .. ' (+$' .. Config.ReviveReward .. ')', 'success', 5000)
        else
            exports.qbx_core:Notify(src, Config.Messages.PatientSaved, 'success', 5000)
        end
    else
        exports.qbx_core:Notify(src, Config.Messages.NotMedic, 'error', 3000)
    end
end)

-- Callback untuk cek status player (untuk interaction)
lib.callback.register('injury:server:getPlayerStatus', function(source, targetId)
    local Target = exports.qbx_core:GetPlayer(targetId)
    if not Target then 
        return nil
    end
    
    return {
        isDead = Target.PlayerData.metadata['isdead'],
        isKnocked = Target.PlayerData.metadata['inknock'],
        inLaststand = Target.PlayerData.metadata['inlaststand']
    }
end)

-- Event untuk heal stats setelah revive
RegisterNetEvent('injury:server:healStats', function()
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player then return end
    
    -- Set hunger dan thirst ke 30% (kondisi lemah)
    Player.Functions.SetMetaData('hunger', Config.ReviveHunger)
    Player.Functions.SetMetaData('thirst', Config.ReviveThirst)
    
    -- Reset stress ke 0
    if Player.PlayerData.metadata['stress'] then
        Player.Functions.SetMetaData('stress', 0)
    end
end)
