#!/bin/bash
# 36-gateway.sh

module_gateway() {
    local gw=$(ip route | grep default | awk '{print $3}' | head -1)
    [ -n "$gw" ] && echo "󰑩 ${gw}"
}

# Execute if run directly
module_gateway
