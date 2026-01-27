# Mini PC hardware configuration
# Filesystems are managed by disk-config.nix (disko)
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
  boot.kernelModules = [ "kvm-intel" ];  # or kvm-amd

  hardware.enableRedistributableFirmware = true;
}
