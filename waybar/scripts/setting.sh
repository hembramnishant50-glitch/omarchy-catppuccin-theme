#!/usr/bin/env bash
# =============================================================================
# Omarchy Macchiato – Advanced Settings & Cleaner (FIXED)
# =============================================================================

# --- 1. Verified Path Configuration ---
# Using $HOME ensures the path is always correct for your user
DIR="$HOME/.config/waybar/scripts"
WG="$DIR/wg-manager.sh"
YT="$DIR/yt-dl.sh"
KILLER="$DIR/app-killer.sh"
SCAN="$DIR/clamav-scanner.sh"
SPOOF="$DIR/mac-spoofer.sh"
METADATA="$DIR/metadata_cleaner.sh"
SHREDDER="$DIR/shredder.sh"

# --- 2. Theme Configuration ---
BG="#1e2030"
BORDER="#c19cf2"    
TEXT="#c19cf2"      
SEL_BG="#39515A"    
SEL_TEXT="#85abbc"  
ELEMENT_BG="#c19cf2" 

ROFI_THEME="
* { background-color: transparent; text-color: $TEXT; font: 'JetBrainsMono Nerd Font 11'; }
window { background-color: $BG; border: 2px; border-color: $BORDER; border-radius: 14px; width: 400px; location: center; anchor: center; padding: 15px; }
inputbar { children: [ prompt, entry ]; padding: 5px; }
prompt { text-color: $SEL_TEXT; }
entry { text-color: $TEXT; placeholder: 'Search...'; placeholder-color: #6e738d; }
listview { lines: 8; fixed-height: true; scrollbar: false; spacing: 8px; margin: 10px 0 0 0; }
element { padding: 10px; border-radius: 10px; background-color: $ELEMENT_BG; text-color: $BG; }
element selected { background-color: $SEL_BG; text-color: $SEL_TEXT; }
"

# --- 3. Helper Functions ---

# Global Installer (Shows progress in terminal)[cite: 6]
run_install() {
    alacritty --class OmarchyFloatingTerm --title "Omarchy Installer" -e bash -c "
        echo -e '\e[38;2;198;160;246m✦ Installing Omarchy Dependencies...\e[0m'
        sudo pacman -S --needed --noconfirm mat2 perl-image-exiftool wireguard-tools openresolv jq curl zenity rofi alacritty clamav macchanger yt-dlp ffmpeg
        echo -e '\n\e[32m✔ Installation Finished!\e[0m'
        sleep 2
    "
}

# Cleaner Sub-menu (Includes Metadata and Shredder)
run_cleaner() {
    clean_options="🧹 Clear All Cache\n🗑️ Empty Trash\n🛡️ Metadata Cleaner\n💀 Secure Shredder\n📦 Remove Orphan Packages\n↩ Back"
    
    selected_clean=$(echo -e "$clean_options" | rofi -dmenu -i -p "󰃢 Cleaner" \
        -kb-cancel "Escape,MouseSecondary,MousePrimary" -theme-str "$ROFI_THEME")

    case "$selected_clean" in
        *"Clear All Cache"*) rm -rf "$HOME/.cache/"* 2>/dev/null && notify-send "Cleaner" "Cache Purged" ;;
        *"Empty Trash"*)
            alacritty --class OmarchyFloatingTerm --title "Emptying Trash" -e bash -c "
                echo -e '\e[38;2;198;160;246m✦ Purging Trash...\e[0m'
                rm -rf \"$HOME/.local/share/Trash/\"* 2>/dev/null
                sleep 0.5
            "
            notify-send "Cleaner" "Done" ;;
        *"Metadata Cleaner"*) [[ -f "$METADATA" ]] && bash "$METADATA" || notify-send "Error" "Metadata script not found" ;;
        *"Secure Shredder"*) [[ -f "$SHREDDER" ]] && bash "$SHREDDER" || notify-send "Error" "Shredder script not found" ;;
        *"Remove Orphan Packages"*) alacritty --class OmarchyFloatingTerm -e bash -c "sudo pacman -Rs \$(pacman -Qtdq); sleep 1" ;;
        *"Back"*) exec "$0" ;;
    esac
}

# --- 4. Main Menu Logic ---
options="🔐 WireGuard\n🎬 YouTube DL\n🧹 Omarchy Cleaner\n🔪 App Killer\n🛡️ Scan Malware\n🎭 Spoof MAC\n🛠️ Install Dependencies"

chosen=$(echo -e "$options" | rofi -dmenu -i -p "󱄅 " \
    -kb-cancel "Escape,MouseSecondary,MousePrimary" -theme-str "$ROFI_THEME")

[[ -z "$chosen" ]] && exit 0

case "$chosen" in
    *"WireGuard"*) bash "$WG" & ;;
    *"YouTube DL"*) bash "$YT" & ;;
    *"Omarchy Cleaner"*) run_cleaner ;; 
    *"App Killer"*) bash "$KILLER" & ;;
    *"Scan Malware"*) bash "$SCAN" & ;;
    *"Spoof MAC"*) bash "$SPOOF" & ;;
    *"Install Dependencies"*) run_install ;;
esac