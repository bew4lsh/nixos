# VirtualBox VM configuration (for testing niri/desktop config)
{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix

    # System services
    ../../modules/system/boot.nix

    # Desktop environment
    ../../modules/desktop/greetd.nix
    ../../modules/desktop/niri.nix
    ../../modules/system/swayosd.nix
  ];

  networking.hostName = "virtualbox";

  # VirtualBox guest additions
  virtualisation.virtualbox.guest = {
    enable = true;
    draganddrop = true;
    clipboard = true;
  };

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
      "vboxsf"  # VirtualBox shared folders
    ];
    shell = pkgs.bash;
    initialPassword = "nixos";  # Change after first login!
  };

  # VM-friendly kernel (faster boot, smaller)
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages;

  # Speed up VM boot
  boot.initrd.systemd.enable = false;
  systemd.services.NetworkManager-wait-online.enable = false;

  # Disable services not needed in VM
  services.fstrim.enable = lib.mkForce false;
  powerManagement.enable = lib.mkForce false;

  # VM display - let VirtualBox handle resolution
  # Niri will adapt to the window size

  system.stateVersion = "24.11";
}
