# SAOS Installation Checklist
# Verify all components before building

## Files Structure
- [ ] `docs/SPEC.md` - Full specification
- [ ] `docs/BUILD_GUIDE.md` - Build instructions
- [ ] `docs/CONTRIBUTING.md` - Contribution guidelines
- [ ] `README.md` - Main readme
- [ ] `LICENSE` - MIT License
- [ ] `.gitignore` - Git ignore rules

## Build System
- [ ] `build.sh` - Main build script
- [ ] `profiledef.sh` - archiso profile definition
- [ ] `pacman.conf` - Pacman configuration
- [ ] `packages.x86_64` - Package list

## System Configuration (airootfs/etc/)
- [ ] `saos-release` - OS identity
- [ ] `default/grub` - GRUB boot config
- [ ] `mkinitcpio.conf` - Initramfs config
- [ ] `pam.d/greetd` - PAM authentication config

### Hyprland (window manager)
- [ ] `hypr/hyprland.conf` - Main config
- [ ] `hypr/hyprlock.conf` - Lock screen config

### Waybar (status bar)
- [ ] `waybar/config.jsonc` - Status bar layout
- [ ] `waybar/style.css` - Status bar styling

### Greetd (login)
- [ ] `greetd/config.toml` - Login daemon config
- [ ] `greetd/saos-gtkgreet.css` - Login screen styling

### Howdy (face auth)
- [ ] `howdy/config.ini` - Face recognition config

### Terminal
- [ ] `foot/foot.ini` - Terminal config

### App Launcher
- [ ] `fuzzel/fuzzel.ini` - Launcher config

### Boot
- [ ] `boot/loader/loader.conf` - systemd-boot config
- [ ] `boot/loader/entries/saos.conf` - Boot entry

## Systemd Services (usr/lib/systemd/system/)
- [ ] `saos-setup.service` - Post-install setup
- [ ] `howdy-pam-setup.service` - Howdy PAM config

## Themes & UI (usr/share/)
- [ ] `themes/saos/index.theme` - GTK theme metadata
- [ ] `themes/saos/gtk-4.0/gtk.css` - GTK4 theme

## Boot Splash (splash/saos-plymouth/)
- [ ] `saos.plymouth` - Plymouth theme definition
- [ ] `saos.script` - Plymouth animation script
- [ ] `theme.desktop` - Theme metadata
- [ ] `assets/README.md` - Asset documentation

## Installer (installer/)
- [ ] `calamares/settings.conf` - Main installer config
- [ ] `calamares/modules/users.conf` - User registration
- [ ] `calamares/modules/partition.conf` - Disk setup
- [ ] `calamares/modules/welcome.conf` - Welcome screen
- [ ] `calamares/branding/saos/branding.desc` - Branding
- [ ] `saos-installer.sh` - TUI installer fallback
- [ ] `INSTALLER_GUIDE.md` - Installation guide

## Wallpapers
- [ ] `wallpapers/README.md` - Wallpaper guidelines
- [ ] (Add PNG/JPG wallpaper files as needed)

## User Scripts
- [ ] `airootfs/usr/local/bin/saos-post-install.sh` - Post-install hook
- [ ] `airootfs/usr/local/bin/install-aur-packages.sh` - AUR installer

## Verification Steps

1. **File Permissions**
   ```bash
   chmod +x build.sh
   chmod +x installer/saos-installer.sh
   chmod +x airootfs/usr/local/bin/*.sh
   ```

2. **Syntax Validation**
   - [ ] JSON: `jsonc` in config.jsonc files
   - [ ] YAML/TOML: calamares config files
   - [ ] Shell: all `.sh` scripts
   - [ ] CSS: all `.css` files

3. **Build Test**
   ```bash
   sudo ./build.sh
   ```

4. **ISO Test (QEMU)**
   ```bash
   qemu-system-x86_64 -enable-kvm -m 4G -cdrom out/saos-x86_64.iso
   ```

5. **Verify Contents**
   - [ ] ISO can boot
   - [ ] Installer launches
   - [ ] Colors match SPEC (#000000 bg, #00ff41 text)
   - [ ] Fonts are JetBrains Mono everywhere
   - [ ] No rounded corners
   - [ ] 1px green borders visible

## Pre-Release Checks

- [ ] All config files are valid
- [ ] No hardcoded paths (use /usr/share/, /etc/, etc.)
- [ ] Username validation works (agent + letter/number)
- [ ] All keybinds tested
- [ ] Howdy integration verified
- [ ] Face ID enrollment works
- [ ] Post-install services run
- [ ] Documentation is complete and accurate

---

**MISSION READY WHEN ALL BOXES ARE CHECKED**
