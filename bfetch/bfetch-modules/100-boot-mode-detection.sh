
#!/bin/bash

# Advanced boot detection function with multiple failsafe methods
detect_boot_type() {
    local live_score=0
    local install_score=0
    
    # Method 1: Kernel command line analysis (most reliable)
    if grep -qE "boot=live|boot=casper|rd.live.image|live:" /proc/cmdline 2>/dev/null; then
        ((live_score += 4))
        
        # Specific live system type detection
        if grep -q "toram" /proc/cmdline 2>/dev/null; then
            echo "  Ram Boot"
            return
        elif grep -q "persistent" /proc/cmdline 2>/dev/null; then
            echo "  Persistent"
            return
        fi
    fi
    
    # Method 2: Live system directory structure
    local live_dirs=("/run/live" "/lib/live/mount" "/rofs" "/casper" "/run/live/medium")
    for dir in "${live_dirs[@]}"; do
        if [[ -d "$dir" ]]; then
            ((live_score += 2))
            break
        fi
    done
    
    # Method 3: SquashFS detection - ONLY count if mounted as root or root-related overlay
    # Ignore squashfs loop mounts (iPXE images, snaps, etc.)
    if mount | grep -q 'squashfs.* on / ' 2>/dev/null || \
       mount | grep -q 'squashfs.* on /run/live' 2>/dev/null || \
       mount | grep -q 'squashfs.* on /rofs' 2>/dev/null; then
        ((live_score += 3))
    fi
    
    # Method 4: Root filesystem type analysis
    local root_fs_type
    root_fs_type=$(findmnt -n -o FSTYPE / 2>/dev/null || echo "unknown")
    if [[ "$root_fs_type" =~ ^(overlay|overlayfs|aufs|tmpfs)$ ]]; then
        ((live_score += 3))
    elif [[ "$root_fs_type" =~ ^(ext[234]|xfs|btrfs|f2fs)$ ]]; then
        ((install_score += 4))
    fi
    
    # Method 5: Check for live media mount points
    if findmnt /run/live/medium >/dev/null 2>&1; then
        ((live_score += 2))
        
        # Check if media is read-only ISO
        if mount | grep -q "/run/live/medium.*ro.*iso9660" 2>/dev/null; then
            echo "  Iso Boot"
            return
        fi
    fi
    
    # Method 6: LUKS encryption detection
    if [[ -d /dev/mapper ]] && ls /dev/mapper/luks-* >/dev/null 2>&1; then
        if findmnt /union >/dev/null 2>&1 || [[ $live_score -gt 0 ]]; then
            echo "  Persistent Luks"
            return
        fi
    fi
    
    # Method 7: EFI detection for system type hints
    if [[ -d /sys/firmware/efi ]]; then
        local esp_size
        esp_size=$(lsblk -o SIZE,PARTTYPE 2>/dev/null | grep -i efi | head -1 | awk '{print $1}' | sed 's/[^0-9.]//g')
        if [[ -n "$esp_size" ]] && [[ "$esp_size" =~ ^[0-9]+$ ]]; then
            if (( esp_size < 500 )); then
                ((install_score += 2))
            fi
        fi
    fi
    
    # Method 8: tmpfs usage analysis
    local tmpfs_count
    tmpfs_count=$(mount | grep tmpfs | wc -l 2>/dev/null || echo "0")
    if [[ $tmpfs_count -gt 15 ]]; then
        ((live_score += 1))
    fi
    
    # Method 9: fstab analysis (persistent installs have real fstab entries)
    if [[ -f /etc/fstab ]]; then
        local fstab_real_mounts
        fstab_real_mounts=$(grep -cE '^UUID=|^/dev/' /etc/fstab 2>/dev/null; true)
        if [[ $fstab_real_mounts -ge 1 ]]; then
            ((install_score += 2))
        fi
    fi
    
    # Method 10: Check for live filesystem files
    local live_files=("/run/live/medium/live/filesystem.squashfs" "/casper/filesystem.squashfs" "/LiveOS/squashfs.img")
    for file in "${live_files[@]}"; do
        if [[ -f "$file" ]]; then
            ((live_score += 3))
            break
        fi
    done
    
    # Final determination - persistent install score takes priority when root is a real filesystem
    if [[ $install_score -ge 4 && $live_score -lt 6 ]]; then
        echo "  Persistent"
    elif [[ $live_score -ge 6 ]]; then
        if ! findmnt /run/live/medium >/dev/null 2>&1 && [[ $live_score -ge 8 ]]; then
            echo "󰓡  Ram Boot"
        else
            echo "  Live Boot"
        fi
    elif [[ $live_score -ge 3 ]]; then
        echo "  Live Boot"
    elif [[ $install_score -ge 2 ]]; then
        echo "  Persistent"
    else
        if [[ -f /etc/fstab ]] && grep -q "UUID=" /etc/fstab 2>/dev/null; then
            echo "  Persistent"
        else
            echo "  Live Boot"
        fi
    fi
}

# Call the function directly to output the result
detect_boot_type
