local addon_name, SL = ...
local M = {}

-- All shopping lists
M.ShoppingLists = {}
-- The currently selected shopping list
M.SelectedList = nil

-- Asserts whether a list is currently selected.
M.assert_list = function(name)
    return M.SelectedList ~= nil
end

-- Returns the currently selected shopping list.
M.get_shopping_list = function()
    if not M.assert_list() then
        return SL.Error "No list is currently selected."
    end
    return M.ShoppingLists[M.SelectedList]
end

-- Table of functions to run when the list is updated
M.OnListUpdated = {}

-- Runs all functions in OnListUpdated.
-- This function should be called once when the list is updated.
local on_list_updated = function()
    for _, f in pairs(M.OnListUpdated) do
        f()
    end
end

-- Makes a new entry for the specified item in the currently active shopping list.
M.create_entry = function(item_id, item_name, item_link, item_texture, required)
    if not M.assert_list() then
        return SL.Error "No list is currently selected."
    end
    M.get_shopping_list()[item_id] = {
        ID       = item_id,
        Name     = item_name,
        Link     = item_link,
        Texture  = item_texture,
        Required = required,
        Obtained = 0
    }
end

local replicate_string = function(str, n)
    local result = ""
    for i = 1, n do
        result = result .. str
    end
    return result
end

local get_keys = function(t)
    local keys = {}
    for k, _ in pairs(t) do
        keys[k] = 0
    end
    return keys
end

local create_item_data = function(item_id, enchant_id, gem_id1, gem_id2,
        gem_id3, gem_id4, suffix_id, unique_id, link_level, spec_id, upgrade_id,
        instance_difficulty_id, num_bonus_ids, bonus_id1, bonus_id2,
        upgrade_value, item_name)
    return {
        ItemID               = tonumber(item_id) or 0,
        EnchantID            = tonumber(enchant_id) or 0,
        GemID1               = tonumber(gem_id1) or 0,
        GemID2               = tonumber(gem_id2) or 0,
        GemID3               = tonumber(gem_id3) or 0,
        GemID4               = tonumber(gem_id4) or 0,
        SuffixID             = tonumber(suffix_id) or 0,
        UniqueID             = tonumber(unique_id) or 0,
        LinkLevel            = tonumber(link_level) or 0,
        SpecID               = tonumber(spec_id) or 0,
        UpgradeID            = tonumber(upgrade_id) or 0,
        InstanceDifficultyID = tonumber(instance_difficulty_id) or 0,
        NumBonusIDs          = tonumber(num_bonus_ids) or 0,
        BonusID1             = tonumber(bonus_id1) or 0,
        BonusID2             = tonumber(bonus_id2) or 0,
        UpgradeValue         = tonumber(upgrade_value) or 0,
        Name                 = item_name
    }
end

local disect_item_link = function(item_link)
    local _, _, color, ltype, id, enchant, gem1, gem2, gem3, gem4,
        suffix, unique, link_lvl, name = item_link:find "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?"
    return create_item_data(
        id,
        enchant,
        gem1, gem2, gem3, gem4,
        suffix,
        unique,
        link_lvl,
        nil, nil, nil, nil, nil, nil, nil,
        name
    )
end

local reset_list = function()
    if not M.assert_list() then
        return SL.Error "No list is currently selected."
    end
    for item_id, item in pairs(M.get_shopping_list()) do
        item.Obtained = 0
    end
end

M.update_list = function(updated)
    if not M.assert_list() then
        return SL.Error "No list is currently selected."
    end
    local item_counts = get_keys(M.get_shopping_list())
    for bag_id = 0, 4 do
        local slot_count = GetContainerNumSlots(bag_id)
        if slot_count then
            for slot_id = 1, slot_count do
                local texture, item_count, _, _, _, _, item_link =
                    GetContainerItemInfo(bag_id, slot_id)
                if texture then
                    local item = disect_item_link(item_link)
                    if item_counts[item.ItemID] then
                        item_counts[item.ItemID] = item_counts[item.ItemID] +
                            item_count
                    end
                end
            end
        end
    end
    updated = updated or false
    for item_id, item in pairs(M.get_shopping_list()) do
        if item.Obtained ~= item_counts[item_id] then
            updated = true
            M.get_shopping_list()[item.ID].Obtained = item_counts[item_id]
            M.show_item(item)
        end
    end
    if updated then
        on_list_updated()
    end
end

M.add_entry = function(input)
    if not M.assert_list() then
        return SL.Error "No list is currently selected."
    end
    if not input then
        return SL.Error "You must specify a number followed by the item name."
    end
    local space_index = input:find(" ")
    if not space_index then
        return SL.Error "You must specify a number followed by the item name."
    end
    local required = tonumber(input:sub(1, space_index - 1))
    if not required then
        return SL.Error "You must specify the number of the item you need."
    end
    local item         = input:sub(space_index + 1)
    local item_info    = { GetItemInfo(item) }
    local item_name    = item_info[1]
    local item_link    = item_info[2]
    local item_texture = item_info[10]
    local item_id      = nil
    if not item_link then
        item = SL.Data.Get(item)
        if not item then
            return SL.Error "Can't find the specified item."
        end
        item_id      = item.ID
        item_name    = item.Name
        item_link    = item.Link
        item_texture = item.Texture
    else
        item_id      = disect_item_link(item_link).ItemID
    end
    if item_id == 0 then
        return SL.Error "Could not get the item ID of the specified item."
    end
    M.create_entry(item_id, item_name, item_link, item_texture, required)
    SL.Print("Added %dx%s to your shopping list.", required, item_link)
    M.update_list(true)
