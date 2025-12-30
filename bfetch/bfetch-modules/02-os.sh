#!/bin/bash
# 02-os.sh

module_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo " $PRETTY_NAME"
    else
        echo " $(uname -s)"
    fi
}

# Execute if run directly
module_os
