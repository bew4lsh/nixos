{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix
    ../../modules/system/boot.nix
    ../../modules/system/networking.nix
    ../../modules/system/audio.nix
    ../../modules/system/locale.nix
    ../../modules/hardware/amd-cpu.nix
    ../../modules/hardware/amd-gpu.nix
    ../../modules/desktop/greetd.nix
    ../../modules/desktop/niri.nix
    ../../modules/programs/gaming.nix
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
