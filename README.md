<div align="center">

<img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/misc/transparent.png" height="30"/>

# ☕ Omarchy Macchiato Core

**A solid-state, zero-blur Catppuccin Macchiato theme for [Omarchy](https://omarchy.dev)**

[![License: MIT](https://img.shields.io/badge/License-MIT-c29df2?style=flat-square)](LICENSE)
[![Theme: Macchiato](https://img.shields.io/badge/Catppuccin-Macchiato-be9aee?style=flat-square)](https://github.com/catppuccin/catppuccin)
[![WM: Hyprland](https://img.shields.io/badge/WM-Hyprland-cad3f5?style=flat-square)](https://hyprland.org)
[![Bar: Waybar](https://img.shields.io/badge/Bar-Waybar-cad3f5?style=flat-square)](https://github.com/Alexays/Waybar)

<img src="https://raw.githubusercontent.com/hembramnishant50-glitch/omarchy-macchiato-core-theme/main/preview.png" alt="Omarchy Macchiato Core Preview" width="800"/>

</div>

---

## 🧠 Philosophy

Most themes chase glass effects and transparency. **Macchiato Core** goes the opposite direction.

Every surface is a **pure, solid hex color** — no blur, no transparency, no compositor gimmicks eating your GPU. The result is a distraction-free desktop that renders perfectly at any hardware tier, from a decade-old ThinkPad to a brand-new workstation.

**Core** refers to the stripped-back, purposeful design: everything present has a reason, nothing is decorative noise.

---

## ✨ Features

### 🪟 Solid State UI
Pure hex colors throughout. No transparency. No blur. Every pixel is intentional — delivering a high-contrast, distraction-free workspace that looks equally sharp on a 1080p display or a 4K monitor.

### 📊 The Core Waybar
A fully hand-tuned Waybar config built from the ground up:

- **Edge-to-edge 2px downside border** in `#c29df2` Lavender
- **Unique inset neon underglow trick** — bypasses compositor clipping that breaks most border implementations
- **Optimized 16px module spacing** for a breathable, uncrowded layout
- **Custom charging states** with a dedicated `#39515A` battery indicator color
- **Fixed empty workspace rendering** — workspaces always render correctly, even when empty

### 🌐 Seamless Browser Integration
Includes a custom Chromium `manifest.json` that skins your browser to match the system's exact hex codes. The web and the desktop finally look like one environment.

### 🔤 Typography
Clean, bold configuration for **JetBrainsMono Nerd Font** — crisp at small sizes, iconic at large ones.

---

## 🎨 Color Palette

| Role | Hex | Preview | Description |
|------|-----|---------|-------------|
| Base / Background | `#1e2030` | ![#1e2030](https://placehold.co/16x16/1e2030/1e2030.png) | Deep, solid Macchiato background |
| Foreground / Text | `#cad3f5` | ![#cad3f5](https://placehold.co/16x16/cad3f5/cad3f5.png) | Crisp, readable text and icons |
| Border / Glow | `#c29df2` | ![#c29df2](https://placehold.co/16x16/c29df2/c29df2.png) | Signature Lavender downside border |
| Active Accent | `#be9aee` | ![#be9aee](https://placehold.co/16x16/be9aee/be9aee.png) | Mauve — active workspaces & tooltips |
| Battery Indicator | `#39515A` | ![#39515A](https://placehold.co/16x16/39515A/39515A.png) | Custom charging state color |

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
    [ -d ~/.config/waybar/scripts ] && chmod +x ~/.config/waybar/scripts/*
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

## 🗂 What's Included

```
omarchy-macchiato-core-theme/
├── theme.conf              # Main theme declaration
├── waybar/
│   ├── config              # Module layout & settings
│   ├── style.css           # Full Macchiato color scheme
│   └── scripts/            # Helper scripts (auto-chmod'd on install)
├── chromium/
│   └── manifest.json       # Browser skin for Chromium/Chrome
└── assets/
    └── preview.png         # Theme screenshot
```

---

## 🔧 Requirements

| Dependency | Purpose |
|---|---|
| [Omarchy](https://omarchy.dev) | Base system (required) |
| [Waybar](https://github.com/Alexays/Waybar) | Status bar |
| [Hyprland](https://hyprland.org) | Compositor |
| JetBrainsMono Nerd Font | Typography |
| Chromium / Chrome *(optional)* | Browser theming |

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
