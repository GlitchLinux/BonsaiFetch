#!/bin/bash
# 40-uptime.sh

module_uptime() {
    local uptime_sec=$(cat /proc/uptime | cut -d. -f1)
    local days=$((uptime_sec/86400))
    local hours=$(((uptime_sec%86400)/3600))
    local mins=$(((uptime_sec%3600)/60))
    
    if [ $days -gt 0 ]; then
        echo "  Uptime: ${days}d ${hours}h ${mins}m"
    elif [ $hours -gt 0 ]; then
        echo "  Uptime: ${hours}h ${mins}m"
    else
        echo "  Uptime: ${mins}m"
    fi
}

# Execute if run directly
module_uptime
