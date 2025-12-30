#!/bin/bash
# 95-raid.sh

module_raid() {
    if [ -f /proc/mdstat ]; then
        local arrays=$(grep "^md" /proc/mdstat | wc -l)
        [ "$arrays" -gt 0 ] && echo "󰋊 ${arrays} RAID"
    fi
}

# Execute if run directly
module_raid
