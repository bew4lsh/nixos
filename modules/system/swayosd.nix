{ config, pkgs, ... }:

{
  # SwayOSD - On-Screen Display service
  # Provides visual feedback for volume, brightness, caps lock, etc.

  # The swayosd-server runs as a system service
  # The swayosd-client is called from keybindings

  environment.systemPackages = with pkgs; [
    swayosd
  ];

  # Systemd service for the OSD server
  systemd.user.services.swayosd = {
    description = "SwayOSD LibInput backend for brightness/volume keys";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.swayosd}/bin/swayosd-server";
      Restart = "on-failure";
      RestartSec = 3;
    };
  };

  # Udev rules for swayosd to access input devices
  services.udev.extraRules = ''
    # Allow swayosd to access input devices for brightness keys
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
  '';
}
