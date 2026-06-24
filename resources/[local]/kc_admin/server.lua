-- Register the /kc command, restricted to the 'group.admin' permission level
lib.addCommand('kc', {
    help = 'Buka Admin Panel Khusus (GUI)',
    restricted = 'group.admin'
}, function(source, args)
    -- Trigger client event to open the menu GUI for the admin executing the command
    TriggerClientEvent('kc_admin:client:openMenu', source)
end)
