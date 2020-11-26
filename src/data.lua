local addon_name, SL = ...

SL.Data.Get = function(item_desc)
    local item_data = SL.Data.Items
    -- If the provided argument is an ID
    local id = tonumber(item_desc)
    if id then
        return item_data[id]
    end
    -- If the provided argument is a name or link
    for k, v in pairs(item_data) do
        if v.Name:lower() == item_desc:lower() or v.Link == item_desc then
            return v
        end
    end
    return nil
end

SL.Data.Import = function(name)
    local data = SL.Data.Lists[name]
    if not data then return nil end
    local list = {}
    for _, v in ipairs(data) do
        local item = SL.Data.Get(v[2])
        if not item then return nil end
        list[item.ID] = {
            ID       = item.ID,
            Name     = item.Name,
            Link     = item.Link,
            Texture  = item.Texture,
            Required = v[1],
            Obtained = 0
        }
    end
    return list
end
