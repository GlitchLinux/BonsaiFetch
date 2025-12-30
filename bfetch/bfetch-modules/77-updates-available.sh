#!/bin/bash
# 77-updates-available.sh

module_updates() {
    if command -v apt &>/dev/null; then
        local updates=$(apt list --upgradable 2>/dev/null | grep -c "upgradable")
        [ "$updates" -gt 0 ] && echo "󰇚 ${updates} updates"
    fi
}

# Execute if run directly
module_updates
