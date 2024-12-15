#!/usr/bin/env bash


if [[ "$(systemctl is-enabled plymouth-show-log-comm.service)" == "enable" ]];then
    systemctl disable --now plymouth-show-log-comm.service
    ./check_log.sh update 5 1
else
    systemctl enable --now plymouth-show-log-comm.service
    ./check_log.sh update 5 0
fi
