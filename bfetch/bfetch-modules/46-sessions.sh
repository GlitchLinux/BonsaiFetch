#!/bin/bash
# 46-sessions.sh

module_sessions() {
    local sessions=$(who | wc -l)
    echo "󰍹 ${sessions} session(s)"
}

# Execute if run directly
module_sessions
