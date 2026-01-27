# Disko configuration for Mini PC / home server
# Simple ext4 layout, no encryption
#
# USAGE:
# sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- \
#   --mode disko --flake .#minipc

{
  disko.devices = {
    disk = {
      main = {
        device = "/dev/sda";  # Adjust for your hardware
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
