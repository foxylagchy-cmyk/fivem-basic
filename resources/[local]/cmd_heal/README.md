# 🏥 CMD Heal - Admin Heal Commands

Resource untuk administrator melakukan heal pada player di server KotaCeria.

## 📋 Fitur

- ✅ Heal diri sendiri dengan `/healme`
- ✅ Heal player lain dengan `/heal [id]`
- ✅ Heal semua player dengan `/heal all`
- ✅ Full health + armor restoration
- ✅ Clear visual damage (blood, injuries)
- ✅ Revive player yang mati
- ✅ Notifikasi untuk admin dan player yang di-heal
- ✅ Logging setiap heal action

## 🎮 Commands

### `/healme`
**Deskripsi:** Heal diri sendiri  
**Permission:** Admin only (group.admin)  
**Contoh:** 
```
/healme
```

### `/heal [id]`
**Deskripsi:** Heal player berdasarkan server ID  
**Permission:** Admin only (group.admin)  
**Contoh:** 
```
/heal 5        - Heal player dengan ID 5
/heal 12       - Heal player dengan ID 12
```

### `/heal all`
**Deskripsi:** Heal semua player yang online  
**Permission:** Admin only (group.admin)  
**Contoh:** 
```
/heal all      - Heal semua player di server
```

## 🔧 Instalasi

1. Copy folder `cmd_heal` ke `resources/[local]/`
2. Tambahkan `ensure cmd_heal` ke `server.cfg`
3. Restart server atau gunakan `refresh` dan `ensure cmd_heal`

## 📦 Dependencies

- ✅ **ox_lib** - Untuk notifications dan commands
- ✅ **qbx_core** - Framework QBX
- ⚠️ Pastikan admin sudah terdaftar di ACE Permissions (server.cfg)

## 👮 Permission Setup

Admin permissions sudah di-set di `server.cfg`:
```cfg
add_ace group.admin command allow
add_principal identifier.fivem:XXXXX group.admin
```

## 🎯 Heal Features

Saat player di-heal, akan mendapatkan:
- 🩹 **Health:** Full (200/200)
- 🛡️ **Armor:** Full (100/100)
- 🍔 **Hunger:** Full (100%)
- 💧 **Thirst:** Full (100%)
- 🩸 **Bleeding:** Dihapus
- 💀 **Revive:** Jika player mati akan di-revive
- 🎨 **Visual Damage:** Dihapus (blood, injuries)
- ✨ **Effect:** Animasi heal visual

## 📊 Logs

Setiap heal action akan tercatat di server console:
```
[HEAL] Admin GustysPower (2) heal player TestPlayer (5)
[HEAL] Admin Foca_Geralio (1) heal semua player (12 players)
```

## 🐛 Troubleshooting

**Command tidak bisa digunakan?**
- Pastikan Anda sudah terdaftar sebagai admin di `server.cfg`
- Check dengan `/help heal` atau `/help healme`

**Player tidak ter-heal?**
- Pastikan ID player benar (cek dengan `/id` atau scoreboard)
- Pastikan player masih online

**Heal all tidak work?**
- Check server console untuk error
- Pastikan tidak ada typo: gunakan `/heal all` (lowercase)

## 📝 Changelog

**v1.1.0** (2026-06-22)
- ✨ Added Hunger & Thirst restoration
- 🍔 Hunger restored to 100%
- 💧 Thirst restored to 100%
- 📢 Updated notifications

**v1.0.0** (2026-06-22)
- ✨ Initial release
- ✅ Command /healme untuk self-heal
- ✅ Command /heal [id] untuk heal player lain
- ✅ Command /heal all untuk heal semua player
- ✅ Notifications system
- ✅ Console logging

## 👨‍💻 Author

**KotaCeria Development Team**
- Made for KotaCeria FiveM Server
- Compatible with QBX Framework

## 📄 License

Free to use untuk server KotaCeria
