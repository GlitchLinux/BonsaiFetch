#!/bin/bash
# 37-dns.sh

module_dns() {
    if [ -f /etc/resolv.conf ]; then
        local dns=$(grep "^nameserver" /etc/resolv.conf | head -1 | awk '{print $2}')
        [ -n "$dns" ] && echo "󰇖 ${dns}"
    fi
}

# Execute if run directly
module_dns
