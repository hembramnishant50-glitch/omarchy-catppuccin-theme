#!/usr/bin/env bash
# =============================================================================
# MAC Address Spoofer – Omarchy GUI Edition
# - Auto-exit on click outside (MousePrimary)
# - Floating pinned terminal output
# - Dependency Installer Included
# =============================================================================

# Dependency Check - Notify but don't exit so user can install
for cmd in rofi alacritty zenity macchanger ip notify-send; do
    if ! command -v "$cmd" &>/dev/null; then
        notify-send "Spoofer Warning" "Missing dependency: $cmd. Use the 'Install' option."
    fi
done

# Theme Configuration
BG="#1e2030"
BORDER="#6f7690"
TEXT="#cad3f5"
SEL_BG="#39515A"
SEL_TEXT="#85abbc"

# Rofi Theme
ROFI_THEME="
* { background-color: transparent; text-color: $TEXT; font: 'JetBrainsMono Nerd Font 11'; }
window { background-color: $BG; border: 2px; border-color: $BORDER; border-radius: 14px; width: 500px; padding: 20px; location: center; anchor: center; }
listview { lines: 7; fixed-height: true; scrollbar: false; spacing: 8px; margin: 10px 0 0 0; }
element { padding: 10px; border-radius: 10px; }
element selected { background-color: $SEL_BG; text-color: $SEL_TEXT; }
inputbar { children: [ prompt, entry ]; padding: 10px; background-color: #6f76901A; border-radius: 10px; }
prompt { text-color: $SEL_TEXT; margin: 0 10px 0 0; }
"

# Helper: Run commands in Alacritty with a specific class for floating
run_in_term() {
    local title="$1"
    local cmd="$2"
    local notify_msg="$3"
    
    alacritty --class OmarchyFloatingTerm --title "$title" -e bash -c "
        echo -e '\e[38;2;198;160;246m\e[1m✦ $title\e[0m'
        echo -e '\e[38;2;110;115;141m╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌\e[0m\n'
        $cmd
        echo -e '\n\e[32;1m✔ DONE!\e[0m'
        [[ -n \"$notify_msg\" ]] && notify-send 'Spoofer' \"$notify_msg\"
        echo -e '\n\e[2mTask finished. Press any key to close...\e[0m'
        read -n 1
    "
}

# --- Logic: Get Interfaces ---[cite: 6]
get_interfaces() {
    ip link show | awk -F': ' '/^[0-9]+: (e|w|en|wl)/ {print $2}' | grep -v lo
}

# --- Main Logic ---[cite: 6]
while true; do
    ifaces=$(get_interfaces)
    rofi_ifaces=""
    
    # List network interfaces
    for i in $ifaces; do
        mac=$(ip link show "$i" | awk '/link\/ether/ {print $2}')
        rofi_ifaces+="🌐 $i  ($mac)\n"
    done
    
    # Add utility options to the main list[cite: 6]
    rofi_ifaces+="📦 Install Dependencies\n"
    rofi_ifaces+="🚪 Exit"

    selected_row=$(echo -e "$rofi_ifaces" | rofi -dmenu -i -p "Select Interface" \
        -kb-cancel "Escape,MouseSecondary,MousePrimary" \
        -theme-str "$ROFI_THEME")
    
    [[ -z "$selected_row" || "$selected_row" == *"Exit"* ]] && exit 0

    # Handle Dependency Installation[cite: 6]
    if [[ "$selected_row" == *"Install Dependencies"* ]]; then
        run_in_term "Dependency Installer" "sudo pacman -S --needed --noconfirm macchanger rofi alacritty zenity libnotify iproute2" "Dependencies installed successfully."
        continue
    fi

    iface=$(echo "$selected_row" | awk '{print $2}')

    actions="🎲 Random MAC\n🏭 Vendor MAC\n✏️  Specific MAC\n♻️  Restore Original\n↩ Back"
    
    action_choice=$(echo -e "$actions" | rofi -dmenu -i -p "Action: $iface" \
        -kb-cancel "Escape,MouseSecondary,MousePrimary" \
        -theme-str "$ROFI_THEME")

    [[ -z "$action_choice" || "$action_choice" == *"Back"* ]] && continue

    case "$action_choice" in
        *"Random"*)   cmd="sudo macchanger -r $iface" ;;
        *"Vendor"*)   cmd="sudo macchanger -A $iface" ;;
        *"Restore"*)  cmd="sudo macchanger -p $iface" ;;
        *"Specific"*)
            custom_mac=$(zenity --entry --title="Custom MAC" --text="Enter MAC (XX:XX:XX:XX:XX:XX):")
            if [[ -n "$custom_mac" ]]; then
                cmd="sudo macchanger -m $custom_mac $iface"
            else
                continue
            fi
            ;;
    esac

    # Execute MAC Spoofer logic[cite: 6]
    run_in_term "MAC Spoofer: $iface" "
        echo -e '\e[33mSetting interface down...\e[0m'
        sudo ip link set $iface down
        echo -e '\e[33mApplying new MAC...\e[0m'
        $cmd
        echo -e '\e[33mSetting interface up...\e[0m'
        sudo ip link set $iface up
        echo -e '\n\e[32m✔ Final Status:\e[0m'
        ip link show $iface | grep ether
    " "MAC change for $iface is DONE!"
done