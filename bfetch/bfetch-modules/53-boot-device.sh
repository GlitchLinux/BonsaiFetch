#!/bin/bash
# 53-boot-device.sh

module_bootdev() {
    local bootdev=$(df /boot | tail -1 | awk '{print $1}')
    [ -n "$bootdev" ] && echo "⚡ ${bootdev}"
}

# Execute if run directly
module_bootdev
