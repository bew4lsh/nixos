# Desktop workstation (AMD Ryzen 9 9950X3D + RX 9070 XT)
{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix

    # System services
    ../../modules/system/boot.nix
    ../../modules/system/tailscale.nix
    ../../modules/system/btrbk.nix
    ../../modules/system/printing.nix
    ../../modules/system/syncthing.nix
    ../../modules/system/flatpak.nix
    ../../modules/system/plymouth.nix
    ../../modules/system/virtualization.nix
    ../../modules/system/containers.nix

    # Hardware (AMD-specific)
    ../../modules/hardware/amd-cpu.nix
    ../../modules/hardware/amd-gpu.nix

    # Desktop environment
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
      "docker"
      "libvirtd"
      "kvm"
      "scanner"
      "lp"
    ];
    shell = pkgs.bash;
  };

  # Desktop-specific packages
  environment.systemPackages = with pkgs; [
    # Filesystem (btrfs)
    btrfs-progs
    compsize
  ];

  # SSH server
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  system.stateVersion = "24.11";
}
