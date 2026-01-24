{ config, pkgs, ... }:

{
  # Syncthing - continuous file synchronization
  services.syncthing = {
    enable = true;
    user = "lia";
    group = "users";
    dataDir = "/home/lia";
    configDir = "/home/lia/.config/syncthing";

    # Open firewall
    openDefaultPorts = true;

    # Override default folders and devices if desired
    # settings = {
    #   devices = {
    #     "phone" = {
    #       id = "DEVICE-ID-HERE";
    #     };
    #     "laptop" = {
    #       id = "DEVICE-ID-HERE";
    #     };
    #   };
    #
    #   folders = {
    #     "Documents" = {
    #       path = "/home/lia/Documents";
    #       devices = [ "phone" "laptop" ];
    #       ignorePerms = false;
    #     };
    #     "Photos" = {
    #       path = "/home/lia/Pictures";
    #       devices = [ "phone" ];
    #     };
    #   };
    # };
  };

  # Syncthing tray app
  environment.systemPackages = with pkgs; [
    syncthingtray  # System tray indicator
  ];

  # Ensure proper permissions
  systemd.services.syncthing.serviceConfig.UMask = "0007";
}

# USAGE:
#
# 1. Access web UI at: http://localhost:8384
#
# 2. Add devices:
#    - Get device ID from Actions > Show ID
#    - Share with other devices
#
# 3. Share folders:
#    - Add Folder in web UI
#    - Select which devices to share with
#
# 4. The tray app (syncthingtray) shows sync status
#    Add to niri autostart if desired
#
# TIP: For declarative device/folder config, uncomment
# the settings block above and add your device IDs
