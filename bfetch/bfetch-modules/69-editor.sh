#!/bin/bash
# 69-editor.sh

module_editor() {
    local editor=${EDITOR:-${VISUAL:-vi}}
    echo " ${editor}"
}

# Execute if run directly
module_editor
