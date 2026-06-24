# Nissan Skyline GTR R34 - Custom RB26 Audio

## ⚠️ Masalah Oversized Assets
Resource ini memiliki texture dan model yang besar yang bisa menyebabkan crash:
- `skyline.ytd`: **67 MB** physical memory
- `vehicles_skyline_tuning.ytd`: **48 MB** physical memory  
- `skyline_livery1.yft`: **32 MB** physical memory
- `skyline.yft` & `skyline_hi.yft`: **16.5 MB** virtual memory each

**Total: ~180 MB** - Ini bisa menyebabkan streaming issues dan crash!

---

## ✅ Solusi untuk Mencegah Crash

### 1. **Server.cfg Optimization** (WAJIB!)
Tambahkan setting ini ke `server.cfg`:

```cfg
# Streaming memory optimization - PENTING untuk asset besar
set streaming_textureBufferSize 256
set streaming_meshBufferSize 256
set streaming_timecycleBufferSize 64

# Game build untuk support DLC asset
sv_enforceGameBuild 2802

# Streaming distance optimization
set onesync_distanceCullMultiplier 1.0
```

### 2. **Load Order di server.cfg**
Pastikan urutan loading benar:

```cfg
# Audio HARUS di-load SEBELUM vehicle
ensure sound_str020rb26
ensure skyline
```

### 3. **Client Optimization** (Instruksi untuk Players)
Player HARUS setting graphics mereka:

**Settings > Graphics:**
- **Texture Quality**: Normal atau High (JANGAN Very High!)
- **Extended Texture Budget**: OFF
- **Shader Quality**: Normal
- **Post FX**: Normal
- **Particle Quality**: Normal

**FiveM Settings (F8 Console):**
```
cl_drawDistance 500
cl_vehicleDrawDistance 300
```

### 4. **Server Rules untuk Skyline**
Untuk mencegah crash massal:
- ❌ **Max 3-5 Skyline** spawned bersamaan di area yang sama
- ❌ **Jangan spawn Skyline** saat banyak player berkumpul (event, race start)
- ✅ **Despawn Skyline** yang tidak dipakai (gunakan garage system)

### 5. **Clear Cache** (Jika Ada Masalah)
Player yang crash harus:
1. Quit FiveM
2. Delete folder: `%localappdata%\FiveM\FiveM Application Data\cache`
3. Restart FiveM
4. Reconnect ke server

### 6. **Alternative Solutions**

#### A. Compress Textures (Recommended)
Gunakan OpenIV untuk compress texture:
1. Buka `skyline.ytd` dan `vehicles_skyline_tuning.ytd` 
2. Re-export dengan compression DXT1/DXT5
3. Target size: < 20 MB per file

#### B. Reduce LOD Models
Edit `vehicles.meta` line 66:
```xml
<lodDistances content="float_array">
  150.000000  <!-- dari 300 -->
  150.000000  <!-- dari 300 -->
  150.000000  <!-- dari 300 -->
  150.000000  <!-- dari 300 -->
  150.000000  <!-- dari 300 -->
  150.000000  <!-- dari 300 -->
</lodDistances>
```

#### C. Limit Liveries
Hapus atau comment `skyline_livery1.yft` di stream folder jika tidak diperlukan (saves 32 MB!)

---

## 🔊 Custom Audio RB26DETT
Audio engine menggunakan `str020rb26` sound pack:
- Realistic RB26 engine sound
- Turbo spool & BOV
- Backfire sounds

**Requirements:**
- Resource `sound_str020rb26` HARUS running
- Load order: audio first, then vehicle

---

## 🐛 Troubleshooting Crash

### Crash saat spawn Skyline:
1. Check F8 console untuk error
2. Pastikan `sound_str020rb26` running: `resmon` di F8
3. Lower graphics settings
4. Clear cache

### Skyline invisible/not loading:
1. Terlalu banyak Skyline spawned
2. Client texture buffer penuh
3. Coba respawn atau teleport away lalu kembali

### Audio tidak keluar:
1. `ensure sound_str020rb26` di server console
2. Check `vehicles.meta` line 25: `<audioNameHash>str020rb26</audioNameHash>`

### Server lag saat Skyline spawned:
1. Asset terlalu besar untuk server spec
2. Reduce max Skyline yang bisa spawned
3. Consider compress textures (solution 6.A)

---

## 📊 Performance Impact
- **Low-end PC**: Mungkin crash atau stutter
- **Mid-range PC**: Playable dengan settings Normal
- **High-end PC**: No issues

**Minimum Requirements untuk Player:**
- RAM: 16 GB
- VRAM: 4 GB
- Graphics: GTX 1060 / RX 580 or better

---

## 📝 Notes
- Resource ini menggunakan format FXv2 (`fx_version 'cerulean'`)
- Compatible dengan QBX/QBCore frameworks
- Custom audio hash: `str020rb26`
- Vehicle model name: `skyline`
- Vehicle class: Sport
