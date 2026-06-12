#!/usr/bin/env bash
# Run this ONCE on your Arch build machine before running build.sh
# It copies the required boot config files from the official archiso releng profile

set -e

SAOS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RELENG="/usr/share/archiso/configs/releng"

if [ ! -d "$RELENG" ]; then
    echo "[ERROR] archiso not installed. Run: sudo pacman -S archiso"
    exit 1
fi

echo "[INFO] Copying required boot files from archiso releng profile..."

# syslinux (BIOS boot)
cp -r "$RELENG/syslinux" "$SAOS_DIR/"

# EFI boot entries (UEFI boot)
mkdir -p "$SAOS_DIR/efiboot/loader/entries"
cp -r "$RELENG/efiboot" "$SAOS_DIR/"

# pacman.conf (required by mkarchiso)
cp "$RELENG/pacman.conf" "$SAOS_DIR/"

# grub (needed for some boot modes)
if [ -d "$RELENG/grub" ]; then
    cp -r "$RELENG/grub" "$SAOS_DIR/"
fi

echo "[INFO] Updating EFI boot entry labels to SAOS..."
# Replace Arch Linux labels with SAOS in loader entries
find "$SAOS_DIR/efiboot" -name "*.conf" -exec sed -i 's/Arch Linux/SAOS/g' {} \;

echo ""
echo "[DONE] Boot files copied. You can now run: sudo ./build.sh"
