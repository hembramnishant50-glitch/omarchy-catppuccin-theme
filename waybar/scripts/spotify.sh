#!/bin/bash

# --- Configuration ---
VISIBLE_LEN=20 
SLEEP_TIME=0.15 
bars=(" " "▂" "▃" "▄" "▅" "▆" "▇" "█")
scroll_pos=0
frame=0

while true; do
    # 1. Get Spotify Status[cite: 1]
    PLAYER_STATUS=$(playerctl -p spotify status 2>/dev/null)

    if [ "$PLAYER_STATUS" = "Playing" ]; then
        # 2. Workspace Logic[cite: 1]
        CURRENT_WS=$(hyprctl activeworkspace -j | jq -r '.id')
        SPOTIFY_WS=$(hyprctl clients -j | jq -r '.[] | select(.class=="Spotify" or .initialClass=="Spotify") | .workspace.id' | head -n 1)

        # 3. Animation Logic (Colors removed)[cite: 1]
        idx1=$(( (frame + 0) % 8 )); b1=${bars[$idx1]}
        idx2=$(( (frame + 3) % 8 )); b2=${bars[$idx2]}
        idx3=$(( (frame + 6) % 8 )); b3=${bars[$idx3]}
        ANIMATION="$b1$b2$b3"

        # 4. Content Logic[cite: 1]
        if [ "$CURRENT_WS" == "$SPOTIFY_WS" ]; then
            SONG=$(playerctl -p spotify metadata title)
            FULL_TEXT=" $SONG "
            
            # Scrolling Logic[cite: 1]
            if [ ${#FULL_TEXT} -gt $VISIBLE_LEN ]; then
                DISPLAY_TEXT="${FULL_TEXT:$scroll_pos:$VISIBLE_LEN}"
                if [ ${#DISPLAY_TEXT} -lt $VISIBLE_LEN ]; then
                    DISPLAY_TEXT="$DISPLAY_TEXT${FULL_TEXT:0:$((VISIBLE_LEN - ${#DISPLAY_TEXT}))}"
                fi
                scroll_pos=$(( (scroll_pos + 1) % ${#FULL_TEXT} ))
            else
                DISPLAY_TEXT="$FULL_TEXT"
                while [ ${#DISPLAY_TEXT} -lt $VISIBLE_LEN ]; do DISPLAY_TEXT="$DISPLAY_TEXT "; done
            fi
            echo "{\"text\": \" $ANIMATION <b>$DISPLAY_TEXT</b>\", \"class\": \"playing\"}"
        else
            echo "{\"text\": \" $ANIMATION\", \"class\": \"playing-compact\"}"
            scroll_pos=0 
        fi

        frame=$((frame + 1))
    elif [ "$PLAYER_STATUS" = "Paused" ]; then
        echo "{\"text\": \" 󰏤\", \"class\": \"paused\"}"[cite: 1]
    else
        echo "" 
    fi

    sleep $SLEEP_TIME
done