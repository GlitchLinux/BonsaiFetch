#!/bin/bash
# 74-webserver.sh

module_webserver() {
    if systemctl is-active apache2 &>/dev/null; then
        echo "󰖟 Apache: active"
    elif systemctl is-active nginx &>/dev/null; then
        echo "󰖟 Nginx: active"
    fi
}

# Execute if run directly
module_webserver
