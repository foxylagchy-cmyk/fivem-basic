local QBCore = exports['qb-core']:GetCoreObject()

local function SendWebhook(title, message, color)
    if Config.WebhookURL == "" or Config.WebhookURL == "https://discord.com/api/webhooks/YOUR_WEBHOOK_ID/YOUR_WEBHOOK_TOKEN" then
        return
    end

    local embed = {
        {
            ["title"] = title,
            ["description"] = message,
            ["type"] = "rich",
            ["color"] = color,
            ["footer"] = {
                ["text"] = "Kota Ceria System"
            },
            ["timestamp"] = os.date('!%Y-%m-%dT%H:%M:%SZ')
        }
    }

    PerformHttpRequest(Config.WebhookURL, function(err, text, headers) end, 'POST', json.encode({
        username = Config.WebhookName,
        avatar_url = Config.WebhookAvatar,
        embeds = embed
    }), { ['Content-Type'] = 'application/json' })
end

RegisterNetEvent('QBCore:Server:SetDuty', function(source, onDuty)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local jobName = Player.PlayerData.job.name
    local citizenId = Player.PlayerData.citizenid
    local fullName = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname
    
    if Config.AllowedJobs[jobName] then
        local dutyStatus = onDuty and "🟢 **ON DUTY**" or "🔴 **OFF DUTY**"
        local color = onDuty and 65280 or 16711680 -- Green or Red

        local title = "Catatan Duty " .. fullName .. " (" .. citizenId .. ")"
        local message = "**Nama:** " .. fullName .. "\n**Job:** " .. string.upper(jobName) .. "\n**Status:** " .. dutyStatus

        SendWebhook(title, message, color)
    end
end)
