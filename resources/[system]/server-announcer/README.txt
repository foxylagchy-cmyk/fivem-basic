SERVER ANNOUNCER - Auto Announcement System
==========================================

Resource ini otomatis mengirim announcement setiap kali:
1. Server restart/ensure
2. Resource server-announcer di-restart

FITUR:
------
✅ Auto announcement saat server start
✅ Manual announcement via command
✅ Scheduled announcement (berulang)
✅ Integrasi dengan txAdmin
✅ Styling modern dengan CSS

COMMANDS:
---------
/announce <pesan>
  - Kirim announcement manual ke semua player
  - Requires: Admin permission

/scheduleannounce <detik> <pesan>
  - Buat scheduled announcement yang berulang
  - Minimal interval: 60 detik
  - Requires: Admin permission

CONTOH PENGGUNAAN:
------------------
1. Manual announcement:
   /announce Server akan maintenance dalam 10 menit!

2. Scheduled announcement:
   /scheduleannounce 300 Jangan lupa save progress kalian!
   (akan mengirim announcement setiap 5 menit)

KONFIGURASI:
------------
Edit file server.lua bagian Config untuk mengubah:
- announcementMessage: Pesan default saat restart
- announcementDuration: Durasi notifikasi (ms)
- delayAfterStart: Delay setelah resource start (ms)

PERMISSIONS:
------------
Resource ini membutuhkan ace permission "command.announce"
Admin yang sudah di-set di server.cfg otomatis punya akses.

NOTES:
------
- Resource ini lightweight dan tidak mempengaruhi performance
- Announcement menggunakan chat template dengan styling modern
- Terintegrasi dengan qbx_core untuk dual notification
