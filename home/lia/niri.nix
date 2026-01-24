{ config, pkgs, inputs, ... }:

let
  # Rosé Pine colors
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
  # niri configuration
  xdg.configFile."niri/config.kdl".text = ''
    // Rosé Pine themed niri configuration

    // Input configuration
    input {
        keyboard {
            xkb {
                layout "us"
            }
        }

        touchpad {
            tap
            natural-scroll
            accel-profile "flat"
        }

        mouse {
            accel-profile "flat"
        }

        // Focus follows mouse
        focus-follows-mouse max-scroll-amount="0%"
    }

    // Output (monitor) configuration
    output "DP-1" {
        // Main monitor - 1440p center
        mode "2560x1440@60.000"
        position x=1440 y=360
        scale 1.0
    }

    output "DP-2" {
        // Top monitor - 1080p above main
        mode "1920x1080@60.000"
        position x=1760 y=-720
        scale 1.0
    }

    output "DP-3" {
        // Portrait monitor - 1440p right, rotated CCW (270 degrees)
        mode "2560x1440@60.000"
        position x=4000 y=0
        transform "270"
        scale 1.0
    }

    // Layout configuration
    layout {
        gaps 8

        center-focused-column "never"

        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
            proportion 1.0
        }

        default-column-width { proportion 0.5; }

        focus-ring {
            width 2
            active-color "${colors.iris}"
            inactive-color "${colors.highlightMed}"
        }

        border {
            off
        }

        struts {
            left 0
            right 0
            top 0
            bottom 0
        }
    }

    // Spawn at startup
    spawn-at-startup "waybar"
    spawn-at-startup "mako"
    spawn-at-startup "wl-paste" "--type" "text" "--watch" "cliphist" "store"
    spawn-at-startup "wl-paste" "--type" "image" "--watch" "cliphist" "store"

    // Prefer no client-side decorations
    prefer-no-csd

    // Screenshot path
    screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

    // Hotkey overlay skip
    hotkey-overlay {
        skip-at-startup
    }

    // Animation configuration
    animations {
        slowdown 0.8

        window-open {
            duration-ms 200
            curve "ease-out-expo"
        }

        window-close {
            duration-ms 150
            curve "ease-out-quad"
        }

        window-movement {
            duration-ms 200
            curve "ease-out-expo"
        }

        window-resize {
            duration-ms 200
            curve "ease-out-expo"
        }

        workspace-switch {
            duration-ms 300
            curve "ease-out-expo"
        }

        horizontal-view-movement {
            duration-ms 200
            curve "ease-out-expo"
        }

        config-notification-open-close {
            duration-ms 200
            curve "ease-out-expo"
        }
    }

    // Window rules
    window-rule {
        match app-id="firefox"
        open-maximized true
    }

    window-rule {
        match app-id="steam"
        open-floating true
    }

    window-rule {
        // Picture-in-picture
        match title="Picture-in-Picture"
        open-floating true
    }

    // Keybindings
    binds {
        // Terminal
        Mod+Return { spawn "wezterm"; }

        // Launcher
        Mod+D { spawn "fuzzel"; }

        // Close window
        Mod+Shift+Q { close-window; }

        // Quit niri
        Mod+Shift+E { quit; }

        // Lock screen
        Mod+Escape { spawn "swaylock"; }

        // Screenshots
        Print { screenshot; }
        Mod+Print { screenshot-screen; }
        Mod+Shift+Print { screenshot-window; }

        // Focus movement
        Mod+H { focus-column-left; }
        Mod+J { focus-window-down; }
        Mod+K { focus-window-up; }
        Mod+L { focus-column-right; }

        Mod+Left { focus-column-left; }
        Mod+Down { focus-window-down; }
        Mod+Up { focus-window-up; }
        Mod+Right { focus-column-right; }

        // Move windows
        Mod+Shift+H { move-column-left; }
        Mod+Shift+J { move-window-down; }
        Mod+Shift+K { move-window-up; }
        Mod+Shift+L { move-column-right; }

        Mod+Shift+Left { move-column-left; }
        Mod+Shift+Down { move-window-down; }
        Mod+Shift+Up { move-window-up; }
        Mod+Shift+Right { move-column-right; }

        // Focus monitor
        Mod+Ctrl+H { focus-monitor-left; }
        Mod+Ctrl+L { focus-monitor-right; }
        Mod+Ctrl+K { focus-monitor-up; }
        Mod+Ctrl+J { focus-monitor-down; }

        // Move window to monitor
        Mod+Ctrl+Shift+H { move-column-to-monitor-left; }
        Mod+Ctrl+Shift+L { move-column-to-monitor-right; }
        Mod+Ctrl+Shift+K { move-column-to-monitor-up; }
        Mod+Ctrl+Shift+J { move-column-to-monitor-down; }

        // Workspaces
        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }

        Mod+Shift+1 { move-column-to-workspace 1; }
        Mod+Shift+2 { move-column-to-workspace 2; }
        Mod+Shift+3 { move-column-to-workspace 3; }
        Mod+Shift+4 { move-column-to-workspace 4; }
        Mod+Shift+5 { move-column-to-workspace 5; }
        Mod+Shift+6 { move-column-to-workspace 6; }
        Mod+Shift+7 { move-column-to-workspace 7; }
        Mod+Shift+8 { move-column-to-workspace 8; }
        Mod+Shift+9 { move-column-to-workspace 9; }

        // Workspace navigation
        Mod+Tab { focus-workspace-previous; }
        Mod+U { focus-workspace-down; }
        Mod+I { focus-workspace-up; }
        Mod+Shift+U { move-column-to-workspace-down; }
        Mod+Shift+I { move-column-to-workspace-up; }

        // Column width
        Mod+R { switch-preset-column-width; }
        Mod+Minus { set-column-width "-10%"; }
        Mod+Equal { set-column-width "+10%"; }

        // Window height
        Mod+Shift+Minus { set-window-height "-10%"; }
        Mod+Shift+Equal { set-window-height "+10%"; }

        // Fullscreen
        Mod+F { maximize-column; }
        Mod+Shift+F { fullscreen-window; }

        // Consume window into column / expel from column
        Mod+Comma { consume-window-into-column; }
        Mod+Period { expel-window-from-column; }

        // Center column
        Mod+C { center-column; }

        // Scroll
        Mod+WheelScrollDown { focus-workspace-down; }
        Mod+WheelScrollUp { focus-workspace-up; }

        // Media keys
        XF86AudioRaiseVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"; }
        XF86AudioLowerVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
        XF86AudioMute { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
        XF86AudioMicMute { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"; }

        XF86MonBrightnessUp { spawn "brightnessctl" "set" "5%+"; }
        XF86MonBrightnessDown { spawn "brightnessctl" "set" "5%-"; }

        XF86AudioPlay { spawn "playerctl" "play-pause"; }
        XF86AudioPrev { spawn "playerctl" "previous"; }
        XF86AudioNext { spawn "playerctl" "next"; }

        // Clipboard history
        Mod+V { spawn "sh" "-c" "cliphist list | fuzzel -d | cliphist decode | wl-copy"; }

        // Power menu (you can customize this)
        Mod+Shift+P { spawn "sh" "-c" "echo -e 'logout\nsuspend\nreboot\nshutdown' | fuzzel -d | xargs -I {} sh -c 'case {} in logout) niri msg action quit;; suspend) systemctl suspend;; reboot) systemctl reboot;; shutdown) systemctl poweroff;; esac'"; }
    }
  '';

  # Ensure screenshots directory exists
  home.file."Pictures/Screenshots/.keep".text = "";
}
