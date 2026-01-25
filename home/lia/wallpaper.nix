{ config, pkgs, ... }:

{
  # Wpaperd - wallpaper daemon with per-monitor support
  # Alternative: swaybg for simpler static wallpapers

  home.packages = with pkgs; [
    wpaperd
    swaybg  # Fallback/simple option
  ];

  # Wpaperd configuration
  # Clone wallpapers: git clone https://github.com/p4rfait/rose-pine-wallpapers ~/Pictures/rose-pine-wallpapers
  xdg.configFile."wpaperd/config.toml".text = ''
    [default]
    # Default settings for all monitors
    duration = "30m"
    mode = "fill"
    sorting = "random"

    # Rosé Pine wallpapers - all monitors use the same pool
    path = "~/Pictures/rose-pine-wallpapers/wallpapers"
  '';

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
