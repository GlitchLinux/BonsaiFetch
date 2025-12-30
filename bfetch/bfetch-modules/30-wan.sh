#!/bin/bash
# 30-wan.sh

module_wan() {
    local wan=$(curl -s --max-time 2 ifconfig.me 2>/dev/null || echo "N/A")
    echo "  ${wan}"
}

# Execute if run directly
module_wan
