{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix

    # System
    ../../modules/system/boot.nix
    ../../modules/system/networking.nix
    ../../modules/system/audio.nix
    ../../modules/system/locale.nix
    ../../modules/system/tailscale.nix
    ../../modules/system/btrbk.nix
    ../../modules/system/printing.nix
    ../../modules/system/syncthing.nix
    ../../modules/system/flatpak.nix
    ../../modules/system/plymouth.nix
    ../../modules/system/virtualization.nix

    # Hardware
    ../../modules/hardware/amd-cpu.nix
    ../../modules/hardware/amd-gpu.nix

    # Desktop
    ../../modules/desktop/greetd.nix
    ../../modules/desktop/niri.nix
    ../../modules/system/swayosd.nix

    # Programs
    ../../modules/programs/gaming.nix

    # Optional - enable after first boot and setup:
    # ../../modules/system/sops.nix        # After creating age keys
    # ../../modules/system/lanzaboote.nix  # After first boot, see instructions
    # ../../modules/system/impermanence.nix # After creating @persist subvolume
  ];

  networking.hostName = "adrasteia";

  # User configuration
  users.users.lia = {
    isNormalUser = true;
    description = "lia";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "input"
      "gamemode"
    ];
    shell = pkgs.bash;
  };

  # System packages available to all users
  environment.systemPackages = with pkgs; [
    # Core utilities
    git
    wget
    curl
    unzip
    file
    tree
    ripgrep
    fd
    jq
    htop
    btop

    # Filesystem
    btrfs-progs
    compsize

    # Nix tools
    nh
    nix-output-monitor
    nvd
  ];

  # Nix settings
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      trusted-users = [ "root" "lia" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System state version - don't change after install
  system.stateVersion = "24.11";
}
