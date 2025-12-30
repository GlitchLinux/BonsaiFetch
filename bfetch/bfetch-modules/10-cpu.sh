#!/bin/bash
# 10-cpu.sh

module_cpu() {
    local cpu_model=$(grep -m1 "model name" /proc/cpuinfo | cut -d: -f2 | xargs)
    echo "󰻠 ${cpu_model}"
}

# Execute if run directly
module_cpu
