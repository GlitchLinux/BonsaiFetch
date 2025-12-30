#!/bin/bash
# 68-terminal.sh

module_terminal() {
    local term=${TERM:-unknown}
    echo " ${term}"
}

# Execute if run directly
module_terminal
