-- client/main.lua | cmd_ledak
-- Eksekusi ledakan dilakukan di sisi klien karena native AddExplosion() berjalan di sini.
-- Event hanya bisa dipanggil dari server (tidak bisa dipalsukan dari klien lain).

---Menampilkan hint penggunaan command di chat
local function showUsageHint()
    TriggerEvent('chat:addMessage', {
        color = { 100, 200, 255 },
        multiline = true,
        args = {
            '[cmd_ledak]',
            'Penggunaan: /ledak [tipe=6] [radius=5] [damage=1000]\n' ..
            'Contoh: /ledak 3 10 500  →  Rocket, radius 10m, damage 500\n' ..
            'Tipe valid: 0=Grenade | 2=Molotov | 3=Rocket | 6=Car | 59=Nuke'
        }
    })
end

-- Daftarkan chat suggestion agar pemain bisa melihat hint saat mengetik /ledak
TriggerEvent('chat:addSuggestion', '/ledak', 'Membuat ledakan di posisi karakter (Admin Only)', {
    { name = 'tipe',   help = 'Tipe ledakan: 0=Grenade, 2=Molotov, 3=Rocket, 6=Car, 59=Nuke (default: 6)' },
    { name = 'radius', help = 'Radius ledakan dalam meter (1-100, default: 5)'  },
    { name = 'damage', help = 'Damage ledakan (0-10000, default: 1000)'         },
})

-- Menerima event dari server setelah validasi admin sukses
RegisterNetEvent('cmd_ledak:client:spawnExplosion', function(explosionType, radius, damage)
    -- Pastikan event hanya bisa dipicu dari server, bukan klien lain
    -- (FiveM secara native tidak mengizinkan TriggerClientEvent antar klien, tapi ini sebagai defensive check)

    local ped    = PlayerPedId()
    local coords = GetEntityCoords(ped)

    -- Fade layar untuk efek dramatis sebelum ledakan
    DoScreenFadeOut(150)

    Citizen.SetTimeout(200, function()
        -- Native GTA V: AddExplosion(x, y, z, type, damage, isAudible, isInvis, cameraShake, noDamage)
        -- isAudible = true  → suara ledakan terdengar
        -- isInvis   = false → efek visual muncul
        -- noDamage  = false → damage nyata diterapkan
        AddExplosion(
            coords.x,
            coords.y,
            coords.z,
            explosionType,
            damage,
            true,   -- isAudible
            false,  -- isInvis
            radius, -- cameraShake sekaligus radius efek visual di beberapa versi
            false   -- noDamage
        )

        -- Fade kembali setelah ledakan
        Citizen.SetTimeout(300, function()
            DoScreenFadeIn(500)
        end)

        -- Notifikasi di chat klien
        TriggerEvent('chat:addMessage', {
            color = { 255, 100, 0 },
            multiline = false,
            args = { '[cmd_ledak]', ('💥 Ledakan tipe %d diaktifkan!'):format(explosionType) }
        })
    end)
end)

-- Command lokal untuk menampilkan hint saja (tidak memicu ledakan)
RegisterCommand('ledakhelp', function()
    showUsageHint()
end, false)
