RegisterNetEvent('cmd_nitro:server:SyncFlames', function(netId, state)
    local veh = NetworkGetEntityFromNetworkId(netId)
    if veh ~= 0 then
        Entity(veh).state:set('nitroFlames', state, true)
    end
end)
