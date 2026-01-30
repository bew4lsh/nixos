{ config, pkgs, ... }:

{
  programs.noctalia-shell = {
    enable = true;
    systemd.enable = true;

    # Rosé Pine color scheme using Material Design 3 tokens
    # Reference: https://github.com/noctalia-dev/noctalia-colorschemes
    colors = {
      # Material Design 3 color tokens mapped to Rosé Pine
      mPrimary = "#c4a7e7";      # iris - primary accent
      mOnPrimary = "#191724";    # base - text on primary
      mSecondary = "#9ccfd8";    # foam - secondary accent
      mOnSecondary = "#191724";  # base - text on secondary
      mTertiary = "#ebbcba";     # rose - tertiary accent
      mOnTertiary = "#191724";   # base - text on tertiary
      mError = "#eb6f92";        # love - error state
      mOnError = "#191724";      # base - text on error
      mSurface = "#1f1d2e";      # surface - main background
      mOnSurface = "#e0def4";    # text - main text color
      mSurfaceVariant = "#26233a"; # overlay - elevated surfaces
      mOnSurfaceVariant = "#908caa"; # subtle - secondary text
      mOutline = "#6e6a86";      # muted - borders
      mShadow = "#000000";       # shadow color
      mHover = "#403d52";        # highlightMed - hover state
      mOnHover = "#e0def4";      # text - text on hover
    };

    # Settings are largely managed via Noctalia's built-in GUI
    # Only specify overrides here if needed
    settings = {
      # Compositor detection (niri is auto-detected, but explicit is fine)
      compositor = "niri";
    };
  };
}
