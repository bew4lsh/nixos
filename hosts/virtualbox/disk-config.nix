# Disko configuration for VirtualBox VM
# Simple ext4 layout, no encryption (it's a test VM)
#
# USAGE:
# 1. Create a new VirtualBox VM:
#    - Type: Linux, Version: Other Linux (64-bit)
#    - Enable EFI: Settings > System > Enable EFI
#    - Create a VDI disk (32GB+ recommended)
#    - Attach NixOS ISO to optical drive
#
# 2. Boot the VM from ISO
#
# 3. Identify the disk (usually /dev/sda for VirtualBox):
#    lsblk
#
# 4. Run disko:
#    sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- \
#      --mode disko ./hosts/virtualbox/disk-config.nix --arg device '"/dev/sda"'
#
# 5. Install NixOS:
#    sudo nixos-install --flake .#virtualbox
#
# 6. Remove ISO and reboot

{ device ? "/dev/sda", ... }:

{
  disko.devices = {
    disk = {
      main = {
        inherit device;
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
