local mp = require 'mp'

function TableLeng(t)
    local leng = 0
    for k, v in pairs(t) do
        leng = leng + 1
    end
    return leng;
end

function Info(name, value)
    if type(value) == "boolean" then
        if value then
            value = "true"
        elseif not value then
            value = "false"
        else
            value = nil
        end
    elseif type(value) == "nil" then
        value = "null"
    end
    mp.msg.info(name .. ': ' .. value)
end

function ShowTable(arg, table, layer)
    mp.msg.info(arg)
    local pos = 0
    for index, value in pairs(table) do
        pos = pos + 1

        if type(value) == "table" then
            ShowTable(index, value, layer + 1)
        end
        if pos == TableLeng(table) then
            Info((' │'):rep(layer) .. ' └' .. index, value)
        else
            Info((' │'):rep(layer) .. ' ├' .. index, value)
        end
    end
end

function ShowMsg(arg, property_value)
    if type(property_value) == "table" then
        ShowTable(arg, property_value, 0)
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
