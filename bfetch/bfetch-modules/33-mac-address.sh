#!/bin/bash
# 33-mac-address.sh

module_mac() {
    local iface=$(ip route | grep default | awk '{print $5}' | head -1)
    if [ -n "$iface" ]; then
        local mac=$(cat /sys/class/net/${iface}/address 2>/dev/null)
        [ -n "$mac" ] && echo "󰈀 ${mac}"
    fi
}

# Execute if run directly
module_mac
