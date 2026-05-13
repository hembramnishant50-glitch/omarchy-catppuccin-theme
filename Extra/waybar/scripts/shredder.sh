#!/usr/bin/env bash
# =============================================================================
# Secure Shredder – Omarchy GUI Edition
# - Auto-exit on click outside (MousePrimary)
# - GUI selection via Rofi & Zenity
# - Professional TUI shredding via Alacritty
# =============================================================================

# Theme Configuration (Macchiato/Omarchy)
BG="#1e2030"
BORDER="#6f7690"
TEXT="#cad3f5"
SEL_BG="#39515A"
SEL_TEXT="#85abbc"
MAUVE="#c6a0f6"
RED="#ed8796"
YELLOW="#eed49f"

# Rofi Theme Matching your Scanner script
ROFI_THEME="
* { background-color: transparent; text-color: $TEXT; font: 'JetBrainsMono Nerd Font 11'; }
window { background-color: $BG; border: 2px; border-color: $BORDER; border-radius: 14px; width: 500px; padding: 20px; location: center; anchor: center; }
listview { lines: 6; fixed-height: true; scrollbar: false; spacing: 8px; margin: 10px 0 0 0; }
element { padding: 10px; border-radius: 10px; }
element selected { background-color: $SEL_BG; text-color: $SEL_TEXT; }
inputbar { children: [ prompt, entry ]; padding: 10px; background-color: #6f76901A; border-radius: 10px; }
prompt { text-color: $SEL_TEXT; margin: 0 10px 0 0; }
entry { text-color: $TEXT; }
"

# Helper: Run commands in Alacritty
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

# --- Internal Shred Logic ---
# This is called by the script itself when running inside the terminal
if [[ "$1" == "--shred-now" ]]; then
    MODE=$2; TARGET=$3; PASSES=$4
    
    echo -e "\e[38;2;237;135;150m⚠️  DESTRUCTION PROTOCOL ACTIVE\e[0m"
    echo -e "\e[38;2;133;171;188mTarget:\e[0m $TARGET"
    echo -e "\e[38;2;133;171;188mPasses:\e[0m $PASSES Cycles + Zero-fill\n"
    
    read -p "Type 'yes' to confirm permanent destruction: " confirm
    if [[ "$confirm" == "yes" ]]; then
        if [ -d "$TARGET" ]; then
            # Directory logic
            mapfile -t FILES < <(find "$TARGET" -type f)
            for file in "${FILES[@]}"; do
                echo -ne "\r\e[38;2;238;212;159m[PROCESS]\e[0m Shredding: ${file: -40}..."
                shred -u -n "$PASSES" -z "$file"
            done
            rm -rf "$TARGET"
        else
            # File logic
            shred -u -n "$PASSES" -z -v "$TARGET"
        fi
        echo -e "\n\n\e[38;2;166;218;149m✔ Data has been physically erased.\e[0m"
    else
        echo -e "\n\e[31mOperation cancelled.\e[0m"
    fi
    exit 0
fi

# --- Main Menu ---
options="󰈔 Shred File\n󱪓 Shred Folder\n󰃢 Empty Trash (Secure)\n󰛑 Dry Run Simulation\n🚪 Exit"

chosen=$(echo -e "$options" | rofi -dmenu -i -p "󰆴 Shredder" \
    -kb-cancel "Escape,MouseSecondary,MousePrimary" \
    -theme-str "$ROFI_THEME")

[[ -z "$chosen" || "$chosen" == *"Exit"* ]] && exit 0

case "$chosen" in
    *"Shred File"*)
        target=$(zenity --file-selection --title="Select target file")
        ;;
    *"Shred Folder"*)
        target=$(zenity --file-selection --directory --title="Select target folder")
        ;;
    *"Empty Trash"*)
        target="$HOME/.local/share/Trash/files"
        [[ ! -d "$target" ]] && notify-send "Shredder" "Trash is already empty." && exit 0
        ;;
    *"Dry Run"*)
        target=$(zenity --file-selection --title="Select simulation target")
        run_in_term "Shred Simulation" "echo -e 'Simulating destruction of: $target\nNo files will be harmed.'; sleep 2"
        exit 0
        ;;
esac

# If a target was selected, get passes and launch terminal
if [[ -n "$target" ]]; then
    passes=$(zenity --scale --title="Security Level" --text="Select overwrite passes" --min-value=1 --max-value=35 --value=3 --step=1)
    [[ -z "$passes" ]] && passes=3
    
    run_in_term "Secure Shredder" "bash '$0' --shred-now '$chosen' '$target' '$passes'"
fi