#!/bin/bash
# 72-fail2ban.sh

module_fail2ban() {
    if systemctl is-active fail2ban &>/dev/null; then
        local banned=$(fail2ban-client status 2>/dev/null | grep "Currently banned" | awk '{print $4}')
        echo "󰒃 fail2ban: ${banned:-0} banned"
    fi
}

# Execute if run directly
module_fail2ban
