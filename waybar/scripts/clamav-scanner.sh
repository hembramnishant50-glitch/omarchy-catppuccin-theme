#!/usr/bin/env bash
# =============================================================================
# Malware Scanner – Omarchy GUI Edition
# - Auto-exit on click outside (MousePrimary)
# - GUI folder selection via Zenity
# - Terminal-based Updates, Logs & Installs via Alacritty
# =============================================================================

# Dependency Check
for cmd in rofi alacritty zenity clamscan freshclam; do
    if ! command -v "$cmd" &>/dev/null; then
        notify-send "Scanner Error" "Missing dependency: $cmd"
        # We don't exit here so the user can still use the "Install" option
    fi
done

# Theme Configuration
BG="#1e2030"
BORDER="#6f7690"
TEXT="#cad3f5"
SEL_BG="#39515A"
SEL_TEXT="#85abbc"
MAUVE="#c6a0f6"

# Rofi Theme matching your Macchiato style
ROFI_THEME="
* { background-color: transparent; text-color: $TEXT; font: 'JetBrainsMono Nerd Font 11'; }
window { background-color: $BG; border: 2px; border-color: $BORDER; border-radius: 14px; width: 500px; padding: 20px; location: center; anchor: center; }
listview { lines: 5; fixed-height: true; scrollbar: false; spacing: 8px; margin: 10px 0 0 0; }
element { padding: 10px; border-radius: 10px; }
element selected { background-color: $SEL_BG; text-color: $SEL_TEXT; }
inputbar { children: [ prompt, entry ]; padding: 10px; background-color: #6f76901A; border-radius: 10px; }
prompt { text-color: $SEL_TEXT; margin: 0 10px 0 0; }
entry { text-color: $TEXT; }
"

# Helper: Run commands in Alacritty (Floating Class added for your Hyprland rules)
run_in_term() {
    local title="$1"
    local cmd="$2"
    alacritty --class OmarchyFloatingTerm --title "$title" -e bash -c "
        echo -e '\e[38;2;198;160;246m\e[1m✦ $title\e[0m'
        echo -e '\e[38;2;110;115;141m╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌\e[0m\n'
        $cmd
        echo -e '\n\e[2mProcess finished. Press any key to close...\e[0m'
        read -n 1
    " &
}

# --- Main Logic ---
options="📂 Scan a Directory\n🔄 Update Virus Definitions\n📄 View Last Scan Log\n📦 Install Dependencies\n🚪 Exit"

# Rofi Menu with Auto-Exit logic (MousePrimary = Click outside to exit)
chosen=$(echo -e "$options" | rofi -dmenu -i -p "󰒔 Scanner" \
    -kb-cancel "Escape,MouseSecondary,MousePrimary" \
    -theme-str "$ROFI_THEME")

[[ -z "$chosen" || "$chosen" == *"Exit"* ]] && exit 0

case "$chosen" in
    *"Scan a Directory"*)
        target=$(zenity --file-selection --directory --title="Select folder to scan")
        if [[ -n "$target" ]]; then
            if zenity --question --title="Safe Mode" --text="Remove infected files?" --ok-label="Remove" --cancel-label="Report Only"; then
                flag="--remove=yes"
            else
                flag=""
            fi
            logfile="/tmp/clamscan_$(date +%Y%m%d_%H%M%S).log"
            run_in_term "Virus Scan" "sudo clamscan --recursive --infected --verbose $flag --log=$logfile '$target'"
        fi
        ;;

    *"Update Virus Definitions"*)
        run_in_term "ClamAV Update" "sudo freshclam"
        ;;

    *"View Last Scan Log"*)
        latest_log=$(ls -t /tmp/clamscan_*.log 2>/dev/null | head -1)
        if [[ -n "$latest_log" ]]; then
            run_in_term "Scan Log: $(basename "$latest_log")" "sudo cat '$latest_log'"
        else
            notify-send "Scanner" "No log files found."
        fi
        ;;

    *"Install Dependencies"*)
        run_in_term "Install Dependencies" "sudo pacman -S --needed --noconfirm clamav rofi alacritty zenity"
        ;;
esac