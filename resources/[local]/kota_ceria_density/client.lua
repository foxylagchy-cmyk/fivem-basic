Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0) -- Harus berjalan setiap frame (0 ms)
        
        -- Angka 0.0 artinya HILANG TOTAL. 
        -- Karena kita mau disedikitkan saja, kita pakai 0.3
        local density = 0.4 
        
        SetVehicleDensityMultiplierThisFrame(density) -- Mobil yang jalan
        SetPedDensityMultiplierThisFrame(density) -- Orang jalan kaki
        SetRandomVehicleDensityMultiplierThisFrame(density) -- Mobil random
        SetParkedVehicleDensityMultiplierThisFrame(density) -- Mobil parkir
        SetScenarioPedDensityMultiplierThisFrame(density, density) -- Orang nongkrong/ngobrol
        
        -- Menonaktifkan Polisi NPC & Ambulans NPC (Agar tidak datang saat ada keributan)
        for i = 1, 15 do
            EnableDispatchService(i, false)
        end
    end
end)
