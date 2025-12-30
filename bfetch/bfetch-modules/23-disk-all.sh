#!/bin/bash
# 23-disk-all.sh

module_disk_all() {
    df -h --output=target,used,size,pcent | grep -v "tmpfs\|devfs\|loop" | tail -n +2 | while read mount used size pcent; do
        echo "󰉉 ${mount}: ${used}/${size} (${pcent})"
    done
}

# Execute if run directly
module_disk_all
