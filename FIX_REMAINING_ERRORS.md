# 🔧 Fix Remaining Errors

## ✅ Status: PEFCL & qbx_npwd FIXED!

Errors yang sudah hilang:
- ✅ PEFCL timeout errors → GONE!
- ✅ qbx_npwd export errors → GONE!

---

## ❌ Error yang Masih Ada:

### Error 1: basic-gamemode
```
SCRIPT ERROR: @basic-gamemode/basic_client.lua:2: 
No such export setAutoSpawn in resource spawnmanager
```

**Penyebab:**
- Resource `basic-gamemode` masih running dari cache
- Mencoba akses `spawnmanager` yang sudah disabled

**Lokasi:**
- Resource ini dari FXServer default (bukan dari folder resources)
- Loaded via mapmanager secara otomatis

---

### Error 2: rpemots (Minor - Non-Critical)
```
Uncaught TypeError: Cannot read properties of undefined (reading 'emoteType')
@rpemots/client/NUI/js/main.js:212
```

**Penyebab:**
- Bug kecil di resource rpemots
- Tidak affect gameplay

---

## 🔧 SOLUSI Error basic-gamemode

### Opsi 1: Stop Manual (Console) ⚡
```
stop basic-gamemode
stop spawnmanager
restart mapmanager
```

### Opsi 2: Add to server.cfg (Permanent) 📝
Tambahkan di server.cfg setelah baris `ensure mapmanager`:
```cfg
ensure mapmanager
stop basic-gamemode
stop spawnmanager
```

### Opsi 3: Edit server-engine config
Jika menggunakan txAdmin, edit server.cfg dari txAdmin panel dan tambahkan `stop` commands.

### Opsi 4: Clear Cache & Full Restart (Most Effective)
```bash
# 1. Stop server
quit

# 2. Delete cache (optional)
# Hapus folder: cache/

# 3. Start server lagi
```

---

## 🔧 SOLUSI Error rpemots (Optional)

### Cek apakah rpemots ada:
```
Path: resources/*/rpemots/
```

### Opsi A: Update Resource
Download versi terbaru dari GitHub

### Opsi B: Disable Resource (jika tidak dipakai)
```
stop rpemots
```

Atau tambahkan di fxmanifest.lua comment out scripts.

---

## 📋 Quick Command List

Jalankan di console server (satu per satu):

```
stop basic-gamemode
stop spawnmanager  
stop rpemots
restart mapmanager
restart [QBX]
```

Atau full restart:
```
quit
# Start server lagi
```

---

## ✅ Expected Result After Fix

Console yang bersih:
```
[script:mapmanager] Started successfully
[script:qbx_core] Started successfully
[script:qbx_spawn] Started successfully
[script:qb-banking-main] Started successfully

✅ No basic-gamemode errors
✅ No PEFCL errors
✅ No qbx_npwd errors
✅ Only minor rpemots warning (safe to ignore)
```

---

## 🎯 Priority

### Critical (Must Fix):
- ❌ basic-gamemode error → **FIX NOW**

### Minor (Can Ignore):
- ⚠️ rpemots error → **Safe to ignore** (doesn't break gameplay)

---

## 🚀 Recommended Action

**DO THIS NOW:**

1. Open server console
2. Type:
   ```
   stop basic-gamemode
   stop spawnmanager
   ```
3. Check if errors gone ✅

If errors persist after `stop`:
```
quit
# Restart server completely
```

---

## 📝 Update server.cfg (Permanent Fix)

Add these lines after `ensure mapmanager`:

```cfg
ensure mapmanager
stop basic-gamemode  # Konflik dengan qbx_spawn
stop spawnmanager    # Konflik dengan qbx_spawn
ensure md-chat
```

This will automatically stop these resources on every server start.

---

## 🐛 Why These Errors Happen

1. **basic-gamemode** = FiveM default resource for vanilla gameplay
   - Not compatible with QBX Framework
   - qbx_spawn replaces its functionality

2. **spawnmanager** = FiveM default spawn system
   - qbx_spawn is more advanced
   - Both cannot run together

3. **rpemots** = Custom emote resource
   - Has minor JavaScript bug
   - Doesn't affect core functionality

---

## ✅ Final Checklist

- [x] PEFCL disabled → **DONE**
- [x] qbx_npwd disabled → **DONE**
- [ ] basic-gamemode stopped → **DO NOW**
- [ ] spawnmanager stopped → **DO NOW**
- [ ] rpemots fixed/ignored → **OPTIONAL**

---

**Date:** June 22, 2026
**Server:** KotaCeria FiveM (Local Dev)
**Status:** Almost Clean! 🎉
