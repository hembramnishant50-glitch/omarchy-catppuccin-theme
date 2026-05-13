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
    *app.zoom.us*)          app_name=" Zoom" ;;
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
    *launchpad.37signals.com*) app_name="󰓾 Basecamp" ;;
    *app.fizzy.do*) app_name="󰄬 Fizzy" ;;
    *app.hey.com*)            app_name="󰇮 HEY Mail" ;;
    *x.com*)                app_name=" X" ;;

    # --- OMARCHY ECOSYSTEM ---
    "org.omarchy.terminal") app_name=" Terminal" ;;
    "omarchy-launch-audio"|"org.omarchy.wiremix"|"pavucontrol") app_name="󰓃 Audio" ;;
    "omarchy-launch-wifi"|"org.omarchy.impala") app_name="󰖩 WiFi" ;;
    "org.omarchy.lazydocker") app_name="󰡨 Lazydocker" ;;
    "omarchy-cleaner"|"org.bleachbit.BleachBit"|"bleachbit-root") app_name="󰃢 Cleaner" ;;
    "aether"|"li.oever.aether") app_name="󰏫 Aether" ;;
    "Imv"|*imv*)              app_name="󰋩 Imv" ;;
    "Org.kde.kdenlive"|*kdenlive*) app_name="󱄢 Kdenlive" ;;
    "Localsend"|*localsend*)                app_name="󰩟 LocalSend" ;;
    "Mpv"|*mpv*)                            app_name=" MPV" ;;
    "Typora"|*typora*)                      app_name="󰽛 Typora" ;;
    "Com.github.PintaProject.Pinta"|*Pinta*)        app_name=" Pinta" ;;
    "System-config-printer"|*config-printer*)       app_name="󰐪 Printers" ;;
    "Python3"|*python3*)    app_name="󰌠 Python3" ;;
    "java"|*java*|*Java*)   app_name=" Java" ;;

    # --- SYSTEM, SHELL & TERMINALS ---
    "waybar")               app_name="󱑆 Waybar" ;;
    "walker")               app_name="󰀻 Walker" ;;
    "ghostty"|"com.mitchellh.ghostty") app_name=" Ghostty" ;;
    "kitty")                app_name=" Kitty" ;;
    "alacritty")            app_name=" Alacritty" ;;
    "Alacritty"|*alacritty*)                app_name=" Alacritty" ;;

    # --- BROWSERS ---
    "google-chrome"|"chromium") app_name=" Chrome" ;;
    "firefox")              app_name=" Firefox" ;;
    "brave-browser")        app_name=" Brave" ;;
    "librewolf")            app_name="󰈹 LibreWolf" ;;
    "vivaldi")              app_name=" Vivaldi" ;;
    "Brave-origin-beta"|*origin-beta*) app_name="󰖟 Brave Origin" ;;

    # --- GNOME APPS ---
    "gnome-control-center"|"org.gnome.Settings") app_name="⚙️ Settings" ;;
    "org.gnome.Nautilus")       app_name=" Files" ;;
    "gnome-terminal"|"org.gnome.Console") app_name=" Terminal" ;;
    "org.gnome.TextEditor"|"gedit") app_name="󰈙 Text Editor" ;;
    "org.gnome.Calculator")     app_name=" Calculator" ;;
    "org.gnome.Calendar")       app_name="󰃭 Calendar" ;;
    "org.gnome.Characters")     app_name="󰅩 Characters" ;;
    "org.gnome.clocks")         app_name="󱎫 Clocks" ;;
    "org.gnome.Contacts")       app_name="󰊤 Contacts" ;;
    "gnome-disks"|"org.gnome.DiskUtility") app_name="󰋊 Disks" ;;
    "evince"|"org.gnome.Evince") app_name="󰈙 Document Viewer" ;;
    "org.gnome.Extensions")     app_name="󰟖 Extensions" ;;
    "org.gnome.font-viewer")    app_name=" Fonts" ;;
    "yelp"|"org.gnome.Yelp")    app_name="󰋖 Help" ;;
    "eog"|"org.gnome.eog"|"org.gnome.Loupe") app_name="󰋩 Image Viewer" ;;
    "org.gnome.Logs")           app_name="󰒎 Logs" ;;
    "org.gnome.Maps")           app_name="󰉙 Maps" ;;
    "org.gnome.Music")          app_name="󰝚 Music" ;;
    "org.gnome.Photos")         app_name="󰄄 Photos" ;;
    "gnome-software"|"org.gnome.Software") app_name="󰮯 Software" ;;
    "gnome-system-monitor"|"org.gnome.SystemMonitor") app_name="󰒋 System Monitor" ;;
    "gnome-tweaks"|"org.gnome.tweaks") app_name="ﾰ Tweaks" ;;
    "totem"|"org.gnome.Totem")  app_name="󰕼 Videos" ;;
    "org.gnome.Weather")        app_name="󰖐 Weather" ;;
    "epiphany"|"org.gnome.Epiphany") app_name="󰖟 Web" ;;

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
    "Zoom"|*zoom*)          app_name=" Zoom" ;;

    # --- Games APPS ---
    "Minecraft-launcher"|*minecraft*) app_name="󰍳 Minecraft" ;;
    "Minecraft"|*minecraft*) app_name="󰍳 Minecraft" ;;

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
    "Org.cryptomator.launcher.Cryptomator"*|*cryptomator*) app_name="󰌆 Cryptomator" ;;
    "TUI.float"|*TUI.float*) app_name="󰕪 TUI Float" ;;
    "TUI.tile"|*TUI.tile*)   app_name="󰕪 TUI Tile" ;;
    "Nwg-look"|*nwg-look*)    app_name="󰏘 Nwg-Look" ;;
    "Fr.handbrake.ghb"|*handbrake*) app_name="󰕼 HandBrake" ;;
    "Org.bunkus.mkvtoolnix-gui"|*mkvtoolnix*) app_name="󰈫 MKVToolNix" ;;
    "Io.gitlab.adhami3310.Converter"|*Converter*) app_name="󰕡 Switcheroo" ;;

    # --- EXTRA APPS ---
    "Com.rafaelmardojai.Blanket"|*Blanket*) app_name="󰋋 Blanket" ;;
    "Dev.bragefuglseth.Keypunch.Devel"|*Keypunch*) app_name="󰌌 Keypunch" ;;


    # --- TOP FLATHUB / FLATPAK APPS ---
        "com.github.tchx84.Flatseal"|*Flatseal*) app_name="󰟆 Flatseal" ;;
        "com.obsproject.Studio"|*obsproject*) app_name="󰑊 OBS Studio" ;;
        "org.gimp.GIMP"|*gimp*)           app_name=" GIMP" ;;
        "org.kde.krita"|*krita*)          app_name=" Krita" ;;
        "org.inkscape.Inkscape"|*inkscape*) app_name=" Inkscape" ;;
        "org.blender.Blender"|*blender*)  app_name="󰂫 Blender" ;;
        "com.valvesoftware.Steam"|*steam*) app_name=" Steam" ;;
        "com.usebottles.bottles"|*bottles*) app_name="󱄄 Bottles" ;;
        "net.lutris.Lutris"|*lutris*)     app_name="󰊗 Lutris" ;;
        "com.heroicgameslauncher.hgl"|*heroic*) app_name="󰊗 Heroic" ;;
        "org.signal.Signal"|*signal*)     app_name="󰭹 Signal" ;;
        "com.slack.Slack"|*slack*)        app_name=" Slack" ;;
        "org.mozilla.Thunderbird"|*thunderbird*) app_name=" Thunderbird" ;;
        "com.getpostman.Postman"|*postman*) app_name="󰛮 Postman" ;;
        "com.vscodium.codium"|*vscodium*) app_name="󰨞 VSCodium" ;;
        "org.videolan.VLC"|*vlc*)         app_name="󰕼 VLC" ;;
        "com.stremio.Stremio"|*stremio*)  app_name="󰕼 Stremio" ;;
        "org.qbittorrent.qBittorrent"|*qbittorrent*) app_name="󱑢 qBittorrent" ;;
        "org.transmissionbt.Transmission"|*transmission*) app_name="󱑢 Transmission" ;;
        "org.audacityteam.Audacity"|*audacity*) app_name="󰎆 Audacity" ;;
        "com.spotify.Client"|*spotify*)   app_name="󰓇 Spotify" ;;
        "us.zoom.Zoom"|*zoom*)            app_name=" Zoom" ;;
        "com.anydesk.Anydesk"|*anydesk*)  app_name="󰢹 AnyDesk" ;;
        "com.teamviewer.TeamViewer"|*teamviewer*) app_name="󰢹 TeamViewer" ;;
        "Io.github.linx_systems.ClamUI"|*ClamUI*) app_name="󰕥 ClamUI" ;;
        "Dev.geopjr.Collision"|*Collision*) app_name="󰛿 Collision" ;;
        "App.drey.Dialect"|*Dialect*) app_name="󰗊 Dialect" ;;
        "Fingergo"|*Fingergo*)   app_name="󰆠 Fingergo" ;;
        "De.swsnr.keepmeawake"|*keepmeawake*) app_name="󰅎 Keep Me Awake" ;;
        "Io.github.vmkspv.lenspect"|*lenspect*) app_name="󰈈 Lenspect" ;;
        "Io.github.fabrialberio.pinapp"|*pinapp*) app_name="󰐃 PinApp" ;;
        "Garden.jamie.Morphosis"|*Morphosis*)   app_name="󱁉 Morphosis" ;;
        "Io.gitlab.theevilskeleton.Upscaler"|*Upscaler*) app_name="󰊕 Upscaler" ;;
        "Org.gnome.gitlab.YaLTeR.VideoTrimmer"|*VideoTrimmer*) app_name="󰆐 Video Trimmer" ;;
        "Io.github.flattool.Warehouse"|*Warehouse*)     app_name="󰏗 Warehouse" ;;
        
        

    # --- DOWNLOAD MANAGERS ---
    *abdownloadmanager*|*ABDownloadManager*) app_name="󰇚 AB Manager" ;;
    "Com-tonikelope-megabasterd-MainPanel"|*megabasterd*) app_name="󰏔 Megabasterd" ;;

    # --- TOR ---
    "Tor"|*tor*)            app_name="󰈹 Tor Browser" ;;

    # --- FALLBACK (Any app not listed above) ---
    *) 
        # Capitalize the first letter of the unknown window class
        app_name="${class^}"
        ;;
esac

# Output the matched name for Waybar to read
echo "$app_name"