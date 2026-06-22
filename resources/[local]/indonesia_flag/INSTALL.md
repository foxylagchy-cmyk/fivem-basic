# 🇮🇩 Indonesia Flag Replacer - Panduan Lengkap

Resource ini sudah **SIAP DIPAKAI**, tapi **butuh file texture bendera** untuk bekerja.

## ✅ Status Install:
- ✅ Resource sudah dibuat
- ✅ Folder `stream` sudah dibuat  
- ✅ Sudah ditambahkan ke `server.cfg`
- ⚠️ **BUTUH**: File texture bendera Indonesia

---

## 🚀 Cara Paling Cepat (5 Menit):

### Opsi 1: Download Resource Jadi (PALING MUDAH)

1. **Cari resource yang sudah jadi:**
   ```
   Google: "fivem indonesia flag github"
   Atau: "fivem bendera indonesia"
   ```

2. **Link yang bisa dicoba:**
   - https://github.com (cari: fivem indonesia flag)
   - https://forum.cfx.re (cari: indonesia atau flag)
   - Discord server FiveM Indonesia

3. **Setelah download:**
   - Extract file nya
   - Copy semua file `.ytd` atau `.png` ke folder:
     ```
     resources/[local]/indonesia_flag/stream/
     ```

4. **Restart server atau jalankan:**
   ```
   restart indonesia_flag
   ```

---

### Opsi 2: Buat Texture Sendiri (Butuh Software)

**Yang Dibutuhkan:**
- Software edit gambar (Paint.NET, GIMP, atau Photoshop)
- Ukuran gambar: 1024x512 pixels

**Langkah-langkah:**

1. **Buat gambar bendera Indonesia:**
   - Buka software edit gambar
   - Buat canvas baru: 1024 x 512 pixels
   - Warna atas (512x256): **Merah #FF0000 atau #CE1126**
   - Warna bawah (512x256): **Putih #FFFFFF**
   - PENTING: Background harus transparan (alpha channel)

2. **Save gambar dengan nama ini:**
   - `prop_flag_us.png`
   - `prop_flag_us_s.png`
   - `prop_flag_usboat.png`

3. **Taruh di folder:**
   ```
   resources/[local]/indonesia_flag/stream/
   ```

4. **Restart:**
   ```
   restart indonesia_flag
   ```

---

### Opsi 3: Pakai OpenIV (Advanced)

Jika familiar dengan modding GTA V:

1. Download OpenIV: https://openiv.com/
2. Extract texture bendera dari GTA V
3. Edit texture dengan warna merah-putih
4. Export sebagai `.ytd`
5. Taruh di folder `stream/`

---

## 📝 File Yang Perlu Ada di Folder Stream:

Minimal salah satu dari ini:

```
stream/
├── prop_flag_us.ytd       (Bendera USA besar - jadi Indonesia)
├── prop_flag_us_s.ytd     (Bendera USA kecil - jadi Indonesia)
├── prop_flag_usboat.ytd   (Bendera di kapal - jadi Indonesia)
└── README.txt             (Sudah ada)
```

Format yang bisa digunakan:
- `.ytd` (GTA V Texture Dictionary) - **RECOMMENDED**
- `.png` (PNG image, akan di-convert otomatis)
- `.dds` (DirectDraw Surface)

---

## 🔍 Cara Cek Apakah Sudah Jalan:

1. **Start resource:**
   ```
   ensure indonesia_flag
   ```

2. **Cek di console:**
   ```
   [Indonesia Flag] Loading flag replacements...
   [Indonesia Flag] ✓ Loaded texture: prop_flag_us
   ```

3. **Cek di game:**
   - Spawn object bendera: `/car patriot` (mobil ada bendera)
   - Atau teleport ke lokasi ada bendera

---

## ❌ Troubleshooting:

### "Bendera tidak berubah"
- ✅ Pastikan ada file texture di `stream/`
- ✅ Pastikan nama file benar (case-sensitive)
- ✅ Restart resource: `restart indonesia_flag`
- ✅ Coba restart server

### "File tidak muncul di game"
- ✅ Cek format file (harus .ytd atau .png)
- ✅ Cek ukuran file (tidak boleh 0 KB)
- ✅ Pastikan fxmanifest.lua benar

### "Tidak tahu cara buat texture"
- ✅ **SOLUSI TERBAIK:** Download yang sudah jadi dari komunitas!
- ✅ Cari di GitHub atau forum.cfx.re

---

## 🔗 Resource Alternatif:

Jika resource ini ribet, cari alternatif yang sudah jadi:

**Keyword pencarian:**
- "fivem indonesia flag"
- "fivem bendera indonesia"
- "gta v indonesia flag mod"

**Situs:**
- https://github.com/search?q=fivem+indonesia+flag
- https://forum.cfx.re/
- Discord FiveM Indonesia

---

## 💡 Tips:

1. **Paling mudah:** Download resource jadi daripada buat sendiri
2. **Alternative:** Cari di forum FiveM Indonesia
3. **Jika stuck:** Tanya di Discord server FiveM lokal

---

## 📦 Struktur Folder Final:

```
indonesia_flag/
├── stream/
│   ├── prop_flag_us.ytd       ← FILE INI HARUS ADA
│   ├── prop_flag_us_s.ytd     ← FILE INI HARUS ADA
│   └── README.txt
├── fxmanifest.lua             ✅ Sudah ada
├── client.lua                 ✅ Sudah ada
├── README.md                  ✅ Sudah ada
├── QUICK_SETUP.txt            ✅ Sudah ada
└── INSTALL.md                 ✅ Sudah ada (file ini)
```

---

## ✅ Resource Sudah Aktif di Server.cfg:

```cfg
ensure indonesia_flag
```

Tinggal tambahkan file texture bendera saja! 🇮🇩

---

**Merdeka!** 🔴⚪
