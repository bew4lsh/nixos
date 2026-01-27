# Disko configuration for MacBook Pro 13" 2020 (Intel, T2)
# LUKS-encrypted btrfs with subvolumes
#
# USAGE:
# 1. Boot NixOS installer (hold Option key on boot, select USB)
# 2. Connect to network (USB ethernet or WiFi adapter)
# 3. Identify your target disk: lsblk
#    - The T2 SSD appears as /dev/nvme0n1
#    - If dual-booting with macOS, resize APFS first from macOS Disk Utility
# 4. Run:
#    sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- \
#      --mode disko ./hosts/laptop/disk-config.nix --arg device '"/dev/nvme0n1"'
# 5. You'll be prompted for a LUKS passphrase
#
# DUAL-BOOT WITH macOS:
# - In macOS, use Disk Utility to resize the APFS container (shrink it)
# - This creates free space for NixOS
# - Disko will use the free space; macOS partition is untouched
# - After install, hold Option on boot to choose OS
#
# FULL DISK (no macOS):
# - This will ERASE the entire disk
# - Make sure you have backups

{
  disko.devices = {
    disk = {
      main = {
        device = "/dev/nvme0n1";  # MacBook T2 SSD
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
                type = "luks";
                name = "cryptroot";
                settings = {
                  allowDiscards = true;  # TRIM for SSD longevity
                  bypassWorkqueues = true;  # Better SSD performance
                };
                # Password prompt during install
                # For automated: passwordFile = "/tmp/secret.key";
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
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
  };
}
