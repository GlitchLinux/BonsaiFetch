#!/bin/bash
# 14-bios.sh

module_bios() {
    if [ -r /sys/devices/virtual/dmi/id/bios_version ]; then
        local version=$(cat /sys/devices/virtual/dmi/id/bios_version 2>/dev/null)
        [ -n "$version" ] && echo "  BIOS ${version}"
    fi
}

# Execute if run directly
module_bios
