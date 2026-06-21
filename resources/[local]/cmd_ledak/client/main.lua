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
    local ped    = PlayerPedId()
    local coords = GetEntityCoords(ped)

    -- damageScale harus dalam range 0.0 - 1.0 (bukan nilai damage mentah)
    -- damage dari server sudah di-clamp 0-10000, kita normalisasi ke 0.0-1.0
    local damageScale = math.min(damage / 1000.0, 1.0)

    -- Lindungi pemain dari self-damage SEBELUM ledakan ditembakkan.
    -- SetEntityInvincible bekerja di level engine (lebih rendah dari god mode script),
    -- sehingga bypass AddExplosion tidak bisa membunuh caster.
    SetEntityInvincible(ped, true)

    -- AddExplosion(x, y, z, type, damageScale, isAudible, isInvis, cameraShake, noDamage)
    AddExplosion(
        coords.x,
        coords.y,
        coords.z,
        explosionType,
        damageScale,
        true,         -- isAudible: suara ledakan dari engine
        false,        -- isInvis: visual aktif
        radius * 0.1, -- cameraShake: skala proporsional dari radius
        false         -- noDamage: damage tetap berlaku untuk NPC/pemain lain
    )

    -- Pastikan suara ledakan terdengar dengan memainkan sound eksplisit
    PlaySoundFromCoord(-1, 'EXPLOSION', coords.x, coords.y, coords.z, 'DLC_HEIST_BIOLAB_FINALE_SOUNDS', false, 0, false)

    -- Padamkan api di ped SEGERA setelah ledakan (sebelum fire damage sempat berjalan)
    StopFireOnEntity(ped)

    -- Monitor selama 3 detik: padamkan api & pulihkan HP jika masih terbakar
    -- Fire damage bisa delay beberapa frame, jadi satu timeout tidak cukup
    local elapsed = 0
    Citizen.CreateThread(function()
        while elapsed < 3000 do
            Citizen.Wait(100)
            elapsed = elapsed + 100

            if IsEntityOnFire(ped) then
                StopFireOnEntity(ped)
            end

            -- Jaga HP tetap penuh selama window perlindungan
            local maxHp = GetEntityMaxHealth(ped)
            if GetEntityHealth(ped) < maxHp then
                SetEntityHealth(ped, maxHp)
            end
        end

        -- Setelah 3 detik: matikan invincible, pastikan api benar-benar padam
        SetEntityInvincible(ped, false)
        StopFireOnEntity(ped)
    end)

    -- Notifikasi di chat klien
    TriggerEvent('chat:addMessage', {
        color = { 255, 100, 0 },
        multiline = false,
        args = { '[cmd_ledak]', ('💥 Ledakan tipe %d diaktifkan!'):format(explosionType) }
    })
end)

-- Command lokal untuk menampilkan hint saja (tidak memicu ledakan)
RegisterCommand('ledakhelp', function()
    showUsageHint()
end, false)
