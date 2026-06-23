local QBCore = exports['qb-core']:GetCoreObject()
local bodycamActive = false

local function UpdateBodycam(Player)
    if not Player then return end
    
    local jobName = Player.PlayerData.job.name
    local onDuty = Player.PlayerData.job.onduty

    if Config.AllowedJobs[jobName] and onDuty then
        local fullName = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname
        local department = Config.DepartmentNames[jobName] or string.upper(jobName) .. " DEPARTMENT"
        
        SendNUIMessage({
            action = "show",
            name = fullName,
            department = department
        })
        bodycamActive = true
    else
        SendNUIMessage({
            action = "hide"
        })
        bodycamActive = false
    end
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    local Player = QBCore.Functions.GetPlayerData()
    UpdateBodycam(Player)
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    SendNUIMessage({ action = "hide" })
    bodycamActive = false
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    local Player = QBCore.Functions.GetPlayerData()
    Player.job = JobInfo
    UpdateBodycam(Player)
end)

RegisterNetEvent('QBCore:Client:SetDuty', function(onDuty)
    local Player = QBCore.Functions.GetPlayerData()
    Player.job.onduty = onDuty
    
    if Config.AllowedJobs[Player.job.name] then
        if onDuty then
            QBCore.Functions.Notify(Config.Notifications.onDuty, "success")
            QBCore.Functions.Notify(Config.Notifications.onDutyGPS, "success")
        else
            QBCore.Functions.Notify(Config.Notifications.offDuty, "error")
            QBCore.Functions.Notify(Config.Notifications.offDutyGPS, "error")
        end
    end
    
    UpdateBodycam(Player)
end)
