local addon_name, SL = ...

local colors = {
    Output = "FF2299FF",
    Error  = "FFFF2222"
}

local output = function(color, format, ...)
    SendSystemMessage(string.format("|c%s%s|r", color, format):format(...))
end

SL.Print = function(format, ...)
    output(colors.Output, format, ...)
end

SL.Error = function(format, ...)
    output(colors.Error, format, ...)
end
