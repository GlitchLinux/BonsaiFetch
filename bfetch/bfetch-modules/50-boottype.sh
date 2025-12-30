#!/bin/bash
# 50-boottype.sh

module_boottype() {
    if [ -d /sys/firmware/efi ]; then
        echo "  UEFI Boot"
    else
        echo "  BIOS Boot"
    fi
}

# Execute if run directly
module_boottype
