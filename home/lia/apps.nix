{ config, pkgs, ... }:

let
  # Read colors from theme options (set by Noctalia in quickshell.nix)
  colors = config.theme.colors;

  # Generate Vesktop/Vencord CSS from Noctalia's colors
  rosePineCSS = ''
    /**
     * @name Rosé Pine
     * @description Rosé Pine theme for Discord/Vesktop
     */

    :root {
      /* Rosé Pine palette */
      --rp-base: ${colors.base};
      --rp-surface: ${colors.surface};
      --rp-overlay: ${colors.overlay};
      --rp-muted: ${colors.muted};
      --rp-subtle: ${colors.subtle};
      --rp-text: ${colors.text};
      --rp-love: ${colors.love};
      --rp-gold: ${colors.gold};
      --rp-rose: ${colors.rose};
      --rp-pine: ${colors.pine};
      --rp-foam: ${colors.foam};
      --rp-iris: ${colors.iris};
      --rp-highlight-low: ${colors.highlightLow};
      --rp-highlight-med: ${colors.highlightMed};
      --rp-highlight-high: ${colors.highlightHigh};
    }

    /* Main background */
    .theme-dark {
      --background-primary: var(--rp-base);
      --background-secondary: var(--rp-surface);
      --background-secondary-alt: var(--rp-overlay);
      --background-tertiary: var(--rp-surface);
      --background-accent: var(--rp-iris);
      --background-floating: var(--rp-overlay);
      --background-modifier-hover: var(--rp-highlight-low);
      --background-modifier-active: var(--rp-highlight-med);
      --background-modifier-selected: var(--rp-highlight-med);
      --background-modifier-accent: var(--rp-highlight-low);

      /* Text colors */
      --text-normal: var(--rp-text);
      --text-muted: var(--rp-muted);
      --text-link: var(--rp-foam);
      --header-primary: var(--rp-text);
      --header-secondary: var(--rp-subtle);
      --interactive-normal: var(--rp-subtle);
      --interactive-hover: var(--rp-text);
      --interactive-active: var(--rp-text);
      --interactive-muted: var(--rp-muted);

      /* Channels */
      --channels-default: var(--rp-subtle);
      --channel-icon: var(--rp-subtle);

      /* Brand colors */
      --brand-experiment: var(--rp-iris);
      --brand-experiment-560: var(--rp-iris);

      /* Status colors */
      --status-positive: var(--rp-pine);
      --status-warning: var(--rp-gold);
      --status-danger: var(--rp-love);

      /* Scrollbar */
      --scrollbar-thin-thumb: var(--rp-highlight-med);
      --scrollbar-thin-track: transparent;
      --scrollbar-auto-thumb: var(--rp-highlight-med);
      --scrollbar-auto-track: var(--rp-surface);

      /* Input */
      --input-background: var(--rp-overlay);
      --input-placeholder-text: var(--rp-muted);

      /* Misc */
      --channeltextarea-background: var(--rp-overlay);
      --activity-card-background: var(--rp-surface);
      --deprecated-card-bg: var(--rp-surface);
      --deprecated-quickswitcher-input-background: var(--rp-overlay);
      --elevation-stroke: var(--rp-highlight-low);
    }

    /* Mention highlights */
    .mentioned__58017 {
      background-color: rgba(235, 111, 146, 0.1) !important;
      border-left-color: var(--rp-love) !important;
    }

    /* Unread pill */
    .unread__04c06 {
      background-color: var(--rp-love) !important;
    }

    /* Selected channel */
    .modeSelected__0c56a {
      background-color: var(--rp-highlight-med) !important;
    }

    /* Buttons */
    .button__581d0.lookFilled__950dd.colorBrand_b48e19 {
      background-color: var(--rp-iris) !important;
    }

    .button__581d0.lookFilled__950dd.colorBrand_b48e19:hover {
      background-color: var(--rp-rose) !important;
    }
  '';
