#!/bin/bash
# 61-packages-rpm.sh

module_packages_rpm() {
    if command -v rpm &>/dev/null; then
        local count=$(rpm -qa | wc -l)
        echo "󰏖 ${count} packages (rpm)"
    fi
}

# Execute if run directly
module_packages_rpm
