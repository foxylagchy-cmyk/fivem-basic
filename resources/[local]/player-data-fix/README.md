# Player Data Fix

## Masalah yang Diselesaikan

Resource ini menyelesaikan masalah umum di QBX/QBCore server dimana script lain mencoba mengakses player data sebelum data tersebut selesai di-load dari database, yang menyebabkan error seperti:

```
attempt to index a nil value (field 'gang')
attempt to index a nil value (field 'metadata')
attempt to index a nil value (field 'coords')
attempt to index a nil value (local 'player')
```

## Cara Kerja

Resource ini:
1. Menunggu QBX framework ter-initialize
2. Memverifikasi semua player data ter-load lengkap (citizenid, job, gang, metadata)
3. Memberikan delay tambahan untuk memastikan semua data siap
4. Export function untuk resource lain untuk check apakah player data sudah ready

## Instalasi

1. Pastikan resource ini di folder `[local]/player-data-fix`
2. Tambahkan ke `server.cfg` **SEBELUM** resource lain yang depend on player data:

```cfg
# Core resources
ensure qbx_core
ensure ox_lib

# Player data fix - HARUS di-load sebelum resource lain!
ensure player-data-fix

# Other resources
ensure qbx_spawn
ensure qbx_hud
ensure qbx_radialmenu
ensure mm_radio
ensure rpemots
# ... dll
```

## Load Order di server.cfg

**PENTING:** Load order yang benar:

```cfg
# 1. Database
ensure oxmysql

# 2. Core frameworks
ensure qbx_core
ensure ox_lib
ensure ox_inventory

# 3. Player data fix (CRITICAL!)
ensure player-data-fix

# 4. Character/spawn systems
ensure qbx_spawn
ensure qbx_multicharacter

# 5. HUD/UI resources
ensure qbx_hud
ensure qbx_radialmenu

# 6. Job/gang resources
ensure qbx_policejob
ensure qbx_ambulancejob

# 7. Other gameplay resources
ensure mm_radio
ensure rpemots
ensure injury-system
# ... dll
```

## Troubleshooting

### Masih ada error "attempt to index nil"
1. Check load order di server.cfg
2. Pastikan `player-data-fix` di-load setelah `qbx_core` tapi sebelum resource lain
3. Restart full server (jangan hanya `ensure`)

### Player stuck di loading screen
1. Check F8 console untuk error lain
2. Verifikasi database connection (MySQL)
3. Check apakah player punya character di database

### Character baru tidak bisa spawn
1. Error ini biasanya dari spawn coords yang nil
2. Sudah di-fix di `qbx_spawn/client/main.lua`
3. Pastikan config spawn punya default spawn point

## Exports

### IsPlayerDataLoaded()
Check apakah player data sudah ready:
```lua
if exports['player-data-fix']:IsPlayerDataLoaded() then
    -- Player data ready
else
    -- Wait for player data
end
```

### WaitForPlayerData()
Wait sampai player data ready (blocking):
```lua
CreateThread(function()
    local success = exports['player-data-fix']:WaitForPlayerData()
    if success then
        -- Proceed with code that needs player data
    end
end)
```

## Script Fixes yang Sudah Dibuat

Resource ini sudah include fix untuk:

1. ✅ **qbx_spawn** - Nil coords check, default spawn fallback
2. ✅ **qbx_radialmenu** - Nil gang check
3. ✅ **mm_radio** - Nil player data check
4. ✅ **injury-system** - Player loaded flag

## Notes

- Resource ini lightweight dan tidak affect performance
- Hanya menambah delay 2-3 detik saat login untuk ensure data loaded
- Lebih baik ada delay kecil daripada player stuck atau crash

## Debug

Enable debug mode dengan uncomment print statements untuk melihat loading progress di F8 console.
