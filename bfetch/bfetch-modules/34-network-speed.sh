#!/bin/bash
# 34-network-speed.sh

module_netspeed() {
    local iface=$(ip route | grep default | awk '{print $5}' | head -1)
    if [ -n "$iface" ]; then
        local speed=$(cat /sys/class/net/${iface}/speed 2>/dev/null)
        [ -n "$speed" ] && [ "$speed" != "-1" ] && echo "󰓅 ${speed}Mb/s"
    fi
}

# Execute if run directly
module_netspeed
