#!/bin/bash
# 70-firewall.sh

module_firewall() {
    if systemctl is-active ufw &>/dev/null; then
        local status=$(ufw status | grep "Status:" | awk '{print $2}')
        echo "󰒃 UFW: ${status}"
    elif systemctl is-active firewalld &>/dev/null; then
        echo "󰒃 firewalld: active"
    elif systemctl is-active iptables &>/dev/null; then
        echo "󰒃 iptables: active"
    fi
}

# Execute if run directly
module_firewall
