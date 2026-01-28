{ config, pkgs, hostname, lib, ... }:

let
  # VirtualBox has limited OpenGL support (no GLSL ES 3.10)
  # Use swaybg instead of wpaperd for compatibility
  isVirtualBox = hostname == "virtualbox";

  # Rosé Pine base color for solid background fallback
  rosePineBase = "#191724";
in
{
  home.packages = with pkgs; [
    swaybg
  ] ++ lib.optionals (!isVirtualBox) [
    wpaperd
  ];

  # Wpaperd configuration (for non-VirtualBox hosts)
  # Clone wallpapers: git clone https://github.com/p4rfait/rose-pine-wallpapers ~/Pictures/rose-pine-wallpapers
  xdg.configFile."wpaperd/config.toml" = lib.mkIf (!isVirtualBox) {
    text = ''
      [default]
      # Default settings for all monitors
      duration = "30m"
      mode = "fit"
      sorting = "random"

      # Rosé Pine wallpapers - all monitors use the same pool
      path = "~/Pictures/rose-pine-wallpapers/wallpapers"
    '';
  };

  # Wpaperd systemd service (for non-VirtualBox hosts)
  systemd.user.services.wpaperd = lib.mkIf (!isVirtualBox) {
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

  # Swaybg systemd service (for VirtualBox - simpler OpenGL requirements)
  systemd.user.services.swaybg = lib.mkIf isVirtualBox {
    Unit = {
      Description = "Swaybg wallpaper daemon";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      # Use solid color by default; change to image with: -i /path/to/image.png -m fill
      ExecStart = "${pkgs.swaybg}/bin/swaybg -c '${rosePineBase}'";
      Restart = "on-failure";
      RestartSec = 1;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
