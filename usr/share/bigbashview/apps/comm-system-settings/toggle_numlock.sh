#!/usr/bin/env bash

# Detect DE
case $XDG_CURRENT_DESKTOP in
    "GNOME")
        # Verifica o estado atual do numlock no GNOME e alterna
        current_state=$(gsettings get org.gnome.desktop.peripherals.keyboard numlock-state)
        if [[ "$current_state" == "false" ]]; then
            # Estado desligado, então liga
            gsettings set org.gnome.desktop.peripherals.keyboard numlock-state "true"
            gsettings set org.gnome.desktop.peripherals.keyboard remember-numlock-state "true"
            ./check_log.sh update 3 1
        else
            # Estado ligado, então desliga
            gsettings set org.gnome.desktop.peripherals.keyboard numlock-state "false"
            gsettings set org.gnome.desktop.peripherals.keyboard remember-numlock-state "false"
            ./check_log.sh update 3 0
        fi
        ;;
    "Cinnamon")
        # Verifica o estado atual do numlock no Cinnamon e alterna
        current_state=$(gsettings get org.cinnamon.desktop.peripherals.keyboard numlock-state)
        if [[ "$current_state" == "false" ]]; then

            pkexec env DISPLAY="$DISPLAY" XAUTHORITY="$XAUTHORITY" "$(pwd)"/numlockx.sh "true"

            # Estado desligado, então liga
            gsettings set org.cinnamon.desktop.peripherals.keyboard numlock-state "true"
            gsettings set org.cinnamon.desktop.peripherals.keyboard remember-numlock-state "true"
            ./check_log.sh update 3 1

        else

            pkexec env DISPLAY="$DISPLAY" XAUTHORITY="$XAUTHORITY" "$(pwd)"/numlockx.sh "false"

            # Estado ligado, então desliga
            gsettings set org.cinnamon.desktop.peripherals.keyboard numlock-state "false"
            gsettings set org.cinnamon.desktop.peripherals.keyboard remember-numlock-state "false"
            ./check_log.sh update 3 0
        fi
        ;;
    "XFCE")
        # Verifica se o arquivo existe, senão cria
        if [[ ! -f ~/.config/xfce4/xfconf/xfce-perchannel-xml/keyboards.xml ]];then
            echo '<?xml version="1.0" encoding="UTF-8"?>

<channel name="keyboards" version="1.0">
  <property name="Default" type="empty">
    <property name="RestoreNumlock" type="bool" value="true"/>
    <property name="Numlock" type="bool" value="true"/>
  </property>
</channel>' > ~/.config/xfce4/xfconf/xfce-perchannel-xml/keyboards.xml
        fi
        # Verifica o estado atual do numlock no XFCE e alterna
        current_state=$(xfconf-query -c keyboards -p /Default/Numlock)
        if [[ "$current_state" == "false" ]]; then

            #pkexec env DISPLAY="$DISPLAY" XAUTHORITY="$XAUTHORITY" "$(pwd)"/numlockx.sh "true"

            # Estado desligado, então liga
            xfconf-query -c keyboards -p /Default/Numlock -t bool -s "true"
            xfconf-query -c keyboards -p /Default/RestoreNumlock -t bool -s "true"
            ./check_log.sh update 3 1
        else

            #pkexec env DISPLAY="$DISPLAY" XAUTHORITY="$XAUTHORITY" "$(pwd)"/numlockx.sh "false"

            # Estado ligado, então desliga
            xfconf-query -c keyboards -p /Default/Numlock -t bool -s "false"
            xfconf-query -c keyboards -p /Default/RestoreNumlock -t bool -s "false"
            ./check_log.sh update 3 0
        fi
        ;;
    *)
        echo -n "Error: Unrecognized desktop environment!"
        exit 1
        ;;
esac
