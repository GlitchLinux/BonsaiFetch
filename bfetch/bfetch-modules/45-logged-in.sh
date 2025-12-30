#!/bin/bash
# 45-logged-in.sh

module_logged_in() {
    local user=$(who | head -1 | awk '{print $1}')
    [ -n "$user" ] && echo "󰀄 ${user}"
}

# Execute if run directly
module_logged_in
