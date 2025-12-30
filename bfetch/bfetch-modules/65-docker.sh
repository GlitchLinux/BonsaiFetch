#!/bin/bash
# 65-docker.sh

module_docker() {
    if command -v docker &>/dev/null && systemctl is-active docker &>/dev/null; then
        local running=$(docker ps -q 2>/dev/null | wc -l)
        local total=$(docker ps -aq 2>/dev/null | wc -l)
        echo " ${running}/${total}"
    fi
}

# Execute if run directly
module_docker
