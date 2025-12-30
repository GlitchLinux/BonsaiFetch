#!/bin/bash
# 67-shell.sh

module_shell() {
    echo " ${SHELL##*/}"
}

# Execute if run directly
module_shell
