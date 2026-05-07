#!/usr/bin/env bash
# =============================================================================
# WireGuard Manager – Omarchy GUI Edition
# - Removed Offline status from header
# - Updated error messaging for failed connections
# - Auto-exit on click outside (MousePrimary)
# =============================================================================

# Theme Configuration
BG="#1e2030"
BORDER="#6f7690"
TEXT="#cad3f5"
SEL_BG="#39515A"
SEL_TEXT="#85abbc"

# Rofi Theme matching your Macchiato style
ROFI_THEME="
* { background-color: transparent; text-color: $TEXT; font: 'JetBrainsMono Nerd Font 11'; }
window { background-color: $BG; border: 2px; border-color: $BORDER; border-radius: 14px; width: 500px; padding: 20px; location: center; anchor: center; }
entry { text-color: #a6da95; }
listview { lines: 10; fixed-height: true; scrollbar: false; spacing: 8px; margin: 10px 0 0 0; }
element { padding: 10px; border-radius: 10px; }
element selected { background-color: $SEL_BG; text-color: $SEL_TEXT; }
inputbar { children: [ prompt, entry ]; padding: 10px; background-color: #6f76901A; border-radius: 10px; }
prompt { text-color: $SEL_TEXT; margin: 0 10px 0 0; }
"

# Helper: Run commands in a floating terminal
run_in_term() {
    local title="$1"
    local cmd="$2"
    alacritty --class OmarchyFloatingTerm --title "$title" -e bash -c "
        echo -e '\e[38;2;198;160;246m\e[1m✦ $title\e[0m'
        echo -e '\e[38;2;110;115;141m╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌\e[0m\n'
        $cmd
        echo -e '\n\e[2mPress any key to close...\e[0m'
        read -n 1
    "
}

# Connection Status check: only show if connected
if ip link show wg0 &>/dev/null; then
    STATUS="[CONNECTED]"
else
    STATUS="" # "Offline" text removed as requested
fi

# Main Menu
options="🟢 Connect VPN\n🔴 Disconnect VPN\n🌐 Check IP & Location\n📊 Show Details\n📝 Edit Config (GUI)\n📦 Install Dependencies\n🎁 Fetch Free Configs\n🚪 Exit"

# Launch Rofi with auto-exit logic
chosen=$(echo -e "$options" | rofi -dmenu -i -p "WireGuard $STATUS" \
    -kb-cancel "Escape,MouseSecondary,MousePrimary" \
    -theme-str "$ROFI_THEME")

[[ -z "$chosen" || "$chosen" == *"Exit"* ]] && exit 0

case "$chosen" in
    *"Connect VPN"*)
        run_in_term "VPN Connect" "
            echo -e '\e[34mApplying System DNS Fixes...\e[0m'
            sudo pacman -S --needed --noconfirm openresolv
            sudo systemctl enable --now systemd-resolved
            sudo resolvconf -u
            
            echo -e '\n\e[34mEstablishing Connection...\e[0m'
            sudo wg-quick down wg0 >/dev/null 2>&1
            if sudo wg-quick up wg0; then
                echo -e '\n\e[32m✔ Connected successfully!\e[0m'
            else
                # Updated error message
                echo -e '\n\e[31m✘ Try once again to connect\e[0m'
            fi
        "
        ;;
        
    *"Disconnect VPN"*)
        run_in_term "VPN Disconnect" "
            if ip link show wg0 &>/dev/null; then
                sudo wg-quick down wg0
                echo -e '\n\e[32m✔ VPN Stopped.\e[0m'
            else
                echo -e '\e[31m✘ wg0 is not currently active.\e[0m'
            fi
        "
        ;;

    *"Edit Config"*)
        EXISTING_CONF=$(sudo cat /etc/wireguard/wg0.conf 2>/dev/null || echo "# Paste [Interface] and [Peer] here")
        NEW_CONF=$(zenity --text-info --editable --title="WireGuard GUI Editor" \
            --width=600 --height=500 --text="$EXISTING_CONF" 2>/dev/null)
        
        if [ $? -eq 0 ] && [ -n "$NEW_CONF" ]; then
            echo "$NEW_CONF" | sudo tee /etc/wireguard/wg0.conf > /dev/null
            sudo chmod 600 /etc/wireguard/wg0.conf
            notify-send "Omarchy" "Config updated!"
        fi
        ;;

    *"Fetch Free Configs"*)
        sub_options="⭐ VPNBook (Recommended)\n🌐 SSHStores\n🌐 VPNJantit\n↩ Back"
        sub_choice=$(echo -e "$sub_options" | rofi -dmenu -i -p "Free Configs" \
            -kb-cancel "Escape,MouseSecondary,MousePrimary" \
            -theme-str "$ROFI_THEME")
            
        case "$sub_choice" in
            *"VPNBook"*) xdg-open "https://www.vpnbook.com/freevpn/wireguard-vpn" ;;
            *"SSHStores"*) xdg-open "https://sshstores.net/wireguard" ;;
            *"VPNJantit"*) xdg-open "https://www.vpnjantit.com/free-wireguard" ;;
            *"Back"*) exec "$0" ;;
        esac
        ;;

    *"Install Dependencies"*)
        run_in_term "Installer" "sudo pacman -S --needed --noconfirm wireguard-tools openresolv jq curl zenity rofi alacritty"
        ;;

    *"Check IP"*)
        run_in_term "IP Check" "curl -s http://ip-api.com/json/ | jq -r '\"IP: \(.query)\nLocation: \(.city), \(.regionName)\nISP: \(.isp)\"'"
        ;;

    *"Show Details"*)
        run_in_term "Details" "sudo wg show"
        ;;
esac