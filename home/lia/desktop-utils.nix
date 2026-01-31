{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # OSD for volume/brightness feedback
    swayosd

    # Emoji picker
    bemoji

    # Color picker
    hyprpicker

    # USB auto-mount
    udiskie

    # Screenshot annotation (beyond basic grim)
    swappy

    # Noctalia dependencies
    cava      # Audio visualizer
    ddcutil   # External monitor brightness control

    # Display management
    nwg-displays  # Visual monitor configuration
  ];

  # SwayOSD - On-Screen Display for volume/brightness
  # Requires the system service to be enabled (see system module)
  # The OSD will show when using media keys

  # Udiskie - USB auto-mount daemon
  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
    tray = "auto";  # Show tray icon when devices are mounted
    settings = {
      program_options = {
        file_manager = "nautilus";
        terminal = "wezterm";
      };
      notifications = {
        device_mounted = true;
        device_unmounted = true;
        device_added = false;
        device_removed = false;
      };
      icon_names = {
        media = "drive-removable-media";
        browse = "folder-open";
        terminal = "terminal";
        unmount = "media-eject";
      };
    };
  };

  # Gammastep - Night light / blue light filter
  # Disabled - Noctalia integrates wlsunset for color temperature control
  # Re-enable if you prefer gammastep over Noctalia's built-in control
  services.gammastep = {
    enable = false;
    provider = "manual";
    latitude = 40.7;   # NYC area
    longitude = -74.0;
    temperature = {
      day = 6500;    # Neutral during day
      night = 3500;  # Warm at night
    };
    tray = true;
    settings = {
      general = {
        fade = 1;
        brightness-day = 1.0;
        brightness-night = 0.9;
        adjustment-method = "wayland";
      };
    };
  };

  # Blueman applet - Bluetooth tray
  services.blueman-applet.enable = true;

  # Network Manager applet - for WiFi management from tray
  services.network-manager-applet.enable = true;
}
