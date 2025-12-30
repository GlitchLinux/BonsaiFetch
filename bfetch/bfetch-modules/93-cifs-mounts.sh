#!/bin/bash
# 93-cifs-mounts.sh

module_cifs() {
    local cifs=$(mount | grep -c "type cifs")
    [ "$cifs" -gt 0 ] && echo "󰋊 ${cifs} CIFS"
}

# Execute if run directly
module_cifs
