#!/usr/bin/env bash
# NixOS installation script
# Run from the NixOS live ISO
#
# Usage: curl -sL https://raw.githubusercontent.com/bew4lsh/nixos/main/install.sh | bash -s <hostname>
# Or:    ./install.sh <hostname>
#
# Hostnames: adrasteia, laptop, virtualbox, minipc

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Check arguments
HOSTNAME="${1:-}"
if [[ -z "$HOSTNAME" ]]; then
    echo "Usage: $0 <hostname>"
    echo ""
    echo "Available hosts:"
    echo "  adrasteia  - Desktop workstation (AMD)"
    echo "  laptop     - MacBook Pro 13\" 2020 (Intel T2)"
    echo "  virtualbox - VirtualBox VM"
    echo "  minipc     - Mini PC / home server"
    exit 1
fi

# Validate hostname
case "$HOSTNAME" in
    adrasteia|laptop|virtualbox|minipc) ;;
    *) error "Unknown hostname: $HOSTNAME" ;;
esac

info "Installing NixOS with hostname: $HOSTNAME"

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    error "This script must be run as root (use sudo)"
fi

# Check internet connectivity
info "Checking internet connection..."
if ! ping -c 1 github.com &>/dev/null; then
    error "No internet connection. Connect to network first."
fi

# Clone or update repo
REPO_DIR="/tmp/nixos"
REPO_URL="https://github.com/bew4lsh/nixos.git"

if [[ -d "$REPO_DIR" ]]; then
    info "Updating existing repo..."
    cd "$REPO_DIR"
    git pull
else
    info "Cloning nixos config..."
    nix-shell -p git --run "git clone $REPO_URL $REPO_DIR"
    cd "$REPO_DIR"
fi

# Show disk layout
info "Current disk layout:"
lsblk

echo ""
warn "Disko will ERASE the target disk!"

# Check if running interactively
if [[ -t 0 ]]; then
    read -p "Continue? (yes/no): " CONFIRM
    if [[ "$CONFIRM" != "yes" ]]; then
        error "Aborted by user"
    fi
else
    warn "Non-interactive mode - add --yes flag to confirm"
    if [[ "${2:-}" != "--yes" ]]; then
        error "Aborted. Run with: ./install.sh $HOSTNAME --yes"
    fi
fi

# Run disko
info "Running disko to partition disk..."
nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko --flake ".#$HOSTNAME"

# Install NixOS
info "Installing NixOS..."
nixos-install --flake ".#$HOSTNAME" --no-root-passwd

info "Installation complete!"
echo ""
echo "Next steps:"
echo "  1. Remove the ISO/USB"
echo "  2. Reboot"
echo "  3. Login as 'lia' (password: 'nixos' for virtualbox, or set during install)"
echo ""
