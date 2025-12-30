#!/bin/bash
# 25-ram-usage-percent.sh

module_ram_percent() {
    local percent=$(free | awk '/Mem:/ {printf "%.0f", $3/$2*100}')
    echo "󰓡 RAM: ${percent}%"
}

# Execute if run directly
module_ram_percent
