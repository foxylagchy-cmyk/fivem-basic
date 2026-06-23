local PlayerData = {}
local isKnocked = false
local isDead = false
local knockStartTime = 0
local deathStartTime = 0
local injuryWalkActive = false
local isPlayerLoaded = false
local lastReviveTime = 0  -- Cooldown untuk prevent re-trigger

-- Forward declarations
local StartKnockPhase
local StartDeathPhase
local RevivePlayer
local StartInjuryWalk

-- Ambil player data saat spawn
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    isPlayerLoaded = true
    print('[Injury System] Player loaded via event')
end)

-- Update player data saat berubah (tidak perlu untuk health monitor)
RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
    -- PlayerData = val (not needed)
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        Wait(2000) -- Wait lebih lama untuk QBX load
        
        -- Cek apakah player sudah login
        if LocalPlayer.state.isLoggedIn then
            -- Langsung set player loaded tanpa akses QBX.PlayerData
            isPlayerLoaded = true
            print('[Injury System] Resource started - Player already logged in')
        end
        print('[Injury System] Client script loaded')
        print('[Injury System] Health monitor thread starting...')
    end
end)

-- Fungsi untuk load animation
local function LoadAnimDict(dict)
    if HasAnimDictLoaded(dict) then return end
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
end

-- Fungsi untuk memulai fase knock
StartKnockPhase = function()
    if Config.Debug then
        print('[Injury System] StartKnockPhase called - isKnocked:', isKnocked, 'isDead:', isDead)
    end
    
    if isKnocked or isDead then return end
    if not Config.EnableKnockPhase then return end
    
    isKnocked = true
    knockStartTime = GetGameTimer()
    
    local playerPed = PlayerPedId()
    
    if Config.Debug then
        print('[Injury System] Knock phase started!')
    end
    
    -- Tampilkan notifikasi blur dengan text
    SendNUIMessage({
        type = "showBleedingScreen",
        message = Config.Messages.BleedingPhase
    })
    
    -- Play crawl animation (stuck di tempat)
    LoadAnimDict(Config.KnockAnimation.dict)
    TaskPlayAnim(playerPed, Config.KnockAnimation.dict, Config.KnockAnimation.anim, 8.0, 1.0, -1, 1, 0, false, false, false)
    
    -- Set health rendah tapi tidak mati
    SetEntityHealth(playerPed, Config.KnockHealthSet)
    
    -- Freeze position agar stuck di tempat
    FreezeEntityPosition(playerPed, true)
    
    -- Loop animation agar tetap crawl
    CreateThread(function()
        while isKnocked and not isDead do
            Wait(1000)
            if not IsEntityPlayingAnim(playerPed, Config.KnockAnimation.dict, Config.KnockAnimation.anim, 3) then
                TaskPlayAnim(playerPed, Config.KnockAnimation.dict, Config.KnockAnimation.anim, 8.0, 1.0, -1, 1, 0, false, false, false)
            end
        end
        -- Unfreeze saat masuk death phase
        FreezeEntityPosition(playerPed, false)
    end)
    
    -- Disable semua movement, hanya voice chat
    CreateThread(function()
        while isKnocked and not isDead do
            Wait(0)
            
            -- Disable ALL movement
            DisableControlAction(0, 30, true)  -- Move Left/Right
            DisableControlAction(0, 31, true)  -- Move Up/Down
            DisableControlAction(0, 21, true)  -- Sprint
            DisableControlAction(0, 22, true)  -- Jump
            DisableControlAction(0, 24, true)  -- Attack
            DisableControlAction(0, 25, true)  -- Aim
            DisableControlAction(0, 140, true) -- Melee Attack Light
            DisableControlAction(0, 141, true) -- Melee Attack Heavy
            DisableControlAction(0, 257, true) -- Attack 2
            DisableControlAction(0, 263, true) -- Melee Attack 1
            
            -- Enable camera
            EnableControlAction(0, 1, true)   -- Look Left/Right
            EnableControlAction(0, 2, true)   -- Look Up/Down
            
            -- Enable voice chat
            if Config.EnableVoiceInKnock then
                EnableControlAction(0, 249, true)  -- Push to Talk
                EnableControlAction(0, 46, true)   -- Honk/Talk
            end
            
            -- Cek apakah sudah waktu untuk death phase
            if GetGameTimer() - knockStartTime >= Config.KnockDuration then
                StartDeathPhase()
                break
            end
        end
    end)
    
    -- Notify server
    TriggerServerEvent('injury:server:setKnockStatus', true)
    
    -- Timer countdown UI
    CreateThread(function()
        while isKnocked and not isDead do
            local timeLeft = math.ceil((Config.KnockDuration - (GetGameTimer() - knockStartTime)) / 1000)
            if timeLeft > 0 then
                SendNUIMessage({
                    type = "updateKnockTimer",
                    time = timeLeft
                })
            end
            Wait(1000)
        end
    end)
