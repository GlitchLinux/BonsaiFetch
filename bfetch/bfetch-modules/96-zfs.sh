#!/bin/bash
# 96-zfs.sh

module_zfs() {
    if command -v zpool &>/dev/null; then
        local pools=$(zpool list -H 2>/dev/null | wc -l)
        [ "$pools" -gt 0 ] && echo "󰋊 ${pools} ZFS pools"
    fi
}

# Execute if run directly
module_zfs
