#!/bin/bash
# 64-snap.sh

module_snap() {
    if command -v snap &>/dev/null; then
        local count=$(snap list 2>/dev/null | tail -n +2 | wc -l)
        [ "$count" -gt 0 ] && echo "󰏖 ${count} snaps"
    fi
}

# Execute if run directly
module_snap
