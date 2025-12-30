#!/bin/bash
# 66-docker-images.sh

module_docker_images() {
    if command -v docker &>/dev/null && systemctl is-active docker &>/dev/null; then
        local count=$(docker images -q 2>/dev/null | wc -l)
        [ "$count" -gt 0 ] && echo " ${count} images"
    fi
}

# Execute if run directly
module_docker_images
