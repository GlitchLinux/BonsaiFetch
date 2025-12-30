#!/bin/bash
# 21-swap.sh

module_swap() {
    local total=$(awk '/SwapTotal/ {printf "%.1f", $2/1024/1024}' /proc/meminfo)
    if [ "${total%.*}" -gt 0 ]; then
        local used=$(awk '/SwapTotal/ {t=$2} /SwapFree/ {printf "%.1f", (t-$2)/1024/1024}' /proc/meminfo)
        echo "󰓡 Swap: ${used}G/${total}G"
    fi
}

# Execute if run directly
module_swap
