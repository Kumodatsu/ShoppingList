local addon_name, SL = ...

-- Handle loading/saving of data from/to file
local on_addon_loaded = function()
    -- Account wide data
    ShoppingList_DB      = ShoppingList_DB      or {}
    -- Character specific data
    ShoppingList_Char_DB = ShoppingList_Char_DB or {}
end

local on_addon_unloading = function()
    
end

local frame_load_vars = CreateFrame("FRAME", "SL_LoadData")

frame_load_vars:RegisterEvent("ADDON_LOADED")
frame_load_vars:RegisterEvent("PLAYER_LOGOUT")

frame_load_vars.OnEvent = function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == addon_name then
        on_addon_loaded()
    elseif event == "PLAYER_LOGOUT" then
        on_addon_unloading()
    end
end

frame_load_vars:SetScript("OnEvent", frame_load_vars.OnEvent)
