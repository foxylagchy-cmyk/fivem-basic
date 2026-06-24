Config = {}

-- Durasi dalam milidetik (1000ms = 1 detik)
Config.KnockDuration = 30000        -- 30 detik fase knock
Config.DeathDuration = 1800000      -- 30 menit fase pingsan (1800 detik)
Config.InjuryWalkDuration = 300000  -- 5 menit injury walk

-- Health Settings
Config.KnockHealthThreshold = 100   -- Health di mana player masuk fase knock
Config.KnockHealthSet = 30          -- Health saat fase knock (10-15% dari max 200)
Config.DeathHealthSet = 25          -- Health saat fase pingsan (sangat rendah)
Config.ReviveHealth = 200           -- Health saat revive (200 = full health 100%)
Config.ReviveHunger = 30            -- Hunger saat revive (30%)
Config.ReviveThirst = 30            -- Thirst saat revive (30%)

-- Animasi Settings
-- Animasi Knock (30 detik) = crawl merangkak, masih sadar
Config.KnockAnimation = {
    dict = "move_injured_ground",
    anim = "front_loop"
}

-- Animasi Pingsan (30 menit) = dead terbaring
Config.DeathAnimation = {
    dict = "dead",
    anim = "dead_a"
}

Config.InjuryWalkClipset = "move_m@injured"

-- Text Messages (bisa diganti ke bahasa lain)
Config.Messages = {
    BleedingPhase = "KAMU MEMASUKI FASE PENDARAHAN!",
    DeathPhase = "KAMU PINGSAN!",
    MedicRevive = "Kamu telah diselamatkan oleh medis!",
    WakeUpInjured = "Kamu terbangun dengan kondisi terluka",
    InjuryHealed = "Kondisimu sudah membaik",
    NotMedic = "Kamu bukan medis!",
    PatientSaved = "Kamu telah menyelamatkan pasien!"
}

-- Feature Toggles
Config.EnableKnockPhase = true      -- Aktifkan fase knock
Config.EnableDeathPhase = true      -- Aktifkan fase pingsan
Config.EnableInjuryWalk = true      -- Aktifkan injury walk setelah revive
Config.EnableBloodDrops = true      -- Aktifkan efek blood drops di UI
Config.EnableVoiceInKnock = true    -- Biarkan player bicara saat knock
Config.AllowCrawlWhenDead = true    -- Biarkan player merangkak (crawl) saat pingsan

-- UI Settings
Config.UISettings = {
    -- Opacity untuk knock phase overlay (0.1 - 1.0, default: 0.15)
    -- Semakin kecil semakin transparan, semakin besar semakin gelap
    KnockOverlayOpacity = 0.15,
    
    -- Opacity untuk death phase overlay (0.1 - 1.0, default: 0.4)
    DeathOverlayOpacity = 0.4,
    
    -- Blur intensity (1-10, default: 3 untuk knock, 2 untuk death)
    -- Semakin besar semakin blur
    KnockBlurIntensity = 3,
    DeathBlurIntensity = 2,
    
    -- Show blood drops animation
    ShowBloodDrops = true,
}

-- Control Disabling
Config.DisableControlsKnock = {
    21,  -- Sprint
    22,  -- Jump
    24,  -- Attack
    25,  -- Aim
    140, -- Melee Attack Light
    141, -- Melee Attack Heavy
    142, -- Melee Attack Alternate
    257, -- Attack 2
    263, -- Melee Attack 1
}

Config.EnableControlsKnock = {
    249, -- Push to Talk
    46,  -- Honk/Talk
}

-- Debug Mode (set false untuk production)
Config.Debug = true  -- Changed to true untuk debugging
Config.EnableTestCommands = true    -- Aktifkan command /testknock, /testrevive, dll

-- Job yang bisa revive
Config.MedicJobs = {
    'ambulance',
    'ems'
}

-- Revive Settings
Config.ReviveReward = 500           -- Uang yang didapat medis saat revive (set 0 untuk disable)
Config.ReviveDistance = 3.0         -- Jarak maksimal untuk revive
