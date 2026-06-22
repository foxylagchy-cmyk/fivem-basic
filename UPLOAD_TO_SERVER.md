# 📤 Files to Upload to Production Server (Anjas Server)

## 🎯 Total Size: < 1 MB (sangat kecil!)

---

## 📋 METHOD 1: Upload Modified Files Only (Recommended)

### File 1: ox_inventory/server.lua
**Path:** `resources/[OX]/ox_inventory/server.lua`
**Size:** ~50 KB
**Changes:** Commented out PEFCL module (line 6)

**Action:**
1. Upload/Replace file ini ke server
2. Path di server: `resources/[OX]/ox_inventory/server.lua`

---

### File 2: qbx_core/config/server.lua
**Path:** `resources/[QBX]/qbx_core/config/server.lua`
**Size:** ~10 KB
**Changes:** 
- Commented out NPWD tables (lines 71-80)
- Commented out bank_accounts_new (line 65)
- Commented out player_mails (line 67)

**Action:**
1. Upload/Replace file ini ke server
2. Path di server: `resources/[QBX]/qbx_core/config/server.lua`

---

### File 3: qbx_spawn/client/main.lua
**Path:** `resources/[QBX]/qbx_spawn/client/main.lua`
**Size:** ~15 KB
**Changes:** Added missing event handler qb-spawn:client:openUI (bottom of file)

**Action:**
1. Upload/Replace file ini ke server
2. Path di server: `resources/[QBX]/qbx_spawn/client/main.lua`

---

### File 4: pefcl/.disabled (NEW)
**Path:** `resources/[QBX]/pefcl/.disabled`
**Size:** < 1 KB
**New file to disable PEFCL resource**

**Action:**
1. Upload file ini ke server
2. Path di server: `resources/[QBX]/pefcl/.disabled`
3. FiveM akan skip resource yang punya file .disabled

---

### File 5: qbx_npwd/.disabled (NEW)
**Path:** `resources/[QBX]/qbx_npwd/.disabled`
**Size:** < 1 KB
**New file to disable qbx_npwd resource**

**Action:**
1. Upload file ini ke server
2. Path di server: `resources/[QBX]/qbx_npwd/.disabled`
3. FiveM akan skip resource yang punya file .disabled

---

### Folder 6: cmd_heal (NEW RESOURCE)
**Path:** `resources/[local]/cmd_heal/`
**Size:** ~20 KB (total folder)
**Files:**
- fxmanifest.lua
- server.lua
- client.lua
- README.md (optional)

**Action:**
1. Upload seluruh folder cmd_heal ke server
2. Path di server: `resources/[local]/cmd_heal/`

---

### File 7: server.cfg (OPTIONAL)
**Path:** `server.cfg`
**Size:** ~5 KB
**Changes:** Added `ensure cmd_heal` line

**Action:**
1. Tambahkan baris ini di server.cfg di server:
   ```cfg
   ensure cmd_heal
   ```
2. Atau upload server.cfg yang sudah di-update

---

## 📊 TOTAL FILES TO UPLOAD

```
Modified Files:
✏️ ox_inventory/server.lua                 (~50 KB)
✏️ qbx_core/config/server.lua              (~10 KB)
✏️ qbx_spawn/client/main.lua               (~15 KB)

New Files:
➕ pefcl/.disabled                         (< 1 KB)
➕ qbx_npwd/.disabled                      (< 1 KB)
➕ cmd_heal/fxmanifest.lua                 (~1 KB)
➕ cmd_heal/server.lua                     (~5 KB)
➕ cmd_heal/client.lua                     (~3 KB)
➕ server.cfg (optional)                   (~5 KB)

TOTAL SIZE: ~90 KB (0.09 MB) ✅ Sangat kecil!
```

---

## 📦 METHOD 2: Create Zip Archive (Easiest)

### Buat folder sementara dengan struktur ini:

```
fixes_for_server/
├── [OX]/
│   └── ox_inventory/
│       └── server.lua
├── [QBX]/
│   ├── qbx_core/
│   │   └── config/
│   │       └── server.lua
│   ├── qbx_spawn/
│   │   └── client/
│   │       └── main.lua
│   ├── pefcl/
│   │   └── .disabled
│   └── qbx_npwd/
│       └── .disabled
├── [local]/
│   └── cmd_heal/
│       ├── fxmanifest.lua
│       ├── server.lua
│       └── client.lua
└── README.txt (petunjuk install)
```

