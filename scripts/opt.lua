local mp = require 'mp'
local options = {
    string_output = false,
    include_script = true
}
require "mp.options".read_options(options, "opt")

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
        end
    elseif type(value) == "nil" then
        value = "null"
    end
    mp.msg.info(name .. ': ' .. value)
end

function ShowTable(arg, propTable, layer)
    mp.msg.info(('│'):rep(layer) .. '[' .. arg .. ']')
    for index, value in pairs(propTable) do
        if type(value) == "table" then
            ShowTable(index, value, layer + 1)
        else
            Info(('│'):rep(layer + 1) .. index, value)
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
        local property_value = nil
        local option_values = nil
        if options.string_output then
            property_value = mp.get_property(arg)
        else
            property_value = mp.get_property_native(arg)
        end
        if options.include_script then
            option_values = mp.get_opt(arg)
        end
        local msgs = 0
        if property_value ~= nil then
            ShowMsg(arg, property_value)
            msgs = msgs + 1
        end
        if option_values ~= nil then
            ShowMsg("Script." .. arg, option_values)
            msgs = msgs + 1
        end
        if msgs == 0 then
            ShowMsg(arg, nil)
        end
    end
end

mp.register_script_message('opt', function(...) GetOpts(...) end)
