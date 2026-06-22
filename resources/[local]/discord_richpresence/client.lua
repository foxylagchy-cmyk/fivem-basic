-- Discord Rich Presence
-- Menampilkan status "Playing" di Discord

-- Konfigurasi
local appId = '1518593371986460692' -- Discord Application ID
local serverName = 'KotaCeria Roleplay'
local largeAsset = 'logo' -- Nama asset di Discord Developer Portal
local smallAsset = 'icon_small'

-- Update Discord Presence
Citizen.CreateThread(function()
    -- Set Discord App ID
    SetDiscordAppId(appId)
    
    while true do
        Citizen.Wait(5000) -- Update setiap 5 detik
        
        -- Get player info
        local playerName = GetPlayerName(PlayerId())
        local playerId = GetPlayerServerId(PlayerId())
        local playerCount = 0
        
        -- Hitung jumlah player
        for _, player in ipairs(GetActivePlayers()) do
            playerCount = playerCount + 1
        end
        
        local maxPlayers = GetConvarInt('sv_maxclients', 48)
        
        -- Set Discord Rich Presence dengan asset
        SetDiscordRichPresenceAsset(largeAsset)
        SetDiscordRichPresenceAssetText(serverName)
        
        SetDiscordRichPresenceAssetSmall(smallAsset)
        SetDiscordRichPresenceAssetSmallText('Online')
        
        -- Set details dan state
        SetRichPresence(string.format('Player: %s | ID: %d', playerName, playerId))
        
        -- Set buttons (opsional - uncomment jika sudah ada link)
        -- SetDiscordRichPresenceAction(0, "Join Server", "fivem://connect/YOURIP:30120")
        -- SetDiscordRichPresenceAction(1, "Discord", "https://discord.gg/YOUR_INVITE")
    end
end)

-- Update saat pertama kali join
AddEventHandler('playerSpawned', function()
    Citizen.Wait(1000)
    local playerName = GetPlayerName(PlayerId())
    local playerId = GetPlayerServerId(PlayerId())
    SetRichPresence(string.format('Player: %s | ID: %d', playerName, playerId))
end)

