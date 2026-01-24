# Disko configuration for btrfs with snapshots
# Designed for dual-boot with Windows 11
#
# USAGE:
# 1. Boot NixOS installer
# 2. Identify your target disk: lsblk
# 3. Run: sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./disk-config.nix --arg device '"/dev/nvme0n1"'
#    Replace /dev/nvme0n1 with your actual disk
#
# NOTE: This assumes Windows is on a SEPARATE disk. If Windows is on the same disk,
# you'll need to manually partition and skip disko, or modify this config.

{ device ? "/dev/nvme0n1", ... }:

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
              size = "1G";
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
                type = "btrfs";
                extraArgs = [ "-f" ]; # Force overwrite
                subvolumes = {
                  "@" = {
                    mountpoint = "/";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "@home" = {
                    mountpoint = "/home";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "@nix" = {
                    mountpoint = "/nix";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "@log" = {
                    mountpoint = "/var/log";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "@snapshots" = {
                    mountpoint = "/.snapshots";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                };
              };
            };
          };
        };
      };
    };
  };

  # If dual-booting and Windows is on another disk, you may want to mount its ESP
  # for os-prober to detect it. Add something like:
  # fileSystems."/mnt/windows-efi" = {
  #   device = "/dev/disk/by-uuid/XXXX-XXXX";  # Windows ESP UUID
  #   fsType = "vfat";
  #   options = [ "ro" "umask=0077" ];
  # };
}
