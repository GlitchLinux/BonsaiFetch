#!/bin/bash
# 50-boottype.sh

module_boottype() {
    if [ -d /sys/firmware/efi ]; then
        echo "UEFI"
    else
        echo "BIOS"
    fi
}

# Execute if run directly
module_boottype
