#!/bin/bash
# 63-flatpak.sh

module_flatpak() {
    if command -v flatpak &>/dev/null; then
        local count=$(flatpak list --app 2>/dev/null | wc -l)
        [ "$count" -gt 0 ] && echo "󰏖 ${count} flatpaks"
    fi
}

# Execute if run directly
module_flatpak
