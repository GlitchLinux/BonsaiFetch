#!/bin/bash

# Bonsai Linux Fetch Tool Installer - New Cyberpunk UI
# Creates modern cyberpunk-style fetch tool with dynamic boot detection
# MOTD disabled by default - use 'bonsaifetch' command
# Author: GlitchLinux

set -e  # Exit on any error

# Colors for script output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Configuration variables
MOTD_DIR="/etc/update-motd.d"
BACKUP_DIR="/etc/motd-backup-$(date +%Y%m%d-%H%M%S)"

# Function to print colored output
print_banner() {
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║      Bonsai Linux Cyberpunk Fetch Tool Installer       ║"
    echo "║                    by GlitchLinux                        ║"
    echo "║        New Cyberpunk UI + Dynamic Boot Detection        ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_status() { echo -e "${GREEN}[✓]${NC} $1"; }
print_info() { echo -e "${BLUE}[i]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[!]${NC} $1"; }
print_error() { echo -e "${RED}[✗]${NC} $1"; }
print_step() { echo -e "${MAGENTA}[STEP]${NC} $1"; }

# Check if running as root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        print_error "This script must be run as root (use sudo)"
        echo "Usage: sudo $0"
        exit 1
    fi
}

# Install update-motd package
install_update_motd() {
    print_step "Installing update-motd package..."
    
    local original_dir=$(pwd)
    cd /tmp
    
    print_info "Downloading update-motd package..."
    if wget -q http://archive.ubuntu.com/ubuntu/pool/main/u/update-motd/update-motd_3.10_all.deb; then
        print_status "Downloaded update-motd package"
        
        print_info "Installing update-motd package..."
        dpkg --force-all -i update-motd_3.10_all.deb || {
            print_warning "First installation had dependency issues, fixing..."
        }
        
        print_info "Fixing dependencies..."
        apt-get update -qq && apt-get install -f -y
        
        print_info "Final installation attempt..."
        dpkg --force-all -i update-motd_3.10_all.deb
        
        rm -f update-motd_3.10_all.deb
        print_status "update-motd installation completed"
    else
        print_warning "Failed to download, trying apt-get..."
        apt-get update -qq
        apt-get install -y update-motd || {
            print_warning "Could not install update-motd"
        }
    fi
    
    cd "$original_dir"
}

