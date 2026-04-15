# ☕ Omarchy Macchiato Core

![Theme Status](https://img.shields.io/badge/Theme-Solid_State-c29df2?style=for-the-badge)
![Platform](https://img.shields.io/badge/OS-Omarchy_Linux-1e2030?style=for-the-badge&logo=linux)
![Palette](https://img.shields.io/badge/Palette-Catppuccin_Macchiato-be9aee?style=for-the-badge)

**Omarchy Macchiato Core** is a structural, high-performance solid theme built on the Catppuccin Macchiato palette for Omarchy Linux. 

Designed for maximum readability and a clean workspace, this theme strictly avoids glassmorphism and transparency in favor of sharp, definitive borders and neon accents. The aesthetic is defined by its signature "floating edge"—a continuous, edge-to-edge bottom border line with a tightly tucked neon drop-shadow.

## ✨ Features

* **Solid State UI:** Pure, solid hex colors. No transparency or blur, ensuring a distraction-free, high-contrast environment.
* **The "Core" Waybar:** * Custom edge-to-edge 2px downside border (`#c29df2`).
  * Unique inset neon underglow trick to bypass compositor clipping.
  * Optimized module spacing (16px) for a breathable, uncrowded layout.
  * Custom charging states (e.g., `#39515A` battery indicator) and fixed empty workspace rendering.
* **Seamless Browser Integration:** Includes a custom Chromium `manifest.json` to skin your browser perfectly to the system's hex codes.
* **Typography:** Clean, bold typography configured for `JetBrainsMono Nerd Font`.

## 🎨 Color Palette 

| Element | Hex Code | Description |
| :--- | :--- | :--- |
| **Base / Background** | `#1e2030` | Deep, solid Macchiato background. |
| **Foreground / Text** | `#cad3f5` | Crisp, readable text and icons across all modules. |
| **Border / Glow** | `#c29df2` | Signature Lavender downside border. |
| **Active Accent** | `#be9aee` | Mauve highlights for active workspaces and tooltips. |

## 📦 Installation

Applying the theme to your Omarchy setup is fully automated via the Omarchy theme installer. Simply run the following command in your terminal:

```bash
omarchy-theme-install https://github.com/hembramnishant50-glitch/omarchy-macchiato-core-theme.git
