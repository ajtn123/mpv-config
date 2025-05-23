# A Minimalist MPV Configuration

## Installation
Prerequisites: MPV installed - Find mpv builds at [mpv.io/installation](https://mpv.io/installation/). For windows, [builds by shinchiro](https://github.com/shinchiro/mpv-winbuild-cmake/releases) is recommended.

1. Download and unzip [this repo](https://github.com/ajtn123/mpv-config/archive/refs/heads/main.zip).
2. Move and rename the `mpv-config` folder to one of the default config directories:
   - [Windows](https://mpv.io/manual/master/#files-on-windows):
     - `C:\users\<USERNAME>\AppData\Roaming\mpv\`
     - `<EXE directory>\portable_config\`
   - [Linux](https://mpv.io/manual/master/#files)
   - [MacOS](https://mpv.io/manual/master/#files-on-macos)
3. Enjoy.
 
Read [MPV Manual](https://mpv.io/manual/master) for more customizable options.

## Customization
### YT-DLP
If you are watching video on Youtube or other YT-DLP supported website with MPV, you should consider setting the following options. `~` represnts the current user's home directory.

1. MPV looks for YT-DLP in PATH and in [config directory](#installation). Set the path if you have it installed elsewhere.
2. Set cookies if you are watching Youtube or other websites that might require them. Comment the line which you are NOT using.
   - Chrome/Edge: extract cookies manually with [Get cookies.txt LOCALLY](https://chromewebstore.google.com/detail/get-cookiestxt-locally/cclelndahbckbenkjhflpdbgdldlbecc).
   - Firefox: use `cookies-from-browser=firefox`, which will automatically extract cookies from browser whenever needed.
3. Comment the line to connect directly without proxying.

Visit [YT-DLP website](https://github.com/yt-dlp/yt-dlp) for more information.
```
[script-opts.conf]
  line 23  (YT-DLP path):
    # script-opts-append = ytdl_hook-ytdl_path=~/tools/mpv/yt-dlp.exe
  line 22-23 (YT-DLP cookies):
    # ytdl-raw-options-append = cookies-from-browser=firefox
    ytdl-raw-options-append = cookies=~\Documents\ytdlcookies.txt
  line 24 (YT-DLP proxy):
    ytdl-raw-options-append = proxy=http://127.0.0.1:7897/
```

## Internationalization
1. The default language of uosc menu is *Simplified Chinese*, you can change it to *English*. Feel free to modify anything after `#!` each line to your language.
2. By default, uosc uses the first available subtitle language, if there is none, *English* is used. You can specify it manually. In this configuration, *Simplified Chinese* is used.
3. The default load order for subtitle is *(Simplified) Chinese* > *English* > *Japanese*, and for audio is *Japanese* > *Chinese* > *English*. These orders are specified using IETF language tags. Please refer to [Common IETF language tags](https://gist.github.com/traysr/2001377) and [MPV Manual](https://mpv.io/manual/master/#options).
4. The default font for subtitle and osd is [GenSenRounded2 JP R](https://github.com/ButTaiwan/gensen-font), for console is [Sarasa Mono SC](https://github.com/be5invis/Sarasa-Gothic), for Bilibili Danmuku is [GenSenRounded2 JP L](https://github.com/ButTaiwan/gensen-font). You can also choose any other font. Comment the line to use the system default if you do not care. These fonts are NOT included in the installation, you must install each of them on your system, or put the font files into the `fonts\` folder in order to use them. 

```
[mpv.conf]
  line 5 (uosc menu language):
    input-conf = "~~/input-sc.conf" (Simplified Chinese)
    input-conf = "~~/input-en.conf" (English)
  line 42 (osd font):
    osd-font = "GenSenRounded2 JP R"
  line 52 (audio language):
    alang = ja,zh-Hans,zh-CN,en
  line 71 (subtitle language):
    slang = zh-Hans,zh-CN,en,ja
  line 74 (subtitle font):
    sub-font = "GenSenRounded2 JP R"

[script-opts.conf]
  line 4 (console font):
    script-opts-append = console-monospace_font=Sarasa Mono SC
  line 9 (stats font):
    # script-opts-append = stats-font=GenSenRounded2 JP R
  line 37 (uosc language):
    # script-opts-append = uosc-languages=zh-hans
  line 57 (danmuku font):
    script-opts-append = bilibiliAssert-fontname=GenSenRounded2 JP L
```

## Uninstallation
Simply deleting the folder that was moved and renamed in [step 2](#installation) will remove this configuration of MPV entirely.

If you also want to uninstall MPV itself, follow the instruction from where you have downloaded it.

## Credit
[scripts\bilibiliAssert](https://github.com/itKelis/MPV-Play-BiliBili-Comments)

[scripts\uosc](https://github.com/tomasklaen/uosc)

[scripts\cycle-profile.lua](https://github.com/CogentRedTester/mpv-scripts/blob/master/cycle-profile.lua)

[scripts\detect-image.lua](https://github.com/occivink/mpv-image-viewer/blob/master/scripts/detect-image.lua)

[~~scripts\image-positioning.lua~~](https://github.com/occivink/mpv-image-viewer/blob/master/scripts/image-positioning.lua)

[scripts\sub-fonts-dir-auto.lua](https://github.com/fbriere/mpv-scripts/blob/master/doc/sub-fonts-dir-auto.md)

[scripts\thumbfast.lua](https://github.com/po5/thumbfast)

[shaders\Anime4K_*.glsl](https://github.com/bloc97/Anime4K)

[shaders\KrigBilateral.glsl](https://github.com/awused/dotfiles/blob/master/mpv/.config/mpv/shaders/KrigBilateral.glsl)

Inspired by [MPV-lazy](https://github.com/hooke007/MPV_lazy).

[MPV Official Website](https://mpv.io/) | [MPV Manual](https://mpv.io/manual/master) | [MPV Source Code](https://github.com/mpv-player/mpv)