# Clean existing MOTD scripts
clean_existing_motd() {
    print_step "Cleaning existing MOTD scripts..."
    
    # Create backup directory
    mkdir -p "$BACKUP_DIR"
    
    # Backup existing MOTD directory
    if [[ -d "$MOTD_DIR" ]]; then
        cp -r "$MOTD_DIR" "$BACKUP_DIR/"
        print_status "Backed up existing MOTD to $BACKUP_DIR"
        
        # Remove all existing scripts
        rm -f "$MOTD_DIR"/*
        print_status "Removed all existing MOTD scripts"
    fi
    
    # Ensure MOTD directory exists
    mkdir -p "$MOTD_DIR"
}

# Create the standalone bonsaifetch command with new cyberpunk UI
create_bonsaifetch() {
    print_step "Creating standalone bonsaifetch command with cyberpunk UI..."
    
    cat > "/usr/local/bin/bonsaifetch" << 'EOF'
#!/bin/bash
# Bonsai Linux Fetch Tool - Cyberpunk UI with Dynamic Boot Detection
# Works independently of MOTD configuration

# Shared color setup function - handles tput errors gracefully
setup_colors() {
    if [[ -z "$TERM" ]]; then
        export TERM="linux"
    fi
    
    if [[ -t 1 ]] && [[ -n "$TERM" ]] && command -v tput >/dev/null 2>&1; then
        if c1=$(tput setaf 1 2>/dev/null); then
            c1=$(tput setaf 1)   # Red
            c2=$(tput setaf 2)   # Green  
            c3=$(tput setaf 3)   # Yellow
            c4=$(tput setaf 4)   # Blue
            c5=$(tput setaf 5)   # Magenta
            c6=$(tput setaf 6)   # Cyan
            c7=$(tput setaf 7)   # White
            bold=$(tput bold 2>/dev/null) || bold='\033[1m'
            reset=$(tput sgr0 2>/dev/null) || reset='\033[0m'
        else
            setup_ansi_colors
        fi
    else
        setup_ansi_colors
    fi
}

setup_ansi_colors() {
    c1='\033[0;31m'   # Red
    c2='\033[0;32m'   # Green
    c3='\033[0;33m'   # Yellow
    c4='\033[0;34m'   # Blue
    c5='\033[0;35m'   # Magenta
    c6='\033[0;36m'   # Cyan
    c7='\033[0;37m'   # White
    bold='\033[1m'
    reset='\033[0m'
}

# Initialize colors
setup_colors

# Function to detect boot type dynamically
detect_boot_type() {
    local boot_status
    
    # Check for live boot from squashfs
    if [[ -f /run/live/medium/live/filesystem.squashfs ]]; then
        # Check if booted to RAM (no source media)
        if ! findmnt /run/live/medium >/dev/null 2>&1; then
            boot_status="${c6} ¤ RAM BOOT ${bold}${c2}"
        # Check for LUKS encrypted live system
        elif [[ -d /dev/mapper ]] && ls /dev/mapper/luks-* >/dev/null 2>&1 && findmnt /union >/dev/null 2>&1; then
            boot_status="${c6} ¤ LIVE LUKS ${bold}${c2}"
        # Check for ISO/IMG read-only media
        elif mount | grep -q "ro.*iso9660\|ro.*vfat.*LIVE"; then
            boot_status="${c6} ¤ ISO BOOT ${bold}${c2}"
        # Regular live boot
        else
            boot_status="${c6} ¤ LIVE BOOT ${bold}${c2}"
        fi
    else
        # Normal installed system
        boot_status="${c6} ¤ FULL SYSTEM   ${bold}${c2}"
    fi
    
    echo "$boot_status"
}

# Function to get system information
get_system_info() {
    hostname_info=$(hostname 2>/dev/null || echo "Unknown")
    os_info="Bonsai GNU/Linux"
    kernel_info=$(uname -r 2>/dev/null || echo "Unknown")
    uptime_info=$(uptime -p 2>/dev/null | sed 's/up //' || echo "Unknown")
    
    # Get host/model info
    if [[ -f /sys/devices/virtual/dmi/id/product_name ]]; then
        host_info=$(cat /sys/devices/virtual/dmi/id/product_name 2>/dev/null || echo "Unknown")
        if [[ -f /sys/devices/virtual/dmi/id/product_version ]]; then
            host_version=$(cat /sys/devices/virtual/dmi/id/product_version 2>/dev/null || echo "")
            [[ "$host_version" != "Unknown" ]] && [[ -n "$host_version" ]] && host_info="$host_info $host_version"
        fi
    else
        host_info="Unknown"
    fi
    
    memory_info=$(free -h 2>/dev/null | awk '/^Mem:/ {print $3 "/" $2}' || echo "Unknown")
    disk_info=$(df -h / 2>/dev/null | awk 'NR==2 {print $3 "/" $2 " (" $5 " used)"}' || echo "Unknown")
    
    # Get IP addresses
    private_ip_adress=$(ip route get 1.1.1.1 2>/dev/null | awk '{print $7; exit}' || hostname -I 2>/dev/null | awk '{print $1}' || echo "Unavailable")
    public_ip=$(timeout 2 curl -s ifconfig.me 2>/dev/null || echo "Unavailable")
    
    # Get CPU info
    cpu_info=$(grep "model name" /proc/cpuinfo 2>/dev/null | head -1 | cut -d: -f2 | sed 's/^ *//' | sed 's/ CPU.*//' || echo "Unknown")
    
    # Get package count
    if command -v dpkg >/dev/null 2>&1; then
        packages=$(dpkg -l 2>/dev/null | grep -c "^ii" || echo "Unknown")
    else
        packages="Unknown"
    fi
}

