#!/bin/bash
# 05-distribution.sh

module_distribution() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo " $NAME $VERSION_ID"
    fi
}

# Execute if run directly
module_distribution
