# Disko configuration for VirtualBox VM
# Simple ext4 layout, no encryption (it's a test VM)
# Device hardcoded to /dev/sda (standard for VirtualBox)
#
# USAGE:
# 1. Create VirtualBox VM with EFI enabled
# 2. Boot from NixOS ISO
# 3. Clone config: git clone https://github.com/YOUR/nixos /tmp/nixos && cd /tmp/nixos
# 4. Run disko:
#    sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- \
#      --mode disko --flake .#virtualbox
# 5. Install: sudo nixos-install --flake .#virtualbox
# 6. Remove ISO and reboot

{
  disko.devices = {
    disk = {
      main = {
        device = "/dev/sda";
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
