{ config, pkgs, ... }:

{
  # btrbk - btrfs snapshot and backup tool
  services.btrbk = {
    instances.snapshots = {
      onCalendar = "hourly";
      settings = {
        # Snapshot retention policy
        snapshot_preserve_min = "2h";
        snapshot_preserve = "24h 7d 4w 3m";

        # Target preservation (for backups to external drive)
        target_preserve_min = "1d";
        target_preserve = "7d 4w 6m 1y";

        # Snapshot locations
        volume."/" = {
          subvolume = {
            "@" = {
              snapshot_dir = "/.snapshots";
              snapshot_create = "onchange";
            };
            "@home" = {
              snapshot_dir = "/.snapshots";
              snapshot_create = "always";
            };
          };

          # Optional: backup to external drive
          # Uncomment and configure when you have a backup target
          # target = "/run/media/lia/backup/btrbk";
        };
      };
    };
  };

  # Required packages
  environment.systemPackages = with pkgs; [
    btrbk
    snapper  # Alternative snapshot tool (optional)

    # Snapshot browsing
    btrfs-progs
    compsize  # Show compression stats
  ];

  # Snapper alternative configuration (if you prefer snapper over btrbk)
  # Uncomment to use snapper instead
  # services.snapper = {
  #   snapshotInterval = "hourly";
  #   cleanupInterval = "1d";
  #   configs = {
  #     home = {
  #       SUBVOLUME = "/home";
  #       ALLOW_USERS = [ "lia" ];
  #       TIMELINE_CREATE = true;
  #       TIMELINE_CLEANUP = true;
  #       TIMELINE_LIMIT_HOURLY = 24;
  #       TIMELINE_LIMIT_DAILY = 7;
  #       TIMELINE_LIMIT_WEEKLY = 4;
  #       TIMELINE_LIMIT_MONTHLY = 6;
  #       TIMELINE_LIMIT_YEARLY = 1;
  #     };
  #   };
  # };
}

# USAGE:
#
# List snapshots:
#   sudo btrbk list snapshots
#
# Create manual snapshot:
#   sudo btrbk run
#
# Restore from snapshot:
#   1. Boot from live USB
#   2. Mount the btrfs volume
#   3. mv @ @.broken
#   4. btrfs subvolume snapshot @.snapshots/SNAPSHOT_NAME @
#   5. Reboot
#
# Browse snapshots:
#   ls /.snapshots/
