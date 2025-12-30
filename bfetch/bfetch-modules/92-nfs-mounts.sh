#!/bin/bash
# 92-nfs-mounts.sh

module_nfs() {
    local nfs=$(mount | grep -c "type nfs")
    [ "$nfs" -gt 0 ] && echo "󰋊 ${nfs} NFS"
}

# Execute if run directly
module_nfs
