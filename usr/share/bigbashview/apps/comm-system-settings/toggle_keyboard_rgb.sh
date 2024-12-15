#!/usr/bin/env bash

if [[ $XDG_SESSION_TYPE == "x11" ]];then
    _scroll=$(xmodmap -pm)
    if ! grep -q "Scroll_Lock" <<< "$_scroll" ;then
        xmodmap -e "add mod3 = Scroll_Lock"

        _auto_start_file=~/.config/autostart/keyboard_rgb.desktop
        if [[ ! -f "$_auto_start_file" ]];then
            echo '[Desktop Entry]
Type=Application
Name=Enable Keyboard RGB
Icon=input-keyboard
Exec=xmodmap -e "add mod3 = Scroll_Lock"
X-GNOME-Autostart-enabled=true
NoDisplay=true
Hidden=true
' > "$_auto_start_file"
        fi
        ./check_log.sh update 2 1
    else
        xmodmap -e "remove mod3 = Scroll_Lock"
        rm ~/.config/autostart/keyboard_rgb.desktop
        ./check_log.sh update 2 0
    fi
    exit
else
    check_file(){
        [[ -f "$1" ]]
    }

    _path_symbols=~/.config/xkb/symbols
    _path_evdev=~/.config/xkb/rules

    if ! check_file "$_path_symbols/scroll";then
        check_path(){
            if [[ ! -d "$1" ]];then
                mkdir -p "$1"
            fi
        }

        check_path $_path_symbols
        check_path $_path_evdev

echo 'default partial modifier_keys
xkb_symbols "map_to_mod3" {
    modifier_map Mod3 { Scroll_Lock };
};
' > "$_path_symbols/scroll"

echo '! option = symbols
  myopts:map_sclk = +scroll(map_to_mod3)

! option = compat
  myopts:en_sclk_led = +ledscroll(scroll_lock)
' > "$_path_evdev/evdev"

        gsettings set org.gnome.desktop.input-sources xkb-options "['terminate:ctrl_alt_bksp', 'myopts:map_sclk', 'myopts:en_sclk_led']"
        ./check_log.sh update 2 1
    else
        rm "$_path_symbols/scroll" "$_path_evdev/evdev"
        gsettings set org.gnome.desktop.input-sources xkb-options "['terminate:ctrl_alt_bksp']"
        ./check_log.sh update 2 0
    fi
    exit
fi
