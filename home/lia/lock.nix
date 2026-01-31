{ config, pkgs, ... }:

{
  # Hypridle - idle daemon
  # Uses Noctalia's built-in lock screen
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "qs ipc call lockScreen toggle";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "niri msg action power-on-monitors";
      };

      listener = [
        # Dim screen after 5 minutes
        {
          timeout = 300;
          on-timeout = "brightnessctl -s set 10%";
          on-resume = "brightnessctl -r";
        }
        # Turn off screen after 10 minutes
        {
          timeout = 600;
          on-timeout = "niri msg action power-off-monitors";
          on-resume = "niri msg action power-on-monitors";
        }
        # Lock after 15 minutes
        {
          timeout = 900;
          on-timeout = "loginctl lock-session";
        }
        # Suspend after 30 minutes
        {
          timeout = 1800;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };

}
