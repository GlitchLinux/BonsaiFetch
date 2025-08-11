#!/bin/bash

# Font & Icon Diagnostic Script
# Identifies exactly what's missing for BonsaiFetch icon display

echo "╔════════════════════════════════════════════════════════════╗"
echo "║            🔍 Font & Icon Diagnostic Tool 🔍              ║"
echo "║          Identifies Missing Dependencies                  ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

print_check() {
    if [[ $1 -eq 0 ]]; then
        echo -e "${GREEN}✅ $2${NC}"
    else
        echo -e "${RED}❌ $2${NC}"
    fi
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_section() {
    echo ""
    echo -e "${CYAN}━━━ $1 ━━━${NC}"
}

# Check basic system info
print_section "SYSTEM INFORMATION"
echo "OS: $(cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | tr -d '"')"
echo "Terminal: $TERM"
echo "User: $(whoami)"
echo "Shell: $SHELL"

# Check font packages
print_section "FONT PACKAGE ANALYSIS"

# Check if fontconfig is installed
if command -v fc-list >/dev/null 2>&1; then
    print_check 0 "fontconfig (font management) - INSTALLED"
else
    print_check 1 "fontconfig (font management) - MISSING"
    echo "  Install with: sudo apt install fontconfig"
fi

# Check for basic font packages
packages_to_check=(
    "fonts-powerline"
    "fonts-font-awesome" 
    "fonts-noto"
    "fonts-noto-color-emoji"
    "fonts-dejavu"
)

for package in "${packages_to_check[@]}"; do
    if dpkg -l | grep -q "^ii.*$package"; then
        print_check 0 "$package - INSTALLED"
    else
        print_check 1 "$package - MISSING"
    fi
done

# Check for Nerd Fonts
print_section "NERD FONT DETECTION"

nerd_fonts_found=0
if fc-list | grep -qi "nerd"; then
    print_check 0 "Nerd Fonts detected"
    nerd_fonts_found=1
    echo "Found Nerd Fonts:"
    fc-list | grep -i "nerd" | cut -d: -f2 | sort | uniq | head -5
else
    print_check 1 "Nerd Fonts - NOT DETECTED"
fi

# Check specific fonts BonsaiFetch needs
print_section "BONSAIFETCH FONT REQUIREMENTS"

required_fonts=(
    "Cascadia"
    "CaskaydiaCove"
    "JetBrains"
    "Fira.*Code"
    "Hack"
)

fonts_available=0
for font in "${required_fonts[@]}"; do
    if fc-list | grep -qi "$font"; then
        print_check 0 "$font family - AVAILABLE"
        ((fonts_available++))
    else
        print_check 1 "$font family - MISSING"
    fi
done

# Test specific icons that are missing in your output
print_section "BONSAIFETCH ICON TEST"

echo "Testing essential BonsaiFetch icons:"
echo ""

# Icons that should appear
echo "Required icons for BonsaiFetch:"
echo "󰇅  (hostname) - Expected: computer/user icon"
echo "󰅐  (uptime) - Expected: clock/time icon"  
echo "󰍛  (GPU) - Expected: graphics card icon"
echo "󰋊  (disk) - Expected: hard drive icon"
echo "󰩟  (network) - Expected: network/wifi icon"
echo "󰏖  (packages) - Expected: box/package icon"
echo "  (CPU) - Expected: processor icon"
echo "  (RAM) - Expected: memory icon"

echo ""
echo "If you see empty squares □ or missing characters, fonts need to be installed."

# Check Unicode support
print_section "UNICODE & ENCODING SUPPORT"

if locale | grep -q "UTF-8"; then
    print_check 0 "UTF-8 encoding support"
else
    print_check 1 "UTF-8 encoding support - CHECK LOCALE"
    echo "  Current locale: $(locale | grep LANG)"
fi

# Terminal capability check
if [[ -n "$TERM" ]]; then
    print_check 0 "Terminal environment detected: $TERM"
else
    print_check 1 "Terminal environment detection"
fi

# Summary and recommendations
print_section "DIAGNOSTIC SUMMARY"

missing_components=0

if ! command -v fc-list >/dev/null 2>&1; then
    ((missing_components++))
fi

if [[ $nerd_fonts_found -eq 0 ]]; then
    ((missing_components++))
fi

if [[ $fonts_available -eq 0 ]]; then
    ((missing_components++))
fi

echo ""
if [[ $missing_components -eq 0 ]]; then
    echo -e "${GREEN}🎉 All font dependencies appear to be installed!${NC}"
    echo ""
    echo "If icons still don't display:"
    echo "1. Restart your terminal"
    echo "2. Set terminal font to a Nerd Font"
    echo "3. Check terminal Unicode support"
else
    echo -e "${RED}❌ Missing $missing_components critical component(s)${NC}"
    echo ""
    echo -e "${YELLOW}🔧 RECOMMENDED FIXES:${NC}"
    echo ""
    
    if ! command -v fc-list >/dev/null 2>&1; then
        echo "1. Install font management:"
        echo "   sudo apt update && sudo apt install fontconfig"
        echo ""
    fi
    
    if [[ $nerd_fonts_found -eq 0 ]] || [[ $fonts_available -eq 0 ]]; then
        echo "2. Install Nerd Fonts (MAIN ISSUE):"
        echo "   sudo bash nerd_font_installer.sh"
        echo ""
        echo "   Or manual installation:"
        echo "   sudo apt install fonts-powerline fonts-font-awesome"
        echo "   # Then download and install Nerd Fonts manually"
        echo ""
    fi
    
    echo "3. Configure terminal font:"
    echo "   Set terminal font to 'CaskaydiaCove Nerd Font' or similar"
    echo ""
    
    echo "4. Restart terminal after installation"
fi

print_section "QUICK FIX COMMANDS"

echo "Run these commands to fix missing fonts:"
echo ""
echo -e "${CYAN}# Install basic font support:${NC}"
echo "sudo apt update"
echo "sudo apt install fontconfig fonts-powerline fonts-font-awesome fonts-noto-color-emoji"
echo ""
echo -e "${CYAN}# Install comprehensive Nerd Fonts:${NC}"
echo "sudo bash nerd_font_installer.sh"
echo ""
echo -e "${CYAN}# Test after installation:${NC}"
echo "test-nerd-fonts"
echo "bash bonsaifetch_icon_test.sh"

echo ""
print_info "💡 The main issue is likely missing Nerd Fonts installation"
print_info "🚀 Run the Nerd Font installer script to fix icon display"
echo ""