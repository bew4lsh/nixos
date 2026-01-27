# Mini PC / Home server configuration
{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix

    # System services
    ../../modules/system/boot.nix
    ../../modules/system/tailscale.nix
    ../../modules/system/containers.nix

    # Hardware - TODO: adjust for your minipc hardware
    # ../../modules/hardware/intel-cpu.nix
  ];

  networking.hostName = "minipc";

  # User configuration
  users.users.lia = {
    isNormalUser = true;
    description = "lia";
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
    ];
    shell = pkgs.bash;
  };

  # Server-specific settings
  # services.openssh.enable = true;

  # Headless - no desktop environment
  # Uncomment below if you want a desktop:
  # ../../modules/desktop/greetd.nix
  # ../../modules/desktop/niri.nix

  system.stateVersion = "24.11";
}
