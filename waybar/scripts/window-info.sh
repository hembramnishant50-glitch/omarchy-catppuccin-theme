#!/bin/bash

# --- CONFIGURATION ---
APP_LIMIT=12
TITLE_LIMIT=18

# 1. SMART WORKSPACE HIDE LOGIC[cite: 1, 2]
# Hides window-info if Spotify is playing AND we are on its workspace
CURRENT_WS=$(hyprctl activeworkspace -j | jq -r '.id')
SPOTIFY_WS=$(hyprctl clients -j | jq -r '.[] | select(.class=="Spotify" or .initialClass=="Spotify") | .workspace.id' | head -1)
PLAYER_STATUS=$(playerctl -p spotify status 2>/dev/null)

if [ "$PLAYER_STATUS" = "Playing" ] && [ "$CURRENT_WS" == "$SPOTIFY_WS" ]; then
    echo ""
    exit 0
fi

# 2. GET WINDOW DATA[cite: 1]
WINDOW_DATA=$(hyprctl activewindow -j)
CLASS=$(echo "$WINDOW_DATA" | jq -r '.class' | tr '[:upper:]' '[:lower:]')
TITLE=$(echo "$WINDOW_DATA" | jq -r '.title')

if [ "$CLASS" == "null" ] || [ -z "$CLASS" ]; then
    echo "{\"text\": \"󰣇 Omarchy\", \"tooltip\": \"Desktop\"}"
    exit 0
fi

# 3. PWA URL CLEANER[cite: 1]
if [[ "$CLASS" == chrome-* ]]; then
    PWA_NAME=$(echo "$CLASS" | sed -E 's/chrome-.*\.([a-z0-9-]+)\.com.*/\1/')
    [[ "$PWA_NAME" == "www" ]] && PWA_NAME=$(echo "$CLASS" | sed -E 's/chrome-www\.([^.]*)\..*/\1/')
    CLASS="$PWA_NAME"
fi

# 4. MASTER MAPPING (Colorless)[cite: 1]
case "$CLASS" in
    # --- Google & Proton ---
    *google-chrome*) ICON=""; NAME="Chrome" ;;
    *google-gmail*|*chrome-mail.google.com*) ICON="󰊭"; NAME="Gmail" ;;
    *google-drive*|*chrome-drive.google.com*) ICON="󰝰"; NAME="Drive" ;;
    *google-calendar*|*chrome-calendar.google.com*) ICON="󰸗"; NAME="Calendar" ;;
    *google-keep*|*chrome-keep.google.com*) ICON="󰟶"; NAME="Keep" ;;
    *google-maps*) ICON="󰉙"; NAME="Maps" ;;
    *google-docs*|*chrome-docs.google.com*) ICON="󰈙"; NAME="Docs" ;;
    *google-sheets*|*chrome-sheets.google.com*) ICON="󰈛"; NAME="Sheets" ;;
    *google-slides*|*chrome-slides.google.com*) ICON="󰈧"; NAME="Slides" ;;
    *google-meet*|*chrome-meet.google.com*) ICON="󰻵"; NAME="Meet" ;;
    *google-photos*|*chrome-photos.google.com*) ICON="󰄄"; NAME="Photos" ;;
    *google-youtube*|*chrome-youtube.com*) ICON="󰗃"; NAME="YouTube" ;;
    *chrome-www.google.com*) ICON=""; NAME="Google" ;;
    *notebooklm*) ICON="󰠮"; NAME="NotebookLM" ;;
    *proton-mail*|*chrome-mail.proton.me*) ICON="󰇮"; NAME="Proton Mail" ;;
    *proton-calendar*) ICON="󰸗"; NAME="Proton Calendar" ;;
    *proton-drive*) ICON="󰝰"; NAME="Proton Drive" ;;
    *proton-pass*) ICON="󰷖"; NAME="Proton Pass" ;;
    *proton-vpn*) ICON="󰖂"; NAME="Proton VPN" ;;

    # --- Student, Research & AI ---
    *clamui*|*io.github.linx_systems.clamui*) ICON="󰒃"; NAME="ClamUI" ;;
    *obsidian*|*md.obsidian.Obsidian*) ICON="󱓧"; NAME="Obsidian" ;;
    *anki*) ICON="󰮔"; NAME="Anki" ;;
    *zotero*) ICON="󱓷"; NAME="Zotero" ;;
    *libreoffice*) ICON="󰏆"; NAME="LibreOffice" ;;
    *onlyoffice*|*desktopeditors*) ICON="󰏆"; NAME="ONLYOFFICE" ;;
    *xournalpp*) ICON="󱞈"; NAME="Xournal++" ;;
    *foliate*) ICON="󰂵"; NAME="Foliate" ;;
    *chatgpt*) ICON="󰚩"; NAME="ChatGPT" ;;
    *gemini*) ICON=""; NAME="Gemini AI" ;;
    *claude*) ICON=""; NAME="Claude AI" ;;
    *perplexity*) ICON="󰚩"; NAME="Perplexity" ;;

    # --- Browsers ---
    *zen-browser*) ICON="󰈹"; NAME="Zen" ;;
    *firefox*) ICON=""; NAME="Firefox" ;;
    *librewolf*) ICON="󰈹"; NAME="LibreWolf" ;;
    *brave*) ICON="󰖟"; NAME="Brave" ;;
    *mullvad*) ICON="󰇚"; NAME="Mullvad" ;;
    *vivaldi*) ICON=""; NAME="Vivaldi" ;;

    # --- Social & Communication ---
    *discord*) ICON=""; NAME="Discord" ;;
    *telegram*|*ayugram*) ICON=""; NAME="Telegram" ;;
    *whatsapp*) ICON=""; NAME="WhatsApp" ;;
    *signal*) ICON="󰭹"; NAME="Signal" ;;
    *reddit*) ICON=""; NAME="Reddit" ;;

    # --- Development & System ---
    *code*|*vscodium*) ICON="󰨞"; NAME="VS Code" ;;
    *ghostty*|*kitty*|*alacritty*) ICON=""; NAME="Terminal" ;;
    *nvim*) ICON=""; NAME="Neovim" ;;
    *missioncenter*) ICON="󱓟"; NAME="Mission Center" ;;
    *warehouse*) ICON=""; NAME="Warehouse" ;;
    *bitwarden*) ICON="󰞀"; NAME="Bitwarden" ;;
    *nautilus*|*dolphin*|*thunar*) ICON=""; NAME="Files" ;;

    # --- Media & Gaming ---
    *vlc*) ICON="󰕼"; NAME="VLC" ;;
    *gimp*) ICON=""; NAME="GIMP" ;;
    *inkscape*) ICON=""; NAME="Inkscape" ;;
    *spotify*) ICON=""; NAME="Spotify" ;;
    *minecraft*) ICON="󰍳"; NAME="Minecraft" ;;
    *retroarch*) ICON="󰊴"; NAME="RetroArch" ;;

    # --- FALLBACK ---
    *) 
        ICON="󱂬"
        NAME=$(echo "$CLASS" | awk -F '.' '{print $NF}')
        NAME="${NAME^}"
        ;;
