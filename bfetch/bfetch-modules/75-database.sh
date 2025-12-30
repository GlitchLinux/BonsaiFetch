#!/bin/bash
# 75-database.sh

module_database() {
    if systemctl is-active mysql &>/dev/null; then
        echo "󰆼 MySQL: active"
    elif systemctl is-active postgresql &>/dev/null; then
        echo "󰆼 PostgreSQL: active"
    fi
}

# Execute if run directly
module_database
