#!/usr/bin/env bash

# Animation frames
frames=("󰎆" "󰎈" "󰎊" "󰎌")
i=0

while true; do
    # Check if Spotify is running and get status
    status=$(playerctl -p spotify status 2>/dev/null)
    
    if [[ "$status" == "Playing" ]]; then
        # Get the song title
        title=$(playerctl -p spotify metadata --format '{{title}}' 2>/dev/null)
        
        # Truncate title to 15 characters to save space on your small waybar
        if [ ${#title} -gt 15 ]; then
            title="${title:0:15}..."
        fi
        
        # Animate the icon
        icon="${frames[$i]}"
        echo "{\"text\": \"$icon $title\", \"class\": \"playing\"}"
        
        i=$(( (i + 1) % 4 ))
        sleep 0.5 # Animation speed
        
    elif [[ "$status" == "Paused" ]]; then
        echo "{\"text\": \"󰏤 Paused\", \"class\": \"paused\"}"
        sleep 2
    else
        # Hide the module completely when Spotify is not running
        echo "{\"text\": \"\", \"class\": \"stopped\"}"
        sleep 2
    fi
done
