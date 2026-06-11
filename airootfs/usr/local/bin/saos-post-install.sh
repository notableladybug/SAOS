#!/usr/bin/env bash
# Post-installation setup for SAOS
# Run this after chroot during installation

set -e

echo "SAOS post-installation setup..."

# Enable services
echo "Enabling system services..."
systemctl enable greetd.service || true
systemctl enable NetworkManager.service || true
systemctl enable nftables.service || true
systemctl enable usbguard.service || true
systemctl enable saos-setup.service || true

# Enable USBGuard notifier if present
echo "Enabling USBGuard notifier..."
if [ -f /usr/lib/systemd/system/usbguard-notifier.service ]; then
    systemctl enable usbguard-notifier.service || true
fi

# Generate USBGuard policy for current devices
echo "Generating USBGuard policy..."
usbguard generate-policy > /etc/usbguard/rules.conf || true

# Install Howdy from AUR if not present
echo "Installing Howdy face authentication..."
if ! command -v howdy >/dev/null 2>&1; then
    if command -v git >/dev/null 2>&1 && command -v makepkg >/dev/null 2>&1; then
        rm -rf /tmp/howdy
        git clone https://aur.archlinux.org/howdy.git /tmp/howdy || true
        if [ -d /tmp/howdy ]; then
            cd /tmp/howdy
            makepkg -si --noconfirm || true
        fi
    fi
fi

# Set Plymouth as default boot splash
echo "Configuring Plymouth..."
plymouth-set-default-theme saos || true

# Create user home directories if needed
echo "Creating user directories..."
mkdir -p /etc/skel/.config/hypr
mkdir -p /etc/skel/.config/waybar
mkdir -p /etc/skel/.config/fuzzel

# Copy Hyprland config to skel
cp /etc/hypr/hyprland.conf /etc/skel/.config/hypr/ 2>/dev/null || true
cp /etc/hypr/hypridle.conf /etc/skel/.config/hypr/ 2>/dev/null || true
cp /etc/hypr/hyprlock.conf /etc/skel/.config/hypr/ 2>/dev/null || true

# Set default wallpaper
echo "Setting default wallpaper..."
if [ -f /usr/share/backgrounds/saos/saos-default.png ]; then
    ln -sf /usr/share/backgrounds/saos/saos-default.png /usr/share/pixmaps/saos-wallpaper.png || true
fi

# Finalize
echo "AGENT REGISTRATION SYSTEM READY."
echo "Rebooting into SAOS..."

exit 0
