# MacBook Pro 13" 2020 (Intel, T2 chip)
# Hardware detection - filesystems are managed by disk-config.nix (disko)
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Intel 10th gen Ice Lake CPU
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "nvme"
    "usb_storage"
    "sd_mod"
  ];

  boot.kernelModules = [ "kvm-intel" ];

  # Apple T2 support - keyboard, trackpad, Touch Bar
  # The apple-bce module is loaded via apple-t2.nix

  # Enable all redistributable firmware (Intel WiFi, etc.)
  hardware.enableRedistributableFirmware = true;

  # Retina display - HiDPI scaling
  # Niri handles this via output scale in home/lia/niri.nix
  # For console: console.font = "ter-v32n";

  # NOTE: After first boot, you can regenerate this with:
  #   nixos-generate-config --show-hardware-config
  # and merge any detected hardware you're missing
}
