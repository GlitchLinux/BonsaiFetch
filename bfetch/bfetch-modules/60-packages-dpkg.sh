#!/bin/bash
# 60-packages-dpkg.sh

module_packages_dpkg() {
    if command -v dpkg &>/dev/null; then
        local count=$(dpkg -l | grep "^ii" | wc -l)
        echo "󰏖  ${count} [dpkg]"
    fi
}

# Execute if run directly
module_packages_dpkg
