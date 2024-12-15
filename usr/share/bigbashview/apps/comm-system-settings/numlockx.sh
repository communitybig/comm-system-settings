#!/usr/bin/env bash

check_numlockx(){
    if ! type -P numlockx;then
        pamac-installer numlockx
    fi
}

_path_lightdm=/etc/lightdm/lightdm.conf

if [[ "$1" == "true" ]];then
    check_numlockx
    sed -i 's|.*greeter-setup-script=.*|greeter-setup-script=/usr/bin/numlockx on|' $_path_lightdm
    /usr/bin/numlockx on
else
    check_numlockx
    sed -i 's|.*greeter-setup-script=.*|greeter-setup-script=/usr/bin/numlockx off|' $_path_lightdm
    /usr/bin/numlockx off
fi

exit
