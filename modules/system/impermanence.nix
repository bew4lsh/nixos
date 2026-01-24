{ config, pkgs, inputs, lib, ... }:

# Impermanence - Ephemeral root filesystem
# Root (/) is wiped on every boot, only explicitly persisted paths survive
#
# This provides:
# - Clean system state on every boot
# - Forces you to declare all state explicitly
# - Easy to identify what's actually needed

{
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  # Persist important system state
  environment.persistence."/persist" = {
    hideMounts = true;

    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/var/lib/tailscale"
      "/etc/NetworkManager/system-connections"

      # If using Docker (you're not, but for reference)
      # "/var/lib/docker"
    ];

    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];

    # User persistence
    users.lia = {
      directories = [
        "Documents"
        "Downloads"
        "Music"
        "Pictures"
        "Videos"
        "Projects"
        "nixos"
        ".local/share/Steam"
        ".local/share/zellij"
        ".local/share/nvim"
        ".local/share/keyrings"
        ".local/state/wireplumber"
        ".config/BraveSoftware"  # If using Brave
        ".mozilla"               # Firefox
        ".ssh"
        ".gnupg"

        # Syncthing
        { directory = ".config/syncthing"; mode = "0700"; }

        # Etc
        ".local/share/Trash"
      ];

      files = [
        ".bash_history"
      ];
    };
  };

  # Root filesystem wipe on boot (for btrfs)
  # This creates a blank @ subvolume on every boot
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    mkdir /mnt
    mount -o subvol=/ /dev/disk/by-label/nixos /mnt

    # Delete old root
    btrfs subvolume list -o /mnt/@ | cut -f9 -d' ' | while read subvolume; do
      btrfs subvolume delete "/mnt/$subvolume"
    done
    btrfs subvolume delete /mnt/@

    # Create fresh root
    btrfs subvolume create /mnt/@

    umount /mnt
  '';

  # Create /persist during install
  fileSystems."/persist" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "btrfs";
    options = [ "subvol=@persist" "compress=zstd" "noatime" ];
    neededForBoot = true;
  };

  # Ensure the persist subvolume exists
  # You need to create this during install:
  # btrfs subvolume create /mnt/@persist
}

# SETUP INSTRUCTIONS:
#
# 1. During install, create the @persist subvolume:
#    mount /dev/YOUR_DISK /mnt
#    btrfs subvolume create /mnt/@persist
#
# 2. Update disk-config.nix to include @persist subvolume
#
# 3. Add impermanence input to flake.nix:
#    impermanence.url = "github:nix-community/impermanence";
#
# 4. Enable this module in hosts/adrasteia/default.nix
#
# IMPORTANT: Test thoroughly before enabling!
# Impermanence is powerful but can cause data loss if misconfigured.
# Start with this module DISABLED and enable only when ready.
