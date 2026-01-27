# MacBook Pro 13" 2020 (Intel, T2 chip)
{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix

    # System services
    ../../modules/system/boot.nix
    ../../modules/system/tailscale.nix
    ../../modules/system/printing.nix
    ../../modules/system/flatpak.nix
    ../../modules/system/plymouth.nix
    ../../modules/system/btrbk.nix  # Btrfs snapshots

    # Hardware (Intel MacBook)
    ../../modules/hardware/intel-cpu.nix
    ../../modules/hardware/intel-gpu.nix
    ../../modules/hardware/apple-t2.nix

    # Desktop environment
    ../../modules/desktop/greetd.nix
    ../../modules/desktop/niri.nix
    ../../modules/system/swayosd.nix
  ];

  networking.hostName = "laptop";

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
    ];
    shell = pkgs.bash;
  };

  # Laptop-specific packages
  environment.systemPackages = with pkgs; [
    # Battery/power monitoring
    acpi
    powertop

    # Filesystem (btrfs)
    btrfs-progs
    compsize
  ];

  # Brightness control (for niri keybinds)
  programs.light.enable = true;

  # Bluetooth (MacBooks have Bluetooth)
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  # NOTE: WiFi on T2 Macs
  # Broadcom WiFi requires firmware extraction from macOS (complex)
  # Recommended: Use a USB WiFi adapter or USB-C ethernet
  # See: https://wiki.t2linux.org/guides/wifi/

  system.stateVersion = "24.11";
}
