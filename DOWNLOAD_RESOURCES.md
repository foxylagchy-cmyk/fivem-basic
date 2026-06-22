# 📦 Daftar Resources QBX yang Perlu Didownload

## ✅ Yang Sudah Ada (Lokal):
- ✅ qbx_core
- ✅ qbx_garages
- ✅ qbx_hud
- ✅ qbx_idcard
- ✅ qbx_loading
- ✅ qbx_spawn (sudah di-fix)
- ✅ qbx_vehicles
- ✅ qbx_vehicleshop-main
- ✅ illenium-appearance

## 📥 Yang Perlu Didownload (Dari Screenshot Server):

### 1. Core Banking & Economy
```
qb-banking-main
qbx_bankrobbery-main
```
**Download dari:**
- https://github.com/Qbox-project/qbx_banking
- https://github.com/Qbox-project/qbx_bankrobbery

**Cara Install:**
1. Download ZIP dari GitHub
2. Extract ke `resources/[QBX]/`
3. Rename folder sesuai nama di server (hapus -main jika perlu)

---

### 2. Jobs & Activities
```
qb-ambulancejob-main
qb-anticheat-main
qb-clothing-main
qb-crypto-main
qb-lapraces-main
qb-minigames-main
qb-multicharacter-main
qb-policejob-main
qb-weed-main
qbx_adminmenu-main
qbx_customs
qbx_dutyutilips-main
qbx_garages
qbx_houses-main
qbx_management
qbx_nitro
qbx_phone
qbx_radialmenu
qbx_seatbelt
qbx_storerobbery-main
qbx_vehiclekeys
qbx_vehicleshop
```

**Download dari Qbox-project GitHub:**
https://github.com/Qbox-project

**Catatan:** 
- Prefix `qb-*` adalah legacy QB-Core resources yang compatible dengan QBX
- Prefix `qbx_*` adalah native QBX resources

---

### 3. NPWD (Phone System) - OPTIONAL
```
npwd (main resource)
qbx_npwd (bridge)
```

**Download dari:**
- https://github.com/project-error/npwd
- https://github.com/Qbox-project/qbx_npwd

**Dependencies:**
- Node.js & pnpm untuk build
- Database tables untuk NPWD

**Alternatif:** Skip NPWD jika tidak digunakan, gunakan qbx_phone saja

---

### 4. PEFCL (Banking System) - TIDAK DIREKOMENDASIKAN
```
pefcl
```

**⚠️ PERHATIAN:** 
PEFCL adalah sistem banking alternatif yang **KONFLIK** dengan QBX Core banking.

**Rekomendasi:** 
- **JANGAN install PEFCL** jika pakai QBX Framework
- QBX sudah punya banking system built-in
- Gunakan qbx_banking atau qb-banking-main

---

## 🚀 Cara Cepat Download Semua

### Opsi 1: Manual Download (Recommended)
1. Buka https://github.com/Qbox-project
2. Download tiap resource yang diperlukan
3. Extract ke `resources/[QBX]/`
4. Pastikan nama folder sama dengan di server

### Opsi 2: Git Clone (Advanced)
```bash
cd resources/[QBX]

# Core Resources
git clone https://github.com/Qbox-project/qbx_banking qb-banking-main
git clone https://github.com/Qbox-project/qbx_ambulancejob qb-ambulancejob-main
git clone https://github.com/Qbox-project/qbx_policejob qb-policejob-main
git clone https://github.com/Qbox-project/qbx_adminmenu qbx_adminmenu-main
git clone https://github.com/Qbox-project/qbx_customs qbx_customs
git clone https://github.com/Qbox-project/qbx_management qbx_management
git clone https://github.com/Qbox-project/qbx_phone qbx_phone
git clone https://github.com/Qbox-project/qbx_radialmenu qbx_radialmenu
git clone https://github.com/Qbox-project/qbx_vehiclekeys qbx_vehiclekeys

# Dan seterusnya...
```

### Opsi 3: Copy dari Server ke Lokal (Fastest)
Jika Anda punya akses FTP/SFTP ke server:
1. Download folder `resources/[QBX]/` dari server
2. Copy ke lokal Anda
3. Done! 🎉

---

## 📝 Setelah Download Semua Resources

### 1. Update server.cfg (Lokal)
Pastikan semua resources di-ensure:
```cfg
ensure [QBX]
```

Atau ensure satu-satu:
```cfg
ensure qbx_core
ensure qbx_spawn
ensure qb-banking-main
ensure qb-ambulancejob-main
ensure qb-policejob-main
ensure qbx_adminmenu-main
ensure qbx_customs
ensure qbx_phone
ensure qbx_radialmenu
ensure qbx_vehiclekeys
# ... dan seterusnya
```

### 2. Import Database Tables
Beberapa resources butuh database tables:
- `qbx_banking` → bank_accounts, bank_accounts_new
- `qbx_properties` → properties
- `npwd` → npwd_* tables
- `qb-ambulancejob` → medical tables
- `qb-policejob` → police tables

**Cara Import:**
1. Cek folder `sql/` atau `database/` di tiap resource
2. Import file `.sql` ke database MySQL Anda
3. Atau copy tables dari server database

### 3. Restart Server Lokal
```
restart [QBX]
```

atau restart full:
```
quit
# Kemudian jalankan server lagi
```

---

## ⚠️ Troubleshooting

### Error: "No such export" atau "Resource not found"
**Solusi:** Resource dependency belum terinstall, cek dependencies di fxmanifest.lua

### Error: "Table does not exist"
**Solusi:** Import database tables yang diperlukan

### Error: PEFCL Masih Muncul
**Solusi:** 
1. Stop resource PEFCL di console: `stop pefcl`
2. Atau hapus folder pefcl dari resources
3. Atau comment di server.cfg jika ada: `# ensure pefcl`

---

## 🎯 Priority Download (Jika Terbatas Waktu)

Download priority tinggi ke rendah:

### Must Have (Priority 1):
- ✅ qbx_core (sudah ada)
- ✅ qbx_spawn (sudah ada & fixed)
- 📥 qb-banking-main
- 📥 qbx_adminmenu-main
- 📥 qbx_vehiclekeys

### Important (Priority 2):
- 📥 qb-ambulancejob-main
- 📥 qb-policejob-main
- 📥 qbx_radialmenu
- 📥 qbx_phone

### Nice to Have (Priority 3):
- 📥 qbx_customs
- 📥 qb-clothing-main
- 📥 qb-lapraces-main
- 📥 qbx_storerobbery-main

### Optional (Priority 4):
- 📥 npwd (kompleks, butuh build)
- 📥 qb-crypto-main
- 📥 qb-weed-main

---

## 📞 Need Help?

Jika ada masalah saat install:
1. Cek console log untuk error
2. Cek fxmanifest.lua untuk dependencies
3. Cek apakah database tables sudah di-import
4. Pastikan folder name sama dengan di server

---

**Last Updated:** June 22, 2026
**Server:** KotaCeria FiveM Server
**Framework:** QBX (Qbox-project)
