# Indonesia Flag Replacer

Resource ini mengganti semua bendera di GTA V dengan bendera Indonesia.

## Cara Install:

### Metode 1: Menggunakan Stream (Lebih Mudah)

1. **Buat folder `stream` di dalam resource ini:**
   ```
   indonesia_flag/
   ├── stream/
   │   └── (taruh file texture bendera di sini)
   ├── fxmanifest.lua
   ├── client.lua
   └── README.md
   ```

2. **Download atau buat texture bendera Indonesia:**
   - Format: `.ytd` (YTD adalah format texture GTA V)
   - Atau format: `.dds`, `.png` (akan di-convert otomatis oleh FiveM)

3. **Cara mendapatkan texture bendera Indonesia:**
   
   **Opsi A - Download dari komunitas:**
   - Cari "Indonesia Flag YTD GTA V" di Google
   - Download dari situs seperti GTA5-Mods.com
   
   **Opsi B - Buat sendiri:**
   - Siapkan gambar bendera Indonesia (merah-putih)
   - Ukuran: 512x256 pixels atau 1024x512 pixels
   - Format: PNG dengan transparansi
   - Gunakan tool OpenIV untuk convert ke .ytd
   
   **Opsi C - Gunakan script untuk generate:**
   - Buat file PNG sederhana dengan 2 warna (merah di atas, putih di bawah)
   - Nama file: `prop_flag_us.png`, `prop_flag_us_s.png`, dll

4. **Update fxmanifest.lua** untuk streaming:

### Metode 2: Manual Replacement (Advanced)

Jika ingin replace texture secara manual lewat code, edit `client.lua` dan gunakan native `AddReplaceTexture()`.

## File yang Perlu Dibuat:

Dalam folder `stream/`, buat file-file ini (format .ytd atau .png):

- `prop_flag_us.ytd` - Bendera USA besar
- `prop_flag_us_s.ytd` - Bendera USA kecil  
- `flag_us.ytd` - Bendera generik
- `flag_american.ytd` - Bendera Amerika lainnya

Semua file ini harus berisi texture bendera Indonesia (merah-putih).

## Aktifkan Resource:

Tambahkan di `server.cfg`:
```
ensure indonesia_flag
```

Atau jalankan di console:
```
ensure indonesia_flag
```

## Troubleshooting:

- **Bendera tidak berubah?** 
  - Pastikan file .ytd ada di folder `stream/`
  - Restart resource: `restart indonesia_flag`
  - Atau restart server

- **Tidak punya file .ytd?**
  - Cari tutorial "How to create YTD file for GTA V"
  - Atau download resource bendera Indonesia yang sudah jadi dari komunitas FiveM

## Alternatif Cepat:

Jika tidak ingin ribet dengan texture, cari resource yang sudah jadi:
- Cari "Indonesia Flag FiveM" di Google
- Download dari forum.cfx.re atau GitHub
- Extract ke folder `resources/[local]/`

## Credits:

- Dibuat untuk server FiveM Indonesia
- Bendera Indonesia - Merah Putih 🇮🇩
