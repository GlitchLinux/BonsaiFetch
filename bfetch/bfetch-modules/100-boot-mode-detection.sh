#!/bin/bash

# Advanced boot detection function with multiple failsafe methods
detect_boot_type() {
    local live_score=0
    local install_score=0
    local detection_methods=()
    
    # Method 1: Kernel command line analysis (most reliable)
    if grep -qE "boot=live|boot=casper|rd.live.image|live:" /proc/cmdline 2>/dev/null; then
        ((live_score += 4))
        
        # Specific live system type detection
        if grep -q "toram" /proc/cmdline 2>/dev/null; then
            echo "   Ram Boot"
            return
        elif grep -q "persistent" /proc/cmdline 2>/dev/null; then
            echo "   Persistent"
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
    
    # Method 3: SquashFS detection (primary live indicator)
    if mount | grep -q squashfs 2>/dev/null; then
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
            echo "Iso Boot"
            return
        fi
    fi
    
    # Method 6: LUKS encryption detection
    if [[ -d /dev/mapper ]] && ls /dev/mapper/luks-* >/dev/null 2>&1; then
        if findmnt /union >/dev/null 2>&1 || [[ $live_score -gt 0 ]]; then
            echo "   Persistent Luks"
            return
        fi
    fi
    
    # Method 7: EFI detection for system type hints
    if [[ -d /sys/firmware/efi ]]; then
        local esp_size
        esp_size=$(lsblk -o SIZE,PARTTYPE 2>/dev/null | grep -i efi | head -1 | awk '{print $1}' | sed 's/[^0-9.]//g')
        if [[ -n "$esp_size" ]] && command -v bc >/dev/null 2>&1; then
            if (( $(echo "$esp_size < 500" | bc -l 2>/dev/null || echo "0") )); then
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
    
    # Method 9: RAM vs filesystem size analysis
    local total_ram root_size
    total_ram=$(free -m 2>/dev/null | awk '/^Mem:/{print $2}' || echo "0")
    root_size=$(df -m / 2>/dev/null | awk 'NR==2{print $3}' || echo "0")
    
    if [[ $root_size -gt 0 && $total_ram -gt 0 ]]; then
        local ratio=$((root_size * 100 / total_ram))
        if [[ $ratio -gt 40 ]]; then
            ((live_score += 2))
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
    
    # Final determination with confidence scoring
    if [[ $live_score -ge 6 ]]; then
        if ! findmnt /run/live/medium >/dev/null 2>&1 && [[ $live_score -ge 8 ]]; then
            echo " 󰓡 Ram Boot"
        else
            echo "   Live System"
        fi
    elif [[ $live_score -ge 3 ]]; then
        echo "   Live Boot"
    elif [[ $install_score -ge 4 ]]; then
        echo "   Persistent"
    else
        if [[ -f /etc/fstab ]] && grep -q "UUID=" /etc/fstab 2>/dev/null; then
            echo "   Persistent"
        else
            echo "   Live Boot"
        fi
    fi
}

# Call the function directly to output the result
detect_boot_type
