#!/bin/bash
# 80-cpu-temp.sh

module_cpu_temp() {
    if [ -f /sys/class/thermal/thermal_zone0/temp ]; then
        local temp=$(cat /sys/class/thermal/thermal_zone0/temp)
        local celsius=$((temp/1000))
        echo "°󰔏 CPU:${celsius}°C"
    elif command -v sensors &>/dev/null; then
        local temp=$(sensors | grep -i "core 0" | awk '{print $3}' | tr -d '+°C' | cut -d. -f1)
        [ -n "$temp" ] && echo "  ${temp}°C"
    fi
}

# Execute if run directly
module_cpu_temp
