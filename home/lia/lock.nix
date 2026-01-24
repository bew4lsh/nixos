{ config, pkgs, ... }:

let
  colors = {
    base = "191724";
    surface = "1f1d2e";
    overlay = "26233a";
    muted = "6e6a86";
    subtle = "908caa";
    text = "e0def4";
    love = "eb6f92";
    gold = "f6c177";
    rose = "ebbcba";
    pine = "31748f";
    foam = "9ccfd8";
    iris = "c4a7e7";
  };
in
{
  # Swaylock - screen locker
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      # Appearance
      color = colors.base;
      font = "Inter";
      font-size = 24;

      # Effects
      clock = true;
      timestr = "%H:%M";
      datestr = "%A, %B %d";

      effect-blur = "10x3";
      effect-vignette = "0.5:0.5";
      fade-in = 0.2;

      # Indicator
      indicator = true;
      indicator-radius = 120;
      indicator-thickness = 8;
      indicator-caps-lock = true;

      # Colors (Rosé Pine)
      inside-color = "${colors.base}cc";
      inside-clear-color = "${colors.pine}cc";
      inside-caps-lock-color = "${colors.gold}cc";
      inside-ver-color = "${colors.iris}cc";
      inside-wrong-color = "${colors.love}cc";

      ring-color = "${colors.overlay}";
      ring-clear-color = "${colors.pine}";
      ring-caps-lock-color = "${colors.gold}";
      ring-ver-color = "${colors.iris}";
      ring-wrong-color = "${colors.love}";

      line-color = "00000000";
      line-clear-color = "00000000";
      line-caps-lock-color = "00000000";
      line-ver-color = "00000000";
      line-wrong-color = "00000000";

      separator-color = "00000000";

      text-color = "${colors.text}";
      text-clear-color = "${colors.text}";
      text-caps-lock-color = "${colors.text}";
      text-ver-color = "${colors.text}";
      text-wrong-color = "${colors.text}";

      key-hl-color = "${colors.foam}";
      bs-hl-color = "${colors.love}";
      caps-lock-key-hl-color = "${colors.gold}";
      caps-lock-bs-hl-color = "${colors.love}";

      # Layout
      layout-bg-color = "00000000";
      layout-border-color = "00000000";
      layout-text-color = "${colors.text}";

      # Behavior
      ignore-empty-password = true;
      show-failed-attempts = true;
      daemonize = true;
    };
  };

  # Hypridle - idle daemon
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof swaylock || swaylock";
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

  home.packages = with pkgs; [
    swaylock-effects
  ];
}
