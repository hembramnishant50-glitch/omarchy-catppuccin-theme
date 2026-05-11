<div align="center">

<img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/misc/transparent.png" height="30"/>

# ☕ Omarchy Macchiato Core

**A high-performance, solid-state Catppuccin theme for [Omarchy](https://omarchy.org/)**

[![License: MIT](https://img.shields.io/badge/License-MIT-c29df2?style=flat-square)](LICENSE)
[![Theme: Macchiato](https://img.shields.io/badge/Catppuccin-Macchiato-be9aee?style=flat-square)](https://github.com/catppuccin/catppuccin)
[![WM: Hyprland](https://img.shields.io/badge/WM-Hyprland-cad3f5?style=flat-square)](https://hyprland.org)

<!-- Small UI Desktop Grid -->
<p align="center">
  <img src="https://github.com/user-attachments/assets/9b2c57c7-2f93-46e3-a11b-d5ae2584e0bd" width="48%" />
  <img src="https://github.com/user-attachments/assets/d251947f-19d0-4250-9b22-52e82d997fce" width="48%" />
</p>
<p align="center">
  <img src="https://github.com/user-attachments/assets/3b426c85-6441-429b-aa31-f9cb4d8587c8" width="48%" />
  <img src="https://github.com/user-attachments/assets/ba641a85-1219-4741-9ea4-b7bc1a3d123c" width="48%" />
</p>
<p align="center">
  <img alt="Image" src="https://github.com/user-attachments/assets/c5ca0c5a-8ee9-446f-94f4-f18edd92ef0a" width="48%" />
  <img src="https://github.com/user-attachments/assets/e0bcab31-f896-4fc7-afbd-818a18dd6752" width="48%" />
</p>

</div>

---

## 🧠 Philosophy

**Macchiato Core** eliminates the performance tax of modern desktops. By using **pure, solid hex colors**. The result is a sharp, high-contrast workspace that feels instantaneous on any hardware.

---

## 📊 Waybar Variants

### 1. Default Core Bar
*Full-width with a signature Lavender (`#c29df2`) underline and high-contrast workspace pills.*
<img src="https://github.com/user-attachments/assets/99253cf4-1465-441e-89bb-b5524d967056" width="100%" alt="Default Waybar" />

### 2. Modern Floating Bar
*A detached, minimalist pill-style layout with grouped system modules.*
<img src="https://github.com/user-attachments/assets/2c9823b8-e97f-4ba4-9af6-4362b875716e" width="100%" alt="2nd Waybar" />

---

## ✨ Features

- **Solid State UI:** No transparency. No blur. Perfect pixel-clarity.
- **Integrated Scripts:** Pre-configured tools inside `~/.config/waybar/scripts/`.

| Script | Function |
|:---|:---|
| `wg-manager.sh` | 🔐 WireGuard VPN Toggle |
| `yt-dl.sh` | 🎬 YouTube Media Downloader |
| `app-killer.sh` | 🗡️ Process Force-Kill Tool |
| `mac-spoofer.sh` | 🌐 Instant MAC Randomization |
| `shredder.sh` | 🔥 Secure File Destruction |
| `tor_firefox_rotator.sh` | 🧅 Tor Identity Rotation |

---
## 🖼️ Wallpaper Collection

A curated selection of high-resolution backgrounds optimized for the Macchiato color palette.

<p align="center">
  <img src="https://github.com/user-attachments/assets/e402f7cb-4cab-4453-ac31-9d769c705983" width="24%" />
  <img src="https://github.com/user-attachments/assets/fcc85c03-9061-4462-b066-a2a067615506" width="24%" />
  <img src="https://github.com/user-attachments/assets/6f2c1b15-2aa5-4e92-9035-7948bf494a68" width="24%" />
  <img src="https://github.com/user-attachments/assets/62efbebb-ca9a-4a01-b7c6-d325e8cf6959" width="24%" />
</p>
<p align="center">
  <img src="https://github.com/user-attachments/assets/10f33015-a08a-4267-a42d-eee056e8663d" width="24%" />
  <img src="https://github.com/user-attachments/assets/92ec24f1-6841-4caf-9700-38ae415ef14e" width="24%" />
  <img src="https://github.com/user-attachments/assets/ecd07836-10c4-4559-b9dd-ef0eedd5df92" width="24%" />
  <img src="https://github.com/user-attachments/assets/6e636ca5-09fc-4114-ad03-113a6c17c027" width="24%" />
</p>

---

## 📦 Installation

Applying this theme is fully automated via the Omarchy theme installer.

### Theme Only (Recommended)

```bash
omarchy-theme-install https://github.com/hembramnishant50-glitch/omarchy-macchiato-core-theme.git
```

### Manual Waybar Setup

If you want to apply the Waybar config manually, the script below safely backs up your existing config and applies the new one:

```bash
#!/usr/bin/env bash

# Step 0 — Install Rofi (Wayland) and Required Fonts
echo "󰒲 Installing Rofi and font dependencies..."
sudo pacman -S --needed rofi-wayland ttf-jetbrains-mono-nerd otf-font-awesome
# These are required for the gear icon, calendar grid, and menu rendering.

# Step 1 — Back up your existing Waybar config
if [ -d ~/.config/waybar ]; then
    BACKUP_NAME="waybar-backup-$(date +%d-%m-%Y)-$RANDOM"
    mv ~/.config/waybar ~/.config/"$BACKUP_NAME"
    echo "✔ Existing config backed up to ~/.config/$BACKUP_NAME"
fi

# Step 2 — Apply the theme's Waybar config
SOURCE_DIR="$HOME/.config/omarchy/current/theme/waybar"

if [ -d "$SOURCE_DIR" ]; then
    mkdir -p ~/.config/waybar
    cp -r "$SOURCE_DIR"/* ~/.config/waybar/
    
    # Ensure scripts are executable, especially setting.sh and ocr-snapper.sh
    if [ -d ~/.config/waybar/scripts ]; then
        chmod +x ~/.config/waybar/scripts/*
    fi
    echo "✔ Waybar configuration applied successfully."
else
    echo "✖ Error: Source directory $SOURCE_DIR not found."
fi

# Step 3 — Restart Waybar
killall -q waybar
nohup waybar > /dev/null 2>&1 &
echo "✔ Waybar restarted."
```

---
<div align="center">

## <span style="color: #c19cf2;">🔒 Hyprlock</span> ✦ *Custom Lock Screen*

<br>

<img width="85%" alt="Hyprlock Preview" src="https://github.com/user-attachments/assets/e0bcab31-f896-4fc7-afbd-818a18dd6752" />

<p align="center">
  <i>Glassmorphism lock screen featuring a live clock, personalized profile greeting, active media controls with visualizers, and quick power options.</i>
</p>

</div>

<br>

```bash
# 1. Install Playerctl (required for media key support)
sudo pacman -S --needed playerctl

# 2. Copy lock screen config files
mv ~/.config/hypr/hyprlock.conf ~/.config/hypr/hyprlock.conf-Backup && \
cp -r ~/.config/omarchy/current/theme/scripts \
      ~/.config/omarchy/current/theme/hyprlock.conf \
      ~/.config/hypr/

# 3. Make scripts executable
chmod +x ~/.config/hypr/scripts/*
```

<br>

### ⏪ Restore Previous Hyprlock (Remove Omarchy Macchiato Core)

```bash
# Remove the custom theme and restore your original backup
rm ~/.config/hypr/hyprlock.conf && \
mv ~/.config/hypr/hyprlock.conf-Backup ~/.config/hypr/hyprlock.conf
```



---
<div align="center">

## <span style="color: #c19cf2;">🎨 Icons & Cursors</span> ✦ *System Theming*

<br>

<br>

```bash
# 1. Install and apply Papirus Dark icons with Violet folders
yay -S papirus-icon-theme papirus-folders-git
papirus-folders -C violet --theme Papirus-Dark
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'

# 2. Install and apply Catppuccin Mocha Mauve cursors
yay -S catppuccin-cursors-mocha
gsettings set org.gnome.desktop.interface cursor-theme 'Catppuccin-Mocha-Mauve-Cursors'

```




---

## 🤝 Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you'd like to change.

  Fork the repo
  Create your feature branch: `git checkout -b feat/my-change`
  Commit your changes: `git commit -m 'feat: add my change'`
  Push: `git push origin feat/my-change`
  Open a Pull Request


---

<div align="center">

Made with ☕ to **Omarchy**

**[⬆ Back to top](#-omarchy-macchiato-core)**

</div>
