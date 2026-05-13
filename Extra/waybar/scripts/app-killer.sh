#!/usr/bin/env bash
# ============================================================================
# Omarchy Task Manager - Header Edition
# - Fixed UI with visible column labels
# - Top usage apps on top
# ============================================================================

# Colors from your Omarchy palette
MAUVE="#c6a0f6"
BASE="#24273a"
TEXT="#cad3f5"
SURFACE="#363a4f"
RED="#ed8796"
SUBTEXT="#a5adce"

# Transparent Variants for selection glow
MAUVE_GLOW="#c6a0f626" 

# 1. Fetch process list, filter system apps, and sort
# Columns: PID (7s), CPU (9s), RAM (9s), COMMAND
process_data=$(ps -eo pid,pcpu,pmem,comm --sort=-pcpu --no-headers | \
    grep -vE "(Hyprland|waybar|swaync|dbus|systemd|kworker|sh|ps|awk|grep|rofi)" | \
    awk '{printf "%-7s  %-8s  %-8s  %s\n", $1, $2"%", $3"%", $4}')

# 2. Launch Rofi with Headers
selected=$(echo -e "$process_data" | rofi -dmenu \
    -i -p "󰓅 Tasks" \
    -kb-cancel "Escape,MouseSecondary,MousePrimary" \
    -theme-str "window { width: 50%; border: 2px; border-color: $MAUVE; border-radius: 14px; background-color: $BASE; padding: 15px; }" \
    -theme-str "inputbar { children: [prompt, entry]; background-color: $SURFACE; border-radius: 10px; padding: 8px; margin: 0 0 10px 0; }" \
    -theme-str "entry { text-color: $TEXT; placeholder: \"Search processes...\"; placeholder-color: $SUBTEXT; }" \
    -theme-str "prompt { text-color: $MAUVE; font: \"JetBrainsMono Nerd Font Bold 11\"; margin: 0 10px 0 5px; }" \
    -theme-str "listview { lines: 10; scrollbar: false; }" \
    -theme-str "element { border-radius: 8px; padding: 8px; text-color: $TEXT; }" \
    -theme-str "element selected { background-color: $MAUVE_GLOW; text-color: $MAUVE; border: 1px; border-color: $MAUVE; }" \
    -header-line " PID      CPU USAGE  RAM USAGE  APPLICATION")

[[ -z "$selected" ]] && exit 0

pid=$(echo "$selected" | awk '{print $1}')
pname=$(echo "$selected" | awk '{print $4}')

# 3. Execution Protocol
action=$(echo -e "🛑 Terminate (SIGTERM)\n🔪 Force Kill (SIGKILL)\n↩ Cancel" | rofi -dmenu \
    -i -p "Kill $pname?" \
    -kb-cancel "Escape,MouseSecondary,MousePrimary" \
    -theme-str "window { width: 30%; border: 2px; border-color: $RED; border-radius: 14px; background-color: $BASE; padding: 15px; }" \
    -theme-str "element selected { background-color: ${RED}33; text-color: $RED; border: 1px; border-color: $RED; }")

case "$action" in
    *"Terminate"*) kill "$pid" && notify-send "Task Manager" "Sent SIGTERM" ;;
    *"Kill"*) kill -9 "$pid" && notify-send "Task Manager" "Sent SIGKILL" ;;
esac