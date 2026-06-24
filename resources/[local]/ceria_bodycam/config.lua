Config = {}

-- Masukkan URL Webhook Discord Anda di sini. 
-- Anda bisa menggantinya kapan saja.
Config.WebhookURL = "https://discord.com/api/webhooks/YOUR_WEBHOOK_ID/YOUR_WEBHOOK_TOKEN"

Config.WebhookName = "Kota Ceria Duty Log"
Config.WebhookAvatar = "https://cdn.discordapp.com/embed/avatars/0.png" -- Avatar URL opsional

-- Daftar job yang diizinkan menggunakan Bodycam
Config.AllowedJobs = {
    ['police'] = true,
    ['ambulance'] = true,
    -- ['sheriff'] = true,
}

-- Notifikasi teks
Config.Notifications = {
    onDuty = "Kamu berhasil on duty",
    onDutyGPS = "GPS dinas telah aktif",
    offDuty = "Kamu berhasil off duty",
    offDutyGPS = "GPS dinas telah nonaktif"
}

-- Teks Bodycam Dept (berdasarkan job, atau custom)
Config.DepartmentNames = {
    ['police'] = "CERIA POLICE DEPARTMENT",
    ['ambulance'] = "CERIA MEDICAL DEPARTMENT",
}
