{ config, pkgs, ... }:

let
  # Rosé Pine palette - this is the source of truth for all app theming
  palette = {
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
  # Export colors to other modules via theme.colors options
  theme.colors = palette;

  programs.noctalia-shell = {
    enable = true;
    systemd.enable = true;

    # Material Design 3 tokens mapped from palette
    colors = {
      mPrimary = palette.iris;           # primary accent
      mOnPrimary = palette.base;         # text on primary
      mSecondary = palette.foam;         # secondary accent
      mOnSecondary = palette.base;       # text on secondary
      mTertiary = palette.rose;          # tertiary accent
      mOnTertiary = palette.base;        # text on tertiary
      mError = palette.love;             # error state
      mOnError = palette.base;           # text on error
      mSurface = palette.surface;        # main background
      mOnSurface = palette.text;         # main text color
      mSurfaceVariant = palette.overlay; # elevated surfaces
      mOnSurfaceVariant = palette.subtle; # secondary text
      mOutline = palette.muted;          # borders
      mShadow = "#000000";               # shadow color
      mHover = palette.highlightMed;     # hover state
      mOnHover = palette.text;           # text on hover
    };

    # Settings are largely managed via Noctalia's built-in GUI
    # Only specify overrides here if needed
    settings = {
      # Compositor detection (niri is auto-detected, but explicit is fine)
      compositor = "niri";
      # Weather location (city name, will be geocoded automatically)
      location = {
        name = "New York";  # Change to your city
      };
      # Terminal command for launching Terminal=true desktop apps
      appLauncher = {
        terminalCommand = "wezterm start --";
      };
      # Bar widget layout
      bar = {
        right = [ "world-clock" "clock" ];
      };
    };
  };

  # Noctalia plugin configuration
  xdg.configFile = {
    # Enabled plugins (keybind-cheatsheet, tailscale, world-clock)
    "noctalia/plugins.json".source = ./noctalia-plugins/plugins.json;

    # World clock plugin - symlink individual files so settings.json can be written at runtime
    "noctalia/plugins/world-clock/Main.qml".source = ./noctalia-plugins/world-clock/Main.qml;
    "noctalia/plugins/world-clock/BarWidget.qml".source = ./noctalia-plugins/world-clock/BarWidget.qml;
    "noctalia/plugins/world-clock/Settings.qml".source = ./noctalia-plugins/world-clock/Settings.qml;
    "noctalia/plugins/world-clock/manifest.json".source = ./noctalia-plugins/world-clock/manifest.json;
    "noctalia/plugins/world-clock/i18n".source = ./noctalia-plugins/world-clock/i18n;
  };
}
