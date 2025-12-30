#!/bin/bash
# 97-encryption.sh

module_encryption() {
    if command -v cryptsetup &>/dev/null; then
        local luks=$(lsblk -o NAME,FSTYPE | grep -c "crypto_LUKS")
        [ "$luks" -gt 0 ] && echo "󰌾 ${luks} LUKS"
    fi
}

# Execute if run directly
module_encryption
