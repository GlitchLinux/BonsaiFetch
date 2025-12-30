#!/bin/bash
# 91-mounts.sh

module_mounts() {
    local count=$(mount | grep -v "tmpfs\|devtmpfs\|sysfs" | wc -l)
    echo "󰉉 ${count} mounts"
}

# Execute if run directly
module_mounts
