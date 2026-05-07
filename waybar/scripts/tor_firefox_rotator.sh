#!/usr/bin/env bash
# =============================================================================
# Tor + Firefox Rotator – Omarchy Nested GUI (Routing Stop Fix)
# =============================================================================

# Configuration Paths
STATE_DIR="$HOME/.local/state/tor-ip-changer"
SERVICE_NAME="change-tor-ip"
SERVICE_FILE="$HOME/.config/systemd/user/${SERVICE_NAME}.service"
CORE_SCRIPT="$HOME/.local/bin/change_tor_ip.sh"
FIREFOX_PROFILE="tor-proxy"

# Theme Colors (Omarchy Macchiato)[cite: 1, 3]
BG="#1e2030"
BORDER="#6f7690"
TEXT="#cad3f5"
SEL_BG="#39515A"
SEL_TEXT="#85abbc"
GREEN="#a6da95"
RED="#ed8796"
MAUVE="#c6a0f6"

# Rofi Theme - Limited lines to prevent stretching[cite: 1]
ROFI_THEME="
* { background-color: transparent; text-color: $TEXT; font: 'JetBrainsMono Nerd Font 11'; }
window { background-color: $BG; border: 2px; border-color: $BORDER; border-radius: 14px; width: 550px; padding: 20px; location: center; anchor: center; }
listview { lines: 6; fixed-height: true; scrollbar: false; spacing: 8px; margin: 10px 0 0 0; }
element { padding: 10px; border-radius: 10px; }
element selected { background-color: $SEL_BG; text-color: $SEL_TEXT; }
inputbar { children: [ prompt, entry ]; padding: 10px; background-color: #6f76901A; border-radius: 10px; }
prompt { margin: 0 10px 0 0; font-weight: bold; }
"

# Helper: Run commands in Alacritty with Done Notification[cite: 1]
run_in_term() {
    local title="$1"
    local cmd="$2"
    alacritty --title "$title" -e bash -c "
        echo -e '\e[38;2;198;160;246m\e[1m✦ $title\e[0m'
        echo -e '\e[38;2;110;115;141m╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌\e[0m\n'
        $cmd
        echo -e '\n\e[32;1m✔ DONE!\e[0m'
        notify-send 'Tor Manager' '$title: Process Finished'
        echo -e '\n\e[2mPress any key to close...\e[0m'
        read -n 1
    "
}

# --- Service Status Helper ---
is_tor_active() { systemctl is-active --quiet tor.service; }
is_rotator_active() { systemctl --user is-active --quiet "$SERVICE_NAME"; }

# --- Main Logic ---
while true; do
    # Dynamic Status Icons and Colors[cite: 3]
    if is_tor_active; then TOR_STAT="ON"; TOR_COL="$GREEN"; TOR_ICON="●"; else TOR_STAT="OFF"; TOR_COL="$RED"; TOR_ICON="○"; fi
    if is_rotator_active; then ROT_STAT="ON"; ROT_COL="$MAUVE"; else ROT_STAT="OFF"; ROT_COL="$RED"; fi

    PROMPT="Tor $TOR_ICON | Rotator [$ROT_STAT]"
    MAIN_OPTIONS="🛠 Setup & Config\n⚙️ Rotation Control\n🛡 Security & Logs\n🚀 Launch Browser\n🗑 Advanced / Uninstall\n🚪 Exit"
    
    CATEGORY=$(echo -e "$MAIN_OPTIONS" | rofi -dmenu -i -p "$PROMPT" -theme-str "$ROFI_THEME prompt { text-color: $TOR_COL; }")

    [[ -z "$CATEGORY" || "$CATEGORY" == *"Exit"* ]] && exit 0
    notify-send "Tor Manager" "Opening: $CATEGORY"

    case "$CATEGORY" in
        *"Setup & Config"*)
            SUB=$(echo -e "🌐 Install Firefox Browser\n⚙️ Install Tor / Setup\n🦊 Configure Firefox Profile\n↩ Back" | rofi -dmenu -i -p "Setup" -theme-str "$ROFI_THEME")
            [[ -z "$SUB" || "$SUB" == *"Back"* ]] && continue
            notify-send "Tor Manager" "Selected: $SUB"

            if [[ "$SUB" == *"Firefox Browser"* ]]; then
                run_in_term "Install Firefox" "sudo pacman -S --needed --noconfirm firefox"
            elif [[ "$SUB" == *"Tor / Setup"* ]]; then
                run_in_term "Tor Setup" "sudo pacman -S --needed --noconfirm tor curl jq xxd openbsd-netcat libnotify; sudo usermod -aG tor $USER; if ! grep -q 'ControlPort 9051' /etc/tor/torrc; then echo -e '\nControlPort 9051\nCookieAuthentication 1\nCookieAuthFileGroupReadable 1' | sudo tee -a /etc/tor/torrc; sudo systemctl restart tor; fi; sudo systemctl enable --now tor"
            elif [[ "$SUB" == *"Configure Firefox"* ]]; then
                run_in_term "Firefox Config" "firefox -CreateProfile '$FIREFOX_PROFILE' >/dev/null 2>&1 || true; PROFILE_PATH=\$(awk -F= '/Path=/ {print \$2; exit}' \$HOME/.mozilla/firefox/profiles.ini); USER_JS=\"\$HOME/.mozilla/firefox/\$PROFILE_PATH/user.js\"; echo 'user_pref(\"network.proxy.type\", 1);' > \"\$USER_JS\"; echo 'user_pref(\"network.proxy.socks\", \"127.0.0.1\");' >> \"\$USER_JS\"; echo 'user_pref(\"network.proxy.socks_port\", 9050);' >> \"\$USER_JS\"; echo 'user_pref(\"network.proxy.socks_remote_dns\", true);' >> \"\$USER_JS\""
            fi
            ;;

        *"Rotation Control"*)
            SUB=$(echo -e "▶️ Start Tor + Rotator\n⏹️ Stop Tor + Rotator\n🔄 Manual IP Rotate\n⏱️ Change Interval\n↩ Back" | rofi -dmenu -i -p "Control" -theme-str "$ROFI_THEME")
            [[ -z "$SUB" || "$SUB" == *"Back"* ]] && continue
            notify-send "Tor Manager" "Selected: $SUB"

            if [[ "$SUB" == *"Start"* ]]; then
                sudo systemctl start tor.service
                systemctl --user enable --now "$SERVICE_NAME"
                notify-send "Tor Manager" "Routing Started."
            elif [[ "$SUB" == *"Stop"* ]]; then
                # FIX: Explicitly stop the system routing and the user rotator[cite: 3]
                systemctl --user stop "$SERVICE_NAME"
                sudo systemctl stop tor.service
                notify-send "Tor Manager" "Routing Stopped Completely."
            elif [[ "$SUB" == *"Manual"* ]]; then
                run_in_term "Manual Rotation" "cookie=\$(sudo xxd -ps /var/run/tor/control.authcookie | tr -d '\n'); printf 'AUTHENTICATE %s\r\nSIGNAL NEWNYM\r\nQUIT\r\n' \"\$cookie\" | nc 127.0.0.1 9051; sleep 1; new_ip=\$(curl -sf --socks5-hostname 127.0.0.1:9050 https://check.torproject.org/api/ip | jq -r '.IP'); echo -e 'New IP: \e[32m'\$new_ip'\e[0m'"
            elif [[ "$SUB" == *"Interval"* ]]; then
                new_int=$(zenity --entry --title="Interval" --text="Seconds (default 30):")
                [[ -n "$new_int" ]] && sed -i "s/RestartSec=.*/RestartSec=$new_int/" "$SERVICE_FILE" && systemctl --user daemon-reload && systemctl --user restart "$SERVICE_NAME" && notify-send "Tor Manager" "Interval Updated."
            fi
            ;;

        *"Security & Logs"*)
            SUB=$(echo -e "🔍 Show Current IP\n🛡️ Verify Tor Connection\n💧 Multi-DNS Leak Check\n📜 View Logs\n↩ Back" | rofi -dmenu -i -p "Security" -theme-str "$ROFI_THEME")
            [[ -z "$SUB" || "$SUB" == *"Back"* ]] && continue
            notify-send "Tor Manager" "Selected: $SUB"

            if [[ "$SUB" == *"Show Current IP"* ]]; then
                run_in_term "IP Check" "curl -sf --socks5-hostname 127.0.0.1:9050 https://check.torproject.org/api/ip | jq -r '\"Exit IP: \(.IP)\\nStatus: Using Tor: \(.IsTor)\"'"
            elif [[ "$SUB" == *"Verify"* ]]; then
                run_in_term "Verification" "curl -sf --socks5-hostname 127.0.0.1:9050 https://check.torproject.org/api/ip | jq '.'"
            elif [[ "$SUB" == *"Multi-DNS"* ]]; then
                run_in_term "Multi-DNS Leak Test" "
                    echo -e '\e[34m[1/3] Checking Tor Exit Status...\e[0m'
                    curl -s --socks5-hostname 127.0.0.1:9050 https://check.torproject.org/api/ip | jq -r '\"IP: \\(.IP)\\nTor: \\(.IsTor)\"'
                    echo -e '\n\e[34m[2/3] Checking IP-API (Location & ISP)...\e[0m'
                    curl -s --socks5-hostname 127.0.0.1:9050 http://ip-api.com/json/ | jq -r '\"IP: \\(.query)\\nISP: \\(.isp)\\nCity: \\(.city)\"'
                    echo -e '\n\e[34m[3/3] Checking DNS Resolver...\e[0m'
                    DNS_RES=\$(curl -s --socks5-hostname 127.0.0.1:9050 https://edns.ip-api.com/json | jq -r '.dns.ip')
                    echo -e \"DNS IP: \$DNS_RES\"
                    [[ \"\$DNS_RES\" == \"\$(curl -s ifconfig.me)\" ]] && echo -e '\e[31m⚠ LEAK DETECTED!\e[0m' || echo -e '\e[32m✔ SECURE\e[0m'
                "
            elif [[ "$SUB" == *"View Logs"* ]]; then
                run_in_term "Logs" "tail -n 20 $STATE_DIR/ip.log 2>/dev/null || echo 'No logs found.'"
            fi
            ;;

        *"Launch Browser"*)
            notify-send "Tor Manager" "Launching Tor Firefox..."
            nohup firefox -P "$FIREFOX_PROFILE" --no-remote >/dev/null 2>&1 &
            ;;

        *"Uninstall"*)
            if zenity --question --text="Uninstall everything?"; then
                run_in_term "Uninstallation" "systemctl --user disable --now $SERVICE_NAME; sudo systemctl disable --now tor; rm -rf $STATE_DIR $SERVICE_FILE $CORE_SCRIPT; systemctl --user daemon-reload"
            fi
            ;;
    esac
done