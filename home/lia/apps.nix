{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Communication
    discord
    # Or use vesktop for better Wayland support and Vencord built-in
    vesktop

    # Music
    spotify
    # Alternative: spotifyd + spotify-tui for terminal

    # Notes
    obsidian

    # Email
    thunderbird

    # Password manager
    bitwarden-desktop
    bitwarden-cli

    # Media
    vlc
    celluloid  # GTK frontend for mpv

    # Office
    libreoffice-fresh
    evince     # PDF viewer
    foliate    # E-book reader

    # Image editing
    gimp
    inkscape

    # Screenshots (beyond basic grim/slurp)
    flameshot  # More feature-rich screenshots

    # System
    gnome-disk-utility
    baobab     # Disk usage analyzer

    # Archive manager
    file-roller

    # Misc
    qalculate-gtk  # Calculator
    gnome-clocks   # World clocks, timers
    gnome-weather  # Weather
  ];

  # Discord/Vesktop Wayland flags
  xdg.desktopEntries = {
    discord = {
      name = "Discord";
      exec = "discord --enable-features=UseOzonePlatform --ozone-platform=wayland";
      icon = "discord";
      terminal = false;
      categories = [ "Network" "InstantMessaging" ];
    };

    vesktop = {
      name = "Vesktop";
      exec = "vesktop --enable-features=UseOzonePlatform --ozone-platform=wayland";
      icon = "vesktop";
      terminal = false;
      categories = [ "Network" "InstantMessaging" ];
    };

    spotify = {
      name = "Spotify";
      exec = "spotify";  # Uses native Wayland now
      icon = "spotify";
      terminal = false;
      categories = [ "Audio" "Music" ];
    };

    obsidian = {
      name = "Obsidian";
      exec = "obsidian --enable-features=UseOzonePlatform --ozone-platform=wayland";
      icon = "obsidian";
      terminal = false;
      categories = [ "Office" ];
    };
  };

  # Thunderbird profile settings
  programs.thunderbird = {
    enable = true;
    profiles.default = {
      isDefault = true;
      settings = {
        # Dark theme
        "extensions.activeThemeID" = "thunderbird-compact-dark@mozilla.org";

        # Privacy
        "mailnews.start_page.enabled" = false;
        "mail.shell.checkDefaultClient" = false;

        # Compose
        "mail.identity.default.compose_html" = false;
        "mail.SpellCheckBeforeSend" = true;
      };
    };
  };

  # Bitwarden auto-lock settings (via CLI)
  # Configure in the app: Settings > Security > Vault timeout
}
