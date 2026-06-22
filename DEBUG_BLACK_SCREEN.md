# 🔍 Debug Black Screen Issue - Step by Step

## 🎯 Current Status:
- ✅ Console bersih (no errors)
- ✅ Character creation works
- ✅ Keybind T works (player loaded)
- ❌ **BLACK SCREEN** - Spawn selector tidak muncul
- ⚠️ Harus reconnect/migrate untuk spawn selector muncul

## 📊 This Means:
1. Character dibuat di database ✅
2. Player object created ✅
3. Client scripts loaded ✅
4. **BUT:** Spawn selector event tidak ter-trigger ❌

---

## 🔧 Fix Applied: Debug Logging

Added extensive logging to track the issue:

**File:** `qbx_spawn/client/main.lua`

### Added Logs:
1. `qb-spawn:client:openUI` event received
2. `qb-spawn:client:setupSpawns` triggered
3. Last location fetched
4. Total spawn locations
5. Camera/map setup
6. UI showing

---

## 🧪 Testing Steps

### Step 1: Restart Server
```
restart qbx_spawn
restart qbx_core
```

Or full restart:
```
quit
# Start lagi
```

### Step 2: Check Server Console
Sebelum create character, pastikan qbx_spawn started:
```
[script:qbx_spawn] Started successfully ✅
```

### Step 3: Create New Character
1. Connect ke server
2. Create character
3. **SEGERA** buka F8 console (client-side)

### Step 4: Check Client Console (F8)
Look for these logs:
```
[qbx_spawn] openUI event received, firstSpawn: true
[qbx_spawn] Triggering setupSpawns for new character
[qbx_spawn] setupSpawns event triggered
[qbx_spawn] Got last location: vec4(195.17, -933.77, 29.7, 144.5)
[qbx_spawn] Total spawn locations: 4
[qbx_spawn] Setting up camera and map...
[qbx_spawn] Showing spawn selector UI
```

### Step 5: Identify Problem

#### Scenario A: No logs at all
**Problem:** Event tidak ter-trigger sama sekali
**Cause:** qbx_core character.lua tidak trigger spawn events
**Solution:** Check qbx_core/client/character.lua

#### Scenario B: "openUI received" but no "setupSpawns triggered"
**Problem:** openUI handler tidak work
**Cause:** Event handler issue
**Solution:** TriggerEvent failed

#### Scenario C: "setupSpawns triggered" but stops midway
**Problem:** Error di callback atau setup functions
**Cause:** ox_lib, MySQL, or native function error
**Solution:** Check for errors in F8

#### Scenario D: All logs show but still black screen
**Problem:** UI rendering issue
**Cause:** Scaleform loading failed or screen fade issue
**Solution:** Force screen fade in

---

## 🔨 Alternative Solutions

### Solution 1: Force Spawn (No Selector)

If spawn selector keeps failing, bypass it completely:

**Create file:** `qbx_spawn/config/shared.lua`
```lua
return {
    skipSpawnSelector = true,  -- NEW
    defaultSpawn = vec4(195.17, -933.77, 29.7, 144.5)  -- Legion Square
}
```

Then modify client to auto-spawn new characters.

### Solution 2: Use Different Spawn System

Try `qb-spawn` (legacy) instead of `qbx_spawn`:
```cfg
# server.cfg
stop qbx_spawn
ensure qb-spawn
```

**Note:** Need qb-apartments for this to work properly.

### Solution 3: Direct Spawn via qbx_core

Modify qbx_core to skip spawn selector for new characters:

**File:** `qbx_core/client/character.lua`
```lua
-- Around line 443-446, replace with:
else
    -- Skip spawn selector, direct spawn
    local defaultSpawn = vec4(195.17, -933.77, 29.7, 144.5)
    SetEntityCoords(cache.ped, defaultSpawn.x, defaultSpawn.y, defaultSpawn.z)
    SetEntityHeading(cache.ped, defaultSpawn.w)
    TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
    TriggerEvent('QBCore:Client:OnPlayerLoaded')
end
```

---

## 🐛 Common Issues & Fixes

### Issue 1: ox_lib not loaded
**Error:** `attempt to call field 'callback' (a nil value)`
**Fix:** 
```cfg
ensure ox_lib
ensure qbx_spawn
```

### Issue 2: Cache.ped is nil
**Error:** `attempt to index global 'cache' (a nil value)`
**Fix:** Use `PlayerPedId()` instead of `cache.ped`

### Issue 3: Scaleform not loading
**Error:** Scaleform returns 0
**Fix:** Increase timeout or use different scaleform

### Issue 4: Screen stuck faded out
**Error:** DoScreenFadeIn never called
**Fix:** Force fade in after 5 seconds

---

## 🎯 Quick Temporary Fix (Command)

While debugging, create a command to manually trigger spawn:

**Add to qbx_spawn/client/main.lua:**
```lua
RegisterCommand('forcespawn', function()
    TriggerEvent('qb-spawn:client:setupSpawns')
end, false)
```

Then when stuck:
1. Press T (chat)
2. Type `/forcespawn`
3. Spawn selector should appear

---

## 📝 Next Steps Based on Logs

### If F8 shows:
1. **"openUI received"** → Good! Event system works
2. **"setupSpawns triggered"** → Good! Event chain works
3. **"Got last location"** → Good! Server callback works
4. **"Total spawn locations: X"** → Good! Spawn data loaded
5. **"Setting up camera"** → Camera should appear
6. **"Showing spawn selector UI"** → UI should render

### If stuck at any step:
- Note which step
- Check for errors in F8
- Screenshot and report

---

## 🚀 After Testing:

1. **Screenshot F8 console logs**
2. **Screenshot server console**
3. **Note at which log it stops**
4. Share here for further debugging

---

## ⚡ Emergency Workaround

If all else fails, create auto-spawn command:

**File:** `resources/[local]/cmd_autospawn/fxmanifest.lua`
```lua
fx_version 'cerulean'
game 'gta5'

client_script 'client.lua'
```

**File:** `resources/[local]/cmd_autospawn/client.lua`
```lua
-- Auto spawn new characters after 5 seconds if stuck
CreateThread(function()
    Wait(5000)
    
    if not IsScreenFadedIn() then
        local spawn = vector4(195.17, -933.77, 29.7, 144.5)
        DoScreenFadeOut(500)
        Wait(500)
        
        SetEntityCoords(PlayerPedId(), spawn.x, spawn.y, spawn.z)
        SetEntityHeading(PlayerPedId(), spawn.w)
        
        TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
        TriggerEvent('QBCore:Client:OnPlayerLoaded')
        
        Wait(500)
        DoScreenFadeIn(1000)
    end
end)
```

Then:
```cfg
ensure cmd_autospawn
```

---

**Updated:** June 22, 2026
**Status:** Debugging with extensive logging
**Next:** Test and report F8 console logs
