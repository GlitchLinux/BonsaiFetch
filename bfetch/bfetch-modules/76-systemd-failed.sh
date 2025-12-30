#!/bin/bash
# 76-systemd-failed.sh

module_failed_services() {
    if command -v systemctl &>/dev/null; then
        local failed=$(systemctl --failed --no-pager --no-legend | wc -l)
        [ "$failed" -gt 0 ] && echo "󰀨 ${failed} failed"
    fi
}

# Execute if run directly
module_failed_services
