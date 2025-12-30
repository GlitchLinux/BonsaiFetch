#!/bin/bash
# 94-lvm.sh

module_lvm() {
    if command -v lvs &>/dev/null; then
        local lvs=$(lvs --noheadings 2>/dev/null | wc -l)
        [ "$lvs" -gt 0 ] && echo "󰋊 ${lvs} LVs"
    fi
}

# Execute if run directly
module_lvm
