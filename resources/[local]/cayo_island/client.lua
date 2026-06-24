-- Cayo Perico Island

print("^2[Cayo Island]^7 Loading Cayo Perico (Coexist Mode)...")

-- Thread 1: Load ALL Cayo Perico IPLs
CreateThread(function()
    print("^3[Cayo Island]^7 Loading IPLs...")
    
    local allIpls = {
        -- TERRAIN
        "h4_islandx_terrain_01", "h4_islandx_terrain_02", "h4_islandx_terrain_03",
        "h4_islandx_terrain_04", "h4_islandx_terrain_05", "h4_islandx_terrain_06",
        "h4_islandx_terrain_props_05_a", "h4_islandx_terrain_props_05_b", "h4_islandx_terrain_props_05_c",
        "h4_islandx_terrain_props_05_d", "h4_islandx_terrain_props_05_e", "h4_islandx_terrain_props_05_f",
        "h4_islandx_terrain_props_06_a", "h4_islandx_terrain_props_06_b", "h4_islandx_terrain_props_06_c",
        
        -- SECTORS
        "h4_ne_ipl_00", "h4_ne_ipl_01", "h4_ne_ipl_02", "h4_ne_ipl_03", "h4_ne_ipl_04",
        "h4_ne_ipl_05", "h4_ne_ipl_06", "h4_ne_ipl_07", "h4_ne_ipl_08", "h4_ne_ipl_09",
        "h4_nw_ipl_00", "h4_nw_ipl_01", "h4_nw_ipl_02", "h4_nw_ipl_03", "h4_nw_ipl_04",
        "h4_nw_ipl_05", "h4_nw_ipl_06", "h4_nw_ipl_07", "h4_nw_ipl_08", "h4_nw_ipl_09",
        "h4_se_ipl_00", "h4_se_ipl_01", "h4_se_ipl_02", "h4_se_ipl_03", "h4_se_ipl_04",
        "h4_se_ipl_05", "h4_se_ipl_06", "h4_se_ipl_07", "h4_se_ipl_08", "h4_se_ipl_09",
        "h4_sw_ipl_00", "h4_sw_ipl_01", "h4_sw_ipl_02", "h4_sw_ipl_03", "h4_sw_ipl_04",
        "h4_sw_ipl_05", "h4_sw_ipl_06", "h4_sw_ipl_07", "h4_sw_ipl_08", "h4_sw_ipl_09",
        
        -- BUILDINGS & PROPS
        "h4_islandairstrip", "h4_islandairstrip_props", "h4_islandx_mansion",
        "h4_islandx_mansion_props", "h4_islandx_props", "h4_islandxdock",
        "h4_islandxdock_props", "h4_islandxdock_props_2", "h4_islandxtower",
        "h4_islandx_maindock", "h4_islandx_maindock_props", "h4_islandx_maindock_props_2",
        "h4_IslandX_Mansion_Vault", "h4_islandairstrip_propsb", "h4_beach",
        "h4_beach_props", "h4_beach_bar_props", "h4_islandx_barrack_props",
        "h4_islandx_checkpoint", "h4_islandx_checkpoint_props", "h4_islandx",
    }
    
    for i, ipl in ipairs(allIpls) do
        RequestIpl(ipl)
        if i % 10 == 0 then
            Wait(50)
        end
    end
    
    print("^2[Cayo Island]^7 All IPLs loaded (" .. #allIpls .. " total)")
end)

-- Thread 2: Enable Island WITHOUT switching from Los Santos
CreateThread(function()
    Wait(1000)
    SetScenarioGroupEnabled("Heist_Island_Peds", true)
    SetAudioFlag("LoadMPData", true)
    
    -- DISABLE CULLING
    SetMapdatacullboxEnabled("h4_ipl_NW", false)
    SetMapdatacullboxEnabled("h4_ipl_NE", false) 
    SetMapdatacullboxEnabled("h4_ipl_SW", false)
    SetMapdatacullboxEnabled("h4_ipl_SE", false)
    
    print("^2[Cayo Island]^7 Culling disabled - COEXIST MODE active!")
    print("^2[Cayo Island]^7 Los Santos & Cayo Perico both visible!")
end)

print("^2[Cayo Island]^7 Loaded successfully!")
