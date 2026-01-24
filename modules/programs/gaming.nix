{ config, pkgs, ... }:

{
  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;

    # Extra packages available in Steam's FHS environment
    extraPackages = with pkgs; [
      # Proton dependencies
      mangohud
      gamemode

      # Additional libraries some games need
      xorg.libXcursor
      xorg.libXi
      xorg.libXinerama
      xorg.libXScrnSaver
      libpng
      libpulseaudio
      libvorbis
      stdenv.cc.cc.lib
      libkrb5
      keyutils
    ];

    # 32-bit packages for older games
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  # Gamemode - optimizes system for gaming
  programs.gamemode = {
    enable = true;
    enableRenice = true;
    settings = {
      general = {
        renice = 10;
        softrealtime = "auto";
        inhibit_screensaver = 1;
      };
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
        amd_performance_level = "high";
      };
      custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
      };
    };
  };

  # Gamescope - SteamOS compositor for gaming
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  # Gaming packages
  environment.systemPackages = with pkgs; [
    # Performance overlay
    mangohud

    # Proton
    protonup-qt
    proton-ge-bin

    # Wine for non-Steam games
    wineWowPackages.stable
    winetricks

    # Controllers
    game-devices-udev-rules

    # Monitoring
    nvtopPackages.amd
  ];

  # Udev rules for controllers
  hardware.steam-hardware.enable = true;

  # Better gaming performance
  boot.kernel.sysctl = {
    # Increase file watchers for games with lots of files
    "fs.inotify.max_user_watches" = 524288;

    # Network tweaks for online gaming
    "net.core.netdev_max_backlog" = 16384;
    "net.core.somaxconn" = 8192;
  };

  # Allow higher nice values for gamemode
  security.pam.loginLimits = [
    {
      domain = "@gamemode";
      type = "soft";
      item = "nice";
      value = "-20";
    }
  ];
}
