local mp = require 'mp'
function Info(name, value)
    mp.msg.info(name .. ': ' .. value)
end

function ShowMsg(arg, property_value)
    if type(property_value) == "table" then
        Info(arg, '')
        for index, value in pairs(property_value) do
            Info(index, value)
        end
        return
    end
    Info(arg, property_value)
end

function ShowOpts(...)
    local args = { ... }
    for _, arg in ipairs(args) do
        local property_value = mp.get_property_native(arg)
        if property_value then ShowMsg(arg, property_value) end
    end
end

mp.register_script_message('opt', function(...) ShowOpts(...) end)
