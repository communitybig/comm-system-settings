#!/usr/bin/env bash

# Detect DE
case $XDG_CURRENT_DESKTOP in
    "GNOME")
        # Verifica a posição atual dos botões no GNOME e alterna
        current_layout=$(gsettings get org.gnome.desktop.wm.preferences button-layout)
        if [[ "$current_layout" == "':minimize,maximize,close'" ]]; then
            # Botões estão à esquerda, então coloca à direita
            gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:'
            ./check_log.sh update 1 1
        else
            # Botões estão à direita, então coloca à esquerda
            gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close'
            ./check_log.sh update 1 0
        fi
        ;;
    "Cinnamon")
        # Verifica a posição atual dos botões no Cinnamon e alterna
        current_layout=$(gsettings get org.cinnamon.desktop.wm.preferences button-layout)
        if [[ "$current_layout" == "'menu:minimize,maximize,close'" ]]; then
            # Botões estão à esquerda, então coloca à direita
            gsettings set org.cinnamon.desktop.wm.preferences button-layout 'close,minimize,maximize:menu'
            ./check_log.sh update 1 1

        else
            # Botões estão à direita, então coloca à esquerda
            gsettings set org.cinnamon.desktop.wm.preferences button-layout 'menu:minimize,maximize,close'
            ./check_log.sh update 1 0
        fi
        ;;
    "XFCE")
        # Verifica a posição atual dos botões no XFCE e alterna
        current_layout=$(xfconf-query -c xfwm4 -p /general/button_layout)
        if [[ "$current_layout" == "|HMC" ]]; then
            # Botões estão à esquerda, então coloca à direita
            xfconf-query -c xfwm4 -p /general/button_layout -s 'CHM|'
            ./check_log.sh update 1 1
        else
            # Botões estão à direita, então coloca à esquerda
            xfconf-query -c xfwm4 -p /general/button_layout -s '|HMC'
            ./check_log.sh update 1 0
        fi
        ;;
    *)
        echo -n "Error: Unrecognized desktop environment!"
        exit 1
        ;;
esac
