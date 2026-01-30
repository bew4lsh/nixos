# Common configuration shared across all hosts
{ config, pkgs, inputs, ... }:

{
  imports = [
    # Core system
    ../system/networking.nix
    ../system/audio.nix
    ../system/locale.nix
    ../system/maintenance.nix
  ];

  # Nix settings (shared across all hosts)
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      trusted-users = [ "root" "@wheel" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Core system packages available on all hosts
  environment.systemPackages = with pkgs; [
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
    mission-center

    # Nix tools
    nh
    nix-output-monitor
    nvd
  ];
}
