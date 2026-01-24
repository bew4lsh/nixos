{ config, pkgs, ... }:

{
  # Wpaperd - wallpaper daemon with per-monitor support
  # Alternative: swaybg for simpler static wallpapers

  home.packages = with pkgs; [
    wpaperd
    swaybg  # Fallback/simple option
  ];

  # Wpaperd configuration
  xdg.configFile."wpaperd/config.toml".text = ''
    [default]
    # Default settings for all monitors
    duration = "30m"
    mode = "center"
    sorting = "random"

    # You can set a single wallpaper or a directory
    # path = "~/Pictures/Wallpapers"

    # Or use a solid color initially (Rosé Pine base)
    # Remove this and set path above once you have wallpapers

    [DP-1]
    # Main monitor - center
    path = "~/Pictures/Wallpapers/main"
    mode = "fill"

    [DP-2]
    # Top monitor
    path = "~/Pictures/Wallpapers/top"
    mode = "fill"

    [DP-3]
    # Portrait monitor - right
    path = "~/Pictures/Wallpapers/portrait"
    mode = "fill"
  '';

  # Create wallpaper directories
  home.file."Pictures/Wallpapers/main/.keep".text = "";
  home.file."Pictures/Wallpapers/top/.keep".text = "";
  home.file."Pictures/Wallpapers/portrait/.keep".text = "";

  # Add to niri startup - but we need to modify niri.nix or use systemd
  # Using systemd user service for cleaner management
  systemd.user.services.wpaperd = {
    Unit = {
      Description = "Wpaperd wallpaper daemon";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.wpaperd}/bin/wpaperd";
      Restart = "on-failure";
      RestartSec = 1;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
