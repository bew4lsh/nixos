# VirtualBox VM hardware configuration
# Filesystems are managed by disk-config.nix (disko)
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  # VirtualBox uses these modules
  boot.initrd.availableKernelModules = [
    "ata_piix"
    "ohci_pci"
    "ehci_pci"
    "ahci"
    "sd_mod"
    "sr_mod"
  ];

  boot.kernelModules = [ ];

  # VirtualBox provides virtualized hardware
  hardware.enableRedistributableFirmware = false;
}
