-- https://github.com/itKelis/MPV-Play-BiliBili-Comments

local mp = require 'mp'
local msg = require 'mp.msg'
local options = require 'mp.options'
local utils = require 'mp.utils'

local o = {
    -- 是否自动显示弹幕。
    autoplay = true,
    -- 最小弹幕数量。
    mincount = 1,
    -- 弹幕字体。
    fontname = 'sans-serif',
    -- 弹幕字体大小。
    fontsize = 50,
    -- 弹幕不透明度 (0-1)。
    opacity = 0.95,
    -- 滚动弹幕显示的持续时间 (秒)。
    duration_marquee = 10,
    -- 静止弹幕显示的持续时间 (秒)。
    duration_still = 5,
    -- 底部留白比例 (0-1)。
    percent = 0.75,
    -- 弹幕屏蔽关键词文件，支持绝对路径和相对路径。
    filter_file = '',
    -- 为低帧率视频添加 fps 滤镜，让滚动弹幕更流畅。
    fps_vf = 30,
    -- 是否在 OSD 显示日志。
    log_osd = false,
    -- 为 false 时使用 Danmu2Ass.exe。
    use_python = true,
    -- Python 可执行文件的名称或路径。
    python_path = 'python',
    -- 指定 CID。
    cid = '',
}

options.read_options(o)

local script_directory = mp.get_script_directory()
local danmaku_file
local danmaku_open = false
local secondary_sub_visibility = mp.get_property_native('secondary-sub-visibility')
local secondary_sub_ass_override = mp.get_property_native('secondary-sub-ass-override')
local FPS_FILTER_LABEL = '@Danmaku-FPS'

local function get_cid()
    for _, track in ipairs(mp.get_property_native('track-list', {})) do
        if track.type == 'sub' and track.lang == 'danmaku' then
            local filename = track['external-filename']
            local cid = filename and filename:match('[/\\](%d+)%.xml$')
            if cid then
                return cid, track.id
            end
        end
    end
end

local function get_sub_id(path)
    path = path:gsub('\\', '/')
    for _, track in ipairs(mp.get_property_native('track-list', {})) do
        local filename = track['external-filename']
        if track.type == 'sub' and filename and filename:gsub('\\', '/') == path then
            return track.id
        end
    end
end

local function file_exists(path)
    local info = path and utils.file_info(path)
    return info and info.is_file or false
end

local function vf_exists(label)
    for _, filter in ipairs(mp.get_property_native('vf', {})) do
        if filter.label == label:sub(2) then
            return true
        end
    end
    return false
end

local function log(message, duration, level)
    msg.log(level or 'info', message)
    if o.log_osd then
        mp.osd_message(message, duration or 2.5)
    end
end

local function remove_fps_filter()
    if vf_exists(FPS_FILTER_LABEL) then
        mp.commandv('vf', 'remove', FPS_FILTER_LABEL)
    end
end

local function add_fps_filter()
    if not vf_exists(FPS_FILTER_LABEL) then
        mp.commandv('vf', 'append', FPS_FILTER_LABEL .. ':lavfi="fps=fps=60:round=down"')
    end
end

local function update_fps_filter()
    if not danmaku_open or not o.fps_vf then
        return
    end

    local fps = mp.get_property_number('container-fps', 30)
    local speed = mp.get_property_number('speed', 1)
    if fps * speed < o.fps_vf then
        add_fps_filter()
    else
        remove_fps_filter()
    end
end

local function hide_danmaku()
    log('隐藏弹幕')
    danmaku_open = false
    mp.set_property_native('secondary-sub-visibility', false)
    remove_fps_filter()
end

local function show_danmaku()
    log('显示弹幕')
    danmaku_open = true
    mp.set_property_native('secondary-sub-visibility', true)
    update_fps_filter()
end

local function toggle_danmaku()
    if not danmaku_file then
        return
    end

    if danmaku_open then
        hide_danmaku()
    elseif mp.get_property_native('secondary-sid') then
        show_danmaku()
    end
end

