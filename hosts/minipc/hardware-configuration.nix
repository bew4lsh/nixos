# TODO: Generate this file on the target machine with:
#   nixos-generate-config --show-hardware-config > hardware-configuration.nix
#
# This is a placeholder. Replace with actual hardware config.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
  boot.kernelModules = [ "kvm-intel" ];  # or kvm-amd

  # TODO: Set your root filesystem
  # fileSystems."/" = {
  #   device = "/dev/disk/by-uuid/XXXXX";
  #   fsType = "ext4";  # or btrfs
  # };

  # fileSystems."/boot" = {
  #   device = "/dev/disk/by-uuid/XXXXX";
  #   fsType = "vfat";
  # };
}
