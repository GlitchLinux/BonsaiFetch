#!/bin/bash
# 52-kernel-params.sh

module_kernelparams() {
    local params=$(cat /proc/cmdline | wc -w)
    echo " ${params} params"
}

# Execute if run directly
module_kernelparams
