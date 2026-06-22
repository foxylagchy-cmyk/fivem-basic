lib.versionCheck('Qbox-project/qbx_spawn')

-- Track players yang perlu starter items (new characters)
local pendingStarterItems = {}

lib.callback.register('qbx_spawn:server:getLastLocation', function(source)
    local player = exports.qbx_core:GetPlayer(source)
    local queryResult = MySQL.single.await('SELECT position FROM players WHERE citizenid = ?', { player.PlayerData.citizenid })

    -- Fallback untuk karakter baru yang belum memiliki posisi tersimpan di database
    local position = (queryResult and queryResult.position) and json.decode(queryResult.position) or vec4(195.17, -933.77, 29.7, 144.5)
    local currentPropertyId = player.PlayerData.metadata.currentPropertyId

    return position, currentPropertyId
  end)

lib.callback.register('qbx_spawn:server:getProperties', function(source)
    if not GetResourceState('qbx_properties'):find('start') then
        return {}
    end

    local player = exports.qbx_core:GetPlayer(source)
    local houseData = {}
    local properties = MySQL.query.await('SELECT id, property_name, coords FROM properties WHERE owner = ?', { player.PlayerData.citizenid })

    for i = 1, #properties do
        local property = properties[i]

        houseData[#houseData + 1] = {
            label = property.property_name,
            coords = json.decode(property.coords),
            propertyId = property.id,
        }
    end

    return houseData
end)

-- Event to mark player for starter items (called by qbx_core)
RegisterNetEvent('qbx_spawn:server:setPendingStarterItems', function()
    local src = source
    pendingStarterItems[src] = true
    print('[qbx_spawn] Player', src, 'marked for starter items after spawn')
end)

-- Event called from client after successful spawn
RegisterNetEvent('qbx_spawn:server:onSpawnComplete', function()
    local src = source
    
    -- Check if player needs starter items
    if pendingStarterItems[src] then
        print('[qbx_spawn] Giving starter items to player', src, 'after spawn')
        TriggerEvent('qbx_core:server:giveStarterItems', src)
        pendingStarterItems[src] = nil
    end
end)