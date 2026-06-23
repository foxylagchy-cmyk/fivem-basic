-- Disable Vehicle Radio
-- Otomatis matikan radio saat masuk kendaraan

local isInVehicle = false

-- Thread untuk detect masuk/keluar kendaraan
CreateThread(function()
    while true do
        Wait(500) -- Check setiap 500ms
        
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        
        if vehicle ~= 0 and not isInVehicle then
            -- Baru masuk kendaraan
            isInVehicle = true
            
            -- Matikan radio
            SetVehicleRadioEnabled(vehicle, false)
            SetVehRadioStation(vehicle, "OFF")
            
            -- Extra: Set volume ke 0
            SetVehicleRadioLoud(vehicle, false)
        elseif vehicle == 0 and isInVehicle then
            -- Keluar dari kendaraan
            isInVehicle = false
        end
    end
end)

-- Thread untuk ensure radio tetap mati
CreateThread(function()
    while true do
        Wait(0) -- Every frame
        
        if isInVehicle then
            local ped = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(ped, false)
            
            if vehicle ~= 0 then
                -- Disable radio controls
                DisableControlAction(0, 81, true)  -- INPUT_VEH_NEXT_RADIO (Q key)
                DisableControlAction(0, 82, true)  -- INPUT_VEH_PREV_RADIO
                DisableControlAction(0, 85, true)  -- INPUT_VEH_RADIO_WHEEL
                
                -- Force radio off
                if not IsPlayerFreeAiming(PlayerId()) then
                    SetVehRadioStation(vehicle, "OFF")
                end
            end
        else
            Wait(500) -- Kalau tidak di kendaraan, wait lebih lama
        end
    end
end)

-- Event saat player spawn
AddEventHandler('playerSpawned', function()
    -- Disable mobile radio juga
    SetMobilePhoneRadioState(false)
end)

-- Event saat resource start
AddEventHandler('onClientResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    -- Disable mobile radio
    SetMobilePhoneRadioState(false)
    
    print('[DisableVehicleRadio] Vehicle radio disabled')
end)
