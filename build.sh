#!/usr/bin/env bash
# SAOS Build Script
# Run on an Arch Linux machine with archiso installed

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT_DIR="$SCRIPT_DIR/out"
WORK_DIR="$SCRIPT_DIR/work"
PROFILE_DIR="$SCRIPT_DIR"
RELENG="/usr/share/archiso/configs/releng"

echo ""
echo "  ███████╗ █████╗  ██████╗ ███████╗"
echo "  ██╔════╝██╔══██╗██╔═══██╗██╔════╝"
echo "  ███████╗███████║██║   ██║███████╗"
echo "  ╚════██║██╔══██║██║   ██║╚════██║"
echo "  ███████║██║  ██║╚██████╔╝███████║"
echo "  ╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝"
echo ""
echo "  SECRET AGENT OPERATING SYSTEM"
echo "  Build System v1.0"
echo ""
echo "  INITIATING BUILD SEQUENCE..."
echo ""

# Check we're running as root
if [ "$EUID" -ne 0 ]; then
    echo "  [ERROR] Build requires root. Run: sudo ./build.sh"
    exit 1
fi

# Check archiso is installed
if ! command -v mkarchiso &> /dev/null; then
    echo "  [ERROR] archiso not found. Install with: sudo pacman -S archiso"
    exit 1
fi

# Clean previous build
if [ -d "$WORK_DIR" ]; then
    echo "  [INFO] Cleaning previous work directory..."
    rm -rf "$WORK_DIR"
fi

mkdir -p "$OUT_DIR"

# Copy Plymouth theme into airootfs
echo "  [INFO] Copying Plymouth theme..."
mkdir -p "$PROFILE_DIR/airootfs/usr/share/plymouth/themes/saos"
cp -r "$SCRIPT_DIR/splash/saos-plymouth/"* \
    "$PROFILE_DIR/airootfs/usr/share/plymouth/themes/saos/"

# Copy wallpapers
echo "  [INFO] Copying wallpapers..."
mkdir -p "$PROFILE_DIR/airootfs/usr/share/backgrounds/saos"
if [ -d "$SCRIPT_DIR/wallpapers" ]; then
    cp -r "$SCRIPT_DIR/wallpapers/"* \
        "$PROFILE_DIR/airootfs/usr/share/backgrounds/saos/"
fi

# Enable required services in airootfs
echo "  [INFO] Enabling services..."
mkdir -p "$PROFILE_DIR/airootfs/etc/systemd/system/multi-user.target.wants"

# greetd
ln -sf /usr/lib/systemd/system/greetd.service \
    "$PROFILE_DIR/airootfs/etc/systemd/system/multi-user.target.wants/greetd.service" 2>/dev/null || true

# NetworkManager
ln -sf /usr/lib/systemd/system/NetworkManager.service \
    "$PROFILE_DIR/airootfs/etc/systemd/system/multi-user.target.wants/NetworkManager.service" 2>/dev/null || true

# nftables
ln -sf /usr/lib/systemd/system/nftables.service \
    "$PROFILE_DIR/airootfs/etc/systemd/system/multi-user.target.wants/nftables.service" 2>/dev/null || true

# usbguard
ln -sf /usr/lib/systemd/system/usbguard.service \
    "$PROFILE_DIR/airootfs/etc/systemd/system/multi-user.target.wants/usbguard.service" 2>/dev/null || true

# SAOS post-install setup service
ln -sf /usr/lib/systemd/system/saos-setup.service \
    "$PROFILE_DIR/airootfs/etc/systemd/system/multi-user.target.wants/saos-setup.service" 2>/dev/null || true

# Ensure required boot config files are present
if [ ! -d "$SCRIPT_DIR/syslinux" ] || [ ! -d "$SCRIPT_DIR/efiboot/loader/entries" ]; then
    echo "  [INFO] Boot config files missing; copying from archiso releng profile..."
    if [ ! -d "$RELENG" ]; then
        echo "  [ERROR] archiso releng profile not found at $RELENG"
        echo "         Install archiso and run FIX_BUILD.sh or create syslinux/efiboot manually."
        exit 1
    fi
    cp -r "$RELENG/syslinux" "$SCRIPT_DIR/"
    cp -r "$RELENG/efiboot" "$SCRIPT_DIR/"
    if [ -d "$RELENG/grub" ]; then
        cp -r "$RELENG/grub" "$SCRIPT_DIR/"
    fi
    echo "  [INFO] Updating EFI boot entry labels to SAOS..."
    find "$SCRIPT_DIR/efiboot" -name "*.conf" -exec sed -i 's/Arch Linux/SAOS/g' {} \;
fi

# Build ISO
echo "  [INFO] Building ISO — this will take 10-20 minutes..."
echo ""

mkarchiso -v -w "$WORK_DIR" -o "$OUT_DIR" "$PROFILE_DIR"

echo ""
echo "  BUILD COMPLETE."
echo "  ISO location: $OUT_DIR/saos-x86_64.iso"
echo ""
echo "  To test in QEMU:"
echo "  qemu-system-x86_64 -enable-kvm -m 4G -boot d -cdrom $OUT_DIR/saos-x86_64.iso -vga virtio"
echo ""
echo "  MISSION PARAMETERS CONFIRMED. SYSTEM READY."
echo ""