# Typewriter effect function
typewriter() {
    local text="$1"
    local delay="${2:-0.10}"
    
    for (( i=0; i<${#text}; i++ )); do
        printf "%b" "${text:$i:1}"
        sleep "$delay"
    done
    printf "\n"
}

# Main fetch function
main() {
    # Get system information
    get_system_info
    
    # Get dynamic boot status
    local boot_status
    boot_status=$(detect_boot_type)
    
    # Create cyberpunk UI display (DO NOT MODIFY THE LAYOUT - VERY SENSITIVE)
    cat << DISPLAY

${c2}${bold}${c2}⊏══════╗${boot_status}
${c2}${bold}${c2}SYSTEM ╚════════════════╗${reset}
${c6}${c5}Linux: ${reset}$os_info${c2} ║${reset}
${c6}${c5}Kernel: ${reset}$kernel_info${c2} ╔╝${reset}
${c2}${bold}${c2}SESSION ⊏══════════════╝⊏═══════╗${reset}
${c2}${c5}CPU:${reset} $cpu_info${c2} ║${reset}
${c2}${c5}Disks: ${reset}$disk_info${c2}  ╔══╝${reset}
${c2}${c5}RAM: ${reset}$memory_info${c2}╔════════════╝${reset}
${c2}${bold}${c2}NETWORK ⊏═══════╝${reset}${c2}⊏══════╗${reset} 
${c2}${c5}WAN-IPv4: ${reset}$public_ip ${c2}║${reset}
${c2}${c5}LAN-IPv4: ${reset}$private_ip_adress ${c2}    ║${reset}
${reset}${c2}⊏═══════════════════════╝${reset}
DISPLAY
 
    # Add typewriter effects if requested
    if [[ "$1" == "--typewriter" ]] || [[ $- == *i* ]]; then
        typewriter "${c7}-> ${c7}WELCOME${bold}${c7} to Bonsai V4.0"
        typewriter "${c7}-> ${c6}apps${bold}${c7} start CLI Toolkit"
        typewriter "${c7}-> ${c6}startx${bold}${c7} JWM GUI Desktop"
        
        # Show SSH connection info if applicable
        if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]; then
            ssh_ip=$(echo "$SSH_CLIENT" | cut -d' ' -f1 2>/dev/null || echo "Unknown")
            echo ""
            typewriter "   ${c5}SSH connection from: $ssh_ip${reset}" 0.02
        fi
        echo ""
    fi
    
    # Reset colors
    printf "${reset}"
}

# Parse arguments
case "$1" in
    "--help"|"-h")
        echo "Bonsai Linux Fetch Tool - Cyberpunk Edition"
        echo "Usage: bonsaifetch [options]"
        echo ""
        echo "Options:"
        echo "  --typewriter    Include typewriter effects"
        echo "  --help, -h      Show this help message"
        echo ""
        echo "Examples:"
        echo "  bonsaifetch                # Cyberpunk system info"
        echo "  bonsaifetch --typewriter   # With typewriter effects"
        echo ""
        echo "Boot Detection:"
        echo "  • LIVE BOOT     - Standard live system"
        echo "  • RAM BOOT      - Live system copied to RAM"
        echo "  • LIVE LUKS     - Encrypted live system"
        echo "  • ISO LIVE BOOT - Booted from ISO/IMG"
        echo "  • PERSISTENCE   - Normal installed system"
        exit 0
        ;;
    *)
        main "$@"
        ;;
esac
EOF
    
    chmod +x "/usr/local/bin/bonsaifetch"
    print_status "Created cyberpunk bonsaifetch command: /usr/local/bin/bonsaifetch"
}

# Create the MOTD header script (DISABLED by default)
create_sidebyside_header() {
    print_step "Creating MOTD header script (disabled by default)..."
    
    cat > "$MOTD_DIR/01-bonsai-header" << 'EOF'
#!/bin/bash
# Bonsai Linux MOTD - Cyberpunk Header
# This script is disabled by default - use 'bonsaifetch' command instead

# Execute the standalone bonsaifetch command
if command -v bonsaifetch >/dev/null 2>&1; then
    bonsaifetch --typewriter
else
    echo "bonsaifetch command not found"
fi
EOF
    
    chmod -x "$MOTD_DIR/01-bonsai-header"  # DISABLED by default
    print_status "Created disabled header script: 01-bonsai-header (use 'sudo bonsai-motd enable' to activate)"
}