end

M.track_entry = function(input)
    if not M.assert_list() then
        return SL.Error "No list is currently selected."
    end
    if not input then
        return SL.Error "You must specify the item name."
    end
    local item_info    = { GetItemInfo(input) }
    local item_name    = item_info[1]
    local item_link    = item_info[2]
    local item_texture = item_info[10]
    local item_id      = nil
    if not item_link then
        local item   = SL.Data.Get(input)
        item_id      = item.ID
        item_name    = item.Name
        item_link    = item.Link
        item_texture = item.Texture
    else
        item_id = disect_item_link(item_link).ItemID
    end
    if item_id == 0 then
        return SL.Error "Could not get the item ID of the specified item."
    end
    M.create_entry(item_id, item_name, item_link, item_texture, nil)
    SL.Print("Tracking %s in your shopping list.", item_link)
    M.update_list(true)
end

M.show_item = function(item)
    if item.Required then
        local got_em = item.Obtained >= item.Required  
        SL.Print("%s%s: %d/%d", item.Link, got_em and "|cFF11FF33" or "",
            item.Obtained, item.Required)
    else
        SL.Print("%s|cFFFFFFFF: %d", item.Link, item.Obtained)
    end
end

M.show_list = function()
    if not M.assert_list() then
        return SL.Error "No list is currently selected."
    end
    SL.Print("Currently selected list: \"%s\".", M.SelectedList)
    local empty = true
    for item_id, item in pairs(M.get_shopping_list()) do
        empty = false
        M.show_item(item)
    end
    if empty then
        SL.Print "Your shopping list is empty."
    end
end

M.clear_list = function()
    if not M.assert_list() then
        return SL.Error "No list is currently selected."
    end
    M.ShoppingLists[M.SelectedList] = {}
    on_list_updated()
    SL.Print "Shopping list cleared."
end

M.remove_entry = function(item_name)
    if not M.assert_list() then
        return SL.Error "No list is currently selected."
    end
    for item_id, item in pairs(M.get_shopping_list()) do
        if item.Name == item_name then
            local item_link = item.Link
            M.get_shopping_list()[item_id] = nil
            on_list_updated()
            SL.Print("%s has been removed from your shopping list.", item_link)
            return true
        end
    end
    SL.Error("\"%s\" doesn't appear on your shopping list.", item_name)
    return false
end

M.select_list = function(name)
    if not M.ShoppingLists[name] then
        return SL.Error "You don't have a shopping list with that name."
    end
    M.SelectedList = name
    M.update_list(true)
end

M.new_list = function(name)
    if M.ShoppingLists[name] then
        SL.Error "A shopping list with that name already exists."
        return false
    end
    M.ShoppingLists[name] = {}
    M.select_list(name)
    SL.Print("Created a new shopping list named \"%s\".", name)
    return true
end

M.show_current_list = function()
    if not M.assert_list() then
        return SL.Print "No list is currently selected."
    end
    SL.Print("Currently selected list: \"%s\".", M.SelectedList)
end

M.show_lists = function()
    local empty = true
    for name, list in pairs(M.ShoppingLists) do
        if empty then
            empty = false
            SL.Print "Your shopping lists:"
        end
        SL.Print(name)
    end
    if empty then
        SL.Print "You have no shopping lists."
    end
end

M.delete_list = function(name)
    if M.SelectedList == name then
        M.SelectedList = nil
    end
    if M.ShoppingLists[name] then
        M.ShoppingLists[name] = nil
        SL.Print("Removed the shopping list \"%s\".", name)
    else
        SL.Error "You don't have a shopping list with that name."
    end
end

M.import_list = function(name)
    local list = SL.Data.Import(name)
    if not list then
        return SL.Error "No list with that name exists in the database."
    end
    if not M.new_list(name) then return end
    M.ShoppingLists[name] = list
    SL.Print("Imported list \"%s\" from the database.", name)
    M.update_list(true)
end

SL.Command.MainCommand = M.show_list

SL.Command.add_cmd("import", M.import_list, [[
/sl import
> "/sl import <list name>" imports a list from the database.
]], true)

SL.Command.add_cmd("add", M.add_entry, [[
/sl add
> "/sl add <number> <item name>" adds the specified number of the specified item to your shopping list.
]], true)

SL.Command.add_cmd("track", M.track_entry, [[
/sl track
> "/sl track <item name>" adds the item to your shopping list without target number.
]], true)

SL.Command.add_cmd("show", M.show_list, [[
/sl show
> "/sl show" shows your shopping list in the chat window.
]])

SL.Command.add_cmd("clear", M.clear_list, [[
/sl clear
> "/sl clear" clears your shopping list.
]])

SL.Command.add_cmd("remove", M.remove_entry, [[
/sl remove
> "/sl remove <item name>" removes the specified item from your shopping list.
]], true)

SL.Command.add_cmd("new", M.new_list, [[
/sl new
> "/sl new <name>" makes a new shopping list with the specified name.
]], true)

SL.Command.add_cmd("select", M.select_list, [[
/sl select
> "/sl select <name>" makes the shopping list with the given name the active shopping list.
]], true)

SL.Command.add_cmd("current", M.show_current_list, [[
/sl current
> "/sl current" shows which shopping list is currently selected.
]])

SL.Command.add_cmd("lists", M.show_lists, [[
/sl lists
> "/sl lists" shows which shopping lists you have.
]])

SL.Command.add_cmd("delete", M.delete_list, [[
/sl delete
> "/sl delete <name>" deletes the shopping list with the specified name.
]], true)

SL.Shopping = M
