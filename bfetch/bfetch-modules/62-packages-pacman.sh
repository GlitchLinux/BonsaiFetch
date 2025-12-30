#!/bin/bash
# 62-packages-pacman.sh

module_packages_pacman() {
    if command -v pacman &>/dev/null; then
        local count=$(pacman -Q | wc -l)
        echo "󰏖 ${count} packages (pacman)"
    fi
}

# Execute if run directly
module_packages_pacman
