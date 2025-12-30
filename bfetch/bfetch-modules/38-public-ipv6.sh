#!/bin/bash
# 38-public-ipv6.sh

module_wanv6() {
    local wan6=$(curl -6 -s --max-time 2 ifconfig.me 2>/dev/null || echo "N/A")
    [ "$wan6" != "N/A" ] && echo "󰩠 ${wan6}"
}

# Execute if run directly
module_wanv6
