#!/bin/bash
# 90-filesystem.sh

module_filesystem() {
    local fs=$(df -T / | tail -1 | awk '{print $2}')
    echo "󰋊 ${fs}"
}

# Execute if run directly
module_filesystem
