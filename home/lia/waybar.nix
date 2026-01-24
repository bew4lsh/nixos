{ config, pkgs, ... }:

let
  colors = {
    base = "#191724";
    surface = "#1f1d2e";
    overlay = "#26233a";
    muted = "#6e6a86";
    subtle = "#908caa";
    text = "#e0def4";
    love = "#eb6f92";
    gold = "#f6c177";
    rose = "#ebbcba";
    pine = "#31748f";
    foam = "#9ccfd8";
    iris = "#c4a7e7";
    highlightLow = "#21202e";
    highlightMed = "#403d52";
    highlightHigh = "#524f67";
  };
in
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    systemd.target = "graphical-session.target";

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 32;
        spacing = 8;
        margin-top = 4;
        margin-left = 8;
        margin-right = 8;

        modules-left = [
          "niri/workspaces"
          "niri/window"
        ];

        modules-center = [
          "clock"
        ];

        modules-right = [
          "tray"
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "temperature"
        ];

        "niri/workspaces" = {
          format = "{icon}";
          format-icons = {
            active = "";
            default = "";
          };
        };

        "niri/window" = {
          format = "{}";
          max-length = 50;
        };

        clock = {
          format = "  {:%H:%M}";
          format-alt = "  {:%A, %B %d, %Y}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            format = {
              months = "<span color='${colors.rose}'><b>{}</b></span>";
              days = "<span color='${colors.text}'><b>{}</b></span>";
              weeks = "<span color='${colors.foam}'><b>W{}</b></span>";
              weekdays = "<span color='${colors.gold}'><b>{}</b></span>";
              today = "<span color='${colors.love}'><b><u>{}</u></b></span>";
            };
          };
        };

        cpu = {
          format = "  {usage}%";
          tooltip = true;
          interval = 2;
        };

        memory = {
          format = "  {}%";
          tooltip = true;
          interval = 2;
        };

        temperature = {
          hwmon-path-abs = "/sys/devices/pci0000:00/0000:00:18.3/hwmon";
          input-filename = "temp1_input";
          critical-threshold = 80;
          format = "  {temperatureC}°C";
          format-critical = "  {temperatureC}°C";
        };

        network = {
          format-wifi = "  {signalStrength}%";
          format-ethernet = "󰈀  {ipaddr}";
          format-disconnected = "󰖪  Disconnected";
          tooltip-format = "{ifname}: {ipaddr}/{cidr}\n{essid}";
        };

        pulseaudio = {
          format = "{icon}  {volume}%";
          format-muted = "󰝟  Muted";
          format-icons = {
            default = [ "" "" "" ];
          };
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-click-right = "pavucontrol";
        };

        tray = {
          icon-size = 16;
          spacing = 8;
        };
      };
    };

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", "Inter", sans-serif;
        font-size: 13px;
        font-weight: 500;
      }

      window#waybar {
        background: ${colors.base};
        color: ${colors.text};
        border-radius: 10px;
        border: 1px solid ${colors.highlightMed};
      }

      #workspaces {
        background: ${colors.surface};
        border-radius: 8px;
        padding: 0 8px;
        margin: 4px;
      }

      #workspaces button {
        color: ${colors.muted};
        padding: 0 6px;
        border: none;
        border-radius: 6px;
        background: transparent;
      }

      #workspaces button:hover {
        background: ${colors.highlightLow};
        color: ${colors.text};
      }

      #workspaces button.active {
        color: ${colors.iris};
        background: ${colors.highlightMed};
      }

      #window {
        color: ${colors.subtle};
        padding: 0 12px;
      }

      #clock {
        color: ${colors.rose};
        background: ${colors.surface};
        border-radius: 8px;
        padding: 0 12px;
        margin: 4px;
      }

      #cpu {
        color: ${colors.foam};
        background: ${colors.surface};
        border-radius: 8px 0 0 8px;
        padding: 0 8px 0 12px;
        margin: 4px 0 4px 4px;
      }

      #memory {
        color: ${colors.iris};
        background: ${colors.surface};
        padding: 0 8px;
        margin: 4px 0;
      }

      #temperature {
        color: ${colors.gold};
        background: ${colors.surface};
        border-radius: 0 8px 8px 0;
        padding: 0 12px 0 8px;
        margin: 4px 4px 4px 0;
      }

      #temperature.critical {
        color: ${colors.love};
      }

      #network {
        color: ${colors.pine};
        background: ${colors.surface};
        border-radius: 8px;
        padding: 0 12px;
        margin: 4px;
      }

      #pulseaudio {
        color: ${colors.gold};
        background: ${colors.surface};
        border-radius: 8px;
        padding: 0 12px;
        margin: 4px;
      }

      #pulseaudio.muted {
        color: ${colors.muted};
      }

      #tray {
        background: ${colors.surface};
        border-radius: 8px;
        padding: 0 8px;
        margin: 4px;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
      }

      tooltip {
        background: ${colors.surface};
        border: 1px solid ${colors.highlightMed};
        border-radius: 8px;
      }

      tooltip label {
        color: ${colors.text};
      }
    '';
  };
}