esac

# 5. SMART TITLE CLEANING[cite: 1]
CLEAN_TITLE=$(echo "$TITLE" | sed -E 's/ — Mozilla Firefox| - Google Chrome| - Brave| - Visual Studio Code| — Zen Browser| - Discord| - YouTube//g')

# 6. WEB APP LOGIC[cite: 1]
WEB_MATCH=$(echo "$TITLE" | grep -oP "(WhatsApp|ChatGPT|Gmail|Reddit|GitHub|Gemini|Claude|Proton|AI Studio|Google AI Studio|Netflix|Twitch|Notion|Instagram)" | head -1)

if [ ! -z "$WEB_MATCH" ]; then
    NAME="$WEB_MATCH"
    [[ "$NAME" == "Google AI Studio" ]] && NAME="AI Studio"
    
    case "$NAME" in
        "AI Studio"|"Gemini") ICON="" ;;
        "WhatsApp") ICON="" ;;
        "ChatGPT") ICON="󰚩" ;;
        "Reddit") ICON="" ;;
        "GitHub") ICON="󰊤" ;;
        "YouTube") ICON="󰗃" ;;
        "Gmail") ICON="󰊭" ;;
    esac
    echo "{\"text\": \"$ICON $NAME\", \"tooltip\": \"$TITLE\"}"
    exit 0
fi

# 7. REGULAR APP LOGIC[cite: 1]
if [ ${#NAME} -gt $APP_LIMIT ]; then NAME="${NAME:0:$APP_LIMIT}.."; fi
if [ ${#CLEAN_TITLE} -gt $TITLE_LIMIT ]; then
    SHORT_TITLE="${CLEAN_TITLE:0:$TITLE_LIMIT}.."
else
    SHORT_TITLE="$CLEAN_TITLE"
fi

if [[ "$CLASS" =~ (firefox|chrome|brave|zen|vivaldi) ]]; then
    echo "{\"text\": \"$ICON $SHORT_TITLE\", \"tooltip\": \"$TITLE\"}"
else
    echo "{\"text\": \"$ICON $NAME | $SHORT_TITLE\", \"tooltip\": \"$CLASS: $TITLE\"}"
fi