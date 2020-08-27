local addon_name, SL = ...

local get_qualified_name = function()
    local name, _ = UnitName("player")
    local realm   = GetRealmName()
    return string.format("%s-%s", name, realm)
end

-- Handle loading/saving of data from/to file
local on_addon_loaded = function()
    -- Account wide data
    SL.Shopping.ShoppingList = ShoppingList_DB or {}
    SL.Shopping.update_list(true)
end

local on_addon_unloading = function()
    ShoppingList_DB = SL.Shopping.ShoppingList
end

local frame_load_vars = CreateFrame("Frame", "SL_LoadData")

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
