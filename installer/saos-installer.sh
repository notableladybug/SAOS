#!/usr/bin/env bash
# SAOS // AGENT REGISTRATION INSTALLER
# Minimal TUI installer for Secret Agent Operating System
# Use if Calamares is unavailable

set -e

# Color definitions (matching SAOS theme)
BLACK='\033[0;30m'
GREEN='\033[0;32m'
BRIGHT_GREEN='\033[1;32m'
DIM_GREEN='\033[2;32m'
RED='\033[0;31m'
AMBER='\033[0;33m'
NC='\033[0m' # No Color

# Helper functions
print_header() {
    clear
    echo -e "${BRIGHT_GREEN}"
    echo "  ███████╗ █████╗  ██████╗ ███████╗"
    echo "  ██╔════╝██╔══██╗██╔═══██╗██╔════╝"
    echo "  ███████╗███████║██║   ██║███████║"
    echo "  ╚════██║██╔══██║██║   ██║╚════██║"
    echo "  ███████║██║  ██║╚██████╔╝███████║"
    echo "  ╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝"
    echo -e "${GREEN}"
    echo "  SECRET AGENT OPERATING SYSTEM"
    echo "  AGENT REGISTRATION SYSTEM v1.0"
    echo -e "${DIM_GREEN}"
    echo "  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "${NC}"
}

print_section() {
    echo ""
    echo -e "${GREEN}[ $1 ]${NC}"
    echo -e "${DIM_GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

print_status() {
    echo -e "${BRIGHT_GREEN}●${NC} $1"
}

print_warning() {
    echo -e "${AMBER}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

# Validate username
validate_username() {
    local username="$1"
    # Format: agent + letter (a-z) or agent + 1-4 digits
    if [[ $username =~ ^agent[a-z]$|^agent[0-9]{1,4}$ ]]; then
        return 0
    else
        return 1
    fi
}

# Validate password strength
validate_password() {
    local password="$1"
    # Require: at least 8 chars, 1 uppercase, 1 lowercase, 1 digit
    if [[ ${#password} -lt 8 ]]; then
        echo "Password must be at least 8 characters"
        return 1
    fi
    if [[ ! $password =~ [A-Z] ]]; then
        echo "Password must contain uppercase letter"
        return 1
    fi
    if [[ ! $password =~ [a-z] ]]; then
        echo "Password must contain lowercase letter"
        return 1
    fi
    if [[ ! $password =~ [0-9] ]]; then
        echo "Password must contain digit"
        return 1
    fi
    return 0
}

# Main installer flow
main() {
    print_header
    print_section "AGENT REGISTRATION"
    echo ""
    
    # Check if running as root
    if [ "$EUID" -ne 0 ]; then
        print_error "Registration requires administrator privileges"
        echo "Run: sudo $0"
        exit 1
    fi
    
    # Get username
    while true; do
        read -p "$(echo -e ${GREEN})AGENT IDENTIFIER${NC} (agent[a-z] or agent[0-9]): " username
        
        if validate_username "$username"; then
            print_success "Agent identifier accepted: $username"
            break
        else
            print_warning "Invalid format. Use 'agentm' or 'agent007'"
        fi
    done
    
    # Get display name
    while true; do
        read -p "$(echo -e ${GREEN})DISPLAY NAME${NC} (Agent X. or Agent NNN): " displayname
        if [[ ! -z "$displayname" ]]; then
            print_success "Display name set: $displayname"
            break
        fi
    done
    
    # Get password
    echo ""
    while true; do
        read -sp "$(echo -e ${GREEN})AUTHORIZATION CODE${NC} (password): " password
        echo ""
        
        error_msg=$(validate_password "$password")
        if [ $? -eq 0 ]; then
            read -sp "$(echo -e ${GREEN})CONFIRM CODE${NC}: " password2
            echo ""
            
            if [ "$password" = "$password2" ]; then
                print_success "Authorization code confirmed"
                break
            else
                print_warning "Codes do not match. Retry."
            fi
        else
            print_warning "$error_msg"
        fi
    done
    
    # Disk selection
    print_section "DISK SELECTION"
    echo "Available disks:"
    lsblk -d -n -o NAME,SIZE,TYPE | grep disk
    echo ""
    read -p "$(echo -e ${GREEN})Target disk${NC} (e.g., sda): " disk
    
    if [ ! -b "/dev/$disk" ]; then
        print_error "Disk /dev/$disk not found"
        exit 1
    fi
    
    print_warning "ALL DATA ON /dev/$disk WILL BE ERASED"
    read -p "Continue? (type 'yes' to confirm): " confirm
    if [ "$confirm" != "yes" ]; then
        print_error "Installation cancelled"
        exit 0
    fi
    
    # Summary
    print_section "MISSION PARAMETERS"
    print_status "Agent Identifier: $username"
    print_status "Display Name: $displayname"
    print_status "Target Disk: /dev/$disk"
    echo ""
    read -p "Proceed with installation? (yes/no): " proceed
    
    if [ "$proceed" = "yes" ]; then
        print_success "AGENT REGISTERED. SYSTEM READY."
        # Actual installation steps would go here
        # This is a template — actual partitioning, formatting, etc. omitted
    else
        print_error "Installation aborted"
        exit 0
    fi
}

main "$@"
