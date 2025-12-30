#!/bin/bash
# 83-battery.sh

module_battery() {
    if [ -d /sys/class/power_supply/BAT0 ]; then
        local capacity=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null)
        local status=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null)
        [ -n "$capacity" ] && echo "󰁹 ${capacity}% (${status})"
    fi
}

# Execute if run directly
module_battery
