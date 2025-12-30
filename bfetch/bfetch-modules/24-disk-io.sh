#!/bin/bash
# 24-disk-io.sh

module_disk_io() {
    if [ -f /proc/diskstats ]; then
        local disk=$(df / | tail -1 | awk '{print $1}' | sed 's/[0-9]*$//' | xargs basename)
        local read=$(awk -v d="$disk" '$3==d {printf "%.1fG", $6/2097152}' /proc/diskstats)
        local write=$(awk -v d="$disk" '$3==d {printf "%.1fG", $10/2097152}' /proc/diskstats)
        echo "󰋊 R:${read} W:${write}"
    fi
}

# Execute if run directly
module_disk_io
