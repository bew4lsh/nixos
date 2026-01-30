{ config, pkgs, ... }:

let
  # Rose Pine colors
  colors = {
    base = "#191724";
    surface = "#1f1d2e";
    overlay = "#26233a";
    muted = "#6e6a86";
    subtle = "#908caa";
    text = "#e0def4";
    love = "#eb6f92";
    gold = "#f6c177";
    rose = "#ebbcba";
    pine = "#31748f";
    foam = "#9ccfd8";
    iris = "#c4a7e7";
    highlightLow = "#21202e";
    highlightMed = "#403d52";
    highlightHigh = "#524f67";
  };
in
{
  programs.noctalia-shell = {
    enable = true;
    systemd.enable = true;

    # Rose Pine color scheme
    colors = {
      # Background colors
      bg = {
        primary = colors.base;
        secondary = colors.surface;
        tertiary = colors.overlay;
      };

      # Foreground/text colors
      fg = {
        primary = colors.text;
        secondary = colors.subtle;
        tertiary = colors.muted;
      };

      # Accent colors
      accent = {
        primary = colors.iris;
        secondary = colors.foam;
        tertiary = colors.rose;
      };

      # Semantic colors
      semantic = {
        error = colors.love;
        warning = colors.gold;
        success = colors.pine;
        info = colors.foam;
      };

      # Border/highlight colors
      border = {
        primary = colors.highlightMed;
        secondary = colors.highlightLow;
        active = colors.iris;
      };
    };

    # General settings
    settings = {
      # Bar configuration
      bar = {
        position = "top";
        height = 32;
        margin = {
          top = 4;
          left = 8;
          right = 8;
          bottom = 0;
        };
        borderRadius = 10;
      };

      # Font configuration
      font = {
        family = "JetBrainsMono Nerd Font";
        size = 13;
      };

      # Module configuration
      modules = {
        workspaces = {
          enable = true;
        };
        clock = {
          enable = true;
          format = "%H:%M";
          formatAlt = "%A, %B %d, %Y";
        };
        cpu = {
          enable = true;
        };
        memory = {
          enable = true;
        };
        network = {
          enable = true;
        };
        audio = {
          enable = true;
        };
        tray = {
          enable = true;
        };
      };

      # Compositor integration
      compositor = "niri";
    };
  };
}
