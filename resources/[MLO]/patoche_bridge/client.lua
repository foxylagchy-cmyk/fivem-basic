-- Patoche Bridge - Force Terrain Load for Cayo Perico
-- This ensures the bridge area terrain loads properly

CreateThread(function()
    -- Force load map data for Cayo Perico region
    SetMapdatacullboxEnabled("h4_ipl_NW", false)
    SetMapdatacullboxEnabled("h4_ipl_NE", false)
    SetMapdatacullboxEnabled("h4_ipl_SW", false)
    SetMapdatacullboxEnabled("h4_ipl_SE", false)
    
    print("^2[Patoche Bridge]^7 Bridge area terrain loading forced!")
end)
