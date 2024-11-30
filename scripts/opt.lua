local mp = require 'mp'

function TableLeng(t)
    local leng = 0
    for _, _ in pairs(t) do
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

function ShowTable(arg, propTable, layer)
    mp.msg.info(arg)
    local pos = 0
    for index, value in pairs(propTable) do
        pos = pos + 1
        if type(value) == "table" then
            ShowTable(index, value, layer + 1)
        end
        if pos == TableLeng(propTable) then
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

function GetOpts(...)
    local args = { ... }
    for _, arg in ipairs(args) do
        local property_value = mp.get_property_native(arg)
        local option_values = mp.get_opt(arg)
        if property_value == nil and option_values == nil then
            ShowMsg(arg, nil)
        elseif property_value == nil then
            ShowMsg(arg, option_values)
        elseif option_values == nil then
            ShowMsg(arg, property_value)
        else
            ShowMsg('P.' .. arg, property_value)
            ShowMsg('O.' .. arg, option_values)
        end
    end
end

mp.register_script_message('opt', function(...) GetOpts(...) end)
