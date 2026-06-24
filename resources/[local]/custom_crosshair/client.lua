local displayCrosshair = true
local currentModel = 1
local isAiming = false

RegisterCommand('crosshair', function(source, args)
    if args[1] then
        local model = tonumber(args[1])
        if model and model >= 1 and model <= 3 then
            currentModel = model
            SendNUIMessage({
                action = "setModel",
                model = currentModel
            })
            TriggerEvent('chat:addMessage', {
                color = {0, 255, 0},
                multiline = true,
                args = {"Crosshair", "Berhasil mengganti crosshair ke model " .. currentModel}
            })
        elseif args[1] == "off" then
            displayCrosshair = false
            SendNUIMessage({
                action = "hide"
            })
            TriggerEvent('chat:addMessage', {
                color = {255, 0, 0},
                multiline = true,
                args = {"Crosshair", "Crosshair dinonaktifkan."}
            })
        elseif args[1] == "on" then
            displayCrosshair = true
            TriggerEvent('chat:addMessage', {
                color = {0, 255, 0},
                multiline = true,
                args = {"Crosshair", "Crosshair diaktifkan."}
            })
        else
            TriggerEvent('chat:addMessage', {
                color = {255, 255, 0},
                multiline = true,
                args = {"Crosshair", "Gunakan: /crosshair [1-3] atau /crosshair [on/off]"}
            })
        end
    else
        -- Toggle if no args
        displayCrosshair = not displayCrosshair
        local status = displayCrosshair and "diaktifkan" or "dinonaktifkan"
        local color = displayCrosshair and {0, 255, 0} or {255, 0, 0}
        
        if not displayCrosshair then
            SendNUIMessage({
                action = "hide"
            })
        end
        
        TriggerEvent('chat:addMessage', {
            color = color,
            multiline = true,
            args = {"Crosshair", "Crosshair " .. status}
        })
    end
end, false)

CreateThread(function()
    while true do
        Wait(0)
        
        if displayCrosshair then
            local ped = PlayerPedId()
            -- Cek apakah player sedang aiming atau menembak
            local aiming, _ = GetEntityPlayerIsFreeAimingAt(PlayerId())
            local isFreeAiming = IsPlayerFreeAiming(PlayerId())
            local isShooting = IsPedShooting(ped)
            local isInVehicle = IsPedInAnyVehicle(ped, false)
            
            -- Sembunyikan reticle default dari game
            HideHudComponentThisFrame(14) -- DEFAULT RETICLE
            
            local shouldShow = false
            
            if isFreeAiming or isShooting then
                -- Jangan tampilkan kalau lagi pakai sniper scope (karena ada scope bawaan)
                local _, weaponHash = GetCurrentPedWeapon(ped, true)
                local weaponGroup = GetWeapontypeGroup(weaponHash)
                
                -- Group 860033945 = SNIPER_RIFLE
                if weaponGroup ~= 860033945 then
                    shouldShow = true
                end
            end
            
            if shouldShow and not isAiming then
                isAiming = true
                SendNUIMessage({
                    action = "show"
                })
            elseif not shouldShow and isAiming then
                isAiming = false
                SendNUIMessage({
                    action = "hide"
                })
            end
        else
            Wait(500) -- Wait if crosshair is totally disabled
        end
    end
end)