**Zip file size:** ~100 KB (0.1 MB) ✅

---

## 🚀 METHOD 3: Via FTP/SFTP (Direct Upload)

### Step-by-step:

1. **Connect ke server** via FTP/SFTP (FileZilla, WinSCP, dll)

2. **Backup files asli** (download dulu sebelum replace):
   ```
   ox_inventory/server.lua
   qbx_core/config/server.lua
   qbx_spawn/client/main.lua
   ```

3. **Upload modified files** ke path yang sama

4. **Upload new files/folders**:
   - `pefcl/.disabled`
   - `qbx_npwd/.disabled`
   - `cmd_heal/` (entire folder)

5. **Edit server.cfg** di server, tambahkan:
   ```cfg
   ensure cmd_heal
   ```

6. **Restart server** via txAdmin atau console:
   ```
   restart [QBX]
   restart [OX]
   ensure cmd_heal
   ```

---

## 🎯 EASIEST METHOD (Recommended)

### Copy-Paste via Text Editor (Ultra Small!)

Jika upload file ribet, bisa **copy-paste code** langsung!

#### Step 1: Edit ox_inventory/server.lua
1. Buka file di server via web editor atau nano
2. Line 6: Tambahkan `--` di depan:
   ```lua
   -- require 'modules.pefcl.server'
   ```

#### Step 2: Edit qbx_core/config/server.lua
1. Buka file di server
2. Line 65: Tambahkan `--` di depan bank_accounts_new
3. Line 67: Tambahkan `--` di depan player_mails
4. Lines 71-80: Tambahkan `--` di depan semua npwd_* tables

#### Step 3: Edit qbx_spawn/client/main.lua
1. Buka file di server
2. Scroll ke paling bawah
3. Paste code ini sebelum closing:
   ```lua
   RegisterNetEvent('qb-spawn:client:openUI', function(firstSpawn)
       if firstSpawn then
           TriggerEvent('qb-spawn:client:setupSpawns')
       end
   end)
   ```

#### Step 4: Create .disabled files
1. Di folder `pefcl/`, buat file `.disabled`
2. Di folder `qbx_npwd/`, buat file `.disabled`

#### Step 5: Upload cmd_heal resource
- Ini satu-satunya yang perlu upload folder (20 KB saja!)

---

## 📝 PETUNJUK UNTUK ANJAS

Kirim file ini ke Anjas dengan petunjuk:

**Subject:** Fix untuk Server - Total Size <1MB

**Isi:**
```
Hi Anjas,

Ini fix untuk error-error di server:
1. PEFCL error → FIXED
2. NPWD warning → FIXED
3. Spawn selector black screen → FIXED
4. Bonus: Admin heal commands

Total files < 1 MB, silakan:
1. Extract ke folder server
2. Replace files yang ada
3. Restart server
4. Done!

Atau bisa copy-paste code langsung sesuai petunjuk di file.

Check FIXES_APPLIED.md untuk detail lengkap.
```

---

## ⚠️ IMPORTANT NOTES

### Backup First!
Sebelum upload/replace, **backup dulu**:
```
ox_inventory/server.lua.backup
qbx_core/config/server.lua.backup
qbx_spawn/client/main.lua.backup
```

### Test After Upload!
Setelah upload:
1. Restart server
2. Check console untuk error
3. Test buat karakter baru
4. Test spawn selector
5. Test heal commands

### Rollback (jika ada masalah):
Restore backup files dan restart server.

---

## 🎉 RESULT AFTER UPLOAD

```
✅ No PEFCL errors
✅ No NPWD warnings
✅ Spawn selector works!
✅ Admin heal commands available!
✅ Clean console logs
```

---

**Total Upload Size:** ~90-100 KB (0.1 MB)
**Compatibility:** FiveM Build 3258 (mp2024_01)
**Framework:** QBX (Qbox-project)
**Tested:** ✅ Local server working

---

**Prepared by:** Kiro AI Assistant
**Date:** June 22, 2026
**For:** KotaCeria FiveM Production Server
