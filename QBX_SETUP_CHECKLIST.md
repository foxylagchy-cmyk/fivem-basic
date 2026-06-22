# ✅ QBX Resources Setup Checklist

## 📋 Pre-Installation Checklist

- [ ] Git installed (untuk auto download)
- [ ] MySQL/MariaDB running
- [ ] Database `fivem` sudah dibuat
- [ ] oxmysql resource sudah running
- [ ] Backup server.cfg dan database

---

## 📦 Step 1: Download Resources

### Opsi A: Auto Download (Recommended)
```bash
# Jalankan script auto download
download_qbx_resources.bat
```

### Opsi B: Manual Download
Download dari: https://github.com/Qbox-project

### Opsi C: Copy dari Server
Copy folder `resources/[QBX]/` dari server production

**Progress:**
- [ ] Core resources downloaded
- [ ] Job resources downloaded
- [ ] Activity resources downloaded

---

## 🗄️ Step 2: Import Database Tables

### Priority 1 - Must Have:
- [ ] **qbx_core** - Import `sql/` files
- [ ] **qbx_banking** - bank_accounts, bank_accounts_new tables
- [ ] **qbx_properties** - properties table
- [ ] **qbx_vehiclekeys** - vehicle_keys table

### Priority 2 - Important:
- [ ] **qb-ambulancejob** - medical/hospital tables
- [ ] **qb-policejob** - police/evidence tables
- [ ] **qbx_phone** - phone tables

### Priority 3 - Optional:
- [ ] **npwd** - All npwd_* tables (if using NPWD)
- [ ] **qb-lapraces** - lapraces tables
- [ ] **qb-crypto** - crypto tables

**Cara Import:**
```sql
-- Via command line
mysql -u root -p fivem < resources/[QBX]/qbx_banking/sql/tables.sql

-- Atau via phpMyAdmin / HeidiSQL
-- Import file .sql dari folder sql/ di tiap resource
```

---

## ⚙️ Step 3: Configure server.cfg

### Update server.cfg:
```cfg
# QBX Core Framework
ensure [OX]          # ox_lib, ox_inventory, oxmysql
ensure [QBX]         # All QBX resources

# Atau ensure individual:
ensure qbx_core
ensure qbx_spawn
ensure qb-banking-main
ensure qbx_adminmenu-main
ensure qbx_vehiclekeys
ensure qbx_radialmenu
ensure qbx_phone
ensure qb-ambulancejob-main
ensure qb-policejob-main
# ... dst
```

**Checklist:**
- [ ] `ensure [QBX]` added to server.cfg
- [ ] PEFCL removed/disabled (konflik dengan QBX banking)
- [ ] spawnmanager & basic-gamemode disabled (konflik dengan qbx_spawn)

---

## 🔧 Step 4: Fix qbx_core Config

### Edit: `resources/[QBX]/qbx_core/config/server.lua`

**Remove non-existent tables warning:**
```lua
-- Comment out tables yang belum ada:
-- 'properties',              -- Comment jika belum install qbx_properties
-- 'bank_accounts_new',       -- Comment jika belum install qbx_banking
-- 'player_mails',            -- Comment jika tidak pakai mail system
-- 'npwd_*',                  -- Comment semua npwd tables jika tidak pakai NPWD
```

**Checklist:**
- [ ] Removed unused table references
- [ ] Config sesuai dengan resources yang terinstall

---

## 🚀 Step 5: First Start

### Start server dan cek console:
```bash
# Start server
FXServer.exe

# Atau via batch file
run.bat
```

### Watch for errors:
- [ ] ✅ No "Table does not exist" warnings
- [ ] ✅ No "No such export" errors
- [ ] ✅ No PEFCL errors
- [ ] ✅ All [QBX] resources started successfully

---

## 🧪 Step 6: Test In-Game

### Test Core Features:
- [ ] **Multicharacter** - Buat & pilih karakter
- [ ] **Spawn Selector** - Pilih lokasi spawn (FIXED!)
- [ ] **Inventory** - Buka inventory (F2)
- [ ] **Banking** - Cek saldo bank
- [ ] **Vehicle Keys** - Test vehicle ownership
- [ ] **Radial Menu** - Test radial menu

### Test Admin Features:
- [ ] **Admin Menu** - `/admin` atau `/adminmenu`
- [ ] **Heal Command** - `/healme` (Custom, sudah dibuat!)
- [ ] **Teleport** - Test admin teleport
- [ ] **Give Item** - Test give item to player

### Test Jobs (if installed):
- [ ] **EMS/Ambulance** - Join & test job
- [ ] **Police** - Join & test job
- [ ] **Mechanic** - Test vehicle repair

---

## 🐛 Step 7: Common Issues & Fixes

### Issue 1: Black screen setelah character creation
**Status:** ✅ FIXED - Added missing event handler

### Issue 2: PEFCL errors in console
**Fix:**
```bash
# Di console:
stop pefcl

# Atau hapus resource PEFCL
# Atau disable di server.cfg
```

### Issue 3: "No such export" errors
**Fix:**
- Install resource yang diperlukan
- Cek dependencies di fxmanifest.lua
- Ensure resource sebelum yang membutuhkannya

### Issue 4: Database table warnings
**Fix:**
- Import SQL files dari resource
- Atau comment table di qbx_core/config/server.lua

### Issue 5: qbx_npwd errors
**Fix (Opsi A - Install NPWD):**
```bash
cd resources
git clone https://github.com/project-error/npwd
cd npwd
pnpm install
pnpm build
```

**Fix (Opsi B - Disable qbx_npwd):**
- Remove `qbx_npwd` folder
- Use `qbx_phone` instead

---

## 📊 Final Verification

### Console Check:
```
[  script:qbx_core] Started successfully
[  script:qbx_spawn] Started successfully  
[  script:qb-banking-main] Started successfully
[  script:qbx_vehiclekeys] Started successfully
...
✅ No errors in console
```

### In-Game Check:
```
✅ Bisa login
✅ Bisa buat karakter
✅ Spawn selector muncul
✅ Bisa spawn di kota
✅ Inventory berfungsi
✅ Banking berfungsi
✅ Admin commands work
```

---

## 🎉 Setup Complete!

Jika semua checklist ✅, maka server lokal Anda sudah:
- ✅ Sama dengan server production
- ✅ Semua QBX resources terinstall
- ✅ Database tables complete
- ✅ No critical errors
- ✅ Ready untuk development!

---

## 📝 Notes

- Backup database & server.cfg sebelum major changes
- Test di server lokal sebelum deploy ke production
- Keep resources updated via `git pull` di tiap folder
- Join QBX Discord untuk support: https://discord.gg/qbox

---

**Setup Date:** _______________
**Completed By:** _______________
**Server Version:** QBX Framework v1.x
**FiveM Build:** 3258 (mp2024_01)