end

-- Fungsi untuk memulai fase death/pingsan
StartDeathPhase = function()
    if isDead then return end
    if not Config.EnableDeathPhase then return end
    
    isKnocked = false
    isDead = true
    deathStartTime = GetGameTimer()
    
    local playerPed = PlayerPedId()
    
    -- Clear animasi knock
    ClearPedTasksImmediately(playerPed)
    
    -- Tampilkan screen mati
    SendNUIMessage({
        type = "showDeathScreen",
        message = Config.Messages.DeathPhase
    })
    
    -- Set ke unconscious state
    SetEntityInvincible(playerPed, true)
    SetEntityHealth(playerPed, Config.DeathHealthSet)
    
    -- Freeze position agar benar-benar stuck
    FreezeEntityPosition(playerPed, true)
    
    -- Dead animation menggunakan NetworkResurrectLocalPlayer agar bisa di-resurrect
    SetEntityHealth(playerPed, 0)
    
    Wait(100)
    
    -- Set back to alive tapi dengan animasi dead
    SetEntityHealth(playerPed, Config.DeathHealthSet)
    SetEntityInvincible(playerPed, true)
    
    -- Play dead anim sekali aja, bukan loop
    LoadAnimDict(Config.DeathAnimation.dict)
    TaskPlayAnim(playerPed, Config.DeathAnimation.dict, Config.DeathAnimation.anim, 8.0, 1.0, -1, 1, 0, false, false, false)
    
    -- Set metadata server
    TriggerServerEvent('injury:server:setDeathStatus', true)
    TriggerServerEvent('hospital:server:SetDeathStatus', true)
    
    -- Disable kontrol - stuck di tempat, tidak bisa bergerak
    CreateThread(function()
        while isDead do
            Wait(0)
            
            -- Disable ALL movement dan actions
            DisableControlAction(0, 30, true)  -- Move Left/Right
            DisableControlAction(0, 31, true)  -- Move Up/Down
            DisableControlAction(0, 21, true)  -- Sprint
            DisableControlAction(0, 22, true)  -- Jump
            DisableControlAction(0, 23, true)  -- Enter Vehicle
            DisableControlAction(0, 24, true)  -- Attack
            DisableControlAction(0, 25, true)  -- Aim
            DisableControlAction(0, 36, true)  -- Ctrl (Duck)
            DisableControlAction(0, 37, true)  -- Select Weapon
            DisableControlAction(0, 44, true)  -- Cover
            DisableControlAction(0, 45, true)  -- Reload
            DisableControlAction(0, 140, true) -- Melee Attack Light
            DisableControlAction(0, 141, true) -- Melee Attack Heavy
            DisableControlAction(0, 142, true) -- Melee Attack Alternate
            DisableControlAction(0, 143, true) -- Melee Block
            DisableControlAction(0, 257, true) -- Attack 2
            DisableControlAction(0, 263, true) -- Melee Attack 1
            DisableControlAction(0, 264, true) -- Melee Attack 2
            
            -- Enable camera only
            EnableControlAction(0, 1, true)   -- Look Left/Right
            EnableControlAction(0, 2, true)   -- Look Up/Down
        end
    end)
    
    -- Timer countdown untuk respawn
    CreateThread(function()
        while isDead do
            local timeLeft = math.ceil((Config.DeathDuration - (GetGameTimer() - deathStartTime)) / 1000)
            if timeLeft > 0 then
                local minutes = math.floor(timeLeft / 60)
                local seconds = timeLeft % 60
                SendNUIMessage({
                    type = "updateDeathTimer",
                    time = string.format("%02d:%02d", minutes, seconds)
                })
            else
                -- Waktu habis, respawn
                RevivePlayer()
                break
            end
            Wait(1000)
        end
    end)
