#!/usr/bin/env bash
# =============================================================================
# Metadata Cleaner – Omarchy Auto-Install Edition
# =============================================================================

# Theme Configuration (Macchiato)
BG="#1e2030"
BORDER="#6f7690"
TEXT="#cad3f5"
SEL_BG="#39515A"
SEL_TEXT="#85abbc"
MAUVE="#c6a0f6"

# Rofi Theme
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

# --- 1. Automatic Terminal Detection ---
# Detects which terminal you have and sets the correct execution flag
detect_terminal() {
    if command -v alacritty &>/dev/null; then
        echo "alacritty --class OmarchyFloatingTerm --title 'Metadata Engine' -e"
    elif command -v ghostty &>/dev/null; then
        echo "ghostty --title='Metadata Engine' -e"
    elif command -v kitty &>/dev/null; then
        echo "kitty --title 'Metadata Engine' -e"
    elif command -v foot &>/dev/null; then
        echo "foot -T 'Metadata Engine' -e"
    else
        notify-send "Error" "No terminal found!"
        exit 1
    fi
}

# --- 2. Rofi Confirmation Logic ---
confirm_action() {
    local prompt="$1"
    local chosen=$(echo -e " Yes, Proceed\n󰜺 No, Cancel" | rofi -dmenu -i -p "$prompt" \
        -kb-cancel "Escape,MouseSecondary,MousePrimary" -theme-str "$ROFI_THEME")
    [[ "$chosen" == *"Yes"* ]] && return 0 || return 1
}

# --- 3. Unified Terminal Execution ---
run_in_term() {
    local term_exec=$(detect_terminal)
    local title="$1"
    local cmd="$2"

    # The command sequence to show progress and wait at the end
    local final_cmd="bash -c \"
        echo -e '\e[38;2;198;160;246m\e[1m✦ $title\e[0m'
        echo -e '\e[38;2;110;115;141m╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌\e[0m\n'
        $cmd
        echo -e '\n\e[2mTask Finished. Press any key to close...\e[0m'
        read -n 1
    \""

    # Launch the detected terminal
    eval "$term_exec $final_cmd" &
}

# --- 4. Internal Task Execution ---
if [[ "$1" == "--clean-now" ]]; then
    TARGET="$2"; MODE="$3"
    if [[ "$MODE" == "inspect" ]]; then
        echo -e "\e[33m[READING METADATA]\e[0m"
        mat2 --show "$TARGET" || exiftool "$TARGET"
    else
        echo -e "\e[35m[SCRUBBING]\e[0m: $TARGET"
        mat2 "$TARGET"
        echo -e "\e[32m✔ Success: Cleaned copy created.\e[0m"
    fi
    exit 0
fi

# --- 5. Main Rofi Menu ---
options="🧹 Clean File Metadata\n📂 Clean Folder Metadata\n🔍 Inspect File Details\n📦 Install Dependencies\n🚪 Exit"

chosen=$(echo -e "$options" | rofi -dmenu -i -p "󰗨 Cleaner" \
    -kb-cancel "Escape,MouseSecondary,MousePrimary" \
    -theme-str "$ROFI_THEME")

[[ -z "$chosen" || "$chosen" == *"Exit"* ]] && exit 0

case "$chosen" in
    *"Clean File"*)
        target=$(zenity --file-selection --title="Select File")
        if [[ -n "$target" ]]; then
            confirm_action "Scrub Metadata?" && run_in_term "Metadata Scrub" "bash '$0' --clean-now '$target' 'clean'"
        fi
        ;;
    *"Clean Folder"*)
        target=$(zenity --file-selection --directory --title="Select Folder")
        if [[ -n "$target" ]]; then
            confirm_action "Scrub Folder?" && run_in_term "Recursive Scrub" "bash '$0' --clean-now '$target' 'clean'"
        fi
        ;;
    *"Inspect"*)
        target=$(zenity --file-selection --title="Inspect File")
        [[ -n "$target" ]] && run_in_term "Metadata Inspection" "bash '$0' --clean-now '$target' 'inspect'"
        ;;
    *"Install Dependencies"*)
        if confirm_action "Install Cleaner Tools?"; then
            # This opens the terminal immediately and shows pacman progress
            run_in_term "Downloading Tools" "sudo pacman -S --needed --noconfirm mat2 perl-image-exiftool"
        fi
        ;;
esac