-- Indonesia Flag Replacer
-- Replaces all USA flags with Indonesian flag

CreateThread(function()
    print('[Indonesia Flag] Loading flag replacements...')
    
    -- List of flag textures in GTA V that we want to replace
    local flagReplacements = {
        -- USA flags
        { dict = 'prop_flag_us', name = 'prop_flag_us' },
        { dict = 'prop_flag_us_s', name = 'prop_flag_us_s' },
        { dict = 'flag_us', name = 'flag_us' },
        { dict = 'flag_american', name = 'flag_american' },
        
        -- You can add more flag textures here
    }
    
    -- Wait for game to load
    Wait(5000)
    
    -- Replace each flag texture with Indonesian flag
    for _, flag in ipairs(flagReplacements) do
        -- Request the original texture dictionary
        local attempt = 0
        while not HasStreamedTextureDictLoaded(flag.dict) and attempt < 10 do
            RequestStreamedTextureDict(flag.dict, false)
            Wait(100)
            attempt = attempt + 1
        end
        
        if HasStreamedTextureDictLoaded(flag.dict) then
            print('[Indonesia Flag] ✓ Loaded texture: ' .. flag.dict)
        else
            print('[Indonesia Flag] ✗ Failed to load: ' .. flag.dict)
        end
    end
    
    print('[Indonesia Flag] Flag replacement complete!')
    print('[Indonesia Flag] Note: You need to provide flag texture files in the flags folder')
end)
