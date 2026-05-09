#!/bin/bash

# --- CONFIGURATION (Use simple Hex) ---
COLOR_BARS="#f5a279"   # Peach
COLOR_TITLE="#89dceb"  # Sky Blue
COLOR_ARTIST="#b4befe" # Lavender

# Redirect all errors to /dev/null so they don't show on screen
exec 2>/dev/null

# 1. Get the active player
get_active_player() {
    local player=$(playerctl --list-all | while read -r p; do
        if [ "$(playerctl -p "$p" status 2>/dev/null)" = "Playing" ]; then
            echo "$p"
            exit 0
        fi
    done)
    # If no player is playing, just get the first one available
    echo "${player:-$(playerctl --list-all | head -1)}"
}

# 2. Clean text for Hyprlock (Pango Markup)
sanitize() {
    local str="$1"
    # Essential: Escape characters that break Pango
    str="${str//&/&amp;}"
    str="${str//</&lt;}"
    str="${str//>/&gt;}"
    str="${str//\"/&quot;}"
    str="${str//\'/&apos;}"
    echo -n "$str"
}

# 3. Big Symmetrical Animation
get_bars() {
    local player=$(get_active_player)
    [ -z "$player" ] && return
    
    local status=$(playerctl -p "$player" status 2>/dev/null)
    if [ "$status" = "Playing" ]; then
        local t=$(( $(date +%s%N) / 200000000 )) 
        local frame=$(( t % 4 ))
        case $frame in
            0) local b="▃ ▆ █ ▆" ;;
            1) local b="▆ █ ▆ ▃" ;;
            2) local b="█ ▆ ▃ ▆" ;;
            3) local b="▆ ▃ ▆ █" ;;
        esac
        echo -n "<span size='large' color='$COLOR_BARS'>$b</span>"
    else
        echo -n "<span size='large' color='$COLOR_BARS'>󰏤</span>"
    fi
}

# 4. The Music Name and Artist
get_music_info() {
    local player=$(get_active_player)
    
    # Check if a player actually exists
    if [ -z "$player" ]; then
        echo -n "No Media Playing"
        return
    fi

    # Fetch Title and Artist
    local title=$(playerctl -p "$player" metadata --format "{{title}}" 2>/dev/null)
    local artist=$(playerctl -p "$player" metadata --format "{{artist}}" 2>/dev/null)

    # If title is empty, use filename or "Unknown"
    [ -z "$title" ] && title="Unknown Track"
    [ -z "$artist" ] && artist="Unknown Artist"

    # Truncate long names to prevent layout breaking
    [ ${#title} -gt 25 ] && title="${title:0:22}..."
    [ ${#artist} -gt 20 ] && artist="${artist:0:17}..."

    # Clean the strings
    local c_title=$(sanitize "$title")
    local c_artist=$(sanitize "$artist")

    # The Final Pango String
    echo -n "<span weight='bold' color='$COLOR_TITLE'>$c_title</span> <span color='$COLOR_ARTIST'>by $c_artist</span>"
}

# --- MAIN OUTPUT ---
# Check if playerctl can even see a player
if ! playerctl status &>/dev/null; then
    echo "󰎆  Silence"
else
    # Combine BARS + INFO + BARS
    BARS=$(get_bars)
    INFO=$(get_music_info)
    echo -e "${BARS}   ${INFO}   ${BARS}"
fi