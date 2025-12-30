#!/bin/bash
# 82-fan-speed.sh

module_fans() {
    if command -v sensors &>/dev/null; then
        local fans=$(sensors 2>/dev/null | grep -i "fan" | head -1 | awk '{print $2, $3}')
        [ -n "$fans" ] && echo "󰈐 ${fans}"
    fi
}

# Execute if run directly
module_fans
