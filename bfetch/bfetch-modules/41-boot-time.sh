#!/bin/bash
# 41-boot-time.sh

module_boottime() {
    if command -v who &>/dev/null; then
        local boot=$(who -b | awk '{print $3, $4}')
        echo " ${boot}"
    fi
}

# Execute if run directly
module_boottime
