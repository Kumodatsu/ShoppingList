local addon_name, SL = ...
local M = {}

SLASH_SHOPPING_LIST1 = "/sl"
SLASH_SHOPPING_LIST2 = "/shoppinglist"

SL.Commands = { }

-- msg: str -> bool, str, table
M.parse_cmd = function(msg)
    local tokens = {}
    for token in msg:gmatch("[^%s]+") do
        table.insert(tokens, token)
    end
    if #tokens == 0 then
        return false
    end
    local cmd  = tokens[1]
    local args = { unpack(tokens, 2, #tokens) }
    return true, cmd, args
end

-- cmd: str, args: table
M.execute_cmd = function(name, args)
    local entry = SL.Commands[name]
    if entry ~= nil then
        if entry.Packed then
            if #args ~= 0 then
                local str = args[1]
                for i = 2, #args do
                    str = str .. " " .. args[i]
                end
                entry.Cmd(str)
            else
                entry.Cmd ""    
            end
        else
            entry.Cmd(unpack(args))
        end
    else
        SL.Error("Unknown command: %s", name)
    end
end

M.add_cmd = function(name, f, description, packed)
    if SL.Commands[name] ~= nil then
        SL.Error("Duplicate command name: %s", name)
    else
        if packed == nil then
            packed = false
        end
        SL.Commands[name] = {
            Cmd         = f,
            Description = description,
            Packed      = packed
        }
    end
end

SlashCmdList["SHOPPING_LIST"] = function(msg)
    local success, name, args = M.parse_cmd(msg)
    if success then
        M.execute_cmd(name, args)
    else
        SL.Error("Failed to parse command: %s", msg)
    end
end

local list_help = function(name)
    if name ~= nil then
        local entry = SL.Commands[name]
        if entry ~= nil then
            SL.Print(entry.Description)
        else
            SL.Error("Unknown command: %s", name)
        end
    else
        SL.Print("Available commands:")
        for k, v in pairs(SL.Commands) do
            SL.Print("/sl %s", k)
        end
        SL.Print("Use \"/sl help <command>\" to show an explanation of the specified command.")
    end
end

M.add_cmd("help", list_help, [[
"/sl help" shows the list of commands.
"/sl help <command>" shows an explanation of the specified command.
]])

SL.Command = M
