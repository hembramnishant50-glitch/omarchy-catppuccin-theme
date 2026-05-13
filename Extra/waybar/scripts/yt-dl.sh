#!/usr/bin/env bash
# =============================================================================
# YouTube Downloader – Omarchy GUI + Manual Cookie Selector
# - Auto-exit on click outside (MousePrimary)
# - Dependency Installer included
# =============================================================================

# Configuration
DOWNLOAD_DIR="$HOME/Downloads/YouTube"
DEFAULT_COOKIE_FILE="$HOME/.config/yt-dlp/cookies.txt"
CURRENT_COOKIES="$DEFAULT_COOKIE_FILE"

mkdir -p "$DOWNLOAD_DIR"

# Theme Colors
BG="#1e2030"
BORDER="#6f7690"
TEXT="#cad3f5"
SEL_BG="#39515A"
SEL_TEXT="#85abbc"

# Rofi Theme
ROFI_THEME="
* { background-color: transparent; text-color: $TEXT; font: 'JetBrainsMono Nerd Font 11'; }
window { background-color: $BG; border: 2px; border-color: $BORDER; border-radius: 14px; width: 500px; padding: 20px; location: center; anchor: center; }
entry { text-color: #a6da95; }
listview { lines: 7; fixed-height: true; scrollbar: false; spacing: 8px; margin: 10px 0 0 0; }
element { padding: 10px; border-radius: 10px; }
element selected { background-color: $SEL_BG; text-color: $SEL_TEXT; }
inputbar { children: [ prompt, entry ]; padding: 10px; background-color: #6f76901A; border-radius: 10px; }
prompt { text-color: $SEL_TEXT; margin: 0 10px 0 0; }
"

# Helper: Install all necessary dependencies in Alacritty
install_deps() {
    alacritty --class OmarchyFloatingTerm --title "Omarchy Dependency Installer" -e bash -c "
        echo -e '\e[38;2;198;160;246m\e[1m✦ Installing Dependencies...\e[0m'
        echo -e '\e[38;2;110;115;141m╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌\e[0m\n'
        sudo pacman -S --needed --noconfirm yt-dlp ffmpeg rofi alacritty zenity libnotify
        echo -e '\n\e[32m✔ Process complete.\e[0m'
        echo -e '\nPress any key to close...'
        read -n 1
    " &
}

# Function to handle cookie selection via GUI
manage_cookies() {
    local options="🍪 Use Default\n📂 Select Manually\n🧩 Install Cookie Extension\n↩ Back"
    local choice=$(echo -e "$options" | rofi -dmenu -i -p "Cookies" \
        -kb-cancel "Escape,MouseSecondary,MousePrimary" \
        -theme-str "$ROFI_THEME")

    case "$choice" in
        *"Use Default"*)
            CURRENT_COOKIES="$DEFAULT_COOKIE_FILE"
            notify-send "Omarchy" "Switched to default cookies."
            ;;
        *"Select Manually"*)
            local manual_file=$(zenity --file-selection --title="Select cookies.txt" --file-filter="*.txt")
            if [[ -n "$manual_file" ]]; then
                CURRENT_COOKIES="$manual_file"
                notify-send "Omarchy" "Cookies set to: $(basename "$manual_file")"
            fi
            ;;
        *"Install Cookie Extension"*)
            xdg-open "https://chromewebstore.google.com/detail/get-cookiestxt-locally/cclelndahbckbenkjhflpdbgdldlbecc" &
            notify-send "Omarchy" "Opening browser to install extension..."
            ;;
        *"Back"*)
            return
            ;;
    esac
}

run_download() {
    local url="$1"
    local format="$2"
    local merge_opts="$3"
    local cookie_cmd=""

    [[ -f "$CURRENT_COOKIES" ]] && cookie_cmd="--cookies $CURRENT_COOKIES"

    alacritty --class OmarchyFloatingTerm --title "Omarchy Downloader" -e bash -c "
        echo -e '\e[38;2;198;160;246m\e[1m✦ Omarchy YouTube Downloader\e[0m'
        echo -e '\e[38;2;110;115;141mUsing Cookies: $CURRENT_COOKIES\e[0m\n'
        
        yt-dlp $cookie_cmd $merge_opts -f '$format' -o '$DOWNLOAD_DIR/%(title)s.%(ext)s' '$url'
        
        if [ \$? -eq 0 ]; then
            echo -e '\n\e[32m✔ Download Complete!\e[0m'
        else
            echo -e '\n\e[31m✘ Download Failed. Check URL or cookies.\e[0m'
        fi
        echo -e '\nPress any key to close...'
        read -n 1
    " &
}

# --- Main Menu Loop ---
while true; do
    options="🎬 Video + Audio\n🎵 Audio Only\n🎞️ Video Only\n⚙️ Cookie Settings\n🛠️ Install Dependencies\n🚪 Exit"
    chosen=$(echo -e "$options" | rofi -dmenu -i -p "󰗃 YT-DL" \
        -kb-cancel "Escape,MouseSecondary,MousePrimary" \
        -theme-str "$ROFI_THEME")

    [[ -z "$chosen" || "$chosen" == "🚪 Exit" ]] && exit 0

    case "$chosen" in
        *"Install Dependencies"*)
            install_deps
            continue
            ;;
        *"Cookie Settings"*)
            manage_cookies
            continue
            ;;
    esac

    url=$(rofi -dmenu -p "Paste URL" \
        -kb-cancel "Escape,MouseSecondary,MousePrimary" \
        -theme-str "$ROFI_THEME")
    [[ -z "$url" ]] && continue

    case "$chosen" in
        *"Video + Audio"*) run_download "$url" "bestvideo+bestaudio/best" "--merge-output-format mp4" ;;
        *"Audio Only"*)    run_download "$url" "bestaudio" "--extract-audio --audio-format m4a" ;;
        *"Video Only"*)    run_download "$url" "bestvideo" "" ;;
    esac
done