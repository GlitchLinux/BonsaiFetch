#!/bin/bash
# 22-disk.sh

module_disk() {
    local disk_info=$(df -h / | awk 'NR==2 {print $3"/"$2" ("$5")"}')
    echo "󰉉 ${disk_info}"
}

# Execute if run directly
module_disk
