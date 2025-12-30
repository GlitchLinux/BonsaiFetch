#!/bin/bash
# 73-ssh-status.sh

module_ssh() {
    if systemctl is-active ssh &>/dev/null || systemctl is-active sshd &>/dev/null; then
        local port=$(grep "^Port" /etc/ssh/sshd_config 2>/dev/null | awk '{print $2}')
        echo "󰣀 SSH:${port:-22}"
    fi
}

# Execute if run directly
module_ssh
