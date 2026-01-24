{ config, pkgs, ... }:

{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=12";
        dpi-aware = "no";
        prompt = "❯ ";
        icon-theme = "rose-pine-icons";
        icons-enabled = true;
        terminal = "wezterm start --";
        layer = "overlay";
        width = 40;
        lines = 12;
        horizontal-pad = 20;
        vertical-pad = 12;
        inner-pad = 8;
      };
      colors = {
        # Rosé Pine
        background = "191724ee";
        text = "e0def4ff";
        prompt = "ebbcbaff";
        placeholder = "6e6a86ff";
        input = "e0def4ff";
        match = "c4a7e7ff";
        selection = "26233aff";
        selection-text = "e0def4ff";
        selection-match = "c4a7e7ff";
        border = "c4a7e7ff";
      };
      border = {
        width = 2;
        radius = 12;
      };
    };
  };
}
