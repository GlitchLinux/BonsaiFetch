#!/bin/bash
# 20-memory.sh

module_memory() {
    local total=$(awk '/MemTotal/ {printf "%.1f", $2/1024/1024}' /proc/meminfo)
    local avail=$(awk '/MemAvailable/ {printf "%.1f", $2/1024/1024}' /proc/meminfo)
    local used=$(awk -v t="$total" -v a="$avail" 'BEGIN {printf "%.1f", t-a}')
    echo "  ${used}G/${total}G"
}

# Execute if run directly
module_memory
