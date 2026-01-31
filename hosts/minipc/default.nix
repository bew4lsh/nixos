# Mini PC / Home server configuration
{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix

    # System services
    ../../modules/system/boot.nix
    ../../modules/system/tailscale.nix
    ../../modules/system/containers.nix

    # Hardware - TODO: adjust for your minipc hardware
    # ../../modules/hardware/intel-cpu.nix
  ];

  networking.hostName = "minipc";

  # User configuration
  users.users.lia = {
    isNormalUser = true;
    description = "lia";
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
    ];
    shell = pkgs.bash;
  };

  # Server-specific settings
  # services.openssh.enable = true;

  # Watchtower - auto-update Docker containers
  # Dockge - Docker Compose management UI (port 5001)
  virtualisation.oci-containers = {
    backend = "docker";
    containers.watchtower = {
      image = "containrrr/watchtower:latest";
      volumes = [ "/var/run/docker.sock:/var/run/docker.sock" ];
      environment = {
        WATCHTOWER_CLEANUP = "true";           # Remove old images after update
        WATCHTOWER_SCHEDULE = "0 0 4 * * SAT"; # 4am every Saturday (cron format)
        WATCHTOWER_INCLUDE_STOPPED = "true";   # Update stopped containers too
        TZ = "America/New_York";               # Adjust to your timezone
      };
    };
    containers.dockge = {
      image = "louislam/dockge:1";
      ports = [ "5001:5001" ];
      volumes = [
        "/var/run/docker.sock:/var/run/docker.sock"
        "/opt/dockge:/app/data"
        "/opt/stacks:/opt/stacks"
      ];
      environment = {
        DOCKGE_STACKS_DIR = "/opt/stacks";
      };
    };
  };

  # Headless - no desktop environment
  # Uncomment below if you want a desktop:
  # ../../modules/desktop/greetd.nix
  # ../../modules/desktop/niri.nix

  system.stateVersion = "24.11";
}
