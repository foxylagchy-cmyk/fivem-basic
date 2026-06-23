# Lyzen Jacket - Custom Clothing untuk FiveM

## Deskripsi
Resource ini menambahkan custom jacket "Lyzen" ke server FiveM yang menggunakan `illenium-appearance` atau clothing menu lainnya.

## Instalasi

### 1. Pastikan File Sudah di Tempat yang Benar
Resource ini seharusnya sudah berada di:
```
resources/[local]/lyzen_jacket/
```

Struktur file:
```
lyzen_jacket/
├── fxmanifest.lua
├── mp_m_freemode_01_male_freemode_hipster.ymt
├── README.md
└── stream/
    ├── jbib_006_u.ydd              (3D model jacket)
    ├── jbib_diff_006_a_uni.ytd     (Texture A)
    └── jbib_diff_006_b_uni.ytd     (Texture B)
```

### 2. Tambahkan ke server.cfg
Tambahkan baris ini ke `server.cfg`:
```cfg
ensure lyzen_jacket
```

**Posisi:** Sebaiknya di section VEHICLE SYSTEMS atau buat section baru CUSTOM CLOTHING sebelum MLO section.

### 3. Restart Server atau Ensure Resource
```
ensure lyzen_jacket
```
Atau restart server.

## Cara Menggunakan

### Di Illenium-Appearance:
1. Buka clothing menu (biasanya di barbershop/clothing store)
2. Pilih **"Jackets/Tops"** (Component 11)
3. Scroll sampai menemukan jacket Lyzen
4. Pilih dan akan ada 2 texture variant (A dan B)

### Lokasi di Menu:
- **Category:** Male Freemode Hipster
- **Component:** 11 (Jackets)
- **Drawable ID:** 6 (atau tergantung clothing lain yang terinstall)
- **Textures:** 2 variant (A dan B)

## Technical Info

### File Components:
- **YMT File:** Metadata yang mendefinisikan properties clothing (category, drawable ID, textures)
- **YDD File:** 3D geometry/model dari jacket
- **YTD Files:** Texture files (warna/pattern jacket)

### Component IDs di GTA V:
```
0  = Head
1  = Masks
2  = Hair
3  = Upper Body (Torsos)
4  = Lower Body (Legs)
5  = Bags & Parachutes
6  = Shoes
7  = Accessories
8  = Undershirt
9  = Body Armor
10 = Decals & Badges
11 = Jackets/Tops  ← LYZEN JACKET ADA DI SINI
```

### Naming Convention:
- `jbib` = Jacket/Top component identifier
- `006` = Drawable ID (jacket ke-6 di category ini)
- `_u` = Universal (male/female)
- `diff` = Diffuse texture
- `_a` / `_b` = Texture variants

## Troubleshooting

### Jacket Tidak Muncul di Menu:
1. **Cek resource sudah running:**
   ```
   restart lyzen_jacket
   ```

2. **Cek F8 console (client):**
   - Tekan F8 di game
   - Lihat apakah ada error saat load resource

3. **Cek server console:**
   - Lihat apakah ada error saat ensure resource

4. **Cek file structure:**
   - Pastikan semua file ada (1 YMT, 3 files di stream folder)
   - Pastikan nama file PERSIS seperti di atas (case sensitive!)

### Jacket Muncul Tapi Tidak Ada Texture (Hitam/Putih):
- YTD files mungkin corrupt atau tidak compatible
- Coba re-export dari original source

### Jacket Muncul Tapi Model Aneh (Glitchy):
- YDD file mungkin corrupt
- Pastikan YDD file compatible dengan GTA V version yang digunakan

### Conflict dengan Clothing Lain:
- Jika ada resource lain yang juga menggunakan drawable ID 6 di category hipster, akan terjadi conflict
- Solusi: Edit YMT file untuk menggunakan drawable ID yang berbeda

## Untuk Menambah Clothing Lain

Jika ingin menambah clothing lain (misal: pants, shoes, dll):

1. **Export/Download clothing files** (YMT, YDD, YTD)
2. **Identifikasi component type:**
   - Jacket = Component 11
   - Pants = Component 4
   - Shoes = Component 6
   - dst

3. **Buat resource baru** atau tambahkan ke resource ini
4. **Update fxmanifest.lua** untuk include YMT files baru
5. **Restart resource**

## Credits
- **Clothing:** Lyzen
- **Integration:** Gustyx Power
- **Appearance System:** illenium-appearance

## Support
Jika ada masalah atau pertanyaan, hubungi server admin atau developer.

---

**Version:** 1.0.0  
**Last Updated:** 2026-06-24  
**Compatible With:** illenium-appearance, qb-clothing, fivem-appearance
