#!/bin/bash
# 81-all-temps.sh

module_all_temps() {
    if command -v sensors &>/dev/null; then
        sensors 2>/dev/null | grep "°C" | while read line; do
            echo "󰔏 ${line}"
        done
    fi
}

# Execute if run directly
module_all_temps
