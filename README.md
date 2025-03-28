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
3. Enjoy.

## Internationalization
1. The default language of uosc menu is *Simplified Chinese*, you can change it to *English*. Feel free to modify anything after `#!` per line to your language.
```
[mpv.conf] line 5
input-conf = "~~/input-zh.conf"
input-conf = "~~/input-en.conf"
```

## [Credit](https://github.com/ajtn123/mpv-config/blob/main/Credits.txt)