# Create disabled system info script
create_disabled_sysinfo() {
    print_step "Creating disabled system info script..."
    
    cat > "$MOTD_DIR/02-bonsai-sysinfo" << 'EOF'
#!/bin/bash
# Bonsai Linux MOTD - System Information (Disabled - integrated into bonsaifetch)
# This script is disabled because system info is now in the standalone bonsaifetch tool

exit 0
EOF
    
    chmod -x "$MOTD_DIR/02-bonsai-sysinfo"  # Make it non-executable
    print_status "Created disabled system info script: 02-bonsai-sysinfo"
}

# Create disabled typewriter script
create_disabled_typewriter() {
    print_step "Creating disabled typewriter script..."
    
    cat > "$MOTD_DIR/03-bonsai-typewriter" << 'EOF'
#!/bin/bash
# Bonsai Linux MOTD - Typewriter Effects (Disabled - integrated into bonsaifetch)
# This script is disabled because typewriter effects are now in the standalone bonsaifetch tool

exit 0
EOF
    
    chmod -x "$MOTD_DIR/03-bonsai-typewriter"  # Make it non-executable
    print_status "Created disabled typewriter script: 03-bonsai-typewriter"
}

# Create management tools
create_management_tools() {
    print_step "Creating management tools..."
    
    cat > "/usr/local/bin/bonsai-motd" << 'EOF'
#!/bin/bash
# Bonsai Linux MOTD Management Tool

MOTD_DIR="/etc/update-motd.d"

case "$1" in
    "test")
        echo "Testing Bonsai Linux Cyberpunk MOTD (same as 'bonsaifetch --typewriter')..."
        echo ""
        if command -v bonsaifetch >/dev/null 2>&1; then
            bonsaifetch --typewriter
        else
            echo "bonsaifetch command not found"
        fi
        ;;
    "enable")
        chmod +x "$MOTD_DIR/01-bonsai-header"
        echo "Bonsai Cyberpunk MOTD enabled - will show on login"
        echo "Note: This uses the standalone bonsaifetch command"
        ;;
    "disable")
        chmod -x "$MOTD_DIR"/??-bonsai-*
        echo "Bonsai MOTD disabled - use 'bonsaifetch' command manually"
        ;;
    "update")
        if command -v update-motd >/dev/null 2>&1; then
            update-motd
            echo "MOTD cache updated"
        else
            echo "update-motd command not available"
        fi
        ;;
    *)
        echo "Bonsai Linux Cyberpunk MOTD Management Tool"
        echo "Usage: $0 {command}"
        echo ""
        echo "Commands:"
        echo "  test     - Show MOTD preview (same as 'bonsaifetch --typewriter')"
        echo "  enable   - Enable MOTD on login"
        echo "  disable  - Disable MOTD on login"
        echo "  update   - Update MOTD cache"
        echo ""
        echo "Primary Usage:"
        echo "  bonsaifetch              - Show cyberpunk system info anytime"
        echo "  bonsaifetch --typewriter - Show with typewriter effects"
        echo ""
        echo "Boot Detection Features:"
        echo "  • Dynamic boot type detection (LIVE/RAM/LUKS/ISO/PERSISTENCE)"
        echo "  • Cyberpunk-style UI with box drawing characters"
        echo "  • Color-coded sections and information display"
        echo ""
        echo "Note: MOTD is disabled by default. Use 'bonsaifetch' command instead."
        exit 1
        ;;
esac
EOF

    chmod +x "/usr/local/bin/bonsai-motd"
    print_status "Created management tool: bonsai-motd"
}

