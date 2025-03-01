# A Minimalist MPV Configuration

## Usage

0. Download and install MPV from [here](https://github.com/shinchiro/mpv-winbuild-cmake/releases), or from [other sources](https://mpv.io/installation/).
1. Download [zip](https://github.com/ajtn123/mpv-config/archive/refs/heads/main.zip) or clone this repo.
2. **Move** and **rename** the folder to one of MPV default config file locations:

   On Windows: `C:\users\<username>\AppData\Roaming\mpv\mpv.conf` or `.\<MPV dir>\portable_config\mpv.conf`

   For other OS, [see](https://mpv.io/manual/master/#files).

4. Enjoy. Read [MPV Manual](https://mpv.io/manual/master/) for more information.

## Internationalization

The default language of uosc menu is Simplified Chinese. You can change it to English by doing following modification.

`/mpv.conf` `line-5`: `input-conf = "~~/input-zh.conf"` => `input-conf = "~~/input-en.conf"`

Other places should be set automaticly, consistent with system language setting.

## [Credit](https://github.com/ajtn123/mpv-config/blob/main/Credits.txt)

[mpv](https://mpv.io/)

[uosc](https://github.com/tomasklaen/uosc)

[MPV-Play-BiliBili-Comments](https://github.com/itKelis/MPV-Play-BiliBili-Comments)

[thumbfast](https://github.com/po5/thumbfast)

[mpv-scripts](https://github.com/CogentRedTester/mpv-scripts)

[mpv-image-viewer](https://github.com/occivink/mpv-image-viewer)

[danmaku2ass](https://github.com/m13253/danmaku2ass)

[Anime4K](https://github.com/bloc97/Anime4K)

[KrigBilateral.glsl](https://github.com/awused/dotfiles/blob/master/mpv/.config/mpv/shaders/KrigBilateral.glsl)

[MPV_lazy](https://github.com/hooke007/MPV_lazy)