in
{
  home.packages = with pkgs; [
    # Communication - prefer vesktop for Wayland + Vencord
    vesktop
    signal-desktop
    wasistlos  # WhatsApp for Linux (formerly whatsapp-for-linux)

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
    evince     # PDF viewer (GTK)
    zathura    # PDF viewer (vim-like)
    foliate    # E-book reader

    # Image editing
    gimp
    inkscape

    # Screenshots (beyond basic grim/slurp)
    flameshot

    # System
    gnome-disk-utility
    baobab     # Disk usage analyzer

    # Archive manager
    file-roller

    # Misc
    qalculate-gtk  # Calculator
    gnome-clocks   # World clocks, timers
    gnome-weather  # Weather

    # Calendar
    kdePackages.merkuro  # Kalendar - Qt calendar app
  ];

  # Desktop entries with Wayland flags
  xdg.desktopEntries = {
    vesktop = {
      name = "Discord";
      genericName = "Internet Messenger";
      exec = "vesktop --enable-features=UseOzonePlatform --ozone-platform=wayland";
      icon = "vesktop";
      terminal = false;
      categories = [ "Network" "InstantMessaging" ];
    };

    obsidian = {
      name = "Obsidian";
      exec = "obsidian --enable-features=UseOzonePlatform --ozone-platform=wayland";
      icon = "obsidian";
      terminal = false;
      categories = [ "Office" ];
    };
  };

  # Vesktop/Vencord Rosé Pine theme
  # Theme CSS is managed by nix, but settings.json must be mutable for Vesktop to work
  xdg.configFile."vesktop/themes/rose-pine.css".text = rosePineCSS;

  # Obsidian Rosé Pine CSS snippet
  # Note: You need to enable CSS snippets in Obsidian settings
  # Settings > Appearance > CSS Snippets (at bottom)
  home.file.".config/obsidian/.rose-pine-snippet.css".text = ''
    /* Rosé Pine for Obsidian */
    /* Enable in Settings > Appearance > CSS Snippets */
    /* Or install the "Rosé Pine" community theme from Settings > Appearance > Themes */

    .theme-dark {
      --background-primary: #191724;
      --background-primary-alt: #1f1d2e;
      --background-secondary: #1f1d2e;
      --background-secondary-alt: #26233a;
      --background-modifier-border: #403d52;
      --background-modifier-form-field: #26233a;
      --background-modifier-form-field-highlighted: #403d52;
      --background-modifier-box-shadow: rgba(0, 0, 0, 0.3);
      --background-modifier-success: #31748f;
      --background-modifier-error: #eb6f92;
      --background-modifier-error-rgb: 235, 111, 146;
      --background-modifier-error-hover: #eb6f92;
      --background-modifier-cover: rgba(25, 23, 36, 0.8);
      --text-accent: #c4a7e7;
      --text-accent-hover: #ebbcba;
      --text-normal: #e0def4;
      --text-muted: #6e6a86;
      --text-faint: #6e6a86;
      --text-error: #eb6f92;
      --text-error-hover: #eb6f92;
      --text-highlight-bg: rgba(235, 111, 146, 0.2);
      --text-highlight-bg-active: rgba(235, 111, 146, 0.3);
      --text-selection: rgba(196, 167, 231, 0.3);
      --text-on-accent: #191724;
      --interactive-normal: #908caa;
      --interactive-hover: #e0def4;
      --interactive-accent: #c4a7e7;
      --interactive-accent-rgb: 196, 167, 231;
      --interactive-accent-hover: #ebbcba;
      --scrollbar-active-thumb-bg: #403d52;
      --scrollbar-bg: #1f1d2e;
      --scrollbar-thumb-bg: #26233a;
      --highlight-mix-blend-mode: lighten;
    }
  '';

  # Note about Obsidian theme
  home.file.".config/obsidian/.readme".text = ''
    Obsidian Rosé Pine Setup
    ========================

    Option 1: Community Theme (Recommended)
    1. Open Obsidian Settings (Ctrl+,)
    2. Go to Appearance > Themes
    3. Click "Manage" and search for "Rosé Pine"
    4. Install and enable it

    Option 2: CSS Snippet
    1. The rose-pine-snippet.css file is in this directory
    2. In Obsidian: Settings > Appearance > CSS Snippets
    3. Click the folder icon to open snippets folder
    4. Copy the rose-pine-snippet.css file there
    5. Enable it in the CSS Snippets section
  '';

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
}
