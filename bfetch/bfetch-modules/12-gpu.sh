#!/bin/bash
# 12-gpu.sh

module_gpu() {
    if command -v lspci &>/dev/null; then
        local gpu=$(lspci | grep -i "vga\|3d\|display" | cut -d: -f3 | xargs | head -1)
        [ -n "$gpu" ] && echo "󰍹 ${gpu}"
    fi
}

# Execute if run directly
module_gpu
