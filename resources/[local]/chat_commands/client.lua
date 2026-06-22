-- Client side script
-- Tambahkan suggestions untuk commands

TriggerEvent('chat:addSuggestion', '/report', 'Laporkan masalah ke admin', {
    { name="pesan", help="Tuliskan laporan Anda" }
})

TriggerEvent('chat:addSuggestion', '/staff', 'Kirim pesan sebagai staff ke semua pemain (Admin Only)', {
    { name="pesan", help="Pesan yang akan dikirim" }
})

TriggerEvent('chat:addSuggestion', '/staffo', 'Chat dengan sesama admin (Admin Only)', {
    { name="pesan", help="Pesan untuk admin" }
})

TriggerEvent('chat:addSuggestion', '/ooc', 'Chat Out of Character', {
    { name="pesan", help="Pesan OOC Anda" }
})

TriggerEvent('chat:addSuggestion', '/godcar', 'Toggle God Mode untuk kendaraan (Admin Only)')

-- God Car System
local godCarEnabled = false

RegisterNetEvent('chat_commands:toggleGodCar')
AddEventHandler('chat_commands:toggleGodCar', function()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    if vehicle == 0 then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            multiline = true,
            args = {"System", "Anda harus berada di dalam kendaraan!"}
        })
        return
    end
    
    godCarEnabled = not godCarEnabled
    
    if godCarEnabled then
        TriggerEvent('chat:addMessage', {
            color = {0, 255, 0},
            multiline = true,
            args = {"System", "God Car Mode: AKTIF - Kendaraan kebal dari kerusakan!"}
        })
    else
        TriggerEvent('chat:addMessage', {
            color = {255, 165, 0},
            multiline = true,
            args = {"System", "God Car Mode: NONAKTIF"}
        })
    end
end)

-- Thread untuk menjaga kendaraan tetap kebal
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        if godCarEnabled then
            local playerPed = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            
            if vehicle ~= 0 then
                -- Set kendaraan tidak bisa rusak
                SetEntityInvincible(vehicle, true)
                SetVehicleCanBeVisiblyDamaged(vehicle, false)
                SetVehicleCanEngineDegrade(vehicle, false)
                SetVehicleCanBreak(vehicle, false)
                SetVehicleFixed(vehicle)
                SetVehicleDeformationFixed(vehicle)
                SetVehicleUndriveable(vehicle, false)
                
                -- Disable ledakan
                DisableVehicleImpactExplosionActivation(vehicle, true)
                
                -- Set body health maksimal
                SetVehicleBodyHealth(vehicle, 1000.0)
                SetVehicleEngineHealth(vehicle, 1000.0)
                SetVehiclePetrolTankHealth(vehicle, 1000.0)
            else
                -- Jika keluar dari kendaraan, matikan god mode
                godCarEnabled = false
                TriggerEvent('chat:addMessage', {
                    color = {255, 165, 0},
                    multiline = true,
                    args = {"System", "God Car Mode NONAKTIF - Anda keluar dari kendaraan"}
                })
            end
        else
            Citizen.Wait(1000) -- Jika tidak aktif, tunggu lebih lama
        end
    end
end)
