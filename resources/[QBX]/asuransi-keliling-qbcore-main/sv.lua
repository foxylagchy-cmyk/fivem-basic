local cooldown = 1 

local function isVehicleOccupied(veh)
    for seat = -1, 20 do 
        if GetPedInVehicleSeat(veh, seat) ~= 0 then 
            return true 
        end
    end
    return false 
end

local function askel()
    for i, veh in pairs(GetAllVehicles()) do 
        if HasVehicleBeenOwnedByPlayer(veh) then 
            if not isVehicleOccupied(veh) then
                DeleteEntity(veh)
            end
        end
    end

    -- Replace ox_lib:notify with okokNotify
    TriggerClientEvent('okokNotify:Alert', -1, 'Asuransi', 'Asuransi keliling telah selesai', 5000, 'success')
end

local function sendCountdown(menit)
    for i = menit, 0, -1 do
        if i >= 1 then
            -- Replace ox_lib:notify with okokNotify
            TriggerClientEvent('okokNotify:Alert', -1, 'Asuransi', 'Asuransi keliling akan bekerja dalam '..i..' menit', 5000, 'info')

            if i == 1 then
                Wait(30000)
                for j = 3, 1, -1 do
                    TriggerClientEvent('okokNotify:Alert', -1, 'Asuransi', 'Asuransi keliling akan bekerja dalam '..j..'0 detik', 5000, 'info')
                    Wait(j ~= 1 and 10000 or 1000)

                    if j == 1 then
                        for k = 9, 1, -1 do
                            TriggerClientEvent('okokNotify:Alert', -1, 'Asuransi', 'Asuransi keliling akan bekerja dalam '..k..' detik', 5000, 'info')
                            Wait(1000)
                        end
                    end
                end
            else
                Wait(60000)
            end
        else
            askel()
        end
    end
end

lib.addCommand('asuransikel', {
    help = 'Asuransi Keliling',
    params = {
        {
            name = 'menit',
            type = 'number',
            help = 'Menit',
            optional = true,
        },
    },
    restricted = 'group.admin'
}, function(source, args, raw)
    local menit = tonumber(args.menit)
    if menit then
        sendCountdown(menit)
    else
        askel()
    end
end)

lib.cron.new('* */' .. cooldown .. ' * * *', function()
    sendCountdown(10)--10 menit countdown
end)
