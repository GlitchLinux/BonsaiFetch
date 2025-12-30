#!/bin/bash
# 47-zombie-processes.sh

module_zombies() {
    local zombies=$(ps aux | awk '$8=="Z" {count++} END {print count+0}')
    [ "$zombies" -gt 0 ] && echo "󰊠 ${zombies} zombie(s)"
}

# Execute if run directly
module_zombies
