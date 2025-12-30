#!/bin/bash
# 51-init-system.sh

module_init() {
    if [ -d /run/systemd/system ]; then
        echo " systemd"
    elif [ -f /sbin/openrc ]; then
        echo " OpenRC"
    elif [ -f /sbin/init ]; then
        local init=$(readlink /sbin/init)
        echo " ${init##*/}"
    fi
}

# Execute if run directly
module_init
