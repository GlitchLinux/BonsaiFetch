#!/bin/bash
# 11-cpu-cores.sh

module_cpu_cores() {
    local cores=$(nproc)
    local threads=$(grep -c processor /proc/cpuinfo)
    echo "󰻠 ${cores} cores / ${threads} threads"
}

# Execute if run directly
module_cpu_cores
