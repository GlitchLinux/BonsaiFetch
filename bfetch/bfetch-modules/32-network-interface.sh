#!/bin/bash
# 32-network-interface.sh

module_netif() {
    local iface=$(ip route | grep default | awk '{print $5}' | head -1)
    [ -n "$iface" ] && echo "󰈀 ${iface}"
}

# Execute if run directly
module_netif
