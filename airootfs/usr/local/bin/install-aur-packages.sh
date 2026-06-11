#!/usr/bin/env bash
# SAOS AUR Package Installation Hook
# Run after base system installation to install Howdy

cat > /tmp/saos-aur-packages.sh << 'EOF'
#!/usr/bin/env bash
# Install AUR packages for SAOS

set -e

echo "Installing AUR packages..."

# Install yay if not present
if ! command -v yay &> /dev/null; then
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd ..
    rm -rf yay
fi

# Install Howdy (face authentication)
echo "Installing Howdy..."
yay -S --noconfirm howdy

# Optional: Install other AUR packages
# yay -S hyprlock  # Hyprland lock screen

echo "AUR packages installed."
EOF

chmod +x /tmp/saos-aur-packages.sh
/tmp/saos-aur-packages.sh
