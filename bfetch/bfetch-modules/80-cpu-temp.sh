#!/bin/bash
# 80-cpu-temp.sh

module_cpu_temp() {
    if [ -r /sys/class/thermal/thermal_zone0/temp ]; then
        local temp
        temp=$(< /sys/class/thermal/thermal_zone0/temp)
        echo "󰔏° CPU:$((temp / 1000))°C"
        return
    fi

    if command -v sensors &>/dev/null; then
        local temp
        temp=$(sensors 2>/dev/null | awk '/Core 0/ {gsub(/[+°C]/,"",$3); print int($3)}')
        [ -n "$temp" ] && echo "󰔏° ${temp}°C"
    fi
}

module_cpu_temp
