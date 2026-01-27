# Disko configuration for Mini PC / home server
# Simple ext4 layout, no encryption
#
# USAGE:
# sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- \
#   --mode disko --flake .#minipc

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
