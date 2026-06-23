local QBCore = exports['qb-core']:GetCoreObject()
local bodycamActive = false

local function UpdateBodycam(PlayerData)
    if not PlayerData or not PlayerData.job then return end
    
    local jobName = PlayerData.job.name
    local onDuty = PlayerData.job.onduty

    if Config.AllowedJobs[jobName] and onDuty then
        local fullName = PlayerData.charinfo.firstname .. " " .. PlayerData.charinfo.lastname
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
            SendNUIMessage({
                action = "notify",
                type = "success",
                messages = { Config.Notifications.onDuty, Config.Notifications.onDutyGPS }
            })
        else
            SendNUIMessage({
                action = "notify",
                type = "error",
                messages = { Config.Notifications.offDuty, Config.Notifications.offDutyGPS }
            })
        end
    end
    
    UpdateBodycam(Player)
end)
