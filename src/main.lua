local addon_name, SL = ...

-- Version command
local show_version = function()
    local author  = GetAddOnMetadata("ShoppingList", "author")
    local title   = GetAddOnMetadata("ShoppingList", "title")
    local version = GetAddOnMetadata("ShoppingList", "version")
    SL.Print("%s's %s, version %s", author, title, version)
end

SL.Command.add_cmd("version", show_version, [[
"/sl version"
> "/sl version" shows information about the currently loaded version of ShoppingList.
]])

-- Global addon getter
SL_API = SL

