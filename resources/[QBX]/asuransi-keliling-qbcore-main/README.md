# 🛡️ Asuransi Keliling QBCore
_Sistem asuransi keliling otomatis untuk server FiveM QBCore — dibuat dengan penuh rasa tanggung jawab oleh kibieptr._

## 🔍 Deskripsi
sistem asuransi keliling (anti-spam kendaraan) untuk server FiveM berbasis **QBCore Framework**. Sistem ini secara otomatis akan menghapus kendaraan yang tidak sedang digunakan oleh pemain, demi menjaga performa server tetap stabil dan rapi.  
Script ini dilengkapi notifikasi dinamis, countdown sebelum penghapusan, dan dapat dijalankan manual via command maupun otomatis via cron.


## 🧰 Fitur
- 🚗 **Deteksi & Hapus Kendaraan Kosong**  
  Menghapus kendaraan milik pemain yang tidak sedang digunakan (*unoccupied*).

- 🕒 **Cron Otomatis**  
  Menjadwalkan asuransi keliling tiap periode tertentu (default: setiap 1 jam).

- 📢 **Notifikasi okokNotify**  
  Countdown & informasi dikirim ke semua pemain lewat notifikasi visual yang elegan.

- 🔐 **Command Admin**  
  Jalankan asuransi keliling secara manual dengan kontrol penuh.


## 💻 Command
```
/asuransikel [menit]
```
- **Tanpa argumen** → Asuransi keliling langsung dijalankan.
- **Dengan argumen menit** → Countdown sebelum proses dimulai.

Contoh:
```bash
/asuransikel 5
```
_Asuransi keliling akan dimulai setelah 5 menit._

## 🧠 Cara Kerja
1. Admin mengetik command atau sistem berjalan via cron.
2. Sistem menghitung mundur (dengan notifikasi berkala).
3. Setelah waktu habis, kendaraan kosong yang dimiliki pemain akan dihapus.
4. Pemain menerima notifikasi bahwa proses selesai.


## 🛠️ Instalasi
1. Tambahkan file script ke resource folder:
```bash
resources/[local]/asuransi-keliling-qbcore
```
2. Pastikan `okokNotify` sudah terinstal dan aktif di server.
3. Tambahkan ke `server.cfg`:
```
ensure asuransi-keliling-qbcore
```

## 🧾 Dependensi
- [QBCore Framework](https://github.com/qbcore-framework/qb-core)
- [okokNotify](https://github.com/overextended/ox_lib) (untuk notifikasi visual)


## 🔄 Petunjuk Lanjutan

### 🕒 Cara Mengedit Cron
Secara default, sistem menjalankan countdown dan pembersihan kendaraan setiap **1 jam**. Namun, jika kamu ingin menyesuaikan interval waktu pembersihan kendaraan, kamu bisa mengedit nilai `cooldown` yang ada di skrip.

- Untuk mengubah interval, cari bagian berikut dalam skrip:
```lua
local cooldown = 1
```
- Ganti angka `1` dengan angka yang sesuai dengan interval waktu yang diinginkan (dalam jam). Misalnya, untuk menjalankan proses setiap 30 menit, ganti menjadi:
```lua
local cooldown = 0.5
```
- Selain itu, jika kamu ingin mengubah interval per hitungan mundur dalam countdown, buka fungsi `sendCountdown` dan sesuaikan nilai `Wait(60000)` yang ada di dalamnya, yang secara default menghitung mundur setiap 1 menit.

### ⏰ Menambahkan Cron Tambahan
Jika kamu ingin menambahkan lebih banyak cron untuk menjalankan proses asuransi keliling pada jadwal yang berbeda, kamu bisa menambahkan baris cron baru seperti berikut:
```lua
lib.cron.new('* */2 * * *', function() -- Setiap 2 jam
    sendCountdown(10) -- 10 menit countdown
end)
```
Baris ini akan menjalankan asuransi keliling setiap 2 jam.


### 🔄 Integrasi dengan Sistem Lain
Skrip ini menggunakan notifikasi dari **okokNotify**. Jika kamu ingin mengintegrasikannya dengan sistem notifikasi lain (misalnya `esx:showNotification` atau sistem notifikasi lainnya), kamu bisa mengganti bagian yang memanggil notifikasi:
```lua
TriggerClientEvent('okokNotify:Alert', -1, 'Asuransi', 'Asuransi keliling telah selesai', 5000, 'success')
```
Ganti dengan sistem notifikasi yang sesuai dengan framework server kamu.

Contoh jika menggunakan `esx:showNotification`:
```lua
TriggerClientEvent('esx:showNotification', -1, 'Asuransi keliling telah selesai')
```

## 👤 Author
Made with ❤️ by [kibieptr](https://github.com/kibieptr)  
> "Koding sambil ngopi, biar logika gak mati."


## 📜 Lisensi
MIT License — bebas digunakan, dimodifikasi, dan dibagikan dengan mencantumkan kredit ke **kibieptr**.
