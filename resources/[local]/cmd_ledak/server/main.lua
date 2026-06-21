-- server/main.lua | cmd_ledak
-- Validasi command dilakukan di sisi server untuk keamanan (anti-cheat).
-- Server memverifikasi bahwa pemain adalah admin SEBELUM mengirim event ke klien.

local EXPLOSION_TYPES = {
    [0]  = 'Grenade',
    [1]  = 'Grenande Launcher',
    [2]  = 'Molotov',
    [3]  = 'Rocket',
    [4]  = 'TankShell',
    [5]  = 'Hi-Octane',
    [6]  = 'Car',
    [7]  = 'Plane',
    [8]  = 'PetrolPump',
    [9]  = 'Bike',
    [10] = 'Dir Steam',
    [11] = 'Explosion',
    [12] = 'Barrel',
    [13] = 'Propane',
    [14] = 'Blimp',
    [59] = 'Nuke',
}

-- Daftar tipe ledakan yang valid untuk validasi input
local MIN_TYPE = 0
local MAX_TYPE = 14 -- tipe >= 15 s/d 58 tidak valid, kecuali 59

---Memeriksa apakah pemain memiliki izin admin via ACE Permissions
---@param source number Player server ID
---@return boolean
local function isAdmin(source)
    return IsPlayerAceAllowed(source, 'command')
end

-- Gunakan `true` sebagai parameter ke-3:
-- FiveM secara native akan mengecek ACE `command.ledak`
-- yang diwarisi dari `add_ace group.admin command allow` di server.cfg
-- Pemain non-admin akan langsung ditolak oleh engine, tidak perlu pengecekan manual.
RegisterCommand('ledak', function(source, args)
    -- Tolak eksekusi dari console server (source == 0)
    if source == 0 then
        print('[cmd_ledak] Command ini hanya bisa dijalankan oleh pemain dalam game.')
        return
    end

    -- Parsing tipe ledakan dari argumen, default ke tipe 6 (Car) jika tidak diisi
    local explosionType = tonumber(args[1]) or 6
    local radius        = tonumber(args[2]) or 5.0
    local damage        = tonumber(args[3]) or 1000.0

    -- Clamp & validasi tipe ledakan agar tidak crash client
    if explosionType < MIN_TYPE or (explosionType > MAX_TYPE and explosionType ~= 59) then
        TriggerClientEvent('chat:addMessage', source, {
            color = { 255, 165, 0 },
            multiline = true,
            args = { '[cmd_ledak]', ('Tipe ledakan tidak valid. Gunakan 0-%d atau 59.'):format(MAX_TYPE) }
        })
        return
    end

    -- Clamp radius & damage agar server tidak dieksploitasi
    radius = math.max(1.0, math.min(radius, 100.0))
    damage = math.max(0.0, math.min(damage, 10000.0))

    -- Kirim event ke klien yang bersangkutan saja (bukan broadcast)
    TriggerClientEvent('cmd_ledak:client:spawnExplosion', source, explosionType, radius, damage)

    -- Log ke console server untuk audit trail
    local playerName = GetPlayerName(source)
    print(('[cmd_ledak] %s (ID: %d) memicu ledakan | Tipe: %s (%d) | Radius: %.1f | Damage: %.1f')
        :format(playerName, source, EXPLOSION_TYPES[explosionType] or 'Unknown', explosionType, radius, damage))
end, true) -- true = FiveM native ACE enforcement: butuh command.ledak (inherit dari group.admin)
