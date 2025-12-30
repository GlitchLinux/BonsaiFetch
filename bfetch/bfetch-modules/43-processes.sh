#!/bin/bash
# 43-processes.sh

module_processes() {
    local total=$(ps aux | wc -l)
    local running=$(ps aux | awk '$8=="R" || $8=="R+" {count++} END {print count+0}')
    echo "󰐗 ${running}/${total}"
}

# Execute if run directly
module_processes
