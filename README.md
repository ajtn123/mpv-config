# A Minimalist MPV Configuration

## Usage
0. Download and install MPV from [mpv.io/installation](https://mpv.io/installation/). For windows, [builds by shinchiro](https://github.com/shinchiro/mpv-winbuild-cmake/releases) is recommended.
1. Download and unzip [this repo](https://github.com/ajtn123/mpv-config/archive/refs/heads/main.zip).
2. Move and rename the `mpv-config` folder to one of the default config file locations:
   - [Windows](https://mpv.io/manual/master/#files-on-windows):
     - `C:\users\<USERNAME>\AppData\Roaming\mpv\`
     - `<EXE directory>\portable_config\`
   - [Linux](https://mpv.io/manual/master/#files)
   - [MacOS](https://mpv.io/manual/master/#files-on-macos)
3. Enjoy. See [MPV Manual](https://mpv.io/manual/master) for more customizable options.

## Internationalization
1. The default language of uosc menu is *Simplified Chinese*, you can change it to *English*. Feel free to modify anything after `#!` each line to your language.
2. The default load order for subtitle is *Simplified Chinese* > *Other Chinese* > *English* > *Japanese*, and for audio is *Japanese* > *Simplified Chinese* > *Other Chinese* > *English*. This list can be changed according to [MPV Manual](https://mpv.io/manual/master/#options).
```
[mpv.conf]
  line 5 (uosc menu):
    input-conf = "~~/input-zh.conf"
    input-conf = "~~/input-en.conf"
  line 52 (audio):
    alang = ja,zh-Hans,en
  line 71 (subtitle):
    slang = zh-Hans,en,ja
```

## [Credit](https://github.com/ajtn123/mpv-config/blob/main/Credits.txt)