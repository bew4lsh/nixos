{ config, pkgs, inputs, ... }:

{
  # Enable niri from the flake
  programs.niri = {
    enable = true;
    package = pkgs.niri;  # Or inputs.niri.packages.${pkgs.system}.niri for latest
  };

  # XDG portal for screen sharing, file dialogs, etc.
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
    config = {
      common = {
        default = [ "gtk" ];
      };
      niri = {
        default = [ "gtk" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
      };
    };
  };

  # Polkit for privilege escalation dialogs
  security.polkit.enable = true;
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  # Keyring for secrets
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  # Enable Xwayland for compatibility
  programs.xwayland.enable = true;

  # DBus activation for Wayland
  services.dbus.enable = true;

  # Fonts
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      # Main fonts
      inter
      nerd-fonts.jetbrains-mono

      # Fallback fonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      liberation_ttf
      dejavu_fonts
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "DejaVu Serif" "Noto Serif" ];
        sansSerif = [ "Inter" "Noto Sans" ];
        monospace = [ "JetBrainsMono Nerd Font" "Noto Sans Mono" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  # Essential Wayland packages
  environment.systemPackages = with pkgs; [
    # Wayland essentials
    wayland
    wayland-utils
    wayland-protocols
    wl-clipboard
    wl-clip-persist
    cliphist

    # XWayland support for X11 apps (Java IDEs, etc.)
    xwayland-satellite

    # Screenshot/recording
    grim
    slurp
    swappy
    wf-recorder

    # Utilities
    brightnessctl
    playerctl
    libnotify
    xdg-utils

    # File manager
    nautilus
    file-roller

    # Image viewer
    imv
    loupe

    # System monitor
    gnome-system-monitor

    # Cursor
    rose-pine-cursor
  ];

  # Session variables for Wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";  # Electron apps use Wayland
    MOZ_ENABLE_WAYLAND = "1";  # Firefox Wayland
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    GDK_BACKEND = "wayland,x11";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "niri";
    GTK_THEME = "rose-pine";  # Ensure GTK theme is applied
    _JAVA_AWT_WM_NONREPARENTING = "1";  # Fix Java apps on tiling WMs
  };

  # Enable dconf for GTK settings
  programs.dconf.enable = true;
}
