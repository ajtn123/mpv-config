local options = {
    target_speed = 2.5,
}

local mp = require 'mp'
require 'mp.options'.read_options(options)

local normal_speed = 1.0
local is_accelerating = false

local function enable()
    normal_speed = mp.get_property_number('speed', 1)

    is_accelerating = true
    mp.set_property_number('speed', options.target_speed)
end

local function disable()
    mp.set_property_number('speed', normal_speed)
    is_accelerating = false
end

local function hold_handler(ev)
    if not ev then
        return
    elseif ev.event == 'down' and not is_accelerating then
        enable()
    elseif ev.event == 'up' and is_accelerating then
        disable()
    end
end

mp.add_key_binding(nil, 'accelerate', hold_handler, {complex = true})
