#!/usr/bin/env bash

# --- SPOTIFY OVERRIDE ---
# Check if Spotify is playing. If it is, output nothing and exit immediately.
spotify_status=$(playerctl -p spotify status 2>/dev/null)
if [[ "$spotify_status" == "Playing" ]]; then
    echo ""
    exit 0
fi

# --- GET ACTIVE WINDOW ---
# Get the active window class from Hyprland
class=$(hyprctl activewindow 2>/dev/null | grep "class: " | awk '{print $2}')

# If there is no active window (e.g., on an empty workspace), show the Omarchy default
if [[ -z "$class" ]]; then
    echo "󱄅 Omarchy"
    exit 0
fi

# Match the class to your custom icons and names
case "$class" in
    # --- UNIVERSAL WEB APPS (PWAs) ---
    *chatgpt.com*)          app_name="󰚩 ChatGPT" ;;
    *gemini.google.com*)    app_name="󰊭 Gemini AI" ;;
    *claude.ai*)            app_name="󰘳 Claude AI" ;;
    *perplexity.ai*)        app_name="󰭹 Perplexity" ;;
    *deepseek.com*)         app_name="󰠧 DeepSeek" ;;
    *notebooklm.google.com*) app_name="󰠮 NotebookLM" ;;
    *mail.google.com*)      app_name="󰇮 Gmail" ;;
    *drive.google.com*)     app_name="󰏫 Drive" ;;
    *calendar.google.com*)  app_name="󰃭 Calendar" ;;
    *keep.google.com*)      app_name="󰟶 Keep" ;;
    *maps.google.com*) app_name="󰉙 Maps" ;;
    *docs.google.com*)      app_name="󰈙 Docs" ;;
    *sheets.google.com*)    app_name="󱎏 Sheets" ;;
    *slides.google.com*)    app_name="󰐨 Slides" ;;
    *meet.google.com*)      app_name="󰘪 Meet" ;;
    *photos.google.com*) app_name="󰄄 Photos" ;;
    *youtube.com*)          app_name="󰗃 YouTube" ;;
    *mail.proton.me*)       app_name="󰇮 Proton Mail" ;;
    *drive.proton.me*)      app_name="󱑢 Proton Drive" ;;
    *calendar.proton.me*)   app_name="󰃭 Proton Calendar" ;;
    *pass.proton.me*)       app_name="󰷛 Proton Pass" ;;
    *protonvpn.com*)        app_name="󰒄 Proton VPN" ;;
    *wallet.proton.me*)     app_name="󱠔 Proton Wallet" ;;
    *outlook.office.com*)   app_name="󰇮 Outlook" ;;
    *teams.microsoft.com*)  app_name="󰊻 Teams" ;;
    *onedrive.live.com*)    app_name="󰏫 OneDrive" ;;
    *office.com*)           app_name="󰏆 Microsoft 365" ;;
    *app.zoom.us*)          app_name="󰘪 Zoom" ;;
    *web.whatsapp.com*)     app_name=" WhatsApp" ;;
    *github.com*)           app_name="󰊤 GitHub" ;;
    *stackoverflow.com*)    app_name="󰓌 Stack Overflow" ;;
    *notion.so*)            app_name="󰇈 Notion" ;;
    *canva.com*)            app_name="󰕑 Canva" ;;
    *figma.com*)            app_name="󰈔 Figma" ;;
    *discord.com*)          app_name="󰙯 Discord" ;;
    *reddit.com*)           app_name="󰑍 Reddit" ;;
    *spotify.com*) app_name="󰓇 Spotify" ;;
    *google.com*)           app_name=" Google Search" ;;

    # --- OMARCHY ECOSYSTEM ---
    "org.omarchy.terminal") app_name=" Terminal" ;;
    "omarchy-launch-audio"|"org.omarchy.wiremix"|"pavucontrol") app_name="󰓃 Audio" ;;
    "omarchy-launch-wifi"|"org.omarchy.impala") app_name="󰖩 WiFi" ;;
    "org.omarchy.lazydocker") app_name="󰡨 Lazydocker" ;;
    "omarchy-cleaner"|"org.bleachbit.BleachBit"|"bleachbit-root") app_name="󰃢 Cleaner" ;;

    # --- SYSTEM, SHELL & TERMINALS ---
    "waybar")               app_name="󱑆 Waybar" ;;
    "walker")               app_name="󰀻 Walker" ;;
    "ghostty"|"com.mitchellh.ghostty") app_name=" Ghostty" ;;
    "kitty")                app_name=" Kitty" ;;
    "alacritty")            app_name=" Alacritty" ;;

    # --- BROWSERS ---
    "google-chrome"|"chromium") app_name=" Chrome" ;;
    "firefox")              app_name=" Firefox" ;;
    "brave-browser")        app_name=" Brave" ;;
    "librewolf")            app_name="󰈹 LibreWolf" ;;
    "vivaldi")              app_name=" Vivaldi" ;;

    # --- OFFICE SUITES ---
    *libreoffice*|*LibreOffice*|*Libreoffice-startcenter*|"org.libreoffice.LibreOffice") app_name="󰏆 LibreOffice" ;;
    "onlyoffice-desktopeditors"|*onlyoffice*) app_name="󰏆 ONLYOFFICE" ;;
    "textmaker"|*textmaker*|"planmaker"|*planmaker*|"presentations"|*presentations*|"freeoffice"|*freeoffice*) app_name="󰏆 FreeOffice" ;;
    "wps"|"et"|"wpp"|"wpspdf"|*wps-office*) app_name="󰏆 WPS Office" ;;
    "soffice"|*openoffice*) app_name="󰏆 OpenOffice" ;;

    # --- LINUX NATIVE & DESKTOP APPS ---
    "gnome-control-center"|"systemsettings") app_name="⚙️ Settings" ;;
    "org.gnome.Nautilus"|"thunar"|"dolphin") app_name=" Files" ;;
    "org.gnome.clocks")     app_name="󱎫 Clocks" ;;
    "code"|"com.visualstudio.code") app_name="󰨞 VS Code" ;;
    "nvim")                 app_name=" Neovim" ;;
    "vim")                  app_name=" Vim" ;;
    "obsidian"|"md.obsidian.Obsidian") app_name="󱓧 Obsidian" ;;
    "com.github.xournalpp.xournalpp") app_name="󱞈 Xournal++" ;;

    # --- COMMUNICATION & SOCIAL ---
    "discord"|"com.discordapp.Discord"|"dev.vencord.Vesktop"|"Vesktop") app_name="󰙯 Discord" ;;
    "org.telegram.desktop"|"com.ayugram.desktop") app_name=" Telegram" ;;
    "whatsapp")             app_name=" WhatsApp" ;;
    "spotify")              app_name="󰓇 Spotify" ;;
    "vlc")                  app_name="󰕼 VLC" ;;

    # --- UTILITIES & MAINTENANCE ---
    "bitwarden"|"com.bitwarden.desktop") app_name="󰞀 Bitwarden" ;;
    "1password"|"com.onepassword.desktop") app_name="󰷛 1Password" ;;
    "com.github.tenderowl.frog") app_name="󰋚 Frog" ;;
    "qbittorrent")          app_name="󱑢 qBittorrent" ;;
    "io.github.kolunmi.Bazaar") app_name="󰀻 Bazaar" ;;
    "com.heroicgameslauncher.hgl.aethergazer") app_name="󱜙 Aether Gazer" ;;
    "aether"|"li.oever.aether") app_name="󰏫 Aether" ;;

    # --- DOWNLOAD MANAGERS ---
    *abdownloadmanager*|*ABDownloadManager*) app_name="󰇚 AB Manager" ;;

    # --- FALLBACK (Any app not listed above) ---
    *) 
        # Capitalize the first letter of the unknown window class
        app_name="${class^}"
        ;;
esac

# Output the matched name for Waybar to read
echo "$app_name"