end

-- Fungsi untuk revive player
RevivePlayer = function()
    local playerPed = PlayerPedId()
    
    -- Set flags dulu untuk stop semua threads
    isDead = false
    isKnocked = false
    injuryWalkActive = false  -- Reset flag ini juga
    lastReviveTime = GetGameTimer()  -- Set cooldown
    
    -- Wait sebentar biar threads stop
    Wait(100)
    
    -- Unfreeze position
    FreezeEntityPosition(playerPed, false)
    
    -- Force clear all tasks dan animations
    ClearPedTasks(playerPed)
    ClearPedTasksImmediately(playerPed)
    ClearPedSecondaryTask(playerPed)
    
    -- Clear blood/wounds
    ClearPedBloodDamage(playerPed)
    ResetPedVisibleDamage(playerPed)
    ClearPedWetness(playerPed)
    ClearPedEnvDirt(playerPed)
    
    -- Reset ped completely
    SetEntityCoordsNoOffset(playerPed, GetEntityCoords(playerPed).x, GetEntityCoords(playerPed).y, GetEntityCoords(playerPed).z, false, false, false)
    SetEntityHeading(playerPed, GetEntityHeading(playerPed))
    
    -- Reset all states
    SetEntityInvincible(playerPed, false)
    SetEntityHealth(playerPed, Config.ReviveHealth)
    SetPedCanRagdoll(playerPed, true)
    SetPedArmour(playerPed, 0)
    
    -- Heal stats (hunger, thirst, stress)
    TriggerServerEvent('injury:server:healStats')
    
    -- Resurrect (paksa bangun)
    ResurrectPed(playerPed)
    
    -- Wait
    Wait(200)
    
    -- Clear lagi untuk mastiin
    ClearPedTasksImmediately(playerPed)
    
    -- Reset movement clipset ke normal
    ResetPedMovementClipset(playerPed, 0.0)
    ResetPedStrafeClipset(playerPed)
    ResetPedWeaponMovementClipset(playerPed)
    
    -- Hide UI
    SendNUIMessage({
        type = "hideScreens"
    })
    
    -- Wait
    Wait(300)
    
    -- Aktifkan injury walk jika diaktifkan
    if Config.EnableInjuryWalk then
        StartInjuryWalk()
    end
    
    -- Update server
    TriggerServerEvent('injury:server:setDeathStatus', false)
    TriggerServerEvent('hospital:server:SetDeathStatus', false)
    TriggerServerEvent('injury:server:setKnockStatus', false)
    
    exports.qbx_core:Notify(Config.Messages.WakeUpInjured, 'error', 5000)
end

