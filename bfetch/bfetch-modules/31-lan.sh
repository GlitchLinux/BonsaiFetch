#!/bin/bash
# 31-lan.sh

module_lan() {
    local lan=$(ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v "127.0.0.1" | head -1)
    echo "󰩟 ${lan:-N/A}"
}

# Execute if run directly
module_lan
