#!/bin/bash
# 13-motherboard.sh

module_motherboard() {
    if [ -r /sys/devices/virtual/dmi/id/board_vendor ]; then
        local vendor=$(cat /sys/devices/virtual/dmi/id/board_vendor 2>/dev/null)
        local model=$(cat /sys/devices/virtual/dmi/id/board_name 2>/dev/null)
        [ -n "$vendor" ] && echo " ${vendor} ${model}"
    fi
}

# Execute if run directly
module_motherboard
