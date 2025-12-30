#!/bin/bash
# 42-load-average.sh

module_load() {
    local load=$(cat /proc/loadavg | awk '{print $1, $2, $3}')
    echo "󰓅 ${load}"
}

# Execute if run directly
module_load
