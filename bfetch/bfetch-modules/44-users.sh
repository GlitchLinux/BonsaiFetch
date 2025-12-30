#!/bin/bash
# 44-users.sh

module_users() {
    local users=$(who | wc -l)
    echo "󰀄 ${users} user(s)"
}

# Execute if run directly
module_users