# Test the bonsaifetch command
test_bonsaifetch() {
    print_step "Testing cyberpunk bonsaifetch command..."
    
    echo ""
    print_info "Cyberpunk Bonsaifetch Preview:"
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                        CYBERPUNK BONSAIFETCH PREVIEW                       ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════════════════════╝${NC}"
    
    # Test bonsaifetch
    if command -v bonsaifetch >/dev/null 2>&1; then
        bonsaifetch --typewriter 2>/dev/null || {
            print_warning "bonsaifetch test completed with warnings"
        }
    else
        print_error "bonsaifetch command not found"
    fi
    
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Main installation function
main() {
    print_banner
    
    check_root
    
    print_info "Starting Bonsai Linux Cyberpunk Fetch Tool installation..."
    print_info "This will create:"
    print_info "  • 'bonsaifetch' - Cyberpunk-style fetch command (primary tool)"
    print_info "  • Dynamic boot type detection (LIVE/RAM/LUKS/ISO/PERSISTENCE)"
    print_info "  • Modern UI with box drawing characters and color coding"
    print_info "  • MOTD components (DISABLED by default)"
    print_info "  • Management tools for optional MOTD activation"
    
    # Ask for confirmation
    read -p "Continue with installation? [Y/n]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        print_info "Installation cancelled"
        exit 0
    fi
    
    # Installation steps
    install_update_motd
    clean_existing_motd
    create_bonsaifetch
    create_sidebyside_header
    create_disabled_sysinfo
    create_disabled_typewriter
    create_management_tools
    test_bonsaifetch
    
    # Final information
    echo ""
    print_status "Bonsai Linux Cyberpunk Fetch Tool installation completed successfully!"
    echo ""
    print_info "🎯 Primary Tool Installed:"
    echo -e "  ${GREEN}• bonsaifetch${NC}               - Show cyberpunk system info anytime"
    echo -e "  ${GREEN}• bonsaifetch --typewriter${NC}  - Show with typewriter effects"
    echo ""
    print_info "📁 Files Created:"
    echo "  • Fetch Tool: /usr/local/bin/bonsaifetch"
    echo "  • MOTD Management: /usr/local/bin/bonsai-motd"
    echo "  • MOTD Scripts: $MOTD_DIR (DISABLED by default)"
    echo "  • Backup: $BACKUP_DIR"
    echo ""
    print_info "🔧 Usage Examples:"
    echo -e "  ${CYAN}bonsaifetch${NC}                    # Cyberpunk system info"
    echo -e "  ${CYAN}bonsaifetch --typewriter${NC}       # With animations"
    echo -e "  ${CYAN}sudo bonsai-motd enable${NC}        # Enable MOTD on login"
    echo -e "  ${CYAN}sudo bonsai-motd disable${NC}       # Disable MOTD"
    echo -e "  ${CYAN}echo 'bonsaifetch' >> ~/.bashrc${NC} # Add to bashrc"
    echo ""
    print_info "🎨 Cyberpunk Features:"
    echo "  • Dynamic boot detection (LIVE/RAM/LUKS/ISO/PERSISTENCE)"
    echo "  • Box drawing character UI with cyberpunk aesthetics"
    echo "  • Color-coded sections (SYSTEM/SESSION/NETWORK)"
    echo "  • Works independently of MOTD system"
    echo "  • No tput errors - robust color handling" 
    echo "  • Optional typewriter effects"
    echo "  • Can be added to bashrc, zshrc, etc."
    echo ""
    print_info "🚀 Boot Type Detection:"
    echo "  • LIVE BOOT     - Standard live system from media"
    echo "  • RAM BOOT      - Live system copied to RAM (no media)"
    echo "  • LIVE LUKS     - Encrypted live system with LUKS"
    echo "  • ISO LIVE BOOT - Booted from read-only ISO/IMG"
    echo "  • PERSISTENCE   - Normal installed system"
    echo ""
    print_warning "MOTD is DISABLED by default - use 'bonsaifetch' command instead!"
    print_info "Try it now: bonsaifetch --typewriter"
}

# Run the main function
main "$@"
