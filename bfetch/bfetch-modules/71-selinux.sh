#!/bin/bash
# 71-selinux.sh

module_selinux() {
    if command -v getenforce &>/dev/null; then
        local status=$(getenforce 2>/dev/null)
        [ -n "$status" ] && echo "󰒃 SELinux: ${status}"
    fi
}

# Execute if run directly
module_selinux
