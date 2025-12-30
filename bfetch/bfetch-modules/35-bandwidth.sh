#!/bin/bash
# 35-bandwidth.sh

module_bandwidth() {
    local iface=$(ip route | grep default | awk '{print $5}' | head -1)
    if [ -n "$iface" ]; then
        local rx=$(cat /sys/class/net/${iface}/statistics/rx_bytes)
        local tx=$(cat /sys/class/net/${iface}/statistics/tx_bytes)
        local rx_gb=$(awk -v r="$rx" 'BEGIN {printf "%.2f", r/1073741824}')
        local tx_gb=$(awk -v t="$tx" 'BEGIN {printf "%.2f", t/1073741824}')
        echo "󰓅 ↓${rx_gb}G ↑${tx_gb}G"
    fi
}

# Execute if run directly
module_bandwidth