-- Fungsi untuk injury walk
StartInjuryWalk = function()
    print('[Injury System] StartInjuryWalk called - injuryWalkActive:', injuryWalkActive)
    
    if injuryWalkActive then 
        print('[Injury System] Injury walk already active, skipping')
        return 
    end
    
    injuryWalkActive = true
    local playerPed = PlayerPedId()
    
    print('[Injury System] Setting injury walk...')
    
    -- Clear semua animasi dulu
    ClearPedTasksImmediately(playerPed)
    
    -- Wait sedikit
    Wait(200)
    
    -- Reset ALL movement clipsets ke normal dulu
    ResetPedMovementClipset(playerPed, 0.0)
    ResetPedStrafeClipset(playerPed)
    ResetPedWeaponMovementClipset(playerPed)
    
    -- Wait lagi
    Wait(200)
    
    -- Set clipset untuk jalan terluka
    RequestAnimSet(Config.InjuryWalkClipset)
    while not HasAnimSetLoaded(Config.InjuryWalkClipset) do
        Wait(10)
    end
    
    SetPedMovementClipset(playerPed, Config.InjuryWalkClipset, 1.0)
    
    print('[Injury System] Injury walk activated for', Config.InjuryWalkDuration / 1000, 'seconds')
    
    -- Durasi injury walk dari config
    SetTimeout(Config.InjuryWalkDuration, function()
        ResetPedMovementClipset(playerPed, 0.0)
        injuryWalkActive = false
        exports.qbx_core:Notify(Config.Messages.InjuryHealed, 'success', 3000)
    end)
end

-- Monitor health untuk trigger knock phase
CreateThread(function()
    print('[Injury System] Health monitor thread started!')
    
    while true do
        Wait(100)
        
        -- Debug untuk cek kondisi
        if Config.Debug and GetGameTimer() % 5000 < 100 then -- Print every 5 seconds
            print('[Injury System] Monitor check - isLoggedIn:', LocalPlayer.state.isLoggedIn, 'isPlayerLoaded:', isPlayerLoaded)
        end
        
        if LocalPlayer.state.isLoggedIn and isPlayerLoaded then
            local playerPed = PlayerPedId()
            local health = GetEntityHealth(playerPed)
            local timeSinceRevive = GetGameTimer() - lastReviveTime
            
            if Config.Debug and health <= Config.KnockHealthThreshold then
                print('[Injury System] Health:', health, 'Threshold:', Config.KnockHealthThreshold, 'isKnocked:', isKnocked, 'isDead:', isDead, 'Cooldown:', timeSinceRevive)
            end
            
            -- Jika health habis dan belum dalam fase knock/death
            -- DAN sudah lewat 5 detik dari last revive (cooldown)
            if health <= Config.KnockHealthThreshold and not isKnocked and not isDead and timeSinceRevive > 5000 then
                print('[Injury System] Triggering knock phase - Health:', health)
                StartKnockPhase()
            end
        end
    end
end)

-- Event untuk medic revive
RegisterNetEvent('injury:client:medicRevive', function()
    if not isDead and not isKnocked then return end
    
    isDead = false
    isKnocked = false
    
    local playerPed = PlayerPedId()
    
    -- Clear state
    ClearPedTasksImmediately(playerPed)
    SetEntityInvincible(playerPed, false)
    SetEntityHealth(playerPed, Config.ReviveHealth)
    
    -- Hide UI
    SendNUIMessage({
        type = "hideScreens"
    })
    
    -- Update server
    TriggerServerEvent('injury:server:setDeathStatus', false)
    TriggerServerEvent('hospital:server:SetDeathStatus', false)
    TriggerServerEvent('injury:server:setKnockStatus', false)
    
    exports.qbx_core:Notify(Config.Messages.MedicRevive, 'success', 5000)
end)

-- Event untuk admin revive
RegisterNetEvent('injury:client:revive', function()
    print('[Injury System] Admin revive event triggered')
    RevivePlayer()
end)

-- Command untuk test (hanya jika diaktifkan di config)
if Config.EnableTestCommands then
    RegisterCommand('testknock', function()
        print('[Injury System] Command /testknock executed')
        StartKnockPhase()
    end, false)

    RegisterCommand('testrevive', function()
        print('[Injury System] Command /testrevive executed')
        RevivePlayer()
    end, false)

    RegisterCommand('stopinjury', function()
        print('[Injury System] Command /stopinjury executed')
        local playerPed = PlayerPedId()
        ResetPedMovementClipset(playerPed, 0.0)
        injuryWalkActive = false
        exports.qbx_core:Notify('Injury walk dihentikan', 'info', 3000)
    end, false)
    
    print('[Injury System] Test commands registered: /testknock, /testrevive, /stopinjury')
end
