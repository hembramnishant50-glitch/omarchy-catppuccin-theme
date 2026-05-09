<div align="center">

<img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/misc/transparent.png" height="30"/>

# ☕ Omarchy Macchiato Core

**A high-performance, solid-state Catppuccin theme for [Omarchy](https://omarchy.dev)**

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
  <img src="https://github.com/user-attachments/assets/d251947f-19d0-4250-9b22-52e82d997fce" width="48%" />
</p>

</div>

---

## 🧠 Philosophy

**Macchiato Core** eliminates the performance tax of modern desktops. By using **pure, solid hex colors** with zero blur and zero transparency, it removes compositor lag and GPU overhead. The result is a sharp, high-contrast workspace that feels instantaneous on any hardware.

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
- **Chromium Skin:** Custom `manifest.json` included to match your browser to the system.
- **Typography:** Optimized for **JetBrainsMono Nerd Font**.
- **12 Integrated Scripts:** Pre-configured tools inside `~/.config/waybar/scripts/`.

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
  <img src="https://github.com/user-attachments/assets/a3dbe5c7-c55d-45d7-8b26-70291c8cc158" width="24%" />
  <img src="https://github.com/user-attachments/assets/0159bd89-e88f-4e21-bb88-31c188955b6b" width="24%" />
  <img src="https://github.com/user-attachments/assets/166b620a-1c60-40be-91f1-4a49513fd3ae" width="24%" />
  <img src="https://github.com/user-attachments/assets/9e80dfa6-b214-44fb-84df-da9b7d6f12ea" width="24%" />
</p>
<p align="center">
  <img src="https://github.com/user-attachments/assets/f555f4b5-d4a9-4556-9108-acb639655577" width="24%" />
  <img src="https://github.com/user-attachments/assets/e13069d6-cbc4-43b8-ae6f-a27a02fd1008" width="24%" />
  <img src="https://github.com/user-attachments/assets/c06b9fcb-ee44-4c5d-bb26-be16bb96007a" width="24%" />
  <img src="https://github.com/user-attachments/assets/e0bcab31-f896-4fc7-afbd-818a18dd6752" width="24%" />
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



---


## 🤝 Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you'd like to change.

1. Fork the repo
2. Create your feature branch: `git checkout -b feat/my-change`
3. Commit your changes: `git commit -m 'feat: add my change'`
4. Push: `git push origin feat/my-change`
5. Open a Pull Request

---

## 📄 License

Released under the [MIT License](LICENSE).

---

<div align="center">

Made with ☕ and `#c29df2`

**[⬆ Back to top](#-omarchy-macchiato-core)**

</div>