local function load_danmaku(path)
    local info = utils.file_info(path)
    if not info or not info.is_file then
        return
    end

    mp.set_property_native('secondary-sub-visibility', false)
    mp.set_property_native('secondary-sub-ass-override', false)

    local success, error_message = mp.commandv('sub-add', path, 'auto')
    if not success then
        log('无法加载弹幕: ' .. tostring(error_message), nil, 'error')
        return
    end

    local subtitle_id = get_sub_id(path)
    if not subtitle_id then
        log('无法确定弹幕轨道 ID。', nil, 'error')
        return
    end

    danmaku_file = path
    mp.set_property_native('secondary-sid', subtitle_id)

    local approximate_count = math.floor((info.size - 850) / 120)
    log(string.format('%s [%d][%d]', path, info.size, approximate_count))
    if o.autoplay and approximate_count >= o.mincount then
        show_danmaku()
    end
end

local function process_danmaku(cid)
    if not cid or cid == '' then
        return
    end
    if not script_directory then
        log('请将脚本作为包含 main.lua 的目录加载。', nil, 'error')
        return
    end

    local directory = os.getenv('TEMP') or '/tmp'
    local width, height = 1920, 1080
    local video_width = mp.get_property_number('width', 16)
    local video_height = mp.get_property_number('height', 9)
    local aspect = video_height > 0 and video_width / video_height or 16 / 9
    if aspect > width / height then
        height = math.floor(width / aspect)
    elseif aspect > 0 and aspect < width / height then
        width = math.floor(height * aspect)
    end

    local args
    if o.use_python then
        args = {o.python_path, utils.join_path(script_directory, 'Danmu2Ass.py')}
    else
        args = {utils.join_path(script_directory, 'Danmu2Ass.exe')}
    end
    local converter_args = {
        '-d', directory,
        '-s', string.format('%dx%d', width, height),
        '-fn', o.fontname,
        '-fs', tostring(o.fontsize),
        '-a', tostring(o.opacity),
        '-dm', tostring(o.duration_marquee),
        '-ds', tostring(o.duration_still),
        '-flf', mp.command_native({'expand-path', o.filter_file}),
        '-p', tostring(math.floor(o.percent * height)),
        '-r', cid,
    }
    for _, arg in ipairs(converter_args) do
        args[#args + 1] = arg
    end

    mp.command_native_async({
        name = 'subprocess',
        playback_only = false,
        capture_stdout = true,
        capture_stderr = true,
        args = args,
    }, function(success, result, error_message)
        if success and result and result.status == 0 then
            load_danmaku(utils.join_path(directory, 'bilibili.ass'))
            return
        end

        local details = error_message or (result and result.stderr)
        if not details or details == '' then
            details = result and ('exit code ' .. tostring(result.status)) or 'unknown error'
        end
        log('处理错误: ' .. details, nil, 'error')
    end)
end

local function check_danmaku()
    local cid = o.cid ~= '' and o.cid or mp.get_opt('cid')
    if cid == '' then
        cid = nil
    end

    if not cid then
        local path = mp.get_property('path')
        if path and not path:find('^%a[%w+.-]*://')
            and not path:find('bilibili.com', 1, true)
            and not path:find('bilivideo.com', 1, true)
        then
            return
        end

        local danmaku_id
        cid, danmaku_id = get_cid()
        if cid and danmaku_id then
            mp.commandv('sub-remove', danmaku_id)
        end
    end

    -- Leave ordinary subtitles selected when no danmaku CID is available.
    if not cid then
        return
    end
    mp.set_property_native('sid', false)
    process_danmaku(cid)
end

local function remove_danmaku()
    if not danmaku_file then
        return
    end

    log('文件结束')
    if file_exists(danmaku_file) then
        os.remove(danmaku_file)
    end
    danmaku_file = nil
    danmaku_open = false
    mp.set_property_native('secondary-sub-visibility', secondary_sub_visibility)
    mp.set_property_native('secondary-sub-ass-override', secondary_sub_ass_override)
    remove_fps_filter()
end

mp.register_event('file-loaded', check_danmaku)
mp.register_event('end-file', remove_danmaku)
mp.observe_property('speed', 'number', update_fps_filter)

mp.register_script_message('load-danmaku', process_danmaku)
mp.add_key_binding(nil, 'toggle', toggle_danmaku)
