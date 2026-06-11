# SAOS Installer Guide

## Quick Installation

1. **Boot from USB**
   - SAOS ISO will auto-boot to installer

2. **Welcome Screen**
   - Read the mission briefing
   - Confirm system requirements

3. **Regional Settings**
   - Select timezone (UTC recommended)
   - Choose keyboard layout

4. **Disk Configuration**
   - Select target disk
   - Choose partitioning scheme
   - **WARNING: All data will be erased**

5. **Agent Registration**
   - **Agent ID**: `agentm` or `agent007` (lowercase)
   - **Display Name**: `Agent M.` or `Agent 007`
   - **Authorization Code**: Password (8+ chars, mixed case + numbers)
   - Confirm credentials

6. **Installation**
   - Review summary
   - Begin installation (5-15 minutes)
   - Reboot when prompted

7. **First Boot**
   - Login with Agent credentials
   - Or use face authentication: click **[ FACE ID ]**

---

## Post-Installation

### Enroll Face ID

```bash
sudo howdy add
# Look at webcam when prompted
# Takes ~30 seconds to capture
```

### Test Face ID

```bash
sudo howdy test
```

### Update System

```bash
sudo pacman -Syyu
```

### Install AUR Packages (optional)

```bash
sudo pacman -S yay  # or another AUR helper
yay -S <package>
```

---

## Troubleshooting Installer

**Installer won't launch**
- Try manual: `sudo saos-installer.sh`

**Calamares crashes**
- Check logs: `journalctl -n 50`

**Disk not detected**
- Run: `lsblk`
- Check BIOS/UEFI settings

**Package installation fails**
- Check internet: `ping 8.8.8.8`
- Mirror might be down — wait and retry

---

## Installer Files

| File | Purpose |
|------|---------|
| `/installer/calamares/` | GUI installer config |
| `/installer/saos-installer.sh` | TUI fallback installer |
| `packages.x86_64` | Packages to install |

---

## Next Steps

1. **Enroll Face ID** for passwordless login
2. **Customize** Hyprland keybinds (see CONTRIBUTING.md)
3. **Add wallpaper** to `~/Pictures/`
4. **Join the community** — report bugs, suggest features

---

MISSION BRIEFING COMPLETE. AGENT REGISTRATION IN PROGRESS.
