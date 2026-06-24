local revolverWeapons = {
    [`WEAPON_REVOLVER`] = { camShake = 0.15, padShakeIntensity = 255, padShakeDuration = 200 },
    [`WEAPON_NAVYREVOLVER`] = { camShake = 0.18, padShakeIntensity = 255, padShakeDuration = 250 },
    [`WEAPON_DOUBLEACTION`] = { camShake = 0.10, padShakeIntensity = 200, padShakeDuration = 150 }
}

CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        
        -- Cek jika player sedang menembak
        if IsPedShooting(ped) then
            local _, weaponHash = GetCurrentPedWeapon(ped, true)
            
            -- Jika senjata yang dipakai ada di list revolverWeapons
            if revolverWeapons[weaponHash] then
                local config = revolverWeapons[weaponHash]
                
                -- Getaran kamera (Screen Shake)
                ShakeGameplayCam("SMALL_EXPLOSION_SHAKE", config.camShake)
                
                -- Getaran controller (Gamepad Vibration)
                SetPadShake(0, config.padShakeDuration, config.padShakeIntensity)
            end
        end
    end
end)
